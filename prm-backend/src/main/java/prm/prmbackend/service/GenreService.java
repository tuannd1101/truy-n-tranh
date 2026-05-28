package prm.prmbackend.service;

import prm.prmbackend.dto.request.GenreRequestDTO;
import prm.prmbackend.dto.response.GenreResponseDTO;

import java.util.List;

public interface GenreService {

    // ── spec method ───────────────────────────────────────────────────────────

    List<GenreResponseDTO> getAllGenres();

    // ── extra methods ─────────────────────────────────────────────────────────

    GenreResponseDTO findById(String id);

    GenreResponseDTO create(GenreRequestDTO request);

    GenreResponseDTO update(String id, GenreRequestDTO request);

    void delete(String id);
}
