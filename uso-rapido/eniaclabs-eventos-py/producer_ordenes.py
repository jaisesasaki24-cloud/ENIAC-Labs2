import json
import time
import random
from kafka import KafkaProducer

producer = KafkaProducer(
    bootstrap_server=['kafka:9092'],
    key_serializer=lambda k: str(k).encode('utf-8'),
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

metodos = ["TARJETA", "YAPE", "TRANSFERENCIA", "MERCADO_PAGO"]
orden_id = 500

print("[Python Producer] Iniciando envio continuo de eventos orden.creada hacia 'orden-eventos'...")
try:
    while True:
        orden_id += 1
        evento = {
            "tipoEvento": "orden.creada",
            "ordenId": orden_id,
            "idCliente": random.randint(1, 20),
            "total": round(random.uniform(50.0, 1500.0), 2),
            "metodoPago": random.choice(metodos),
            "origen": "eniaclabs-eventos-py",
            "timestamp": int(time.time() * 1000)
        }
        future = producer.send('orden-eventos', key=orden_id, value=evento)
        record_metadata = future.get(timeout=10)
        print(json.dumps({
            "component": "producer",
            "eventType": evento["tipoEvento"],
            "ordenId": orden_id,
            "partition": record_metadata.partition,
            "offset": record_metadata.offset,
            "status": "published"
        }))
        time.sleep(2)
except KeyboardInterrupt:
    print("[Python Producer] Detenido por el usuario.")
finally:
    producer.close()
