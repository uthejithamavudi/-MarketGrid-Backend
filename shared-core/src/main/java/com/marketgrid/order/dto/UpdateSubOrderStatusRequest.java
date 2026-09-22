package com.marketgrid.order.dto;

import com.marketgrid.order.SubOrderStatus;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class UpdateSubOrderStatusRequest {
    @NotNull(message = "Sub-order status is required")
    private SubOrderStatus status;

    private String trackingNumber;
}
