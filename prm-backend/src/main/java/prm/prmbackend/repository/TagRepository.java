package prm.prmbackend.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import prm.prmbackend.entity.Tag;
import prm.prmbackend.entity.enums.TagGroup;

import java.util.List;
import java.util.Optional;

@Repository
public interface TagRepository extends MongoRepository<Tag, String> {

    // ── spec methods ─────────────────────────────────────────────────────────

    Optional<Tag> findBySlug(String slug);

    List<Tag> findByIdIn(List<String> ids);

    List<Tag> findByGroup(TagGroup group);

    // ── extra helpers used by service layer ───────────────────────────────────

    Optional<Tag> findByName(String name);

    boolean existsByName(String name);

    boolean existsBySlug(String slug);
}
