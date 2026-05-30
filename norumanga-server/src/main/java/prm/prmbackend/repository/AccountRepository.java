package prm.prmbackend.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import prm.prmbackend.entity.Account;

import java.util.Optional;

@Repository
public interface AccountRepository extends MongoRepository<Account, String> {
    Optional<Account> findByEmail(String email);
    boolean existsByEmail(String email);
}
