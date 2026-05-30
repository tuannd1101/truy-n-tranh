package prm.prmbackend.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import prm.prmbackend.entity.Payment;

import java.util.List;

@Repository
public interface PaymentRepository extends MongoRepository<Payment, String> {

    List<Payment> findByAccountIdOrderByCreatedAtDesc(String accountId);

    Page<Payment> findByAccountId(String accountId, Pageable pageable);
}
