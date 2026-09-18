package pe.edu.upeu.eniaclabs.pago.dto;

import lombok.*;
import java.util.Map;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MercadoPagoWebhookDto {
    private String action;
    private String api_version;
    private Map<String, Object> data;
    private String date_created;
    private Long id;
    private Boolean live_mode;
    private String type;
    private Long user_id;
}