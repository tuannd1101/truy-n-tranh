package prm.prmbackend.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import prm.prmbackend.dto.request.UserUpdateRequestDTO;
import prm.prmbackend.dto.response.BaseApiResponse;
import prm.prmbackend.dto.response.UserDetailResponseDTO;
import prm.prmbackend.service.UserService;

/**
 * Admin user management — view, view detail, update.
 * Creation and deletion are intentionally NOT exposed.
 */
@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    /**
     * GET /api/users?keyword=&roleId=&page=&size=
     * Paginated user list (admin / manager).
     */
    @GetMapping
    @PreAuthorize("hasAnyRole('Admin', 'Manager')")
    public ResponseEntity<BaseApiResponse<Page<UserDetailResponseDTO>>> getAll(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String roleId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {

        PageRequest pageable = PageRequest.of(page, size,
                Sort.by("createdAt").descending());
        return ResponseEntity.ok(BaseApiResponse.ok("Success",
                userService.getUsers(keyword, roleId, pageable)));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('Admin', 'Manager')")
    public ResponseEntity<BaseApiResponse<UserDetailResponseDTO>> getById(
            @PathVariable String id) {
        return ResponseEntity.ok(BaseApiResponse.ok("Success",
                userService.findById(id)));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('Admin', 'Manager')")
    public ResponseEntity<BaseApiResponse<UserDetailResponseDTO>> update(
            @PathVariable String id,
            @Valid @RequestBody UserUpdateRequestDTO request) {
        return ResponseEntity.ok(BaseApiResponse.ok("Cập nhật người dùng thành công",
                userService.update(id, request)));
    }
}
