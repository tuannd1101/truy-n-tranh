package prm.prmbackend.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import prm.prmbackend.dto.response.BaseApiResponse;
import prm.prmbackend.dto.response.FavoriteResponseDTO;
import prm.prmbackend.exception.AppException;
import prm.prmbackend.exception.ErrorCode;
import prm.prmbackend.service.FavoriteService;

import java.util.List;
import java.util.Map;

/**
 * Favorite manga for the authenticated user.
 */
@RestController
@RequestMapping("/api/favorites")
@RequiredArgsConstructor
public class FavoriteController {

    private final FavoriteService favoriteService;

    @GetMapping
    public ResponseEntity<BaseApiResponse<List<FavoriteResponseDTO>>> myFavorites(
            Authentication auth) {
        return ResponseEntity.ok(BaseApiResponse.ok("Success",
                favoriteService.getMyFavorites(email(auth))));
    }

    @PostMapping("/{mangaId}")
    public ResponseEntity<BaseApiResponse<FavoriteResponseDTO>> add(
            @PathVariable String mangaId, Authentication auth) {
        return ResponseEntity.status(HttpStatus.CREATED).body(BaseApiResponse.ok(
                "Đã thêm vào yêu thích",
                favoriteService.addFavorite(email(auth), mangaId)));
    }

    @DeleteMapping("/{mangaId}")
    public ResponseEntity<BaseApiResponse<Void>> remove(
            @PathVariable String mangaId, Authentication auth) {
        favoriteService.removeFavorite(email(auth), mangaId);
        return ResponseEntity.ok(BaseApiResponse.ok("Đã bỏ yêu thích", null));
    }

    @GetMapping("/{mangaId}/status")
    public ResponseEntity<BaseApiResponse<Map<String, Boolean>>> status(
            @PathVariable String mangaId, Authentication auth) {
        boolean fav = favoriteService.isFavorite(email(auth), mangaId);
        return ResponseEntity.ok(BaseApiResponse.ok("Success",
                Map.of("favorite", fav)));
    }

    private String email(Authentication auth) {
        if (auth == null || auth.getName() == null) {
            throw new AppException(ErrorCode.UNAUTHENTICATED);
        }
        return auth.getName();
    }
}
