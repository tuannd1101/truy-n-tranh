package prm.prmbackend.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import prm.prmbackend.dto.request.BundleRequestDTO;
import prm.prmbackend.dto.response.BaseApiResponse;
import prm.prmbackend.dto.response.BundleResponseDTO;
import prm.prmbackend.service.BundleService;

import java.util.List;

@RestController
@RequestMapping("/api/bundles")
@RequiredArgsConstructor
public class BundleController {

    private final BundleService bundleService;

    // ── public read endpoints ─────────────────────────────────────────────────

    /**
     * GET /api/bundles            → active bundles only (default, client view)
     * GET /api/bundles?all=true   → all bundles (admin view)
     */
    @GetMapping
    public ResponseEntity<BaseApiResponse<List<BundleResponseDTO>>> getAll(
            @RequestParam(required = false, defaultValue = "false") boolean all) {
        List<BundleResponseDTO> result = all
                ? bundleService.getAllBundles()
                : bundleService.getActiveBundles();
        return ResponseEntity.ok(BaseApiResponse.ok("Success", result));
    }

    @GetMapping("/{id}")
    public ResponseEntity<BaseApiResponse<BundleResponseDTO>> getById(
            @PathVariable String id) {
        return ResponseEntity.ok(BaseApiResponse.ok("Success",
                bundleService.findById(id)));
    }

    // ── admin write endpoints ─────────────────────────────────────────────────

    @PostMapping
    @PreAuthorize("hasAnyRole('Admin', 'Manager')")
    public ResponseEntity<BaseApiResponse<BundleResponseDTO>> create(
            @Valid @RequestBody BundleRequestDTO request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(BaseApiResponse.ok("Bundle created", bundleService.create(request)));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('Admin', 'Manager')")
    public ResponseEntity<BaseApiResponse<BundleResponseDTO>> update(
            @PathVariable String id,
            @Valid @RequestBody BundleRequestDTO request) {
        return ResponseEntity.ok(BaseApiResponse.ok("Bundle updated",
                bundleService.update(id, request)));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('Admin', 'Manager')")
    public ResponseEntity<BaseApiResponse<Void>> delete(@PathVariable String id) {
        bundleService.delete(id);
        return ResponseEntity.ok(BaseApiResponse.ok("Bundle deleted", null));
    }
}
