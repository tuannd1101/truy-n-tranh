package prm.prmbackend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import prm.prmbackend.entity.enums.BillingCycle;

import java.time.Instant;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BundleResponseDTO {

    private String id;
    private String name;
    private String description;
    private long price;
    private BillingCycle billingCycle;
    private int durationDays;
    private String roleName;
    private List<String> features;
    private boolean active;
    private Instant createdAt;
    private Instant updatedAt;
}
