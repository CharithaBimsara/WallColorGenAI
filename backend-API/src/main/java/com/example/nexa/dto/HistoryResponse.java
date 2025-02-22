package com.example.nexa.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
//@AllArgsConstructor
//@NoArgsConstructor
public class HistoryResponse {
    private String image;
    private List<String> palette;

    public HistoryResponse(String interiorImageUrl, List<String> palette) {
        this.image = interiorImageUrl;
        this.palette =palette;
    }
}
