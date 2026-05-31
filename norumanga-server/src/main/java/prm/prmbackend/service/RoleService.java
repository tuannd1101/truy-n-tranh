package prm.prmbackend.service;

import prm.prmbackend.dto.response.RoleResponseDTO;

import java.util.List;

public interface RoleService {

    List<RoleResponseDTO> getAllRoles();

    RoleResponseDTO findById(String id);
}
