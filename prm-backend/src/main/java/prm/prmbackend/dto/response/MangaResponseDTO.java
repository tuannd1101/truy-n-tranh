package prm.prmbackend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import prm.prmbackend.entity.enums.MangaStatus;

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

    /** List of creators */
    private List<CreatorResponseDTO> creators;

    /** List of tags */
    private List<TagResponseDTO> tags;

    private MangaStatus status;
    private Boolean isPremium;
}
