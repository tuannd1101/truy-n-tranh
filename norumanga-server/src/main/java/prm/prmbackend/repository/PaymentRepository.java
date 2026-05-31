package prm.prmbackend.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import prm.prmbackend.entity.Payment;
import prm.prmbackend.entity.enums.PaymentStatus;

import java.util.List;
import java.util.Optional;

@Repository
public interface PaymentRepository extends MongoRepository<Payment, String> {

    List<Payment> findByAccountIdOrderByCreatedAtDesc(String accountId);

    Page<Payment> findByAccountId(String accountId, Pageable pageable);

    /** Latest successful payment — used to derive premium expiry. */
    Optional<Payment> findFirstByAccountIdAndStatusOrderByExpiresAtDesc(
            String accountId, PaymentStatus status);
}
