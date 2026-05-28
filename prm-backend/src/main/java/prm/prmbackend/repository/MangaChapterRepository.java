package prm.prmbackend.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import prm.prmbackend.entity.MangaChapter;

import java.util.List;
import java.util.Optional;

@Repository
public interface MangaChapterRepository extends MongoRepository<MangaChapter, String> {

    // ── spec methods ─────────────────────────────────────────────────────────

    List<MangaChapter> findByMangaIdOrderByChapterNumberAsc(String mangaId);

    Optional<MangaChapter> findByMangaIdAndChapterNumber(String mangaId, Double chapterNumber);

    // ── extra helpers used by service layer ───────────────────────────────────

    Page<MangaChapter> findByMangaId(String mangaId, Pageable pageable);

    Optional<MangaChapter> findByMangaIdAndLanguageAndChapterNumber(
            String mangaId, String language, Double chapterNumber);

    boolean existsByMangaIdAndLanguageAndChapterNumber(
            String mangaId, String language, Double chapterNumber);

    void deleteAllByMangaId(String mangaId);

    long countByMangaId(String mangaId);
}
