package prm.prmbackend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreatorResponseDTO {

    private String id;
    private String name;
    private String slug;
    private String originalName;
    private String avatarUrl;
}
