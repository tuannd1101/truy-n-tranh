package prm.prmbackend.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import prm.prmbackend.entity.enums.TagGroup;

@Data
public class TagRequestDTO {

    @NotBlank(message = "Tag name is required")
    private String name;

    @NotBlank(message = "Slug is required")
    private String slug;

    private TagGroup group;
}
