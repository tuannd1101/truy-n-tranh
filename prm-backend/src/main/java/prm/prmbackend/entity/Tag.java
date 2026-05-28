package prm.prmbackend.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import prm.prmbackend.entity.enums.TagGroup;

import java.time.Instant;

/**
 * MongoDB collection: tags
 *
 * Indexes managed by MongoIndexConfig (not annotations):
 *   slug  — unique
 *   group — single
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "tags")
public class Tag {

    @Id
    private String id;

    private String name;

    /** unique — enforced by MongoIndexConfig */
    private String slug;

    private TagGroup group;

    private Instant createdAt;

    private Instant updatedAt;
}
