package prm.prmbackend.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import prm.prmbackend.dto.request.MangaRequestDTO;
import prm.prmbackend.dto.response.MangaResponseDTO;
import prm.prmbackend.entity.MangaSeries;
import prm.prmbackend.entity.enums.LicenseStatus;
import prm.prmbackend.entity.enums.MangaStatus;
import prm.prmbackend.exception.AppException;
import prm.prmbackend.exception.ErrorCode;
import prm.prmbackend.repository.MangaChapterRepository;
import prm.prmbackend.repository.MangaRepository;
import prm.prmbackend.service.MangaService;

import java.time.Instant;
import java.util.List;

@Service
@RequiredArgsConstructor
public class MangaServiceImpl implements MangaService {

    private final MangaRepository mangaRepository;
    private final MangaChapterRepository chapterRepository;

    // ── spec methods ──────────────────────────────────────────────────────────

    @Override
    public List<MangaResponseDTO> getLatestMangas() {
        return mangaRepository.findTop10ByOrderByLastUpdatedAtDesc()
                .stream().map(this::toResponse).toList();
    }

    @Override
    public List<MangaResponseDTO> getRecommendedMangas() {
        return mangaRepository.findTop10ByOrderByViewCountDesc()
                .stream().map(this::toResponse).toList();
    }

    @Override
    public MangaResponseDTO getMangaById(String id) {
        return toResponse(getOrThrow(id));
    }

    @Override
    public MangaResponseDTO getMangaBySlug(String slug) {
        return toResponse(mangaRepository.findBySlug(slug)
                .orElseThrow(() -> new AppException(ErrorCode.MANGA_NOT_FOUND)));
    }

    @Override
    public Page<MangaResponseDTO> searchMangas(String query, Pageable pageable) {
        if (query == null || query.isBlank()) {
            return mangaRepository.findAll(pageable).map(this::toResponse);
        }
        return mangaRepository.findByTitleContainingIgnoreCase(query, pageable)
                .map(this::toResponse);
    }

    @Override
    public Page<MangaResponseDTO> getMangasByFilter(
            String genreId,
            String tagId,
            MangaStatus status,
            LicenseStatus licenseStatus,
            Pageable pageable) {

        // Apply the most specific single filter available.
        // For compound filters a @Query or Criteria approach would be needed;
        // this covers the common single-dimension cases cleanly.
        if (genreId != null && !genreId.isBlank()) {
            return mangaRepository.findByGenreIdsContaining(genreId, pageable)
                    .map(this::toResponse);
        }
        if (tagId != null && !tagId.isBlank()) {
            return mangaRepository.findByTagIdsContaining(tagId, pageable)
                    .map(this::toResponse);
        }
        if (status != null) {
            return mangaRepository.findByStatus(status, pageable).map(this::toResponse);
        }
        if (licenseStatus != null) {
            return mangaRepository.findByLicenseStatus(licenseStatus, pageable)
                    .map(this::toResponse);
        }
        return mangaRepository.findAll(pageable).map(this::toResponse);
    }

    // ── admin / write methods ─────────────────────────────────────────────────

    @Override
    public Page<MangaResponseDTO> findAll(Pageable pageable) {
        return mangaRepository.findAll(pageable).map(this::toResponse);
    }

    @Override
    public Page<MangaResponseDTO> findByAuthor(String authorId, Pageable pageable) {
        return mangaRepository.findByAuthorIdsContaining(authorId, pageable)
                .map(this::toResponse);
    }

    @Override
    public MangaResponseDTO create(MangaRequestDTO request) {
        Instant now = Instant.now();
        MangaSeries manga = MangaSeries.builder()
                .title(request.getTitle())
                .slug(request.getSlug())
                .originalTitle(request.getOriginalTitle())
                .alternativeTitles(request.getAlternativeTitles())
                .description(request.getDescription())
                .coverUrl(request.getCoverUrl())
                .bannerUrl(request.getBannerUrl())
                .authorIds(request.getAuthorIds())
                .artistIds(request.getArtistIds())
                .genreIds(request.getGenreIds())
                .tagIds(request.getTagIds())
                .originalLanguage(request.getOriginalLanguage())
                .status(request.getStatus())
                .publicationDemographic(request.getPublicationDemographic())
                .contentRating(request.getContentRating())
                .releaseYear(request.getReleaseYear())
                .isPremium(request.getIsPremium() != null ? request.getIsPremium() : false)
                .licenseStatus(request.getLicenseStatus() != null
                        ? request.getLicenseStatus() : LicenseStatus.DEMO)
                .sourceName(request.getSourceName())
                .officialUrl(request.getOfficialUrl())
                .createdAt(now)
                .updatedAt(now)
                .build();
        return toResponse(mangaRepository.save(manga));
    }

    @Override
    public MangaResponseDTO update(String id, MangaRequestDTO request) {
        MangaSeries manga = getOrThrow(id);
        manga.setTitle(request.getTitle());
        manga.setSlug(request.getSlug());
        manga.setOriginalTitle(request.getOriginalTitle());
        manga.setAlternativeTitles(request.getAlternativeTitles());
        manga.setDescription(request.getDescription());
        manga.setCoverUrl(request.getCoverUrl());
        manga.setBannerUrl(request.getBannerUrl());
        manga.setAuthorIds(request.getAuthorIds());
        manga.setArtistIds(request.getArtistIds());
        manga.setGenreIds(request.getGenreIds());
        manga.setTagIds(request.getTagIds());
        manga.setOriginalLanguage(request.getOriginalLanguage());
        manga.setStatus(request.getStatus());
        manga.setPublicationDemographic(request.getPublicationDemographic());
        manga.setContentRating(request.getContentRating());
        manga.setReleaseYear(request.getReleaseYear());
        if (request.getIsPremium() != null) manga.setIsPremium(request.getIsPremium());
        if (request.getLicenseStatus() != null) manga.setLicenseStatus(request.getLicenseStatus());
        manga.setSourceName(request.getSourceName());
        manga.setOfficialUrl(request.getOfficialUrl());
        manga.setUpdatedAt(Instant.now());
        return toResponse(mangaRepository.save(manga));
    }

    @Override
    public void delete(String id) {
        getOrThrow(id);
        chapterRepository.deleteAllByMangaId(id);
        mangaRepository.deleteById(id);
    }

    // ── helpers ──────────────────────────────────────────────────────────────

    private MangaSeries getOrThrow(String id) {
        return mangaRepository.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.MANGA_NOT_FOUND));
    }

    private MangaResponseDTO toResponse(MangaSeries m) {
        return MangaResponseDTO.builder()
                .id(m.getId())
                .title(m.getTitle())
                .slug(m.getSlug())
                .description(m.getDescription())
                .coverUrl(m.getCoverUrl())
                .bannerUrl(m.getBannerUrl())
                .authors(m.getAuthorIds())
                .artists(m.getArtistIds())
                .genres(m.getGenreIds())
                .tags(m.getTagIds())
                .status(m.getStatus())
                .publicationDemographic(m.getPublicationDemographic())
                .contentRating(m.getContentRating())
                .releaseYear(m.getReleaseYear())
                .lastChapter(m.getLastChapter())
                .lastUpdatedAt(m.getLastUpdatedAt())
                .viewCount(m.getViewCount())
                .favoriteCount(m.getFavoriteCount())
                .isPremium(m.getIsPremium())
                .licenseStatus(m.getLicenseStatus())
                .sourceName(m.getSourceName())
                .officialUrl(m.getOfficialUrl())
                .build();
    }
}
