package com.marketgrid.vendor.dto;

import com.marketgrid.vendor.VendorStatus;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class VendorStatusUpdateRequest {
    @NotNull(message = "Vendor status is required")
    private VendorStatus status;
    private String reason;
}
