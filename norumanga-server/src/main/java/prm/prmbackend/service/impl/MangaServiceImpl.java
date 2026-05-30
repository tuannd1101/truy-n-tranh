package prm.prmbackend.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import prm.prmbackend.dto.request.MangaRequestDTO;
import prm.prmbackend.dto.response.MangaResponseDTO;
import prm.prmbackend.entity.MangaSeries;
import prm.prmbackend.entity.enums.MangaStatus;
import prm.prmbackend.exception.AppException;
import prm.prmbackend.exception.ErrorCode;
import prm.prmbackend.repository.MangaChapterRepository;
import prm.prmbackend.repository.MangaRepository;
import prm.prmbackend.repository.CreatorRepository;
import prm.prmbackend.repository.TagRepository;
import prm.prmbackend.dto.response.CreatorResponseDTO;
import prm.prmbackend.dto.response.TagResponseDTO;
import prm.prmbackend.service.MangaService;

import java.time.Instant;
import java.util.List;

@Service
@RequiredArgsConstructor
public class MangaServiceImpl implements MangaService {

    private final MangaRepository mangaRepository;
    private final MangaChapterRepository chapterRepository;
    private final CreatorRepository creatorRepository;
    private final TagRepository tagRepository;

    // ── spec methods ──────────────────────────────────────────────────────────

    @Override
    public List<MangaResponseDTO> getLatestMangas() {
        return mangaRepository.findTop10ByOrderByUpdatedAtDesc()
                .stream().map(this::toResponse).toList();
    }

    @Override
    public List<MangaResponseDTO> getRecommendedMangas() {
        return mangaRepository.findTop10ByOrderByCreatedAtDesc()
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
            String tagId,
            MangaStatus status,
            Pageable pageable) {

        if (tagId != null && !tagId.isBlank()) {
            return mangaRepository.findByTagIdsContaining(tagId, pageable)
                    .map(this::toResponse);
        }
        if (status != null) {
            return mangaRepository.findByStatus(status, pageable).map(this::toResponse);
        }
        return mangaRepository.findAll(pageable).map(this::toResponse);
    }

    // ── admin / write methods ─────────────────────────────────────────────────

    @Override
    public Page<MangaResponseDTO> findAll(Pageable pageable) {
        return mangaRepository.findAll(pageable).map(this::toResponse);
    }

    @Override
    public Page<MangaResponseDTO> findByCreator(String creatorId, Pageable pageable) {
        return mangaRepository.findByCreatorIdsContaining(creatorId, pageable)
                .map(this::toResponse);
    }

    @Override
    public MangaResponseDTO create(MangaRequestDTO request) {
        Instant now = Instant.now();
        MangaSeries manga = MangaSeries.builder()
                .title(request.getTitle())
                .slug(request.getSlug())
                .description(request.getDescription())
                .coverUrl(request.getCoverUrl())
                .creatorIds(request.getCreatorIds())
                .tagIds(request.getTagIds())
                .status(request.getStatus())
                .isPremium(request.getIsPremium() != null ? request.getIsPremium() : false)
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
        manga.setDescription(request.getDescription());
        manga.setCoverUrl(request.getCoverUrl());
        manga.setCreatorIds(request.getCreatorIds());
        manga.setTagIds(request.getTagIds());
        manga.setStatus(request.getStatus());
        if (request.getIsPremium() != null) manga.setIsPremium(request.getIsPremium());
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
        List<CreatorResponseDTO> creators = m.getCreatorIds() == null || m.getCreatorIds().isEmpty() 
            ? List.of()
            : creatorRepository.findAllById(m.getCreatorIds()).stream()
                .map(c -> CreatorResponseDTO.builder().id(c.getId()).name(c.getName()).slug(c.getSlug()).build()).toList();

        List<TagResponseDTO> tags = m.getTagIds() == null || m.getTagIds().isEmpty()
            ? List.of()
            : tagRepository.findAllById(m.getTagIds()).stream()
                .map(t -> TagResponseDTO.builder().id(t.getId()).name(t.getName()).slug(t.getSlug()).build()).toList();

        return MangaResponseDTO.builder()
                .id(m.getId())
                .title(m.getTitle())
                .slug(m.getSlug())
                .description(m.getDescription())
                .coverUrl(m.getCoverUrl())
                .creators(creators)
                .tags(tags)
                .status(m.getStatus())
                .isPremium(m.getIsPremium())
                .build();
    }
}
