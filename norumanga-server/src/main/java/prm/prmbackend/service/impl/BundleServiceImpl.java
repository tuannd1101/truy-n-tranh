package prm.prmbackend.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import prm.prmbackend.dto.request.BundleRequestDTO;
import prm.prmbackend.dto.response.BundleResponseDTO;
import prm.prmbackend.entity.Bundle;
import prm.prmbackend.exception.AppException;
import prm.prmbackend.exception.ErrorCode;
import prm.prmbackend.repository.BundleRepository;
import prm.prmbackend.service.BundleService;

import java.time.Instant;
import java.util.List;

@Service
@RequiredArgsConstructor
public class BundleServiceImpl implements BundleService {

    private final BundleRepository bundleRepository;

    @Override
    public List<BundleResponseDTO> getAllBundles() {
        return bundleRepository.findAll().stream().map(this::toResponse).toList();
    }

    @Override
    public List<BundleResponseDTO> getActiveBundles() {
        return bundleRepository.findByActiveTrue().stream().map(this::toResponse).toList();
    }

    @Override
    public BundleResponseDTO findById(String id) {
        return toResponse(getOrThrow(id));
    }

    @Override
    public BundleResponseDTO create(BundleRequestDTO request) {
        if (bundleRepository.existsByName(request.getName())) {
            throw new AppException(ErrorCode.BUNDLE_ALREADY_EXISTS);
        }
        Instant now = Instant.now();
        Bundle bundle = Bundle.builder()
                .name(request.getName())
                .description(request.getDescription())
                .price(request.getPrice())
                .billingCycle(request.getBillingCycle())
                .roleName(resolveRoleName(request.getRoleName()))
                .features(request.getFeatures())
                .active(request.getActive() == null || request.getActive())
                .createdAt(now)
                .updatedAt(now)
                .build();
        return toResponse(bundleRepository.save(bundle));
    }

    @Override
    public BundleResponseDTO update(String id, BundleRequestDTO request) {
        Bundle bundle = getOrThrow(id);
        bundle.setName(request.getName());
        bundle.setDescription(request.getDescription());
        bundle.setPrice(request.getPrice());
        bundle.setBillingCycle(request.getBillingCycle());
        bundle.setRoleName(resolveRoleName(request.getRoleName()));
        bundle.setFeatures(request.getFeatures());
        if (request.getActive() != null) {
            bundle.setActive(request.getActive());
        }
        bundle.setUpdatedAt(Instant.now());
        return toResponse(bundleRepository.save(bundle));
    }

    @Override
    public void delete(String id) {
        getOrThrow(id);
        bundleRepository.deleteById(id);
    }

    // ── helpers ──────────────────────────────────────────────────────────────

    private String resolveRoleName(String roleName) {
        return (roleName == null || roleName.isBlank()) ? "Premium" : roleName;
    }

    private Bundle getOrThrow(String id) {
        return bundleRepository.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.BUNDLE_NOT_FOUND));
    }

    private BundleResponseDTO toResponse(Bundle b) {
        return BundleResponseDTO.builder()
                .id(b.getId())
                .name(b.getName())
                .description(b.getDescription())
                .price(b.getPrice())
                .billingCycle(b.getBillingCycle())
                .durationDays(b.getBillingCycle() != null ? b.getBillingCycle().getDurationDays() : 0)
                .roleName(b.getRoleName())
                .features(b.getFeatures())
                .active(b.isActive())
                .createdAt(b.getCreatedAt())
                .updatedAt(b.getUpdatedAt())
                .build();
    }
}
