package prm.prmbackend.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.Instant;

/**
 * MongoDB collection: reading_history
 *
 * One entry per (accountId, mangaId): the most recently read chapter for that
 * manga. Upserted whenever the user opens a chapter.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "reading_history")
public class ReadingHistory {

    @Id
    private String id;

    private String accountId;

    private String mangaId;

    /** Last chapter number the user read for this manga. */
    private Double chapterNumber;

    private Instant lastReadAt;
}
