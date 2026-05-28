package prm.prmbackend.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;
import prm.prmbackend.entity.MangaSeries;
import prm.prmbackend.entity.enums.ContentRating;
import prm.prmbackend.entity.enums.LicenseStatus;
import prm.prmbackend.entity.enums.MangaStatus;

import java.util.List;
import java.util.Optional;

@Repository
public interface MangaRepository extends MongoRepository<MangaSeries, String> {

    // ── spec methods ─────────────────────────────────────────────────────────

    Optional<MangaSeries> findBySlug(String slug);

    List<MangaSeries> findTop10ByOrderByLastUpdatedAtDesc();

    List<MangaSeries> findTop10ByOrderByViewCountDesc();

    // ── search / filter ───────────────────────────────────────────────────────

    Page<MangaSeries> findByTitleContainingIgnoreCase(String title, Pageable pageable);

    Page<MangaSeries> findByStatus(MangaStatus status, Pageable pageable);

    Page<MangaSeries> findByContentRating(ContentRating contentRating, Pageable pageable);

    Page<MangaSeries> findByLicenseStatus(LicenseStatus licenseStatus, Pageable pageable);

    Page<MangaSeries> findByGenreIdsContaining(String genreId, Pageable pageable);

    Page<MangaSeries> findByTagIdsContaining(String tagId, Pageable pageable);

    Page<MangaSeries> findByAuthorIdsContaining(String authorId, Pageable pageable);

    Page<MangaSeries> findByArtistIdsContaining(String artistId, Pageable pageable);

    @Query("{ 'title': { $regex: ?0, $options: 'i' }, 'status': ?1 }")
    Page<MangaSeries> findByTitleAndStatus(String title, MangaStatus status, Pageable pageable);
}
