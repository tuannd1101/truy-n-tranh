package prm.prmbackend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UploadResponseDTO {
    private String url;
    private String publicId;
    private String format;
    private long bytes;
}
