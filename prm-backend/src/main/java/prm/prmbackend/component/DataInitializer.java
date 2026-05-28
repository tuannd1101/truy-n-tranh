package prm.prmbackend.component;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Component;
import prm.prmbackend.entity.*;
import prm.prmbackend.entity.enums.*;
import prm.prmbackend.repository.*;

import java.time.Instant;
import java.util.*;

/**
 * Seed data initializer.
 *
 * Guard rules (evaluated in order):
 * 1. If env var FORCE_SEED=true → always seed, never delete existing data.
 * 2. If active profile contains "dev" → seed when manga collection is empty.
 * 3. Otherwise (production default) → seed only roles; skip manga/chapter seed.
 *
 * Manga seed is always additive — existing documents are never deleted.
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class DataInitializer implements CommandLineRunner {

        private final Environment environment;

        private final RoleRepository roleRepository;
        private final GenreRepository genreRepository;
        private final TagRepository tagRepository;
        private final CreatorRepository creatorRepository;
        private final MangaRepository mangaRepository;
        private final MangaChapterRepository chapterRepository;

        // ── entry point ───────────────────────────────────────────────────────────

        @Override
        public void run(String... args) {
                log.info("DataInitializer starting...");

                // Roles always seeded (safe, idempotent)
                seedRoles();

                log.info("DataInitializer completed.");
        }

        // ── roles ─────────────────────────────────────────────────────────────────

        private void seedRoles() {
                record RoleDef(String name, String description) {
                }
                List<RoleDef> defs = List.of(
                                new RoleDef("Free", "Free User"),
                                new RoleDef("Premium", "Premium User"),
                                new RoleDef("Manager", "Content Manager"),
                                new RoleDef("Admin", "System Administrator"));
                for (RoleDef d : defs) {
                        if (roleRepository.findByName(d.name()).isEmpty()) {
                                roleRepository.save(Role.builder()
                                                .name(d.name()).description(d.description()).build());
                                log.info("Seeded role: {}", d.name());
                        }
                }
        }

        // ── genres ────────────────────────────────────────────────────────────────

        private Map<String, Genre> seedGenres() {
                record GenreDef(String name, String slug) {
                }
                List<GenreDef> defs = List.of(
                                new GenreDef("Action", "action"),
                                new GenreDef("Adventure", "adventure"),
                                new GenreDef("Comedy", "comedy"),
                                new GenreDef("Fantasy", "fantasy"),
                                new GenreDef("Mystery", "mystery"),
                                new GenreDef("Sports", "sports"),
                                new GenreDef("Supernatural", "supernatural"));

                Map<String, Genre> result = new LinkedHashMap<>();
                for (GenreDef d : defs) {
                        Genre genre = genreRepository.findBySlug(d.slug()).orElseGet(() -> {
                                Instant now = Instant.now();
                                Genre g = Genre.builder()
                                                .name(d.name()).slug(d.slug())
                                                .createdAt(now).updatedAt(now).build();
                                Genre saved = genreRepository.save(g);
                                log.info("Seeded genre: {}", d.name());
                                return saved;
                        });
                        result.put(d.slug(), genre);
                }
                return result;
        }

        // ── tags ──────────────────────────────────────────────────────────────────

        private Map<String, Tag> seedTags() {
                record TagDef(String name, String slug, TagGroup group) {
                }
                List<TagDef> defs = List.of(
                                new TagDef("Pirates", "pirates", TagGroup.THEME),
                                new TagDef("Ninja", "ninja", TagGroup.THEME),
                                new TagDef("Detective", "detective", TagGroup.THEME),
                                new TagDef("Football", "football", TagGroup.THEME),
                                new TagDef("Curses", "curses", TagGroup.THEME),
                                new TagDef("Shonen", "shonen", TagGroup.FORMAT),
                                new TagDef("School", "school", TagGroup.THEME));

                Map<String, Tag> result = new LinkedHashMap<>();
                for (TagDef d : defs) {
                        Tag tag = tagRepository.findBySlug(d.slug()).orElseGet(() -> {
                                Instant now = Instant.now();
                                Tag t = Tag.builder()
                                                .name(d.name()).slug(d.slug()).group(d.group())
                                                .createdAt(now).updatedAt(now).build();
                                Tag saved = tagRepository.save(t);
                                log.info("Seeded tag: {}", d.name());
                                return saved;
                        });
                        result.put(d.slug(), tag);
                }
                return result;
        }

        // ── creators ──────────────────────────────────────────────────────────────

        private Map<String, Creator> seedCreators() {
                record CreatorDef(String name, String slug, String originalName) {
                }
                List<CreatorDef> defs = List.of(
                                new CreatorDef("Eiichiro Oda", "eiichiro-oda", "尾田栄一郎"),
                                new CreatorDef("Masashi Kishimoto", "masashi-kishimoto", "岸本斉史"),
                                new CreatorDef("Gege Akutami", "gege-akutami", "芥見下々"),
                                new CreatorDef("Gosho Aoyama", "gosho-aoyama", "青山剛昌"),
                                new CreatorDef("Yoichi Takahashi", "yoichi-takahashi", "高橋陽一"));

                Map<String, Creator> result = new LinkedHashMap<>();
                for (CreatorDef d : defs) {
                        Creator creator = creatorRepository.findBySlug(d.slug()).orElseGet(() -> {
                                Instant now = Instant.now();
                                Creator c = Creator.builder()
                                                .name(d.name()).slug(d.slug()).originalName(d.originalName())
                                                .createdAt(now).updatedAt(now).build();
                                Creator saved = creatorRepository.save(c);
                                log.info("Seeded creator: {}", d.name());
                                return saved;
                        });
                        result.put(d.slug(), creator);
                }
                return result;
        }

        // ── EXTERNAL_LINK_ONLY mangas ─────────────────────────────────────────────

        private void seedLicensedMangas(
                        Map<String, Genre> genres,
                        Map<String, Tag> tags,
                        Map<String, Creator> creators) {

                record LicensedDef(
                                String title, String slug,
                                String creatorSlug,
                                List<String> genreSlugs, List<String> tagSlugs,
                                String description,
                                String sourceName, String officialUrl,
                                Integer releaseYear) {
                }

                List<LicensedDef> defs = List.of(
                                new LicensedDef(
                                                "One Piece", "one-piece",
                                                "eiichiro-oda",
                                                List.of("action", "adventure", "fantasy"),
                                                List.of("pirates", "shonen"),
                                                "A young pirate with the power to stretch like rubber sets out to find the world's greatest treasure and become King of the Pirates.",
                                                "Shonen Jump", "https://mangaplus.shueisha.co.jp/titles/100020",
                                                1997),
                                new LicensedDef(
                                                "Naruto", "naruto",
                                                "masashi-kishimoto",
                                                List.of("action", "adventure", "fantasy"),
                                                List.of("ninja", "shonen"),
                                                "A young ninja outcast carries a powerful demon fox sealed within him and dreams of becoming the greatest ninja in his village.",
                                                "Shonen Jump", "https://mangaplus.shueisha.co.jp/titles/100016",
                                                1999),
                                new LicensedDef(
                                                "Jujutsu Kaisen", "jujutsu-kaisen",
                                                "gege-akutami",
                                                List.of("action", "supernatural", "fantasy"),
                                                List.of("curses", "shonen", "school"),
                                                "A high school student swallows a cursed object and joins a secret organization that hunts down dangerous supernatural curses.",
                                                "Shonen Jump", "https://mangaplus.shueisha.co.jp/titles/100034",
                                                2018),
                                new LicensedDef(
                                                "Detective Conan", "detective-conan",
                                                "gosho-aoyama",
                                                List.of("mystery", "adventure"),
                                                List.of("detective"),
                                                "A teenage detective is shrunk into a child's body by a criminal organization and solves cases while searching for a cure.",
                                                "Shonen Sunday", "https://www.sunday-webry.com/series/conan",
                                                1994),
                                new LicensedDef(
                                                "Captain Tsubasa", "captain-tsubasa",
                                                "yoichi-takahashi",
                                                List.of("sports", "action"),
                                                List.of("football", "shonen"),
                                                "A gifted young footballer pursues his dream of winning the World Cup, inspiring a generation of players around the globe.",
                                                "Shonen Jump", "https://mangaplus.shueisha.co.jp/titles/100052",
                                                1981));

                for (LicensedDef d : defs) {
                        if (mangaRepository.findBySlug(d.slug()).isPresent()) {
                                log.debug("Manga '{}' already exists — skipping", d.slug());
                                continue;
                        }

                        Creator creator = creators.get(d.creatorSlug());
                        List<String> authorIds = creator != null ? List.of(creator.getId()) : List.of();
                        List<String> genreIds = d.genreSlugs().stream()
                                        .map(genres::get).filter(Objects::nonNull)
                                        .map(Genre::getId).toList();
                        List<String> tagIds = d.tagSlugs().stream()
                                        .map(tags::get).filter(Objects::nonNull)
                                        .map(Tag::getId).toList();

                        Instant now = Instant.now();
                        MangaSeries manga = MangaSeries.builder()
                                        .title(d.title())
                                        .slug(d.slug())
                                        .description(d.description())
                                        .authorIds(authorIds)
                                        .artistIds(authorIds)
                                        .genreIds(genreIds)
                                        .tagIds(tagIds)
                                        .status(MangaStatus.ONGOING)
                                        .publicationDemographic(PublicationDemographic.SHONEN)
                                        .contentRating(ContentRating.SAFE)
                                        .releaseYear(d.releaseYear())
                                        .licenseStatus(LicenseStatus.EXTERNAL_LINK_ONLY)
                                        .sourceName(d.sourceName())
                                        .officialUrl(d.officialUrl())
                                        .isPremium(false)
                                        .viewCount(0L)
                                        .favoriteCount(0L)
                                        .lastUpdatedAt(now)
                                        .createdAt(now)
                                        .updatedAt(now)
                                        .build();

                        mangaRepository.save(manga);
                        log.info("Seeded EXTERNAL_LINK_ONLY manga: {}", d.title());
                        // No chapters created — EXTERNAL_LINK_ONLY policy
                }
        }

        // ── DEMO mangas ───────────────────────────────────────────────────────────

        private void seedDemoMangas(
                        Map<String, Genre> genres,
                        Map<String, Tag> tags,
                        Map<String, Creator> creators) {

                record DemoDef(
                                String title, String slug,
                                String creatorSlug,
                                List<String> genreSlugs, List<String> tagSlugs,
                                String description) {
                }

                List<DemoDef> defs = List.of(
                                new DemoDef(
                                                "Pirate Legacy", "pirate-legacy",
                                                "eiichiro-oda",
                                                List.of("action", "adventure"),
                                                List.of("pirates", "shonen"),
                                                "A young pirate inherits a legendary ship and crew, sailing uncharted seas in search of a lost treasure that could change the world."),
                                new DemoDef(
                                                "Shadow Ninja Road", "shadow-ninja-road",
                                                "masashi-kishimoto",
                                                List.of("action", "fantasy"),
                                                List.of("ninja", "shonen"),
                                                "An orphaned ninja with a forbidden shadow technique walks a dangerous path between the world of light and the realm of darkness."),
                                new DemoDef(
                                                "Cursed Academy", "cursed-academy",
                                                "gege-akutami",
                                                List.of("supernatural", "action"),
                                                List.of("curses", "school", "shonen"),
                                                "Students at a hidden academy learn to harness cursed energy while battling ancient spirits that threaten to consume the living world."));

                for (DemoDef d : defs) {
                        if (mangaRepository.findBySlug(d.slug()).isPresent()) {
                                log.debug("Manga '{}' already exists — skipping", d.slug());
                                continue;
                        }

                        Creator creator = creators.get(d.creatorSlug());
                        List<String> authorIds = creator != null ? List.of(creator.getId()) : List.of();
                        List<String> genreIds = d.genreSlugs().stream()
                                        .map(genres::get).filter(Objects::nonNull)
                                        .map(Genre::getId).toList();
                        List<String> tagIds = d.tagSlugs().stream()
                                        .map(tags::get).filter(Objects::nonNull)
                                        .map(Tag::getId).toList();

                        Instant now = Instant.now();
                        MangaSeries manga = MangaSeries.builder()
                                        .title(d.title())
                                        .slug(d.slug())
                                        .description(d.description())
                                        .authorIds(authorIds)
                                        .artistIds(authorIds)
                                        .genreIds(genreIds)
                                        .tagIds(tagIds)
                                        .status(MangaStatus.ONGOING)
                                        .publicationDemographic(PublicationDemographic.SHONEN)
                                        .contentRating(ContentRating.SAFE)
                                        .releaseYear(2024)
                                        .licenseStatus(LicenseStatus.DEMO)
                                        .isPremium(false)
                                        .viewCount(0L)
                                        .favoriteCount(0L)
                                        .lastUpdatedAt(now)
                                        .createdAt(now)
                                        .updatedAt(now)
                                        .build();

                        MangaSeries saved = mangaRepository.save(manga);
                        log.info("Seeded DEMO manga: {}", d.title());

                        seedDemoChapters(saved);
                }
        }

        /**
         * Creates 5 chapters × 5 pages for a DEMO manga.
         * Pages use placeholder imageUrls — no binary data stored.
         */
        private void seedDemoChapters(MangaSeries manga) {
                for (int chNum = 1; chNum <= 5; chNum++) {
                        List<MangaPage> pages = new ArrayList<>();
                        for (int pageIdx = 0; pageIdx < 5; pageIdx++) {
                                pages.add(MangaPage.builder()
                                                .pageIndex(pageIdx)
                                                // Placeholder URL — no binary image stored in MongoDB
                                                .imageUrl(String.format(
                                                                "https://placeholder.manga/demo/%s/ch%d/p%d.jpg",
                                                                manga.getSlug(), chNum, pageIdx + 1))
                                                .width(800)
                                                .height(1200)
                                                .build());
                        }

                        Instant now = Instant.now();
                        MangaChapter chapter = MangaChapter.builder()
                                        .mangaId(manga.getId())
                                        .chapterNumber((double) chNum)
                                        .title("Chapter " + chNum)
                                        .language("en")
                                        .sourceType(ChapterSourceType.DEMO)
                                        .isPremium(false)
                                        .pageCount(pages.size())
                                        .pages(pages)
                                        .publishedAt(now)
                                        .createdAt(now)
                                        .updatedAt(now)
                                        .build();

                        chapterRepository.save(chapter);
                }
                log.info("  → Seeded 5 chapters (5 pages each) for '{}'", manga.getTitle());
        }
}
