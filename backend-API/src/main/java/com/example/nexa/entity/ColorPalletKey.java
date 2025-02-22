package com.example.nexa.entity;

import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.Objects;

@NoArgsConstructor
public class ColorPalletKey implements Serializable {
    private int imageColorPalletId;
    private String email;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ColorPalletKey that = (ColorPalletKey) o;
        return imageColorPalletId == that.imageColorPalletId && Objects.equals(email, that.email);
    }

    @Override
    public int hashCode() {
        return Objects.hash(imageColorPalletId, email);
    }

    public ColorPalletKey(int imageColorPalletId, String email) {
        this.imageColorPalletId = imageColorPalletId;
        this.email = email;
    }


}
