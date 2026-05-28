package prm.prmbackend.service;

import prm.prmbackend.dto.request.TagRequestDTO;
import prm.prmbackend.dto.response.TagResponseDTO;
import prm.prmbackend.entity.enums.TagGroup;

import java.util.List;

public interface TagService {

    // ── spec methods ──────────────────────────────────────────────────────────

    List<TagResponseDTO> getAllTags();

    List<TagResponseDTO> getTagsByGroup(TagGroup group);

    // ── extra methods ─────────────────────────────────────────────────────────

    TagResponseDTO findById(String id);

    TagResponseDTO create(TagRequestDTO request);

    TagResponseDTO update(String id, TagRequestDTO request);

    void delete(String id);
}
