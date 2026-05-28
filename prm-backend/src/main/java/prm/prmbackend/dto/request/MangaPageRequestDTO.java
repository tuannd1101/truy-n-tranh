package prm.prmbackend.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class MangaPageRequestDTO {

    @NotNull(message = "Page index is required")
    private Integer pageIndex;

    /** URL of the page image — no binary data */
    @NotBlank(message = "Image URL is required")
    private String imageUrl;

    private Integer width;

    private Integer height;

    private String contentText;
}
