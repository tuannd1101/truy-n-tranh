package prm.prmbackend.exception;

import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
public enum ErrorCode {
    UNCATEGORIZED_EXCEPTION("Lỗi không xác định", HttpStatus.INTERNAL_SERVER_ERROR),
    INVALID_AUTHENTICATION("Tài khoản hoặc mật khẩu không hợp lệ", HttpStatus.BAD_REQUEST),
    INVALID_KEY("Khóa không hợp lệ", HttpStatus.BAD_REQUEST),
    USER_EXISTED("Tài khoản đã tồn tại", HttpStatus.BAD_REQUEST),
    USER_NOT_EXISTED("Tài khoản không tồn tại", HttpStatus.NOT_FOUND),
    UNAUTHENTICATED("Chưa đăng nhập", HttpStatus.UNAUTHORIZED),
    UNAUTHORIZED("Bạn không có quyền truy cập", HttpStatus.FORBIDDEN),
    INVALID_PASSWORD("Mật khẩu không đúng", HttpStatus.BAD_REQUEST);

    private final String message;
    private final HttpStatus statusCode;

    ErrorCode(String message, HttpStatus statusCode) {
        this.message = message;
        this.statusCode = statusCode;
    }
}
