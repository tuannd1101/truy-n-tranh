package prm.prmbackend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import prm.prmbackend.entity.enums.ChapterSourceType;

import java.time.Instant;
import java.util.List;

/**
 * Full chapter response — used when a reader opens a chapter.
 * Extends ChapterResponse fields and adds the pages list.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChapterDetailResponseDTO {

    // ── same fields as ChapterResponseDTO ────────────────────────────────────
    private String id;
    private String mangaId;
    private Integer volumeNumber;
    private Double chapterNumber;
    private String title;
    private String language;
    private ChapterSourceType sourceType;
    private Boolean isPremium;
    private Integer pageCount;
    private Instant publishedAt;

    // ── detail-only field ─────────────────────────────────────────────────────
    /** Ordered list of pages with imageUrl and optional metadata */
    private List<MangaPageResponseDTO> pages;
}
