package prm.prmbackend.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import prm.prmbackend.dto.request.UserUpdateRequestDTO;
import prm.prmbackend.dto.response.UserDetailResponseDTO;
import prm.prmbackend.entity.Account;
import prm.prmbackend.entity.Role;
import prm.prmbackend.exception.AppException;
import prm.prmbackend.exception.ErrorCode;
import prm.prmbackend.repository.AccountRepository;
import prm.prmbackend.repository.RoleRepository;
import prm.prmbackend.service.UserService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final AccountRepository accountRepository;
    private final RoleRepository roleRepository;

    @Override
    public Page<UserDetailResponseDTO> getUsers(String keyword, String roleId, Pageable pageable) {
        final Page<Account> page;
        if (keyword != null && !keyword.isBlank()) {
            page = accountRepository
                    .findByFullNameContainingIgnoreCaseOrEmailContainingIgnoreCase(
                            keyword, keyword, pageable);
        } else if (roleId != null && !roleId.isBlank()) {
            page = accountRepository.findByRoleId(roleId, pageable);
        } else {
            page = accountRepository.findAll(pageable);
        }

        // Pre-load role names once to avoid N+1 lookups.
        Map<String, String> roleNames = roleNameCache();
        return page.map(account -> toResponse(account, roleNames));
    }

    @Override
    public UserDetailResponseDTO findById(String id) {
        Account account = getOrThrow(id);
        return toResponse(account, roleNameCache());
    }

    @Override
    public UserDetailResponseDTO update(String id, UserUpdateRequestDTO request) {
        Account account = getOrThrow(id);

        if (request.getFullName() != null && !request.getFullName().isBlank()) {
            account.setFullName(request.getFullName().trim());
        }

        if (request.getStatus() != null && !request.getStatus().isBlank()) {
            account.setStatus(request.getStatus().trim());
        }

        // Resolve target role by id (preferred) or name.
        if (request.getRoleId() != null && !request.getRoleId().isBlank()) {
            Role role = roleRepository.findById(request.getRoleId())
                    .orElseThrow(() -> new AppException(ErrorCode.ROLE_NOT_FOUND));
            account.setRoleId(role.getId());
        } else if (request.getRoleName() != null && !request.getRoleName().isBlank()) {
            Role role = roleRepository.findByName(request.getRoleName())
                    .orElseThrow(() -> new AppException(ErrorCode.ROLE_NOT_FOUND));
            account.setRoleId(role.getId());
        }

        Account saved = accountRepository.save(account);
        return toResponse(saved, roleNameCache());
    }

    // ── helpers ──────────────────────────────────────────────────────────────

    private Account getOrThrow(String id) {
        return accountRepository.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_EXISTED));
    }

    private Map<String, String> roleNameCache() {
        Map<String, String> map = new HashMap<>();
        List<Role> roles = roleRepository.findAll();
        for (Role r : roles) {
            map.put(r.getId(), r.getName());
        }
        return map;
    }

    private UserDetailResponseDTO toResponse(Account a, Map<String, String> roleNames) {
        String roleName = a.getRoleId() != null
                ? roleNames.getOrDefault(a.getRoleId(), "Free")
                : "Free";
        return UserDetailResponseDTO.builder()
                .id(a.getId())
                .fullName(a.getFullName())
                .email(a.getEmail())
                .status(a.getStatus())
                .roleId(a.getRoleId())
                .roleName(roleName)
                .createdAt(a.getCreatedAt())
                .updatedAt(a.getUpdatedAt())
                .build();
    }
}
