package prm.prmbackend.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import java.time.Instant;
import java.util.List;

/**
 * MongoDB collection: manga_chapters
 *
 * Indexes managed by MongoIndexConfig (not annotations):
 *   mangaId + chapterNumber — compound unique
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "manga_chapters")
public class MangaChapter {

    @Id
    private String id;

    /** indexed — enforced by MongoIndexConfig */
    private String mangaId;

    private Double chapterNumber;

    @Builder.Default
    private Boolean isPremium = false;

    /**
     * Embedded pages — ordered list of image URLs.
     */
    private List<String> pages;

    private Instant createdAt;

    private Instant updatedAt;
}
