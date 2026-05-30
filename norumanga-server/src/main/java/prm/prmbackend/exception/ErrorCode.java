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
    INVALID_PASSWORD("Mật khẩu không đúng", HttpStatus.BAD_REQUEST),
    INVALID_EMAIL("Email không hợp lệ", HttpStatus.BAD_REQUEST),

    // Manga
    MANGA_NOT_FOUND("Manga không tồn tại", HttpStatus.NOT_FOUND),
    MANGA_LICENSED("Manga có bản quyền: không thể thêm chapter", HttpStatus.FORBIDDEN),
    CHAPTER_NOT_FOUND("Chapter không tồn tại", HttpStatus.NOT_FOUND),
    CHAPTER_ALREADY_EXISTS("Chapter đã tồn tại", HttpStatus.CONFLICT),

    // Genre / Tag / Creator
    GENRE_NOT_FOUND("Genre không tồn tại", HttpStatus.NOT_FOUND),
    GENRE_ALREADY_EXISTS("Genre đã tồn tại", HttpStatus.CONFLICT),
    TAG_NOT_FOUND("Tag không tồn tại", HttpStatus.NOT_FOUND),
    TAG_ALREADY_EXISTS("Tag đã tồn tại", HttpStatus.CONFLICT),
    CREATOR_NOT_FOUND("Creator không tồn tại", HttpStatus.NOT_FOUND),

    // Bundle / Payment
    BUNDLE_NOT_FOUND("Gói đăng ký không tồn tại", HttpStatus.NOT_FOUND),
    BUNDLE_ALREADY_EXISTS("Gói đăng ký đã tồn tại", HttpStatus.CONFLICT),
    BUNDLE_INACTIVE("Gói đăng ký hiện không khả dụng", HttpStatus.BAD_REQUEST),
    PAYMENT_NOT_FOUND("Giao dịch không tồn tại", HttpStatus.NOT_FOUND),
    PAYMENT_ALREADY_PROCESSED("Giao dịch đã được xử lý", HttpStatus.BAD_REQUEST),
    ROLE_NOT_FOUND("Vai trò không tồn tại", HttpStatus.NOT_FOUND);

    private final String message;
    private final HttpStatus statusCode;

    ErrorCode(String message, HttpStatus statusCode) {
        this.message = message;
        this.statusCode = statusCode;
    }
}
