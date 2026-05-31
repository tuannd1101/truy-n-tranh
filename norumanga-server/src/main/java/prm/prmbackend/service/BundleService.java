package prm.prmbackend.service;

import prm.prmbackend.dto.request.BundleRequestDTO;
import prm.prmbackend.dto.response.BundleResponseDTO;

import java.util.List;

public interface BundleService {

    /** All bundles (admin view). */
    List<BundleResponseDTO> getAllBundles();

    /** Only active bundles (public / client view). */
    List<BundleResponseDTO> getActiveBundles();

    BundleResponseDTO findById(String id);

    BundleResponseDTO create(BundleRequestDTO request);

    BundleResponseDTO update(String id, BundleRequestDTO request);

    void delete(String id);
}
