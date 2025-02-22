package com.example.nexa.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Column;
import javax.persistence.Id;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ColorPalletColorCodeDTO {

    private String email;
    private int colorPalletColorId;
    private String colorCode;
    private String selectedColor;
    private String colorGroup;
    private int imageColorPalletId;


}
