package prm.prmbackend.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class CreatorRequestDTO {

    @NotBlank(message = "Creator name is required")
    private String name;

    @NotBlank(message = "Slug is required")
    private String slug;

    private String originalName;

    private String biography;

    /** URL to avatar image — no binary upload */
    private String avatarUrl;
}
