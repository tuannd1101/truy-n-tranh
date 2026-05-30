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

    /** List of creator IDs */
    private List<String> creatorIds;

    /** List of tag IDs */
    private List<String> tags;

    private MangaStatus status;
    private Boolean isPremium;
}
