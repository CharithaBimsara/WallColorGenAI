package com.example.nexa.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.List;
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ColorPaletteResponse implements Serializable {
    private static final long serialVersionUID = 1L;
    private List<ColorInfo> palette;
    private String status;
    private String message;

    public ColorPaletteResponse(Object o, String error, String s) {
        this.palette = (List<ColorInfo>) o;
        this.status =error;
        this.message =s;
    }

//public ColorPaletteResponse(List<ColorInfo> palette, String status, String message) {
//    this.palette = palette;
//    this.status = status;
//    this.message = message;
//}

}
