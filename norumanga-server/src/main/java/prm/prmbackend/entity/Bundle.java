package prm.prmbackend.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import prm.prmbackend.entity.enums.BillingCycle;

import java.time.Instant;
import java.util.List;

/**
 * MongoDB collection: bundles
 *
 * A subscription package a user can purchase to upgrade their account role
 * (e.g. "Premium 1 Month"). Price is stored in VND (integer, no decimals).
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "bundles")
public class Bundle {

    @Id
    private String id;

    /** Display name, e.g. "Premium 1 Tháng" */
    private String name;

    private String description;

    /** Price in VND (no decimals) */
    private long price;

    /** Billing cycle — determines how many premium days are granted */
    private BillingCycle billingCycle;

    /** Name of the Role granted on successful purchase, e.g. "Premium" */
    private String roleName;

    /** Marketing feature bullet points shown on the subscription screen */
    private List<String> features;

    /** Whether the bundle is currently offered to users */
    private boolean active;

    private Instant createdAt;

    private Instant updatedAt;
}
