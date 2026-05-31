package prm.prmbackend.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import prm.prmbackend.dto.request.MangaRequestDTO;
import prm.prmbackend.dto.response.MangaResponseDTO;
import prm.prmbackend.entity.enums.MangaStatus;

import java.util.List;

public interface MangaService {

    // ── spec methods ──────────────────────────────────────────────────────────

    /** Top 10 most recently updated */
    List<MangaResponseDTO> getLatestMangas();

    /** Top 10 most viewed */
    List<MangaResponseDTO> getRecommendedMangas();

    MangaResponseDTO getMangaById(String id);

    /** Returns the manga DTO or null if it no longer exists (no exception). */
    MangaResponseDTO getMangaByIdOrNull(String id);

    MangaResponseDTO getMangaBySlug(String slug);

    /** Full-text / title search */
    Page<MangaResponseDTO> searchMangas(String query, Pageable pageable);

    /** Multi-filter: any combination of tagId, status */
    Page<MangaResponseDTO> getMangasByFilter(
            String tagId,
            MangaStatus status,
            Pageable pageable);

    // ── admin / write methods ─────────────────────────────────────────────────

    Page<MangaResponseDTO> findAll(Pageable pageable);

    Page<MangaResponseDTO> findByCreator(String creatorId, Pageable pageable);

    MangaResponseDTO create(MangaRequestDTO request);

    MangaResponseDTO update(String id, MangaRequestDTO request);

    void delete(String id);
}
