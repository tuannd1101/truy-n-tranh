package prm.prmbackend.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;
import lombok.Data;
import prm.prmbackend.entity.enums.BillingCycle;

import java.util.List;

@Data
public class BundleRequestDTO {

    @NotBlank(message = "Bundle name is required")
    private String name;

    private String description;

    @PositiveOrZero(message = "Price must be zero or positive")
    private long price;

    @NotNull(message = "Billing cycle is required")
    private BillingCycle billingCycle;

    /** Role granted on purchase, defaults to "Premium" when blank */
    private String roleName;

    private List<String> features;

    /** When omitted, defaults to true (active) */
    private Boolean active;
}
