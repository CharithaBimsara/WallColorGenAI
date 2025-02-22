package com.example.nexa.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ColorInfo implements Serializable {
    private static final long serialVersionUID = 1L;
    private String colorName;
    private String hexValue;
}
