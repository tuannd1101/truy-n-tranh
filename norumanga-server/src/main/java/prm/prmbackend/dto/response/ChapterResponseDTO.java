package prm.prmbackend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

/**
 * Lightweight chapter response — used in chapter list views.
 * Does NOT include pages to keep the payload small.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChapterResponseDTO {

    private String id;
    private String mangaId;
    private Double chapterNumber;
    private Boolean isPremium;
    private Integer totalPages;
}
