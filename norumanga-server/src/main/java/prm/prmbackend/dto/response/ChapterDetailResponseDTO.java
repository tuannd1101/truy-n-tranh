package prm.prmbackend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * Full chapter response — used when a reader opens a chapter.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChapterDetailResponseDTO {

    private String id;
    private String mangaId;
    private Double chapterNumber;
    private Boolean isPremium;

    private List<String> pages;
}
