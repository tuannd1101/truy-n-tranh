package prm.prmbackend.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import prm.prmbackend.dto.request.ReadingHistoryRequestDTO;
import prm.prmbackend.dto.response.BaseApiResponse;
import prm.prmbackend.dto.response.ReadingHistoryResponseDTO;
import prm.prmbackend.exception.AppException;
import prm.prmbackend.exception.ErrorCode;
import prm.prmbackend.service.ReadingHistoryService;

import java.util.List;

/**
 * Reading history for the authenticated user.
 */
@RestController
@RequestMapping("/api/reading-history")
@RequiredArgsConstructor
public class ReadingHistoryController {

    private final ReadingHistoryService historyService;

    @GetMapping
    public ResponseEntity<BaseApiResponse<List<ReadingHistoryResponseDTO>>> myHistory(
            Authentication auth) {
        return ResponseEntity.ok(BaseApiResponse.ok("Success",
                historyService.getMyHistory(email(auth))));
    }

    @PostMapping
    public ResponseEntity<BaseApiResponse<ReadingHistoryResponseDTO>> record(
            @Valid @RequestBody ReadingHistoryRequestDTO request, Authentication auth) {
        return ResponseEntity.ok(BaseApiResponse.ok("Đã lưu lịch sử đọc",
                historyService.record(email(auth), request)));
    }

    @DeleteMapping
    public ResponseEntity<BaseApiResponse<Void>> clear(Authentication auth) {
        historyService.clearHistory(email(auth));
        return ResponseEntity.ok(BaseApiResponse.ok("Đã xóa lịch sử đọc", null));
    }

    private String email(Authentication auth) {
        if (auth == null || auth.getName() == null) {
            throw new AppException(ErrorCode.UNAUTHENTICATED);
        }
        return auth.getName();
    }
}
