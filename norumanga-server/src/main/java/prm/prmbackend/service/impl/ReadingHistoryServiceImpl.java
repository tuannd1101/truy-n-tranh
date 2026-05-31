package prm.prmbackend.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import prm.prmbackend.dto.request.ReadingHistoryRequestDTO;
import prm.prmbackend.dto.response.ReadingHistoryResponseDTO;
import prm.prmbackend.entity.Account;
import prm.prmbackend.entity.ReadingHistory;
import prm.prmbackend.exception.AppException;
import prm.prmbackend.exception.ErrorCode;
import prm.prmbackend.repository.AccountRepository;
import prm.prmbackend.repository.ReadingHistoryRepository;
import prm.prmbackend.service.MangaService;
import prm.prmbackend.service.ReadingHistoryService;

import java.time.Instant;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ReadingHistoryServiceImpl implements ReadingHistoryService {

    private final ReadingHistoryRepository historyRepository;
    private final AccountRepository accountRepository;
    private final MangaService mangaService;

    @Override
    public List<ReadingHistoryResponseDTO> getMyHistory(String userEmail) {
        String accountId = accountId(userEmail);
        return historyRepository.findByAccountIdOrderByLastReadAtDesc(accountId)
                .stream().map(this::toResponse).toList();
    }

    @Override
    public ReadingHistoryResponseDTO record(String userEmail, ReadingHistoryRequestDTO request) {
        String accountId = accountId(userEmail);

        if (mangaService.getMangaByIdOrNull(request.getMangaId()) == null) {
            throw new AppException(ErrorCode.MANGA_NOT_FOUND);
        }

        ReadingHistory history = historyRepository
                .findByAccountIdAndMangaId(accountId, request.getMangaId())
                .orElseGet(() -> ReadingHistory.builder()
                        .accountId(accountId)
                        .mangaId(request.getMangaId())
                        .build());

        history.setChapterNumber(request.getChapterNumber());
        history.setLastReadAt(Instant.now());

        return toResponse(historyRepository.save(history));
    }

    @Override
    public void clearHistory(String userEmail) {
        historyRepository.deleteByAccountId(accountId(userEmail));
    }

    // ── helpers ──────────────────────────────────────────────────────────────

    private String accountId(String email) {
        Account account = accountRepository.findByEmail(email)
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_EXISTED));
        return account.getId();
    }

    private ReadingHistoryResponseDTO toResponse(ReadingHistory h) {
        return ReadingHistoryResponseDTO.builder()
                .id(h.getId())
                .mangaId(h.getMangaId())
                .chapterNumber(h.getChapterNumber())
                .lastReadAt(h.getLastReadAt())
                .manga(mangaService.getMangaByIdOrNull(h.getMangaId()))
                .build();
    }
}
