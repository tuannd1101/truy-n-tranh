package prm.prmbackend.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import prm.prmbackend.dto.response.BaseApiResponse;
import prm.prmbackend.dto.response.UploadResponseDTO;
import prm.prmbackend.service.FileUploadService;

import java.util.List;

@RestController
@RequestMapping("/api/v1/uploads")
@RequiredArgsConstructor
@Tag(name = "Uploads", description = "Endpoints for uploading files")
public class UploadController {

    private final FileUploadService fileUploadService;

    @PostMapping("/image")
    @Operation(summary = "Upload a single image", description = "Uploads a single image to Cloudinary and returns the URL")
    public ResponseEntity<BaseApiResponse<UploadResponseDTO>> uploadImage(
            @RequestParam("file") MultipartFile file,
            @RequestParam(value = "folder", required = false, defaultValue = "prm_manga_covers") String folder) {
        
        try {
            UploadResponseDTO response = fileUploadService.uploadFile(file, folder);
            return ResponseEntity.ok(BaseApiResponse.ok("Image uploaded successfully", response));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(BaseApiResponse.error("Failed to upload image: " + e.getMessage()));
        }
    }

    @PostMapping("/images")
    @Operation(summary = "Upload multiple images", description = "Uploads multiple images to Cloudinary (useful for manga chapters)")
    public ResponseEntity<BaseApiResponse<List<UploadResponseDTO>>> uploadImages(
            @RequestParam("files") List<MultipartFile> files,
            @RequestParam(value = "folder", required = false, defaultValue = "prm_manga_pages") String folder) {
        
        try {
            List<UploadResponseDTO> response = fileUploadService.uploadFiles(files, folder);
            return ResponseEntity.ok(BaseApiResponse.ok("Images uploaded successfully", response));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(BaseApiResponse.error("Failed to upload images: " + e.getMessage()));
        }
    }
}
