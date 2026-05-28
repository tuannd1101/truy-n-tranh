package prm.prmbackend.exception;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import prm.prmbackend.dto.response.ApiError;
import prm.prmbackend.dto.response.BaseApiResponse;

import java.util.List;

@ControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    // ── catch-all ─────────────────────────────────────────────────────────────

    @ExceptionHandler(Exception.class)
    public ResponseEntity<BaseApiResponse<Object>> handleGeneric(Exception ex) {
        log.error("Unhandled exception", ex);
        ErrorCode code = ErrorCode.UNCATEGORIZED_EXCEPTION;
        return ResponseEntity
                .status(code.getStatusCode())
                .body(BaseApiResponse.error(
                        "Something went wrong",
                        ApiError.of(code.name(), code.getMessage())));
    }

    // ── domain exceptions ─────────────────────────────────────────────────────

    @ExceptionHandler(AppException.class)
    public ResponseEntity<BaseApiResponse<Object>> handleApp(AppException ex) {
        ErrorCode code = ex.getErrorCode();
        return ResponseEntity
                .status(code.getStatusCode())
                .body(BaseApiResponse.error(
                        code.getMessage(),
                        ApiError.of(code.name(), code.getMessage())));
    }

    // ── security ──────────────────────────────────────────────────────────────

    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<BaseApiResponse<Object>> handleAccessDenied(AccessDeniedException ex) {
        ErrorCode code = ErrorCode.UNAUTHORIZED;
        return ResponseEntity
                .status(code.getStatusCode())
                .body(BaseApiResponse.error(
                        code.getMessage(),
                        ApiError.of(code.name(), code.getMessage())));
    }

    // ── validation ────────────────────────────────────────────────────────────

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<BaseApiResponse<Object>> handleValidation(
            MethodArgumentNotValidException ex) {

        List<String> details = ex.getBindingResult()
                .getAllErrors()
                .stream()
                .map(err -> {
                    if (err instanceof FieldError fe) {
                        return fe.getField() + ": " + fe.getDefaultMessage();
                    }
                    return err.getDefaultMessage();
                })
                .sorted()
                .toList();

        return ResponseEntity
                .badRequest()
                .body(BaseApiResponse.error(
                        "Validation failed",
                        ApiError.of("VALIDATION_ERROR", details)));
    }

    // ── type mismatch (e.g. invalid enum value in @RequestParam) ─────────────

    @ExceptionHandler(value = MethodArgumentNotValidException.class)
    public ResponseEntity<BaseApiResponse<Object>> handlingValidationException(
            MethodArgumentNotValidException exception) {
        String enumKey = exception.getFieldError().getDefaultMessage();
        ErrorCode errorCode = ErrorCode.UNCATEGORIZED_EXCEPTION;

        try {
            errorCode = ErrorCode.valueOf(enumKey);
            return ResponseEntity
                    .status(errorCode.getStatusCode())
                    .body(BaseApiResponse.error(errorCode.getMessage(), null));
        } catch (IllegalArgumentException e) {
            Map<String, String> errors = new HashMap<>();
            exception.getBindingResult().getAllErrors().forEach((error) -> {
                String fieldName = ((FieldError) error).getField();
                String errorMessage = error.getDefaultMessage();
                errors.put(fieldName, errorMessage);
            });

            return ResponseEntity
                    .badRequest()
                    .body(BaseApiResponse.error("Validation failed", errors));
        }
    }
}
