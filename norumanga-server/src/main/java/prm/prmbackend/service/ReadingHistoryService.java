package prm.prmbackend.service;

import prm.prmbackend.dto.request.ReadingHistoryRequestDTO;
import prm.prmbackend.dto.response.ReadingHistoryResponseDTO;

import java.util.List;

public interface ReadingHistoryService {

    /** The authenticated user's reading history, most recent first. */
    List<ReadingHistoryResponseDTO> getMyHistory(String userEmail);

    /** Records (upserts) that the user read a chapter of a manga. */
    ReadingHistoryResponseDTO record(String userEmail, ReadingHistoryRequestDTO request);

    /** Clears the authenticated user's reading history. */
    void clearHistory(String userEmail);
}
