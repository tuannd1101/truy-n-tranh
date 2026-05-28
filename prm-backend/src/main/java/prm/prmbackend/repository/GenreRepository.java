package prm.prmbackend.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import prm.prmbackend.entity.Genre;

import java.util.List;
import java.util.Optional;

@Repository
public interface GenreRepository extends MongoRepository<Genre, String> {

    // ── spec methods ─────────────────────────────────────────────────────────

    Optional<Genre> findBySlug(String slug);

    List<Genre> findByIdIn(List<String> ids);

    // ── extra helpers used by service layer ───────────────────────────────────

    Optional<Genre> findByName(String name);

    boolean existsByName(String name);

    boolean existsBySlug(String slug);
}
