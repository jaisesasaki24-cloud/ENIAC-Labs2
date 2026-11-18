package pe.edu.upeu.eniaclabs.pago;

import com.mercadopago.MercadoPagoConfig;
import com.mercadopago.client.preference.PreferenceBackUrlsRequest;
import com.mercadopago.client.preference.PreferenceClient;
import com.mercadopago.client.preference.PreferenceItemRequest;
import com.mercadopago.client.preference.PreferenceRequest;
import com.mercadopago.resources.preference.Preference;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Prueba de integración directa con la API oficial de Mercado Pago Sandbox (Checkout Pro).
 * Valida que las credenciales oficiales de prueba de ENIAC Labs generen preferencias correctamente.
 */
class MercadoPagoIntegrationTest {

    private static final String ACCESS_TOKEN = "APP_USR-7709062323770834-102620-22d3ad8bb4a98ca436917a52a528a8a1-3796765560";
    private static final String PUBLIC_KEY = "APP_USR-62bf1793-3203-48e6-b913-2da50ee22fe7";

    @BeforeAll
    static void setup() {
        MercadoPagoConfig.setAccessToken(ACCESS_TOKEN);
    }

    @Test
    @DisplayName("Debe generar exitosamente una preferencia de Checkout Pro con moneda PEN en Sandbox")
    void debeCrearPreferenciaCheckoutProEnSandbox() throws Exception {
        PreferenceClient client = new PreferenceClient();

        PreferenceItemRequest item = PreferenceItemRequest.builder()
                .id("gpu-rtx4080-test")
                .title("GeForce RTX 4080 Super OC 16GB")
                .description("Hardware Gamer ENIAC Labs")
                .quantity(1)
                .unitPrice(new BigDecimal("3399.00"))
                .currencyId("PEN")
                .build();

        PreferenceBackUrlsRequest backUrls = PreferenceBackUrlsRequest.builder()
                .success("https://eniaclabs.pe/pagar/success")
                .failure("https://eniaclabs.pe/pagar/failure")
                .pending("https://eniaclabs.pe/pagar/pending")
                .build();

        PreferenceRequest request = PreferenceRequest.builder()
                .items(List.of(item))
                .backUrls(backUrls)
                .autoReturn("approved")
                .externalReference("ORD-TEST-" + System.currentTimeMillis())
                .statementDescriptor("ENIAC LABS")
                .build();

        try {
            Preference preference = client.create(request);

            assertNotNull(preference, "La preferencia no debe ser nula");
            assertNotNull(preference.getId(), "El ID de la preferencia no debe ser nulo");
            assertNotNull(preference.getInitPoint(), "El Init Point de pago debe existir");
            assertNotNull(preference.getSandboxInitPoint(), "El Sandbox Init Point debe existir");

            System.out.println("====================================================================");
            System.out.println("✔ PREFERENCIA MERCADO PAGO CREADA CON ÉXITO EN SANDBOX:");
            System.out.println("  Preference ID    : " + preference.getId());
            System.out.println("  Init Point       : " + preference.getInitPoint());
            System.out.println("  Sandbox InitPoint: " + preference.getSandboxInitPoint());
            System.out.println("====================================================================");
        } catch (com.mercadopago.exceptions.MPApiException ex) {
            System.err.println("====================================================================");
            System.err.println("MPApiException Status Code: " + ex.getStatusCode());
            System.err.println("MPApiException Body       : " + (ex.getApiResponse() != null ? ex.getApiResponse().getContent() : "null"));
            System.err.println("====================================================================");
            throw ex;
        }
    }
}
