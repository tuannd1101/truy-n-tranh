package prm.prmbackend.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import prm.prmbackend.dto.response.BaseApiResponse;
import prm.prmbackend.dto.response.RoleResponseDTO;
import prm.prmbackend.service.RoleService;

import java.util.List;

/**
 * Read-only role endpoints for the admin dashboard.
 */
@RestController
@RequestMapping("/api/roles")
@RequiredArgsConstructor
public class RoleController {

    private final RoleService roleService;

    @GetMapping
    @PreAuthorize("hasAnyRole('Admin', 'Manager')")
    public ResponseEntity<BaseApiResponse<List<RoleResponseDTO>>> getAll() {
        return ResponseEntity.ok(BaseApiResponse.ok("Success",
                roleService.getAllRoles()));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('Admin', 'Manager')")
    public ResponseEntity<BaseApiResponse<RoleResponseDTO>> getById(
            @PathVariable String id) {
        return ResponseEntity.ok(BaseApiResponse.ok("Success",
                roleService.findById(id)));
    }
}
