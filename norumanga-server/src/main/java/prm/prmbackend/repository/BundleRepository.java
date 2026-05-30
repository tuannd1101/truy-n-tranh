package prm.prmbackend.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import prm.prmbackend.entity.Bundle;

import java.util.List;
import java.util.Optional;

@Repository
public interface BundleRepository extends MongoRepository<Bundle, String> {

    List<Bundle> findByActiveTrue();

    Optional<Bundle> findByName(String name);

    boolean existsByName(String name);
}
