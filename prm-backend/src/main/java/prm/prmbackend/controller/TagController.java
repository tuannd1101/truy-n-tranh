package prm.prmbackend.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import prm.prmbackend.dto.request.TagRequestDTO;
import prm.prmbackend.dto.response.BaseApiResponse;
import prm.prmbackend.dto.response.TagResponseDTO;
import prm.prmbackend.entity.enums.TagGroup;
import prm.prmbackend.service.TagService;

import java.util.List;

@RestController
@RequestMapping("/api/tags")
@RequiredArgsConstructor
public class TagController {

    private final TagService tagService;

    /**
     * GET /api/tags          → all tags
     * GET /api/tags?group=THEME → filtered by group
     */
    @GetMapping
    public ResponseEntity<BaseApiResponse<List<TagResponseDTO>>> getAll(
            @RequestParam(required = false) TagGroup group) {
        List<TagResponseDTO> result = (group != null)
                ? tagService.getTagsByGroup(group)
                : tagService.getAllTags();
        return ResponseEntity.ok(BaseApiResponse.ok("Success", result));
    }

    @GetMapping("/{id}")
    public ResponseEntity<BaseApiResponse<TagResponseDTO>> getById(
            @PathVariable String id) {
        return ResponseEntity.ok(BaseApiResponse.ok("Success",
                tagService.findById(id)));
    }

    // ── admin write endpoints ─────────────────────────────────────────────────

    @PostMapping
    @PreAuthorize("hasAnyRole('Admin', 'Manager')")
    public ResponseEntity<BaseApiResponse<TagResponseDTO>> create(
            @Valid @RequestBody TagRequestDTO request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(BaseApiResponse.ok("Tag created", tagService.create(request)));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('Admin', 'Manager')")
    public ResponseEntity<BaseApiResponse<TagResponseDTO>> update(
            @PathVariable String id,
            @Valid @RequestBody TagRequestDTO request) {
        return ResponseEntity.ok(BaseApiResponse.ok("Tag updated",
                tagService.update(id, request)));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('Admin', 'Manager')")
    public ResponseEntity<BaseApiResponse<Void>> delete(@PathVariable String id) {
        tagService.delete(id);
        return ResponseEntity.ok(BaseApiResponse.ok("Tag deleted", null));
    }
}
