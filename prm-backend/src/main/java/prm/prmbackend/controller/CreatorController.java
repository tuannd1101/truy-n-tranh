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
import prm.prmbackend.dto.request.CreatorRequestDTO;
import prm.prmbackend.dto.response.BaseApiResponse;
import prm.prmbackend.dto.response.CreatorResponseDTO;
import prm.prmbackend.service.CreatorService;

import java.util.List;

@RestController
@RequestMapping("/api/creators")
@RequiredArgsConstructor
public class CreatorController {

    private final CreatorService creatorService;

    /**
     * GET /api/creators          → all creators
     * GET /api/creators?name=xyz → search by name
     */
    @GetMapping
    public ResponseEntity<BaseApiResponse<?>> getAll(
            @RequestParam(required = false) String name,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {

        if (name != null && !name.isBlank()) {
            PageRequest pageable = PageRequest.of(page, size, Sort.by("name").ascending());
            Page<CreatorResponseDTO> result = creatorService.search(name, pageable);
            return ResponseEntity.ok(BaseApiResponse.ok("Success", result));
        }

        List<CreatorResponseDTO> result = creatorService.getAllCreators();
        return ResponseEntity.ok(BaseApiResponse.ok("Success", result));
    }

    /**
     * GET /api/creators/{id}
     */
    @GetMapping("/{id}")
    public ResponseEntity<BaseApiResponse<CreatorResponseDTO>> getById(
            @PathVariable String id) {
        return ResponseEntity.ok(BaseApiResponse.ok("Success",
                creatorService.getCreatorById(id)));
    }

    // ── admin write endpoints ─────────────────────────────────────────────────

    @PostMapping
    @PreAuthorize("hasAnyRole('Admin', 'Manager')")
    public ResponseEntity<BaseApiResponse<CreatorResponseDTO>> create(
            @Valid @RequestBody CreatorRequestDTO request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(BaseApiResponse.ok("Creator created", creatorService.create(request)));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('Admin', 'Manager')")
    public ResponseEntity<BaseApiResponse<CreatorResponseDTO>> update(
            @PathVariable String id,
            @Valid @RequestBody CreatorRequestDTO request) {
        return ResponseEntity.ok(BaseApiResponse.ok("Creator updated",
                creatorService.update(id, request)));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('Admin', 'Manager')")
    public ResponseEntity<BaseApiResponse<Void>> delete(@PathVariable String id) {
        creatorService.delete(id);
        return ResponseEntity.ok(BaseApiResponse.ok("Creator deleted", null));
    }
}
