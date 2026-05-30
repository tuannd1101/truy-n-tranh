package prm.prmbackend.service;

import org.springframework.web.multipart.MultipartFile;
import prm.prmbackend.dto.response.UploadResponseDTO;

import java.io.IOException;
import java.util.List;

public interface FileUploadService {
    UploadResponseDTO uploadFile(MultipartFile file, String folder) throws IOException;
    List<UploadResponseDTO> uploadFiles(List<MultipartFile> files, String folder) throws IOException;
    void deleteFile(String publicId) throws IOException;
}
