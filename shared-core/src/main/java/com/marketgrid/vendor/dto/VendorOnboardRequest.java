package com.marketgrid.vendor.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class VendorOnboardRequest {
    @NotBlank(message = "Store name is required")
    private String storeName;

    @NotBlank(message = "Phone number is required")
    private String phone;

    private String businessType;
    private String gstin;
    private String panNumber;

    private String bankName;
    private String accountNumber;
    private String ifscCode;
}
