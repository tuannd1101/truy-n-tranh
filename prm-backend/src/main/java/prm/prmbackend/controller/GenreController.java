package prm.prmbackend.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import prm.prmbackend.dto.request.GenreRequestDTO;
import prm.prmbackend.dto.response.BaseApiResponse;
import prm.prmbackend.dto.response.GenreResponseDTO;
import prm.prmbackend.service.GenreService;

import java.util.List;

@RestController
@RequestMapping("/api/genres")
@RequiredArgsConstructor
public class GenreController {

    private final GenreService genreService;

    /**
     * GET /api/genres
     */
    @GetMapping
    public ResponseEntity<BaseApiResponse<List<GenreResponseDTO>>> getAll() {
        return ResponseEntity.ok(BaseApiResponse.ok("Success",
                genreService.getAllGenres()));
    }

    @GetMapping("/{id}")
    public ResponseEntity<BaseApiResponse<GenreResponseDTO>> getById(
            @PathVariable String id) {
        return ResponseEntity.ok(BaseApiResponse.ok("Success",
                genreService.findById(id)));
    }

    // ── admin write endpoints ─────────────────────────────────────────────────

    @PostMapping
    @PreAuthorize("hasAnyRole('Admin', 'Manager')")
    public ResponseEntity<BaseApiResponse<GenreResponseDTO>> create(
            @Valid @RequestBody GenreRequestDTO request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(BaseApiResponse.ok("Genre created", genreService.create(request)));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('Admin', 'Manager')")
    public ResponseEntity<BaseApiResponse<GenreResponseDTO>> update(
            @PathVariable String id,
            @Valid @RequestBody GenreRequestDTO request) {
        return ResponseEntity.ok(BaseApiResponse.ok("Genre updated",
                genreService.update(id, request)));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('Admin', 'Manager')")
    public ResponseEntity<BaseApiResponse<Void>> delete(@PathVariable String id) {
        genreService.delete(id);
        return ResponseEntity.ok(BaseApiResponse.ok("Genre deleted", null));
    }
}
