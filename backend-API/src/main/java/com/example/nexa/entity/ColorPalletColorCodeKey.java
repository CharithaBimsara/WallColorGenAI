package com.example.nexa.entity;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.Objects;

@NoArgsConstructor
public class ColorPalletColorCodeKey implements Serializable {
    private String email;
    private int colorPalletColorId;

    //added by vikum
    private int imageColorPalletId;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ColorPalletColorCodeKey that = (ColorPalletColorCodeKey) o;
        return colorPalletColorId == that.colorPalletColorId && imageColorPalletId == that.imageColorPalletId && Objects.equals(email, that.email);
    }

    @Override
    public int hashCode() {
        return Objects.hash(email, colorPalletColorId, imageColorPalletId);
    }

//    public ColorPalletColorCodeKey(String email, int colorPalletColorId) {
//        this.email = email;
//        this.colorPalletColorId = colorPalletColorId;
//    }

    //added by vikum for colorpallet update
    public ColorPalletColorCodeKey(String email, int colorPalletColorId, int imageColorPalletId) {
        this.email = email;
        this.colorPalletColorId = colorPalletColorId;
        this.imageColorPalletId = imageColorPalletId;
    }
}
