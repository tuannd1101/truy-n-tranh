package prm.prmbackend.service;

import prm.prmbackend.dto.response.FavoriteResponseDTO;

import java.util.List;

public interface FavoriteService {

    /** The authenticated user's favorite manga, newest first. */
    List<FavoriteResponseDTO> getMyFavorites(String userEmail);

    /** Adds a manga to favorites (idempotent). */
    FavoriteResponseDTO addFavorite(String userEmail, String mangaId);

    /** Removes a manga from favorites. */
    void removeFavorite(String userEmail, String mangaId);

    /** Whether the given manga is in the user's favorites. */
    boolean isFavorite(String userEmail, String mangaId);
}
