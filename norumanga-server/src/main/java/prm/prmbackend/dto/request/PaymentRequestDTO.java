package prm.prmbackend.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import prm.prmbackend.entity.enums.PaymentMethod;

@Data
public class PaymentRequestDTO {

    @NotBlank(message = "Bundle id is required")
    private String bundleId;

    @NotNull(message = "Payment method is required")
    private PaymentMethod method;

    /** Optional external transaction reference (e.g. MoMo transaction id) */
    private String transactionRef;
}
