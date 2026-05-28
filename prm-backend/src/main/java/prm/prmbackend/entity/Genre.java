package prm.prmbackend.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.Instant;

/**
 * MongoDB collection: genres
 *
 * Indexes managed by MongoIndexConfig (not annotations):
 *   slug — unique
 *   name — single
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "genres")
public class Genre {

    @Id
    private String id;

    private String name;

    /** unique — enforced by MongoIndexConfig */
    private String slug;

    private Instant createdAt;

    private Instant updatedAt;
}
