package prm.prmbackend.exception;

import lombok.extern.slf4j.Slf4j;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;

import jakarta.servlet.http.HttpServletRequest;
import prm.prmbackend.dto.response.ApiError;
import prm.prmbackend.dto.response.BaseApiResponse;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@ControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    @ExceptionHandler(AppException.class)
    public ResponseEntity<BaseApiResponse> handleAppException(AppException exception, HttpServletRequest request) {
        ErrorCode errorCode = exception.getErrorCode();

        int status = errorCode.getStatusCode().value();
        String msg = errorCode.getMessage();

        if (exception.getArgs() != null && exception.getArgs().length > 0) {
            msg = String.format(errorCode.getMessage(), exception.getArgs());
        }
        return ResponseEntity
                .status(errorCode.getStatusCode())
                .body(
                        BaseApiResponse.error(msg));
    }

    // Hàm response lỗi bad request.
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<BaseApiResponse> handleValidation(MethodArgumentNotValidException exception,
            HttpServletRequest request) {

        Map<String, String> errorMap = new HashMap<>();

        exception.getBindingResult().getAllErrors()
                .forEach(error -> {
                    String fieldName = ((FieldError) error).getField();
                    String enumKey = error.getDefaultMessage();

                    String errorMessage;
                    try {
                        ErrorCode errorCode = ErrorCode.valueOf(enumKey);
                        errorMessage = errorCode.getMessage();
                    } catch (IllegalArgumentException e) {
                        errorMessage = enumKey;
                    }

                    errorMap.put(fieldName, errorMessage);
                });

        String msg = "Dữ liệu đầu vào không hợp lệ";

        return ResponseEntity.badRequest()
                .body(
                        BaseApiResponse.error(msg, errorMap));
    }

    // Hàm bắt lỗi JSON không hợp lệ
    @ExceptionHandler(org.springframework.http.converter.HttpMessageNotReadableException.class)
    public ResponseEntity<BaseApiResponse<Object>> handleJsonError(HttpServletRequest request) {
        String msg = "Định dạng JSON không hợp lệ.";
        return ResponseEntity.badRequest()
                .body(BaseApiResponse.error(msg));
    }

    // Bắt mọi lỗi chưa được xử lý (tránh lỗi 500 im lặng)
    @ExceptionHandler(Exception.class)
    public ResponseEntity<BaseApiResponse<Object>> handleGeneralException(Exception exception,
            HttpServletRequest request) {
        String msg = "Đã xảy ra lỗi hệ thống: " + exception.getMessage();
        // In log ra terminal của Backend để bạn theo dõi
        exception.printStackTrace();

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(BaseApiResponse.error(msg));
    }

    // Bắt lỗi khi User không đủ quyền truy cập API (403 Forbidden)
    @ExceptionHandler(org.springframework.security.authorization.AuthorizationDeniedException.class)
    public ResponseEntity<BaseApiResponse<Object>> handleAuthorizationDeniedException(
            org.springframework.security.authorization.AuthorizationDeniedException exception,
            HttpServletRequest request) {

        String msg = "Bạn không có quyền thực hiện chức năng này.";

        return ResponseEntity
                .status(HttpStatus.FORBIDDEN) // Trả về mã 403 thay vì 500
                .body(BaseApiResponse.error(msg));
    }
}
