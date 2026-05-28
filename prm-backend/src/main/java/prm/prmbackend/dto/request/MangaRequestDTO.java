package prm.prmbackend.dto.request;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import prm.prmbackend.entity.enums.ContentRating;
import prm.prmbackend.entity.enums.LicenseStatus;
import prm.prmbackend.entity.enums.MangaStatus;
import prm.prmbackend.entity.enums.PublicationDemographic;

import java.util.List;

@Data
public class MangaRequestDTO {

    @NotBlank(message = "Title is required")
    private String title;

    /** URL-friendly slug, e.g. "one-piece" */
    @NotBlank(message = "Slug is required")
    private String slug;

    private String originalTitle;

    private List<String> alternativeTitles;

    private String description;

    /** URL to cover image — no binary upload */
    private String coverUrl;

    /** URL to banner image — no binary upload */
    private String bannerUrl;

    private List<String> authorIds;

    private List<String> artistIds;

    private List<String> genreIds;

    private List<String> tagIds;

    /** ISO 639-1 language code, e.g. "ja", "ko", "zh" */
    private String originalLanguage;

    private MangaStatus status;

    private PublicationDemographic publicationDemographic;

    private ContentRating contentRating;

    @Min(value = 1900, message = "Release year must be >= 1900")
    @Max(value = 2100, message = "Release year must be <= 2100")
    private Integer releaseYear;

    private Boolean isPremium;

    private LicenseStatus licenseStatus;

    private String sourceName;

    /** Required when licenseStatus == LICENSED or EXTERNAL_LINK_ONLY */
    private String officialUrl;
}
