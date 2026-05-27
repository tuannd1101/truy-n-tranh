package prm.prmbackend.service;

import prm.prmbackend.dto.request.ForgotPasswordRequestDTO;
import prm.prmbackend.dto.request.LoginRequestDTO;
import prm.prmbackend.dto.request.RegisterRequestDTO;
import prm.prmbackend.dto.request.ResetPasswordRequestDTO;
import prm.prmbackend.dto.response.AuthResponseDTO;
import prm.prmbackend.dto.response.UserResponseDTO;

public interface AuthService {
    String registerLocal(RegisterRequestDTO request);
    AuthResponseDTO loginLocal(LoginRequestDTO request);
    String forgotPassword(ForgotPasswordRequestDTO request);
    String resetPassword(ResetPasswordRequestDTO request);
    UserResponseDTO getCurrentUser();
}
