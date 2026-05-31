package prm.prmbackend.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class ReadingHistoryRequestDTO {

    @NotBlank(message = "Manga id is required")
    private String mangaId;

    @NotNull(message = "Chapter number is required")
    private Double chapterNumber;
}
