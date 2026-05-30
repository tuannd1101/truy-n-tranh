package prm.prmbackend.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import prm.prmbackend.dto.response.BaseApiResponse;
import prm.prmbackend.dto.response.ChapterDetailResponseDTO;
import prm.prmbackend.service.MangaChapterService;

/**
 * Flat chapter endpoint — fetch a chapter by its own ID.
 *
 * GET /api/chapters/{id}
 */
@RestController
@RequestMapping("/api/chapters")
@RequiredArgsConstructor
public class ChapterController {

    private final MangaChapterService chapterService;

    /**
     * GET /api/chapters/{id}
     * Returns full chapter detail including ordered pages.
     */
    @GetMapping("/{id}")
    public ResponseEntity<BaseApiResponse<ChapterDetailResponseDTO>> getById(
            @PathVariable String id) {
        return ResponseEntity.ok(BaseApiResponse.ok("Success",
                chapterService.getChapterById(id)));
    }
}
