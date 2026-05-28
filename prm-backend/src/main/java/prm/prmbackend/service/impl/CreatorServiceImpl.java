package prm.prmbackend.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import prm.prmbackend.dto.request.CreatorRequestDTO;
import prm.prmbackend.dto.response.CreatorResponseDTO;
import prm.prmbackend.entity.Creator;
import prm.prmbackend.exception.AppException;
import prm.prmbackend.exception.ErrorCode;
import prm.prmbackend.repository.CreatorRepository;
import prm.prmbackend.service.CreatorService;

import java.time.Instant;
import java.util.List;

@Service
@RequiredArgsConstructor
public class CreatorServiceImpl implements CreatorService {

    private final CreatorRepository creatorRepository;

    // ── spec methods ──────────────────────────────────────────────────────────

    @Override
    public List<CreatorResponseDTO> getAllCreators() {
        return creatorRepository.findAll().stream().map(this::toResponse).toList();
    }

    @Override
    public CreatorResponseDTO getCreatorById(String id) {
        return toResponse(getOrThrow(id));
    }

    // ── extra methods ─────────────────────────────────────────────────────────

    @Override
    public Page<CreatorResponseDTO> findAll(Pageable pageable) {
        return creatorRepository.findAll(pageable).map(this::toResponse);
    }

    @Override
    public Page<CreatorResponseDTO> search(String name, Pageable pageable) {
        return creatorRepository.findByNameContainingIgnoreCase(name, pageable)
                .map(this::toResponse);
    }

    @Override
    public CreatorResponseDTO create(CreatorRequestDTO request) {
        Instant now = Instant.now();
        Creator creator = Creator.builder()
                .name(request.getName())
                .slug(request.getSlug())
                .originalName(request.getOriginalName())
                .biography(request.getBiography())
                .avatarUrl(request.getAvatarUrl())
                .createdAt(now)
                .updatedAt(now)
                .build();
        return toResponse(creatorRepository.save(creator));
    }

    @Override
    public CreatorResponseDTO update(String id, CreatorRequestDTO request) {
        Creator creator = getOrThrow(id);
        creator.setName(request.getName());
        creator.setSlug(request.getSlug());
        creator.setOriginalName(request.getOriginalName());
        creator.setBiography(request.getBiography());
        creator.setAvatarUrl(request.getAvatarUrl());
        creator.setUpdatedAt(Instant.now());
        return toResponse(creatorRepository.save(creator));
    }

    @Override
    public void delete(String id) {
        getOrThrow(id);
        creatorRepository.deleteById(id);
    }

    // ── helpers ──────────────────────────────────────────────────────────────

    private Creator getOrThrow(String id) {
        return creatorRepository.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.CREATOR_NOT_FOUND));
    }

    private CreatorResponseDTO toResponse(Creator c) {
        return CreatorResponseDTO.builder()
                .id(c.getId())
                .name(c.getName())
                .slug(c.getSlug())
                .originalName(c.getOriginalName())
                .avatarUrl(c.getAvatarUrl())
                .build();
    }
}
