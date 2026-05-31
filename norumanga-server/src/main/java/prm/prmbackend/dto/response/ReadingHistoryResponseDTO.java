package prm.prmbackend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReadingHistoryResponseDTO {

    private String id;
    private String mangaId;
    private Double chapterNumber;
    private Instant lastReadAt;

    /** Embedded manga summary so the client can render a card directly. */
    private MangaResponseDTO manga;
}
