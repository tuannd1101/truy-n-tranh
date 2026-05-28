package prm.prmbackend.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Embedded document — NOT a separate MongoDB collection.
 * Stored inside MangaChapter.pages as an array element.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MangaPage {

    /** 0-based index of this page within the chapter */
    private Integer pageIndex;

    /** URL of the page image — no binary data stored in MongoDB */
    private String imageUrl;

    /** Original image width in pixels (optional, for layout hints) */
    private Integer width;

    /** Original image height in pixels (optional, for layout hints) */
    private Integer height;

    /** Alt-text or OCR content for accessibility / search (optional) */
    private String contentText;
}
