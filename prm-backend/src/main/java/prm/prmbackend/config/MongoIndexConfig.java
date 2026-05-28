package prm.prmbackend.config;

import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.bson.Document;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.index.CompoundIndexDefinition;
import org.springframework.data.mongodb.core.index.Index;
import org.springframework.data.mongodb.core.index.IndexOperations;
import org.springframework.data.mongodb.core.index.TextIndexDefinition;

/**
 * Programmatic MongoDB index configuration.
 *
 * All indexes are created idempotently at startup via @PostConstruct.
 * Each ensureIndex call is wrapped individually so a pre-existing index
 * with a different name (e.g. from a previous deployment) does not crash
 * the application — it logs a warning and continues.
 *
 * Collections: mangas, manga_chapters, creators, genres, tags
 */
@Configuration
@RequiredArgsConstructor
@Slf4j
public class MongoIndexConfig {

    private final MongoTemplate mongoTemplate;

    @PostConstruct
    public void ensureIndexes() {
        log.info("Ensuring MongoDB indexes...");
        ensureMangaIndexes();
        ensureChapterIndexes();
        ensureCreatorIndexes();
        ensureGenreIndexes();
        ensureTagIndexes();
        log.info("MongoDB indexes check completed.");
    }

    // ── mangas ────────────────────────────────────────────────────────────────

    private void ensureMangaIndexes() {
        IndexOperations ops = mongoTemplate.indexOps("mangas");

        safeEnsure(ops, "mangas.slug",
                new Index().on("slug", Sort.Direction.ASC).unique().named("slug_unique"));

        safeEnsure(ops, "mangas.title text",
                new TextIndexDefinition.TextIndexDefinitionBuilder()
                        .onField("title").named("title_text").build());

        safeEnsure(ops, "mangas.genreIds",
                new Index().on("genreIds", Sort.Direction.ASC).named("genreIds_1"));

        safeEnsure(ops, "mangas.tagIds",
                new Index().on("tagIds", Sort.Direction.ASC).named("tagIds_1"));

        safeEnsure(ops, "mangas.status",
                new Index().on("status", Sort.Direction.ASC).named("status_1"));

        safeEnsure(ops, "mangas.licenseStatus",
                new Index().on("licenseStatus", Sort.Direction.ASC).named("licenseStatus_1"));

        safeEnsure(ops, "mangas.lastUpdatedAt",
                new Index().on("lastUpdatedAt", Sort.Direction.DESC).named("lastUpdatedAt_-1"));

        safeEnsure(ops, "mangas.viewCount",
                new Index().on("viewCount", Sort.Direction.DESC).named("viewCount_-1"));
    }

    // ── manga_chapters ────────────────────────────────────────────────────────

    private void ensureChapterIndexes() {
        IndexOperations ops = mongoTemplate.indexOps("manga_chapters");

        safeEnsure(ops, "chapters.mangaId+chapterNumber unique",
                new CompoundIndexDefinition(
                        new Document("mangaId", 1).append("chapterNumber", 1))
                        .unique().named("mangaId_1_chapterNumber_1"));

        safeEnsure(ops, "chapters.mangaId+volumeNumber",
                new CompoundIndexDefinition(
                        new Document("mangaId", 1).append("volumeNumber", 1))
                        .named("mangaId_1_volumeNumber_1"));

        safeEnsure(ops, "chapters.mangaId+publishedAt",
                new CompoundIndexDefinition(
                        new Document("mangaId", 1).append("publishedAt", -1))
                        .named("mangaId_1_publishedAt_-1"));

        safeEnsure(ops, "chapters.language",
                new Index().on("language", Sort.Direction.ASC).named("language_1"));
    }

    // ── creators ──────────────────────────────────────────────────────────────

    private void ensureCreatorIndexes() {
        IndexOperations ops = mongoTemplate.indexOps("creators");

        safeEnsure(ops, "creators.slug",
                new Index().on("slug", Sort.Direction.ASC).unique().named("slug_1"));

        safeEnsure(ops, "creators.name text",
                new TextIndexDefinition.TextIndexDefinitionBuilder()
                        .onField("name").named("name_text").build());
    }

    // ── genres ────────────────────────────────────────────────────────────────

    private void ensureGenreIndexes() {
        IndexOperations ops = mongoTemplate.indexOps("genres");

        safeEnsure(ops, "genres.slug",
                new Index().on("slug", Sort.Direction.ASC).unique().named("slug_1"));

        safeEnsure(ops, "genres.name",
                new Index().on("name", Sort.Direction.ASC).named("name_1"));
    }

    // ── tags ──────────────────────────────────────────────────────────────────

    private void ensureTagIndexes() {
        IndexOperations ops = mongoTemplate.indexOps("tags");

        safeEnsure(ops, "tags.slug",
                new Index().on("slug", Sort.Direction.ASC).unique().named("slug_1"));

        safeEnsure(ops, "tags.group",
                new Index().on("group", Sort.Direction.ASC).named("group_1"));
    }

    // ── helper ────────────────────────────────────────────────────────────────

    /**
     * Wraps ensureIndex so a pre-existing index with a conflicting name
     * (IndexOptionsConflict / code 85) is logged as a warning instead of
     * crashing the application context.
     */
    private void safeEnsure(IndexOperations ops, String label,
                             org.springframework.data.mongodb.core.index.IndexDefinition def) {
        try {
            ops.ensureIndex(def);
            log.debug("Index OK: {}", label);
        } catch (Exception ex) {
            log.warn("Index '{}' skipped — already exists with different name or options: {}",
                    label, ex.getMessage());
        }
    }
}
