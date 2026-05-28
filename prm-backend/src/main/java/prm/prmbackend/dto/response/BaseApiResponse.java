package prm.prmbackend.dto.response;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Unified response wrapper for all API endpoints.
 *
 * Success shape:
 * {
 *   "data": { ... },
 *   "message": "Success",
 *   "error": null
 * }
 *
 * Error shape:
 * {
 *   "data": null,
 *   "message": "Something went wrong",
 *   "error": {
 *     "code": "ERROR_CODE",
 *     "details": ["..."]
 *   }
 * }
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.ALWAYS)   // always emit data/message/error even when null
public class BaseApiResponse<T> {

    private T data;

    private String message;

    private ApiError error;

    // ── success factory ───────────────────────────────────────────────────────

    public static <T> BaseApiResponse<T> ok(String message, T data) {
        return BaseApiResponse.<T>builder()
                .data(data)
                .message(message)
                .error(null)
                .build();
    }

    // ── error factories ───────────────────────────────────────────────────────

    public static <T> BaseApiResponse<T> error(String message, ApiError error) {
        return BaseApiResponse.<T>builder()
                .data(null)
                .message(message)
                .error(error)
                .build();
    }

    /**
     * Convenience overload kept for backward compatibility with existing
     * controller code that passes a Map<String,String> as the second arg.
     * Converts the map entries into a details list.
     */
    public static <T> BaseApiResponse<T> error(String message,
                                                java.util.Map<String, String> fieldErrors) {
        java.util.List<String> details = fieldErrors == null
                ? java.util.List.of()
                : fieldErrors.entrySet().stream()
                        .map(e -> e.getKey() + ": " + e.getValue())
                        .sorted()
                        .toList();

        return BaseApiResponse.<T>builder()
                .data(null)
                .message(message)
                .error(ApiError.of("VALIDATION_ERROR", details))
                .build();
    }
}
