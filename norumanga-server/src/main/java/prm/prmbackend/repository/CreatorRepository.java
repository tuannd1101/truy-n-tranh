package prm.prmbackend.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import prm.prmbackend.entity.Creator;

import java.util.List;
import java.util.Optional;

@Repository
public interface CreatorRepository extends MongoRepository<Creator, String> {

    // ── spec methods ─────────────────────────────────────────────────────────

    Optional<Creator> findBySlug(String slug);

    List<Creator> findByIdIn(List<String> ids);

    // ── extra helpers used by service layer ───────────────────────────────────

    Page<Creator> findByNameContainingIgnoreCase(String name, Pageable pageable);

    boolean existsBySlug(String slug);
}
