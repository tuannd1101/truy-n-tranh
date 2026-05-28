package prm.prmbackend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * Error detail object embedded in BaseApiResponse when a request fails.
 *
 * JSON shape:
 * {
 *   "code": "MANGA_NOT_FOUND",
 *   "details": ["Manga không tồn tại"]
 * }
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ApiError {

    /** Machine-readable error code — matches ErrorCode enum name */
    private String code;

    /** Human-readable detail messages (validation errors, extra context, etc.) */
    private List<String> details;

    // ── factory helpers ───────────────────────────────────────────────────────

    public static ApiError of(String code, String detail) {
        return ApiError.builder()
                .code(code)
                .details(detail != null ? List.of(detail) : List.of())
                .build();
    }

    public static ApiError of(String code, List<String> details) {
        return ApiError.builder()
                .code(code)
                .details(details != null ? details : List.of())
                .build();
    }
}
