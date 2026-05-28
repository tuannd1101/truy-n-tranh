package prm.prmbackend.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import prm.prmbackend.dto.request.TagRequestDTO;
import prm.prmbackend.dto.response.TagResponseDTO;
import prm.prmbackend.entity.Tag;
import prm.prmbackend.entity.enums.TagGroup;
import prm.prmbackend.exception.AppException;
import prm.prmbackend.exception.ErrorCode;
import prm.prmbackend.repository.TagRepository;
import prm.prmbackend.service.TagService;

import java.time.Instant;
import java.util.List;

@Service
@RequiredArgsConstructor
public class TagServiceImpl implements TagService {

    private final TagRepository tagRepository;

    // ── spec methods ──────────────────────────────────────────────────────────

    @Override
    public List<TagResponseDTO> getAllTags() {
        return tagRepository.findAll().stream().map(this::toResponse).toList();
    }

    @Override
    public List<TagResponseDTO> getTagsByGroup(TagGroup group) {
        return tagRepository.findByGroup(group).stream().map(this::toResponse).toList();
    }

    // ── extra methods ─────────────────────────────────────────────────────────

    @Override
    public TagResponseDTO findById(String id) {
        return toResponse(getOrThrow(id));
    }

    @Override
    public TagResponseDTO create(TagRequestDTO request) {
        if (tagRepository.existsByName(request.getName())) {
            throw new AppException(ErrorCode.TAG_ALREADY_EXISTS);
        }
        Instant now = Instant.now();
        Tag tag = Tag.builder()
                .name(request.getName())
                .slug(request.getSlug())
                .group(request.getGroup())
                .createdAt(now)
                .updatedAt(now)
                .build();
        return toResponse(tagRepository.save(tag));
    }

    @Override
    public TagResponseDTO update(String id, TagRequestDTO request) {
        Tag tag = getOrThrow(id);
        tag.setName(request.getName());
        tag.setSlug(request.getSlug());
        tag.setGroup(request.getGroup());
        tag.setUpdatedAt(Instant.now());
        return toResponse(tagRepository.save(tag));
    }

    @Override
    public void delete(String id) {
        getOrThrow(id);
        tagRepository.deleteById(id);
    }

    // ── helpers ──────────────────────────────────────────────────────────────

    private Tag getOrThrow(String id) {
        return tagRepository.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.TAG_NOT_FOUND));
    }

    private TagResponseDTO toResponse(Tag t) {
        return TagResponseDTO.builder()
                .id(t.getId())
                .name(t.getName())
                .slug(t.getSlug())
                .group(t.getGroup())
                .build();
    }
}
