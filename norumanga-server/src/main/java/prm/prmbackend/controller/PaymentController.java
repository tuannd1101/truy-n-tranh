package prm.prmbackend.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import prm.prmbackend.dto.request.PaymentRequestDTO;
import prm.prmbackend.dto.response.BaseApiResponse;
import prm.prmbackend.dto.response.PaymentResponseDTO;
import prm.prmbackend.exception.AppException;
import prm.prmbackend.exception.ErrorCode;
import prm.prmbackend.service.PaymentService;

import java.util.List;

@RestController
@RequestMapping("/api/payments")
@RequiredArgsConstructor
public class PaymentController {

    private final PaymentService paymentService;

    /**
     * POST /api/payments
     * Purchase a bundle as the authenticated user. On success the transaction is
     * recorded and the user's role is upgraded.
     */
    @PostMapping
    public ResponseEntity<BaseApiResponse<PaymentResponseDTO>> purchase(
            @Valid @RequestBody PaymentRequestDTO request,
            Authentication authentication) {
        String email = requireEmail(authentication);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(BaseApiResponse.ok("Thanh toán thành công",
                        paymentService.purchase(email, request)));
    }

    /**
     * GET /api/payments/me
     * The authenticated user's transaction history (READ-only).
     */
    @GetMapping("/me")
    public ResponseEntity<BaseApiResponse<List<PaymentResponseDTO>>> myPayments(
            Authentication authentication) {
        String email = requireEmail(authentication);
        return ResponseEntity.ok(BaseApiResponse.ok("Success",
                paymentService.getMyPayments(email)));
    }

    // ── admin read-only endpoints ─────────────────────────────────────────────

    /**
     * GET /api/payments?page=&size=  → all transactions (admin, READ-only)
     */
    @GetMapping
    @PreAuthorize("hasAnyRole('Admin', 'Manager')")
    public ResponseEntity<BaseApiResponse<Page<PaymentResponseDTO>>> getAll(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        PageRequest pageable = PageRequest.of(page, size,
                Sort.by("createdAt").descending());
        return ResponseEntity.ok(BaseApiResponse.ok("Success",
                paymentService.getAllPayments(pageable)));
    }

    /**
     * GET /api/payments/account/{accountId}  → a user's transactions (admin)
     */
    @GetMapping("/account/{accountId}")
    @PreAuthorize("hasAnyRole('Admin', 'Manager')")
    public ResponseEntity<BaseApiResponse<Page<PaymentResponseDTO>>> getByAccount(
            @PathVariable String accountId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        PageRequest pageable = PageRequest.of(page, size,
                Sort.by("createdAt").descending());
        return ResponseEntity.ok(BaseApiResponse.ok("Success",
                paymentService.getPaymentsByAccount(accountId, pageable)));
    }

    // ── helpers ───────────────────────────────────────────────────────────────

    private String requireEmail(Authentication authentication) {
        if (authentication == null || authentication.getName() == null) {
            throw new AppException(ErrorCode.UNAUTHENTICATED);
        }
        return authentication.getName();
    }
}
