package prm.prmbackend.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import prm.prmbackend.dto.request.MangaChapterRequestDTO;
import prm.prmbackend.dto.response.ChapterDetailResponseDTO;
import prm.prmbackend.dto.response.ChapterResponseDTO;
import prm.prmbackend.dto.response.MangaPageResponseDTO;
import prm.prmbackend.entity.MangaChapter;
import prm.prmbackend.entity.MangaPage;
import prm.prmbackend.entity.MangaSeries;
import prm.prmbackend.entity.enums.LicenseStatus;
import prm.prmbackend.exception.AppException;
import prm.prmbackend.exception.ErrorCode;
import prm.prmbackend.repository.MangaChapterRepository;
import prm.prmbackend.repository.MangaRepository;
import prm.prmbackend.service.MangaChapterService;

import java.time.Instant;
import java.util.Collections;
import java.util.List;

@Service
@RequiredArgsConstructor
public class MangaChapterServiceImpl implements MangaChapterService {

    private final MangaChapterRepository chapterRepository;
    private final MangaRepository mangaRepository;

    // ── spec methods ──────────────────────────────────────────────────────────

    /**
     * Business rule:
     *   EXTERNAL_LINK_ONLY → empty list (no chapter content stored).
     *   DEMO or LICENSED   → return chapters normally.
     */
    @Override
    public List<ChapterResponseDTO> getChaptersByMangaId(String mangaId) {
        MangaSeries manga = getMangaOrThrow(mangaId);

        if (LicenseStatus.EXTERNAL_LINK_ONLY.equals(manga.getLicenseStatus())) {
            return Collections.emptyList();
        }

        return chapterRepository.findByMangaIdOrderByChapterNumberAsc(mangaId)
                .stream().map(this::toChapterResponse).toList();
    }

    @Override
    public ChapterDetailResponseDTO getChapterById(String id) {
        return toDetailResponse(getChapterOrThrow(id));
    }

    // ── extra methods ─────────────────────────────────────────────────────────

    @Override
    public Page<ChapterResponseDTO> findByManga(String mangaId, Pageable pageable) {
        getMangaOrThrow(mangaId);
        return chapterRepository.findByMangaId(mangaId, pageable)
                .map(this::toChapterResponse);
    }

    @Override
    public ChapterDetailResponseDTO findByMangaAndNumber(
            String mangaId, String language, Double chapterNumber) {
        getMangaOrThrow(mangaId);
        return chapterRepository
                .findByMangaIdAndLanguageAndChapterNumber(mangaId, language, chapterNumber)
                .map(this::toDetailResponse)
                .orElseThrow(() -> new AppException(ErrorCode.CHAPTER_NOT_FOUND));
    }

    @Override
    public ChapterDetailResponseDTO create(String mangaId, MangaChapterRequestDTO request) {
        MangaSeries manga = getMangaOrThrow(mangaId);

        // Copyright enforcement: LICENSED and EXTERNAL_LINK_ONLY cannot store chapter content
        LicenseStatus ls = manga.getLicenseStatus();
        if (LicenseStatus.LICENSED.equals(ls) || LicenseStatus.EXTERNAL_LINK_ONLY.equals(ls)) {
            throw new AppException(ErrorCode.MANGA_LICENSED);
        }

        if (chapterRepository.existsByMangaIdAndLanguageAndChapterNumber(
                mangaId, request.getLanguage(), request.getChapterNumber())) {
            throw new AppException(ErrorCode.CHAPTER_ALREADY_EXISTS);
        }

        List<MangaPage> pages = mapPages(request);
        Instant now = Instant.now();

        MangaChapter chapter = MangaChapter.builder()
                .mangaId(mangaId)
                .volumeNumber(request.getVolumeNumber())
                .chapterNumber(request.getChapterNumber())
                .title(request.getTitle())
                .language(request.getLanguage())
                .sourceType(request.getSourceType())
                .isPremium(request.getIsPremium() != null ? request.getIsPremium() : false)
                .pageCount(pages.size())
                .pages(pages)
                .publishedAt(request.getPublishedAt() != null ? request.getPublishedAt() : now)
                .createdAt(now)
                .updatedAt(now)
                .build();

        return toDetailResponse(chapterRepository.save(chapter));
    }

    @Override
    public ChapterDetailResponseDTO update(String chapterId, MangaChapterRequestDTO request) {
        MangaChapter chapter = getChapterOrThrow(chapterId);

        boolean numberChanged = !chapter.getChapterNumber().equals(request.getChapterNumber());
        boolean langChanged = !chapter.getLanguage().equals(request.getLanguage());
        if (numberChanged || langChanged) {
            if (chapterRepository.existsByMangaIdAndLanguageAndChapterNumber(
                    chapter.getMangaId(), request.getLanguage(), request.getChapterNumber())) {
                throw new AppException(ErrorCode.CHAPTER_ALREADY_EXISTS);
            }
        }

        List<MangaPage> pages = mapPages(request);
        chapter.setVolumeNumber(request.getVolumeNumber());
        chapter.setChapterNumber(request.getChapterNumber());
        chapter.setTitle(request.getTitle());
        chapter.setLanguage(request.getLanguage());
        chapter.setSourceType(request.getSourceType());
        if (request.getIsPremium() != null) chapter.setIsPremium(request.getIsPremium());
        chapter.setPageCount(pages.size());
        chapter.setPages(pages);
        if (request.getPublishedAt() != null) chapter.setPublishedAt(request.getPublishedAt());
        chapter.setUpdatedAt(Instant.now());

        return toDetailResponse(chapterRepository.save(chapter));
    }

    @Override
    public void delete(String chapterId) {
        getChapterOrThrow(chapterId);
        chapterRepository.deleteById(chapterId);
    }

    // ── helpers ──────────────────────────────────────────────────────────────

    private MangaSeries getMangaOrThrow(String mangaId) {
        return mangaRepository.findById(mangaId)
                .orElseThrow(() -> new AppException(ErrorCode.MANGA_NOT_FOUND));
    }

    private MangaChapter getChapterOrThrow(String chapterId) {
        return chapterRepository.findById(chapterId)
                .orElseThrow(() -> new AppException(ErrorCode.CHAPTER_NOT_FOUND));
    }

    private List<MangaPage> mapPages(MangaChapterRequestDTO request) {
        if (request.getPages() == null) return Collections.emptyList();
        return request.getPages().stream()
                .map(p -> MangaPage.builder()
                        .pageIndex(p.getPageIndex())
                        .imageUrl(p.getImageUrl())   // only URL stored — no binary
                        .width(p.getWidth())
                        .height(p.getHeight())
                        .contentText(p.getContentText())
                        .build())
                .toList();
    }

    /** Lightweight — no pages */
    private ChapterResponseDTO toChapterResponse(MangaChapter c) {
        return ChapterResponseDTO.builder()
                .id(c.getId())
                .mangaId(c.getMangaId())
                .volumeNumber(c.getVolumeNumber())
                .chapterNumber(c.getChapterNumber())
                .title(c.getTitle())
                .language(c.getLanguage())
                .sourceType(c.getSourceType())
                .isPremium(c.getIsPremium())
                .pageCount(c.getPageCount())
                .publishedAt(c.getPublishedAt())
                .build();
    }

    /** Full — includes pages */
    private ChapterDetailResponseDTO toDetailResponse(MangaChapter c) {
        List<MangaPageResponseDTO> pages = c.getPages() == null
                ? Collections.emptyList()
                : c.getPages().stream()
                        .map(p -> MangaPageResponseDTO.builder()
                                .pageIndex(p.getPageIndex())
                                .imageUrl(p.getImageUrl())
                                .width(p.getWidth())
                                .height(p.getHeight())
                                .contentText(p.getContentText())
                                .build())
                        .toList();

        return ChapterDetailResponseDTO.builder()
                .id(c.getId())
                .mangaId(c.getMangaId())
                .volumeNumber(c.getVolumeNumber())
                .chapterNumber(c.getChapterNumber())
                .title(c.getTitle())
                .language(c.getLanguage())
                .sourceType(c.getSourceType())
                .isPremium(c.getIsPremium())
                .pageCount(c.getPageCount())
                .publishedAt(c.getPublishedAt())
                .pages(pages)
                .build();
    }
}
