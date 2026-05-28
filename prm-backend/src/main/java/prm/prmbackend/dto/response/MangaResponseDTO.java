package prm.prmbackend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import prm.prmbackend.entity.enums.ContentRating;
import prm.prmbackend.entity.enums.LicenseStatus;
import prm.prmbackend.entity.enums.MangaStatus;
import prm.prmbackend.entity.enums.PublicationDemographic;

import java.time.Instant;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MangaResponseDTO {

    private String id;
    private String title;
    private String slug;
    private String description;
    private String coverUrl;
    private String bannerUrl;

    /** List of author IDs */
    private List<String> authors;

    /** List of artist IDs */
    private List<String> artists;

    /** List of genre IDs */
    private List<String> genres;

    /** List of tag IDs */
    private List<String> tags;

    private MangaStatus status;
    private PublicationDemographic publicationDemographic;
    private ContentRating contentRating;
    private Integer releaseYear;
    private String lastChapter;
    private Instant lastUpdatedAt;
    private Long viewCount;
    private Long favoriteCount;
    private Boolean isPremium;
    private LicenseStatus licenseStatus;
    private String sourceName;
    private String officialUrl;
}
