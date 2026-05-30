package prm.prmbackend.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import prm.prmbackend.dto.request.PaymentRequestDTO;
import prm.prmbackend.dto.response.PaymentResponseDTO;
import prm.prmbackend.entity.Account;
import prm.prmbackend.entity.Bundle;
import prm.prmbackend.entity.Payment;
import prm.prmbackend.entity.Role;
import prm.prmbackend.entity.enums.BillingCycle;
import prm.prmbackend.entity.enums.PaymentStatus;
import prm.prmbackend.exception.AppException;
import prm.prmbackend.exception.ErrorCode;
import prm.prmbackend.repository.AccountRepository;
import prm.prmbackend.repository.BundleRepository;
import prm.prmbackend.repository.PaymentRepository;
import prm.prmbackend.repository.RoleRepository;
import prm.prmbackend.service.PaymentService;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class PaymentServiceImpl implements PaymentService {

    private final PaymentRepository paymentRepository;
    private final BundleRepository bundleRepository;
    private final AccountRepository accountRepository;
    private final RoleRepository roleRepository;

    @Override
    public PaymentResponseDTO purchase(String userEmail, PaymentRequestDTO request) {
        Account account = accountRepository.findByEmail(userEmail)
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_EXISTED));

        Bundle bundle = bundleRepository.findById(request.getBundleId())
                .orElseThrow(() -> new AppException(ErrorCode.BUNDLE_NOT_FOUND));

        if (!bundle.isActive()) {
            throw new AppException(ErrorCode.BUNDLE_INACTIVE);
        }

        Instant now = Instant.now();
        int durationDays = bundle.getBillingCycle() != null
                ? bundle.getBillingCycle().getDurationDays()
                : BillingCycle.MONTHLY.getDurationDays();
        Instant expiresAt = now.plus(durationDays, ChronoUnit.DAYS);

        // Simulated MoMo charge — treated as immediately successful.
        Payment payment = Payment.builder()
                .accountId(account.getId())
                .bundleId(bundle.getId())
                .bundleName(bundle.getName())
                .amount(bundle.getPrice())
                .method(request.getMethod())
                .status(PaymentStatus.SUCCESS)
                .transactionRef(resolveTransactionRef(request.getTransactionRef()))
                .expiresAt(expiresAt)
                .createdAt(now)
                .updatedAt(now)
                .build();

        Payment saved = paymentRepository.save(payment);

        // Upgrade the user's role according to the purchased bundle.
        upgradeRole(account, bundle.getRoleName());

        log.info("Payment {} succeeded for user {} → role {}",
                saved.getId(), account.getEmail(), bundle.getRoleName());

        return toResponse(saved);
    }

    @Override
    public List<PaymentResponseDTO> getMyPayments(String userEmail) {
        Account account = accountRepository.findByEmail(userEmail)
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_EXISTED));
        return paymentRepository.findByAccountIdOrderByCreatedAtDesc(account.getId())
                .stream().map(this::toResponse).toList();
    }

    @Override
    public Page<PaymentResponseDTO> getPaymentsByAccount(String accountId, Pageable pageable) {
        return paymentRepository.findByAccountId(accountId, pageable).map(this::toResponse);
    }

    @Override
    public Page<PaymentResponseDTO> getAllPayments(Pageable pageable) {
        return paymentRepository.findAll(pageable).map(this::toResponse);
    }

    // ── helpers ──────────────────────────────────────────────────────────────

    private void upgradeRole(Account account, String roleName) {
        Role role = roleRepository.findByName(roleName)
                .orElseThrow(() -> new AppException(ErrorCode.ROLE_NOT_FOUND));
        account.setRoleId(role.getId());
        accountRepository.save(account);
    }

    private String resolveTransactionRef(String ref) {
        if (ref != null && !ref.isBlank()) {
            return ref;
        }
        return "MOMO-" + System.currentTimeMillis();
    }

    private PaymentResponseDTO toResponse(Payment p) {
        return PaymentResponseDTO.builder()
                .id(p.getId())
                .accountId(p.getAccountId())
                .bundleId(p.getBundleId())
                .bundleName(p.getBundleName())
                .amount(p.getAmount())
                .method(p.getMethod())
                .status(p.getStatus())
                .transactionRef(p.getTransactionRef())
                .expiresAt(p.getExpiresAt())
                .createdAt(p.getCreatedAt())
                .updatedAt(p.getUpdatedAt())
                .build();
    }
}
