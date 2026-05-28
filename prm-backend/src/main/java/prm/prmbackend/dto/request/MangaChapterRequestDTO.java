package prm.prmbackend.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;
import prm.prmbackend.entity.enums.ChapterSourceType;

import java.time.Instant;
import java.util.List;

@Data
public class MangaChapterRequestDTO {

    private Integer volumeNumber;

    @NotNull(message = "Chapter number is required")
    @Positive(message = "Chapter number must be positive")
    private Double chapterNumber;

    private String title;

    @NotBlank(message = "Language is required")
    private String language;

    private ChapterSourceType sourceType;

    private Boolean isPremium;

    /**
     * Ordered list of pages.
     * Each page contains only an imageUrl — no binary data.
     */
    @Valid
    private List<MangaPageRequestDTO> pages;

    private Instant publishedAt;
}
