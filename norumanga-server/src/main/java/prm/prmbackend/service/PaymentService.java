package prm.prmbackend.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import prm.prmbackend.dto.request.PaymentRequestDTO;
import prm.prmbackend.dto.response.PaymentResponseDTO;

import java.util.List;

public interface PaymentService {

    /**
     * Creates and processes a payment for the currently authenticated user.
     * On success: persists the transaction history and upgrades the user's role
     * according to the purchased bundle.
     *
     * @param userEmail email of the authenticated user (JWT subject)
     */
    PaymentResponseDTO purchase(String userEmail, PaymentRequestDTO request);

    /** Transaction history of the currently authenticated user (read-only). */
    List<PaymentResponseDTO> getMyPayments(String userEmail);

    /** Transaction history of a specific account (admin, read-only). */
    Page<PaymentResponseDTO> getPaymentsByAccount(String accountId, Pageable pageable);

    /** All transactions (admin, read-only). */
    Page<PaymentResponseDTO> getAllPayments(Pageable pageable);
}
