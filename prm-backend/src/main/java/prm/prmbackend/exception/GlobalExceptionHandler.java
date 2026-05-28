package prm.prmbackend.exception;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import prm.prmbackend.dto.response.BaseApiResponse;

import java.util.HashMap;
import java.util.Map;

@ControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    @ExceptionHandler(value = Exception.class)
    public ResponseEntity<BaseApiResponse<Object>> handlingRuntimeException(Exception exception) {
        log.error("Exception: ", exception);
        return ResponseEntity
                .status(ErrorCode.UNCATEGORIZED_EXCEPTION.getStatusCode())
                .body(BaseApiResponse.error(ErrorCode.UNCATEGORIZED_EXCEPTION.getMessage(), null));
    }

    @ExceptionHandler(value = AppException.class)
    public ResponseEntity<BaseApiResponse<Object>> handlingAppException(AppException exception) {
        ErrorCode errorCode = exception.getErrorCode();
        return ResponseEntity
                .status(errorCode.getStatusCode())
                .body(BaseApiResponse.error(errorCode.getMessage(), null));
    }

    @ExceptionHandler(value = MethodArgumentNotValidException.class)
    public ResponseEntity<BaseApiResponse<Object>> handlingValidationException(MethodArgumentNotValidException exception) {
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
