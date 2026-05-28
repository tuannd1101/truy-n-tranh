package prm.prmbackend.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import prm.prmbackend.dto.request.GenreRequestDTO;
import prm.prmbackend.dto.response.GenreResponseDTO;
import prm.prmbackend.entity.Genre;
import prm.prmbackend.exception.AppException;
import prm.prmbackend.exception.ErrorCode;
import prm.prmbackend.repository.GenreRepository;
import prm.prmbackend.service.GenreService;

import java.time.Instant;
import java.util.List;

@Service
@RequiredArgsConstructor
public class GenreServiceImpl implements GenreService {

    private final GenreRepository genreRepository;

    // ── spec method ───────────────────────────────────────────────────────────

    @Override
    public List<GenreResponseDTO> getAllGenres() {
        return genreRepository.findAll().stream().map(this::toResponse).toList();
    }

    // ── extra methods ─────────────────────────────────────────────────────────

    @Override
    public GenreResponseDTO findById(String id) {
        return toResponse(getOrThrow(id));
    }

    @Override
    public GenreResponseDTO create(GenreRequestDTO request) {
        if (genreRepository.existsByName(request.getName())) {
            throw new AppException(ErrorCode.GENRE_ALREADY_EXISTS);
        }
        Instant now = Instant.now();
        Genre genre = Genre.builder()
                .name(request.getName())
                .slug(request.getSlug())
                .createdAt(now)
                .updatedAt(now)
                .build();
        return toResponse(genreRepository.save(genre));
    }

    @Override
    public GenreResponseDTO update(String id, GenreRequestDTO request) {
        Genre genre = getOrThrow(id);
        genre.setName(request.getName());
        genre.setSlug(request.getSlug());
        genre.setUpdatedAt(Instant.now());
        return toResponse(genreRepository.save(genre));
    }

    @Override
    public void delete(String id) {
        getOrThrow(id);
        genreRepository.deleteById(id);
    }

    // ── helpers ──────────────────────────────────────────────────────────────

    private Genre getOrThrow(String id) {
        return genreRepository.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.GENRE_NOT_FOUND));
    }

    private GenreResponseDTO toResponse(Genre g) {
        return GenreResponseDTO.builder()
                .id(g.getId())
                .name(g.getName())
                .slug(g.getSlug())
                .build();
    }
}
