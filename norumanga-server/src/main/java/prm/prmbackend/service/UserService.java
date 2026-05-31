package prm.prmbackend.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import prm.prmbackend.dto.request.UserUpdateRequestDTO;
import prm.prmbackend.dto.response.UserDetailResponseDTO;

public interface UserService {

    /**
     * Paginated user list. Optional [keyword] filters by full name or email,
     * optional [roleId] filters by role.
     */
    Page<UserDetailResponseDTO> getUsers(String keyword, String roleId, Pageable pageable);

    UserDetailResponseDTO findById(String id);

    UserDetailResponseDTO update(String id, UserUpdateRequestDTO request);
}
