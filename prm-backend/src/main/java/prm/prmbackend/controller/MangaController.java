package prm.prmbackend.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import prm.prmbackend.dto.request.MangaRequestDTO;
import prm.prmbackend.dto.response.BaseApiResponse;
import prm.prmbackend.dto.response.MangaResponseDTO;
import prm.prmbackend.entity.enums.LicenseStatus;
import prm.prmbackend.entity.enums.MangaStatus;
import prm.prmbackend.service.MangaService;

import java.util.List;

@RestController
@RequestMapping("/api/mangas")
@RequiredArgsConstructor
public class MangaController {

    private final MangaService mangaService;

    // ── public read endpoints ─────────────────────────────────────────────────

    /**
     * GET /api/mangas/latest
     * Top 10 most recently updated.
     */
    @GetMapping("/latest")
    public ResponseEntity<BaseApiResponse<List<MangaResponseDTO>>> latest() {
        return ResponseEntity.ok(BaseApiResponse.ok("Success",
                mangaService.getLatestMangas()));
    }

    /**
     * GET /api/mangas/recommended
     * Top 10 most viewed.
     */
    @GetMapping("/recommended")
    public ResponseEntity<BaseApiResponse<List<MangaResponseDTO>>> recommended() {
        return ResponseEntity.ok(BaseApiResponse.ok("Success",
                mangaService.getRecommendedMangas()));
    }

    /**
     * GET /api/mangas/{id}
     */
    @GetMapping("/{id}")
    public ResponseEntity<BaseApiResponse<MangaResponseDTO>> getById(
            @PathVariable String id) {
        return ResponseEntity.ok(BaseApiResponse.ok("Success",
                mangaService.getMangaById(id)));
    }

    /**
     * GET /api/mangas/slug/{slug}
     */
    @GetMapping("/slug/{slug}")
    public ResponseEntity<BaseApiResponse<MangaResponseDTO>> getBySlug(
            @PathVariable String slug) {
        return ResponseEntity.ok(BaseApiResponse.ok("Success",
                mangaService.getMangaBySlug(slug)));
    }

    /**
     * GET /api/mangas/search?q=keyword
     */
    @GetMapping("/search")
    public ResponseEntity<BaseApiResponse<Page<MangaResponseDTO>>> search(
            @RequestParam(name = "q", required = false, defaultValue = "") String q,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {

        PageRequest pageable = PageRequest.of(page, size,
                Sort.by("lastUpdatedAt").descending());
        return ResponseEntity.ok(BaseApiResponse.ok("Success",
                mangaService.searchMangas(q, pageable)));
    }

    /**
     * GET /api/mangas?genreId=&tagId=&status=&licenseStatus=&page=&size=
     */
    @GetMapping
    public ResponseEntity<BaseApiResponse<Page<MangaResponseDTO>>> filter(
            @RequestParam(required = false) String genreId,
            @RequestParam(required = false) String tagId,
            @RequestParam(required = false) MangaStatus status,
            @RequestParam(required = false) LicenseStatus licenseStatus,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {

        PageRequest pageable = PageRequest.of(page, size,
                Sort.by("lastUpdatedAt").descending());
        return ResponseEntity.ok(BaseApiResponse.ok("Success",
                mangaService.getMangasByFilter(genreId, tagId, status, licenseStatus, pageable)));
    }

    // ── admin write endpoints ─────────────────────────────────────────────────

    @PostMapping
    @PreAuthorize("hasAnyRole('Admin', 'Manager')")
    public ResponseEntity<BaseApiResponse<MangaResponseDTO>> create(
            @Valid @RequestBody MangaRequestDTO request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(BaseApiResponse.ok("Manga created", mangaService.create(request)));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('Admin', 'Manager')")
    public ResponseEntity<BaseApiResponse<MangaResponseDTO>> update(
            @PathVariable String id,
            @Valid @RequestBody MangaRequestDTO request) {
        return ResponseEntity.ok(BaseApiResponse.ok("Manga updated",
                mangaService.update(id, request)));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('Admin')")
    public ResponseEntity<BaseApiResponse<Void>> delete(@PathVariable String id) {
        mangaService.delete(id);
        return ResponseEntity.ok(BaseApiResponse.ok("Manga deleted", null));
    }
}
