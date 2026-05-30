package prm.prmbackend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import prm.prmbackend.entity.enums.TagGroup;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TagResponseDTO {

    private String id;
    private String name;
    private String slug;
    private TagGroup group;
}
