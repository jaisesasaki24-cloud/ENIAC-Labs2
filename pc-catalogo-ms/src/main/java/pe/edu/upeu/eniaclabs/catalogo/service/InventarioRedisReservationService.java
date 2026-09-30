package pe.edu.upeu.eniaclabs.catalogo.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.script.DefaultRedisScript;
import org.springframework.stereotype.Service;
import pe.edu.upeu.eniaclabs.catalogo.entity.ProductoHardware;
import pe.edu.upeu.eniaclabs.catalogo.repository.ProductoHardwareRepository;

import java.util.List;

/**
 * Servicio de Reserva Atomica en Redis (L4/L7)
 * CORREGIDO por Nemotron 3 Ultra:
 *  - Bug Race Condition: hasKey + set NO era atomico -> two threads could over-sell
 *  - Bug Doble Descuento: commitReservation llamaba a PG siempre -> duplicated deduction
 *  - Solucion: UN UNICO Lua script SETNX para init+reserve atomico
 */
@Slf4j
@Service
public class InventarioRedisReservationService {

    private final StringRedisTemplate redisTemplate;
    private final ProductoHardwareRepository productoRepository;

    /**
     * SCRIPT UNICO ATOMICO: INIT (SETNX) + RESERVE
     * Resuelve el race condition: si la clave no existe, la inicializa Y reserva
     * en una sola operacion Lua (atomica en Redis).
     *
     * KEYS[1]=stockKey, KEYS[2]=reservedKey, KEYS[3]=reservationsHash
     * ARGV[1]=qty, ARGV[2]=orderId, ARGV[3]=initialStock (fallback from DB)
     */
    private static final String LUA_RESERVE_ATOMIC = """
        local currentStock = redis.call('GET', KEYS[1])
        if currentStock == false then
            redis.call('SET', KEYS[1], ARGV[3])
            redis.call('SET', KEYS[2], '0')
            currentStock = ARGV[3]
        end
        local stock = tonumber(currentStock)
        local reserved = tonumber(redis.call('GET', KEYS[2]) or '0')
        local available = stock - reserved
        local qty = tonumber(ARGV[1])
        if available >= qty then
            redis.call('INCRBY', KEYS[2], qty)
            redis.call('HSET', KEYS[3], ARGV[2], ARGV[1])
            return 1
        else
            return 0
        end
        """;

    private static final String LUA_ROLLBACK_SCRIPT = """
        local qty = tonumber(ARGV[1])
        local currentReserved = tonumber(redis.call('GET', KEYS[2]) or '0')
        if currentReserved >= qty then
            redis.call('DECRBY', KEYS[2], qty)
        else
            redis.call('SET', KEYS[2], '0')
        end
        redis.call('HDEL', KEYS[3], ARGV[2])
        return 1
        """;

    /**
     * Commit: solo sincroniza Redis. El descuento en PG
     * ocurre en el paso de "Pago Confirmado" (Saga Final Step),
     * NO aqui. Esto evita el doble descuento.
     */
    private static final String LUA_COMMIT_SCRIPT = """
        local qty = tonumber(ARGV[1])
        redis.call('DECRBY', KEYS[1], qty)
        redis.call('DECRBY', KEYS[2], qty)
        redis.call('HDEL', KEYS[3], ARGV[2])
        return 1
        """;

    private final DefaultRedisScript<Long> reserveScript;
    private final DefaultRedisScript<Long> rollbackScript;
    private final DefaultRedisScript<Long> commitScript;

    public InventarioRedisReservationService(
            @Autowired(required = false) StringRedisTemplate redisTemplate,
            ProductoHardwareRepository productoRepository
    ) {
        this.redisTemplate = redisTemplate;
        this.productoRepository = productoRepository;
        this.reserveScript = new DefaultRedisScript<>(LUA_RESERVE_ATOMIC, Long.class);
        this.rollbackScript = new DefaultRedisScript<>(LUA_ROLLBACK_SCRIPT, Long.class);
        this.commitScript = new DefaultRedisScript<>(LUA_COMMIT_SCRIPT, Long.class);
    }

    /**
     * Intenta reservar stock en Redis atomicamente con Lua Script.
     * Si Redis no esta disponible, degrada a PostgreSQL condicional.
     */
    public boolean tryReserveStock(String sku, int cantidad, String orderId) {
        if (redisTemplate == null) {
            return fallbackToPostgres(sku, cantidad);
        }
        try {
            String stockKey = "stock:" + sku;
            String reservedKey = "reserved:" + sku;
            String reservationsKey = "reservations:" + sku;

            // Obtener stock de DB como valor inicial para el script Lua
            Integer dbStock = productoRepository.findBySku(sku)
                    .map(ProductoHardware::getStockActual)
                    .orElse(0);

            Long result = redisTemplate.execute(
                    reserveScript,
                    List.of(stockKey, reservedKey, reservationsKey),
                    String.valueOf(cantidad),
                    orderId,
                    String.valueOf(dbStock)
            );

            if (result != null && result == 1L) {
                log.info("[Redis] Reserva atomica exitosa SKU={} qty={} orden={}", sku, cantidad, orderId);
                return true;
            } else {
                log.warn("[Redis] Stock insuficiente en cache para SKU={}", sku);
                return false;
            }
        } catch (Exception e) {
            log.warn("[Redis Fallback] Redis no disponible, usando PostgreSQL: {}", e.getMessage());
            return fallbackToPostgres(sku, cantidad);
        }
    }

    private boolean fallbackToPostgres(String sku, int cantidad) {
        int filas = productoRepository.descontarStockPorSkuAtomico(sku, cantidad);
        if (filas > 0) log.info("[PG Fallback] Stock descontado en BD para SKU={}", sku);
        return filas > 0;
    }

    /**
     * Revierte la reserva de stock (Rollback Saga Compensation)
     */
    public void rollbackReservation(String sku, int cantidad, String orderId) {
        if (redisTemplate != null) {
            try {
                String stockKey = "stock:" + sku;
                String reservedKey = "reserved:" + sku;
                String reservationsKey = "reservations:" + sku;
                redisTemplate.execute(rollbackScript,
                        List.of(stockKey, reservedKey, reservationsKey),
                        String.valueOf(cantidad), orderId);
                log.info("[Redis Rollback] Reserva revertida SKU={} qty={}", sku, cantidad);
                return;
            } catch (Exception e) {
                log.warn("[Redis Rollback] Fallback PG: {}", e.getMessage());
            }
        }
        productoRepository.reponerStockPorSkuAtomico(sku, cantidad);
    }

    /**
     * Consolida la reserva en Redis (NO descuenta en PG - eso es responsabilidad
     * del Saga Step de confirmacion de pago para evitar doble descuento).
     */
    public void commitReservation(String sku, int cantidad, String orderId) {
        if (redisTemplate != null) {
            try {
                String stockKey = "stock:" + sku;
                String reservedKey = "reserved:" + sku;
                String reservationsKey = "reservations:" + sku;
                redisTemplate.execute(commitScript,
                        List.of(stockKey, reservedKey, reservationsKey),
                        String.valueOf(cantidad), orderId);
                log.info("[Redis Commit] Reserva confirmada en cache SKU={}", sku);
            } catch (Exception e) {
                log.warn("[Redis Commit] No se pudo sincronizar commit Redis: {}", e.getMessage());
            }
        }
        // NOTA: El descuento en PG ocurre en el Saga Step de confirmacion de pago,
        // NO aqui. Esto previene el doble descuento identificado por Nemotron 3 Ultra.
    }
}