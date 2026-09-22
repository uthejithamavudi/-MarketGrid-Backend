package com.marketgrid.product.dto;

import com.marketgrid.product.ProductStatus;
import com.marketgrid.product.ProductVariant;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Data
public class ProductRequest {
    @NotBlank(message = "Name is required")
    private String name;

    private String description;
    private String categoryId;
    private String categoryName;
    private String subcategory;

    @NotNull(message = "Price is required")
    private BigDecimal price;

    private BigDecimal originalPrice;

    @Min(value = 0, message = "Stock cannot be negative")
    private int stock;

    private String sku;
    private ProductStatus status;
    private List<String> images;
    private List<ProductVariant> variants;
}
