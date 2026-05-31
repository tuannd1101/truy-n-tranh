package prm.prmbackend.dto.request;

import lombok.Data;

/**
 * Fields an admin may edit on a user. All fields optional — only non-null
 * values are applied. User creation/deletion is NOT supported.
 */
@Data
public class UserUpdateRequestDTO {

    private String fullName;

    /** Target role id. Takes precedence over {@link #roleName} when both set. */
    private String roleId;

    /** Target role name (e.g. "Premium"). Used when roleId is not provided. */
    private String roleName;

    /** Account status, e.g. "ACTIVE" / "BANNED". */
    private String status;
}
