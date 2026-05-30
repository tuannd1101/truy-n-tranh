package prm.prmbackend.dto.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;

import java.util.List;

@Data
public class MangaChapterRequestDTO {

    @NotNull(message = "Chapter number is required")
    @Positive(message = "Chapter number must be positive")
    private Double chapterNumber;

    private Boolean isPremium;

    private List<String> pages;
}
