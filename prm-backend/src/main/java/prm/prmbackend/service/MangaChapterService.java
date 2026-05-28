package prm.prmbackend.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import prm.prmbackend.dto.request.MangaChapterRequestDTO;
import prm.prmbackend.dto.response.ChapterDetailResponseDTO;
import prm.prmbackend.dto.response.ChapterResponseDTO;

import java.util.List;

public interface MangaChapterService {

    // ── spec methods ──────────────────────────────────────────────────────────

    /**
     * Returns chapters for a manga ordered by chapterNumber ASC.
     *
     * Business rule:
     *   - licenseStatus == EXTERNAL_LINK_ONLY → returns empty list.
     *   - licenseStatus == DEMO or LICENSED    → returns chapter list.
     */
    List<ChapterResponseDTO> getChaptersByMangaId(String mangaId);

    ChapterDetailResponseDTO getChapterById(String id);

    // ── extra methods used by controller ─────────────────────────────────────

    Page<ChapterResponseDTO> findByManga(String mangaId, Pageable pageable);

    ChapterDetailResponseDTO findByMangaAndNumber(
            String mangaId, String language, Double chapterNumber);

    ChapterDetailResponseDTO create(String mangaId, MangaChapterRequestDTO request);

    ChapterDetailResponseDTO update(String chapterId, MangaChapterRequestDTO request);

    void delete(String chapterId);
}
