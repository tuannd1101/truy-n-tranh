package prm.prmbackend.service.impl;

import org.springframework.stereotype.Service;
import prm.prmbackend.dto.request.ForgotPasswordRequestDTO;
import prm.prmbackend.dto.request.LoginRequestDTO;
import prm.prmbackend.dto.request.RegisterRequestDTO;
import prm.prmbackend.dto.request.ResetPasswordRequestDTO;
import prm.prmbackend.dto.response.AuthResponseDTO;
import prm.prmbackend.dto.response.UserResponseDTO;
import prm.prmbackend.exception.AppException;
import prm.prmbackend.exception.ErrorCode;
import prm.prmbackend.service.AuthService;

@Service
public class AuthServiceImpl implements AuthService {

    @Override
    public String registerLocal(RegisterRequestDTO request) {
        if ("test@test.com".equals(request.getEmail())) {
            throw new AppException(ErrorCode.USER_EXISTED);
        }
        return "User registered successfully";
    }

    @Override
    public AuthResponseDTO loginLocal(LoginRequestDTO request) {
        if ("wrong@test.com".equals(request.getEmail())) {
            throw new AppException(ErrorCode.USER_NOT_EXISTED);
        }
        if ("wrongpassword".equals(request.getPassword())) {
            throw new AppException(ErrorCode.INVALID_PASSWORD);
        }

        UserResponseDTO mockUser = UserResponseDTO.builder()
                .id("1")
                .fullName("Nguyen Van A")
                .email(request.getEmail())
                .role("free")
                .isPremium(false)
                .isFree(true)
                .build();

        return AuthResponseDTO.builder()
                .token("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.mock_token.12345")
                .user(mockUser)
                .build();
    }

    @Override
    public String forgotPassword(ForgotPasswordRequestDTO request) {
        if ("wrong@test.com".equals(request.getEmail())) {
            throw new AppException(ErrorCode.USER_NOT_EXISTED);
        }
        return "Password reset instructions have been sent to your email";
    }

    @Override
    public String resetPassword(ResetPasswordRequestDTO request) {
        if ("invalid_token".equals(request.getToken())) {
            throw new AppException(ErrorCode.INVALID_KEY);
        }
        return "Password has been reset successfully";
    }

    @Override
    public UserResponseDTO getCurrentUser() {
        return UserResponseDTO.builder()
                .id("1")
                .fullName("Nguyen Van A")
                .email("user@example.com")
                .role("free")
                .isPremium(false)
                .isFree(true)
                .build();
    }
}
