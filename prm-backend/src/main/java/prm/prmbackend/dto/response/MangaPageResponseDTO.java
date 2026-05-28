package prm.prmbackend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MangaPageResponseDTO {

    private Integer pageIndex;
    private String imageUrl;
    private Integer width;
    private Integer height;
    private String contentText;
}
