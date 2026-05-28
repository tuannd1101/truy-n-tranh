package prm.prmbackend.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import prm.prmbackend.entity.enums.ContentRating;
import prm.prmbackend.entity.enums.LicenseStatus;
import prm.prmbackend.entity.enums.MangaStatus;
import prm.prmbackend.entity.enums.PublicationDemographic;

import java.time.Instant;
import java.util.List;

/**
 * MongoDB collection: mangas
 *
 * Indexes managed by MongoIndexConfig (not annotations):
 *   slug          — unique
 *   title         — text
 *   genreIds      — multikey
 *   tagIds        — multikey
 *   status        — single
 *   licenseStatus — single
 *   lastUpdatedAt — single DESC
 *   viewCount     — single DESC
 *
 * License policy:
 *   LICENSED / EXTERNAL_LINK_ONLY → only metadata + officialUrl; no chapter content.
 *   DEMO                          → full chapter/page content allowed.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "mangas")
public class MangaSeries {

    @Id
    private String id;

    private String title;

    /** unique — enforced by MongoIndexConfig */
    private String slug;

    private String originalTitle;

    private List<String> alternativeTitles;

    private String description;

    /** URL to cover image — no binary data stored in MongoDB */
    private String coverUrl;

    /** URL to banner image — no binary data stored in MongoDB */
    private String bannerUrl;

    /** IDs referencing the creators collection (authors) */
    private List<String> authorIds;

    /** IDs referencing the creators collection (artists) */
    private List<String> artistIds;

    /** IDs referencing the genres collection */
    private List<String> genreIds;

    /** IDs referencing the tags collection */
    private List<String> tagIds;

    /** ISO 639-1 language code, e.g. "ja", "ko", "zh" */
    private String originalLanguage;

    private MangaStatus status;

    private PublicationDemographic publicationDemographic;

    private ContentRating contentRating;

    private Integer releaseYear;

    /** Last chapter identifier string, e.g. "Chapter 120" */
    private String lastChapter;

    private Instant lastUpdatedAt;

    @Builder.Default
    private Long viewCount = 0L;

    @Builder.Default
    private Long favoriteCount = 0L;

    @Builder.Default
    private Boolean isPremium = false;

    @Builder.Default
    private LicenseStatus licenseStatus = LicenseStatus.DEMO;

    /** Name of the source/scanlation group */
    private String sourceName;

    /**
     * Official reading URL.
     * Required when licenseStatus == LICENSED or EXTERNAL_LINK_ONLY.
     */
    private String officialUrl;

    private Instant createdAt;

    private Instant updatedAt;
}
