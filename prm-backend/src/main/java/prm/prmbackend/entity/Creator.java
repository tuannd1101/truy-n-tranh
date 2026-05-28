package prm.prmbackend.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.Instant;

/**
 * MongoDB collection: creators
 *
 * Indexes managed by MongoIndexConfig (not annotations):
 *   slug — unique
 *   name — text
 *
 * Role (author / artist) is NOT stored here — determined by
 * MangaSeries.authorIds and MangaSeries.artistIds.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "creators")
public class Creator {

    @Id
    private String id;

    private String name;

    /** unique — enforced by MongoIndexConfig */
    private String slug;

    private String originalName;

    private String biography;

    /** URL to avatar image — no binary data stored in MongoDB */
    private String avatarUrl;

    private Instant createdAt;

    private Instant updatedAt;
}
