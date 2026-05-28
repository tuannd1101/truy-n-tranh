package prm.prmbackend.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import prm.prmbackend.entity.enums.ChapterSourceType;

import java.time.Instant;
import java.util.List;

/**
 * MongoDB collection: manga_chapters
 *
 * Indexes managed by MongoIndexConfig (not annotations):
 *   mangaId + chapterNumber — compound unique
 *   mangaId + volumeNumber  — compound
 *   mangaId + publishedAt   — compound
 *   language                — single
 *
 * Pages are embedded as List<MangaPage> — no binary data, only imageUrls.
 * Must NOT be created when parent MangaSeries.licenseStatus == LICENSED
 * or EXTERNAL_LINK_ONLY.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "manga_chapters")
public class MangaChapter {

    @Id
    private String id;

    /** indexed — enforced by MongoIndexConfig */
    private String mangaId;

    private Integer volumeNumber;

    private Double chapterNumber;

    private String title;

    /** ISO 639-1 language code, e.g. "vi", "en" */
    private String language;

    private ChapterSourceType sourceType;

    @Builder.Default
    private Boolean isPremium = false;

    private Integer pageCount;

    /**
     * Embedded pages — ordered by pageIndex.
     * Each page stores only an imageUrl, no binary data.
     */
    private List<MangaPage> pages;

    private Instant publishedAt;

    private Instant createdAt;

    private Instant updatedAt;
}
