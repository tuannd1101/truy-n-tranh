package prm.prmbackend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import prm.prmbackend.entity.enums.ChapterSourceType;

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
    private Integer volumeNumber;
    private Double chapterNumber;
    private String title;
    private String language;
    private ChapterSourceType sourceType;
    private Boolean isPremium;
    private Integer pageCount;
    private Instant publishedAt;
}
