package prm.prmbackend.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import prm.prmbackend.dto.request.ForgotPasswordRequestDTO;
import prm.prmbackend.dto.request.LoginRequestDTO;
import prm.prmbackend.dto.request.RegisterRequestDTO;
import prm.prmbackend.dto.request.ResetPasswordRequestDTO;
import prm.prmbackend.dto.response.AuthResponseDTO;
import prm.prmbackend.dto.response.BaseApiResponse;
import prm.prmbackend.dto.response.UserResponseDTO;
import prm.prmbackend.service.AuthService;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<BaseApiResponse<String>> register(
            @Valid @RequestBody RegisterRequestDTO request) {

        String message = authService.registerLocal(request);

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(BaseApiResponse.ok(message, null));
    }

    @PostMapping("/login")
    public ResponseEntity<BaseApiResponse<AuthResponseDTO>> login(
            @Valid @RequestBody LoginRequestDTO request) {

        AuthResponseDTO data = authService.loginLocal(request);

        return ResponseEntity
                .ok(BaseApiResponse.ok("Login successful", data));
    }

    @PostMapping("/forgot-password")
    public ResponseEntity<BaseApiResponse<String>> forgotPassword(
            @Valid @RequestBody ForgotPasswordRequestDTO request) {

        String message = authService.forgotPassword(request);

        return ResponseEntity
                .ok(BaseApiResponse.ok(message, null));
    }

    @PostMapping("/reset-password")
    public ResponseEntity<BaseApiResponse<String>> resetPassword(
            @Valid @RequestBody ResetPasswordRequestDTO request) {

        String message = authService.resetPassword(request);

        return ResponseEntity
                .ok(BaseApiResponse.ok(message, null));
    }

    @GetMapping("/me")
    public ResponseEntity<BaseApiResponse<UserResponseDTO>> getMe(
            @RequestHeader(value = "Authorization", required = false) String token) {
        
        if (token != null && token.startsWith("Bearer ")) {
            token = token.substring(7);
        }

        UserResponseDTO data = authService.getCurrentUser(token);

        return ResponseEntity
                .ok(BaseApiResponse.ok("Thành công", data));
    }
}
