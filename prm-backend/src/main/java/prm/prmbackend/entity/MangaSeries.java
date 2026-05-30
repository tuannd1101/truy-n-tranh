package prm.prmbackend.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import prm.prmbackend.entity.enums.MangaStatus;

import java.time.Instant;
import java.util.List;

/**
 * MongoDB collection: mangas
 *
 * Indexes managed by MongoIndexConfig (not annotations):
 *   slug          — unique
 *   title         — text
 *   tagIds        — multikey
 *   status        — single
 *   updatedAt     — single DESC
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "mangas")
public class MangaSeries {

    @Id
    private String id;

    private String title;

    /** unique — enforced by MongoIndexConfig */
    private String slug;

    private String description;

    /** URL to cover image — no binary data stored in MongoDB */
    private String coverUrl;

    /** IDs referencing the creators collection (authors/artists) */
    private List<String> creatorIds;

    /** IDs referencing the tags collection */
    private List<String> tagIds;

    private MangaStatus status;

    @Builder.Default
    private Boolean isPremium = false;

    private Instant createdAt;

    private Instant updatedAt;
}
