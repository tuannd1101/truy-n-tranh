package prm.prmbackend.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import prm.prmbackend.entity.enums.MangaStatus;

import java.util.List;

@Data
public class MangaRequestDTO {

    @NotBlank(message = "Title is required")
    private String title;

    /** URL-friendly slug, e.g. "one-piece" */
    @NotBlank(message = "Slug is required")
    private String slug;

    private String description;

    /** URL to cover image — no binary upload */
    private String coverUrl;

    private List<String> creatorIds;

    private List<String> tagIds;

    private MangaStatus status;

    private Boolean isPremium;
}
