package prm.prmbackend.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import prm.prmbackend.dto.request.MangaChapterRequestDTO;
import prm.prmbackend.dto.response.ChapterDetailResponseDTO;
import prm.prmbackend.dto.response.ChapterResponseDTO;
import prm.prmbackend.entity.MangaChapter;
import prm.prmbackend.entity.MangaSeries;
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

    @Override
    public List<ChapterResponseDTO> getChaptersByMangaId(String mangaId) {
        getMangaOrThrow(mangaId);
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
            String mangaId, Double chapterNumber) {
        getMangaOrThrow(mangaId);
        return chapterRepository
                .findByMangaIdAndChapterNumber(mangaId, chapterNumber)
                .map(this::toDetailResponse)
                .orElseThrow(() -> new AppException(ErrorCode.CHAPTER_NOT_FOUND));
    }

    @Override
    public ChapterDetailResponseDTO create(String mangaId, MangaChapterRequestDTO request) {
        getMangaOrThrow(mangaId);

        if (chapterRepository.existsByMangaIdAndChapterNumber(
                mangaId, request.getChapterNumber())) {
            throw new AppException(ErrorCode.CHAPTER_ALREADY_EXISTS);
        }

        List<String> pages = request.getPages() != null ? request.getPages() : Collections.emptyList();
        Instant now = Instant.now();

        MangaChapter chapter = MangaChapter.builder()
                .mangaId(mangaId)
                .chapterNumber(request.getChapterNumber())
                .isPremium(request.getIsPremium() != null ? request.getIsPremium() : false)
                .pages(pages)
                .createdAt(now)
                .updatedAt(now)
                .build();

        return toDetailResponse(chapterRepository.save(chapter));
    }

    @Override
    public ChapterDetailResponseDTO update(String chapterId, MangaChapterRequestDTO request) {
        MangaChapter chapter = getChapterOrThrow(chapterId);

        boolean numberChanged = !chapter.getChapterNumber().equals(request.getChapterNumber());
        if (numberChanged) {
            if (chapterRepository.existsByMangaIdAndChapterNumber(
                    chapter.getMangaId(), request.getChapterNumber())) {
                throw new AppException(ErrorCode.CHAPTER_ALREADY_EXISTS);
            }
        }

        List<String> pages = request.getPages() != null ? request.getPages() : Collections.emptyList();
        chapter.setChapterNumber(request.getChapterNumber());
        if (request.getIsPremium() != null) chapter.setIsPremium(request.getIsPremium());
        chapter.setPages(pages);
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

    /** Lightweight — no pages */
    private ChapterResponseDTO toChapterResponse(MangaChapter c) {
        return ChapterResponseDTO.builder()
                .id(c.getId())
                .mangaId(c.getMangaId())
                .chapterNumber(c.getChapterNumber())
                .isPremium(c.getIsPremium())
                .build();
    }

    /** Full — includes pages */
    private ChapterDetailResponseDTO toDetailResponse(MangaChapter c) {
        return ChapterDetailResponseDTO.builder()
                .id(c.getId())
                .mangaId(c.getMangaId())
                .chapterNumber(c.getChapterNumber())
                .isPremium(c.getIsPremium())
                .pages(c.getPages() != null ? c.getPages() : Collections.emptyList())
                .build();
    }
}
