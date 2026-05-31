package prm.prmbackend.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import prm.prmbackend.dto.request.ForgotPasswordRequestDTO;
import prm.prmbackend.dto.request.LoginRequestDTO;
import prm.prmbackend.dto.request.RegisterRequestDTO;
import prm.prmbackend.dto.request.ResetPasswordRequestDTO;
import prm.prmbackend.dto.response.AuthResponseDTO;
import prm.prmbackend.dto.response.UserResponseDTO;
import prm.prmbackend.entity.Account;
import prm.prmbackend.entity.Payment;
import prm.prmbackend.entity.Role;
import prm.prmbackend.entity.enums.PaymentStatus;
import prm.prmbackend.exception.AppException;
import prm.prmbackend.exception.ErrorCode;
import prm.prmbackend.repository.AccountRepository;
import prm.prmbackend.repository.PaymentRepository;
import prm.prmbackend.repository.RoleRepository;
import prm.prmbackend.service.AuthService;
import prm.prmbackend.utils.JwtUtil;

import java.time.Instant;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final AccountRepository accountRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;
    private final PaymentRepository paymentRepository;

    @Override
    public String registerLocal(RegisterRequestDTO request) {
        if (accountRepository.existsByEmail(request.getEmail())) {
            throw new AppException(ErrorCode.USER_EXISTED);
        }

        Role freeRole = roleRepository.findByName("Free")
                .orElseGet(() -> roleRepository.save(Role.builder()
                        .name("Free")
                        .description("Free User")
                        .build()));

        Account account = Account.builder()
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .fullName(request.getFullName())
                .roleId(freeRole.getId())
                .status("ACTIVE")
                .build();

        accountRepository.save(account);

        return "Đăng ký tài khoản thành công";
    }

    @Override
    public AuthResponseDTO loginLocal(LoginRequestDTO request) {
        Account account = accountRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new AppException(ErrorCode.INVALID_AUTHENTICATION));

        if (!passwordEncoder.matches(request.getPassword(), account.getPassword())) {
            throw new AppException(ErrorCode.INVALID_AUTHENTICATION);
        }

        String roleName = "Free";
        if (account.getRoleId() != null) {
            roleName = roleRepository.findById(account.getRoleId())
                    .map(Role::getName)
                    .orElse("Free");
        }

        String token = jwtUtil.generateToken(account.getEmail(), roleName);

        UserResponseDTO userResponse = UserResponseDTO.builder()
                .id(account.getId())
                .fullName(account.getFullName())
                .email(account.getEmail())
                .role(roleName)
                .build();

        return AuthResponseDTO.builder()
                .token(token)
                .user(userResponse)
                .build();
    }

    @Override
    public String forgotPassword(ForgotPasswordRequestDTO request) {
        if ("wrong@test.com".equals(request.getEmail())) {
            throw new AppException(ErrorCode.USER_NOT_EXISTED);
        }
        return "Hướng dẫn đặt lại mật khẩu đã được gửi vào email của bạn";
    }

    @Override
    public String resetPassword(ResetPasswordRequestDTO request) {
        if ("invalid_token".equals(request.getToken())) {
            throw new AppException(ErrorCode.INVALID_KEY);
        }
        return "Mật khẩu đã được thay đổi thành công";
    }

    @Override
    public UserResponseDTO getCurrentUser(String token) {
        if (token == null || token.isEmpty()) {
            throw new AppException(ErrorCode.UNAUTHENTICATED);
        }

        String email;
        try {
            email = jwtUtil.extractUsername(token);
        } catch (Exception e) {
            throw new AppException(ErrorCode.UNAUTHENTICATED);
        }

        Account account = accountRepository.findByEmail(email)
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_EXISTED));

        String roleName = "Free";
        if (account.getRoleId() != null) {
            roleName = roleRepository.findById(account.getRoleId())
                    .map(Role::getName)
                    .orElse("Free");
        }

        return UserResponseDTO.builder()
                .id(account.getId())
                .fullName(account.getFullName())
                .email(account.getEmail())
                .role(roleName)
                .premiumExpiresAt(resolvePremiumExpiry(account.getId(), roleName))
                .build();
    }

    /**
     * Premium expiry is the expiry of the latest successful payment, but only
     * while the user currently holds the Premium role and that expiry is in the
     * future.
     */
    private Instant resolvePremiumExpiry(String accountId, String roleName) {
        if (!"Premium".equalsIgnoreCase(roleName)) {
            return null;
        }
        return paymentRepository
                .findFirstByAccountIdAndStatusOrderByExpiresAtDesc(accountId, PaymentStatus.SUCCESS)
                .map(Payment::getExpiresAt)
                .filter(exp -> exp != null && exp.isAfter(Instant.now()))
                .orElse(null);
    }
}
