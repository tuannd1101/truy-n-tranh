package prm.prmbackend.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class GenreRequestDTO {

    @NotBlank(message = "Genre name is required")
    private String name;

    @NotBlank(message = "Slug is required")
    private String slug;
}
