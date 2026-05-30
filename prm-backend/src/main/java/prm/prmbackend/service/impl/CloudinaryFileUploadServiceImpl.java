package prm.prmbackend.service.impl;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import prm.prmbackend.dto.response.UploadResponseDTO;
import prm.prmbackend.service.FileUploadService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class CloudinaryFileUploadServiceImpl implements FileUploadService {

    private final Cloudinary cloudinary;

    @Override
    public UploadResponseDTO uploadFile(MultipartFile file, String folder) throws IOException {
        try {
            String originalFilename = file.getOriginalFilename();
            String publicId = UUID.randomUUID().toString();
            
            if (originalFilename != null && originalFilename.contains(".")) {
                publicId = originalFilename.substring(0, originalFilename.lastIndexOf(".")) + "_" + publicId;
            }

            Map<String, Object> params = ObjectUtils.asMap(
                    "folder", folder != null ? folder : "prm_manga",
                    "public_id", publicId
            );

            Map<?, ?> uploadResult = cloudinary.uploader().upload(file.getBytes(), params);

            return UploadResponseDTO.builder()
                    .url(uploadResult.get("secure_url").toString())
                    .publicId(uploadResult.get("public_id").toString())
                    .format(uploadResult.get("format") != null ? uploadResult.get("format").toString() : "")
                    .bytes(uploadResult.get("bytes") != null ? Long.parseLong(uploadResult.get("bytes").toString()) : 0)
                    .build();
        } catch (Exception e) {
            throw new RuntimeException("Failed to upload image: " + e.getMessage(), e);
        }
    }

    @Override
    public List<UploadResponseDTO> uploadFiles(List<MultipartFile> files, String folder) throws IOException {
        List<UploadResponseDTO> results = new ArrayList<>();
        for (MultipartFile file : files) {
            results.add(uploadFile(file, folder));
        }
        return results;
    }

    @Override
    public void deleteFile(String publicId) throws IOException {
        try {
            cloudinary.uploader().destroy(publicId, ObjectUtils.emptyMap());
        } catch (Exception e) {
            throw new RuntimeException("Failed to delete image: " + e.getMessage(), e);
        }
    }
}
