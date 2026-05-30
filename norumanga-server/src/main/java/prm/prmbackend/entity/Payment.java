package prm.prmbackend.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import prm.prmbackend.entity.enums.PaymentMethod;
import prm.prmbackend.entity.enums.PaymentStatus;

import java.time.Instant;

/**
 * MongoDB collection: payments
 *
 * A transaction record for a user purchasing a subscription bundle.
 * Acts as the user's transaction history (read-only for end users).
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "payments")
public class Payment {

    @Id
    private String id;

    /** Account id of the purchasing user */
    private String accountId;

    /** Bundle that was purchased */
    private String bundleId;

    /** Snapshot of bundle name at purchase time */
    private String bundleName;

    /** Amount charged in VND (snapshot of bundle price) */
    private long amount;

    private PaymentMethod method;

    private PaymentStatus status;

    /** External transaction reference (e.g. MoMo transaction id) */
    private String transactionRef;

    /** When premium access (granted by this payment) expires */
    private Instant expiresAt;

    private Instant createdAt;

    private Instant updatedAt;
}
