package prm.prmbackend.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import prm.prmbackend.dto.request.CreatorRequestDTO;
import prm.prmbackend.dto.response.CreatorResponseDTO;

import java.util.List;

public interface CreatorService {

    // ── spec methods ──────────────────────────────────────────────────────────

    List<CreatorResponseDTO> getAllCreators();

    CreatorResponseDTO getCreatorById(String id);

    // ── extra methods ─────────────────────────────────────────────────────────

    Page<CreatorResponseDTO> findAll(Pageable pageable);

    Page<CreatorResponseDTO> search(String name, Pageable pageable);

    CreatorResponseDTO create(CreatorRequestDTO request);

    CreatorResponseDTO update(String id, CreatorRequestDTO request);

    void delete(String id);
}
