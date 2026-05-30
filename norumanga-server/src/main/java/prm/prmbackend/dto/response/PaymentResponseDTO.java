package prm.prmbackend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import prm.prmbackend.entity.enums.PaymentMethod;
import prm.prmbackend.entity.enums.PaymentStatus;

import java.time.Instant;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PaymentResponseDTO {

    private String id;
    private String accountId;
    private String bundleId;
    private String bundleName;
    private long amount;
    private PaymentMethod method;
    private PaymentStatus status;
    private String transactionRef;
    private Instant expiresAt;
    private Instant createdAt;
    private Instant updatedAt;
}
