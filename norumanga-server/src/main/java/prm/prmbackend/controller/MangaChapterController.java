package prm.prmbackend.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import prm.prmbackend.dto.request.MangaChapterRequestDTO;
import prm.prmbackend.dto.response.BaseApiResponse;
import prm.prmbackend.dto.response.ChapterDetailResponseDTO;
import prm.prmbackend.dto.response.ChapterResponseDTO;
import prm.prmbackend.service.MangaChapterService;

import java.util.List;

/**
 * Handles chapter endpoints nested under a manga:
 * GET /api/mangas/{mangaId}/chapters
 *
 * Chapter-by-id endpoint lives in ChapterController:
 * GET /api/chapters/{id}
 */
@RestController
@RequestMapping("/api/mangas/{mangaId}/chapters")
@RequiredArgsConstructor
public class MangaChapterController {

        private final MangaChapterService chapterService;

        /**
         * GET /api/mangas/{mangaId}/chapters
         *
         * Returns all chapters ordered by chapterNumber ASC.
         * Returns empty list when manga.licenseStatus == EXTERNAL_LINK_ONLY.
         */
        @GetMapping
        public ResponseEntity<BaseApiResponse<List<ChapterResponseDTO>>> getByManga(
                        @PathVariable String mangaId) {
                return ResponseEntity.ok(BaseApiResponse.ok("Success",
                                chapterService.getChaptersByMangaId(mangaId)));
        }

        /**
         * GET /api/mangas/{mangaId}/chapters/paged
         * Paginated — useful for manga with many chapters.
         */
        @GetMapping("/paged")
        public ResponseEntity<BaseApiResponse<Page<ChapterResponseDTO>>> getPaged(
                        @PathVariable String mangaId,
                        @RequestParam(defaultValue = "0") int page,
                        @RequestParam(defaultValue = "50") int size) {
                PageRequest pageable = PageRequest.of(page, size,
                                Sort.by("chapterNumber").ascending());
                return ResponseEntity.ok(BaseApiResponse.ok("Success",
                                chapterService.findByManga(mangaId, pageable)));
        }

        /**
         * GET /api/mangas/{mangaId}/chapters/number/{chapterNumber}
         * Fetch a specific chapter by number (returns full pages).
         */
        @GetMapping("/number/{chapterNumber}")
        public ResponseEntity<BaseApiResponse<ChapterDetailResponseDTO>> getByNumber(
                        @PathVariable String mangaId,
                        @PathVariable Double chapterNumber) {
                return ResponseEntity.ok(BaseApiResponse.ok("Success",
                                chapterService.findByMangaAndNumber(mangaId, chapterNumber)));
        }

        // ── admin write endpoints ─────────────────────────────────────────────────

        @PostMapping
        @PreAuthorize("hasAnyRole('Admin', 'Manager')")
        public ResponseEntity<BaseApiResponse<ChapterDetailResponseDTO>> create(
                        @PathVariable String mangaId,
                        @Valid @RequestBody MangaChapterRequestDTO request) {
                return ResponseEntity.status(HttpStatus.CREATED)
                                .body(BaseApiResponse.ok("Chapter created",
                                                chapterService.create(mangaId, request)));
        }

        @PutMapping("/{chapterId}")
        @PreAuthorize("hasAnyRole('Admin', 'Manager')")
        public ResponseEntity<BaseApiResponse<ChapterDetailResponseDTO>> update(
                        @PathVariable String mangaId,
                        @PathVariable String chapterId,
                        @Valid @RequestBody MangaChapterRequestDTO request) {
                return ResponseEntity.ok(BaseApiResponse.ok("Chapter updated",
                                chapterService.update(chapterId, request)));
        }

        @DeleteMapping("/{chapterId}")
        @PreAuthorize("hasRole('Admin')")
        public ResponseEntity<BaseApiResponse<Void>> delete(
                        @PathVariable String mangaId,
                        @PathVariable String chapterId) {
                chapterService.delete(chapterId);
                return ResponseEntity.ok(BaseApiResponse.ok("Chapter deleted", null));
        }
}
