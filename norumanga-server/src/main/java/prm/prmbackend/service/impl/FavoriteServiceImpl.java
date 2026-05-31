package prm.prmbackend.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import prm.prmbackend.dto.response.FavoriteResponseDTO;
import prm.prmbackend.entity.Account;
import prm.prmbackend.entity.Favorite;
import prm.prmbackend.exception.AppException;
import prm.prmbackend.exception.ErrorCode;
import prm.prmbackend.repository.AccountRepository;
import prm.prmbackend.repository.FavoriteRepository;
import prm.prmbackend.service.FavoriteService;
import prm.prmbackend.service.MangaService;

import java.time.Instant;
import java.util.List;

@Service
@RequiredArgsConstructor
public class FavoriteServiceImpl implements FavoriteService {

    private final FavoriteRepository favoriteRepository;
    private final AccountRepository accountRepository;
    private final MangaService mangaService;

    @Override
    public List<FavoriteResponseDTO> getMyFavorites(String userEmail) {
        String accountId = accountId(userEmail);
        return favoriteRepository.findByAccountIdOrderByCreatedAtDesc(accountId)
                .stream().map(this::toResponse).toList();
    }

    @Override
    public FavoriteResponseDTO addFavorite(String userEmail, String mangaId) {
        String accountId = accountId(userEmail);

        // Validate the manga exists.
        if (mangaService.getMangaByIdOrNull(mangaId) == null) {
            throw new AppException(ErrorCode.MANGA_NOT_FOUND);
        }

        Favorite favorite = favoriteRepository
                .findByAccountIdAndMangaId(accountId, mangaId)
                .orElseGet(() -> favoriteRepository.save(Favorite.builder()
                        .accountId(accountId)
                        .mangaId(mangaId)
                        .createdAt(Instant.now())
                        .build()));

        return toResponse(favorite);
    }

    @Override
    public void removeFavorite(String userEmail, String mangaId) {
        String accountId = accountId(userEmail);
        favoriteRepository.deleteByAccountIdAndMangaId(accountId, mangaId);
    }

    @Override
    public boolean isFavorite(String userEmail, String mangaId) {
        return favoriteRepository.existsByAccountIdAndMangaId(accountId(userEmail), mangaId);
    }

    // ── helpers ──────────────────────────────────────────────────────────────

    private String accountId(String email) {
        Account account = accountRepository.findByEmail(email)
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_EXISTED));
        return account.getId();
    }

    private FavoriteResponseDTO toResponse(Favorite f) {
        return FavoriteResponseDTO.builder()
                .id(f.getId())
                .mangaId(f.getMangaId())
                .createdAt(f.getCreatedAt())
                .manga(mangaService.getMangaByIdOrNull(f.getMangaId()))
                .build();
    }
}
