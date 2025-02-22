package com.example.nexa.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.Objects;

@Entity
@NoArgsConstructor
@AllArgsConstructor
@Data
@IdClass(ColorPalletColorCodeKey.class)
public class ColorPalletColorCode {
    @Id
    private String email;

    @Id
    private int colorPalletColorId;

    @Id
    private int imageColorPalletId;
    private String colorCode;

    @ManyToOne
    @JoinColumns({
            @JoinColumn(name = "email", referencedColumnName = "email", insertable = false, updatable = false),
            @JoinColumn(name = "imageColorPalletId", referencedColumnName = "imageColorPalletId", insertable = false, updatable = false)
    })
    private ColorPallet colorPallet;

    public String getColorCode() {
        return colorCode;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ColorPalletColorCode that = (ColorPalletColorCode) o;
        return colorPalletColorId == that.colorPalletColorId && imageColorPalletId == that.imageColorPalletId && Objects.equals(email, that.email);
    }

    @Override
    public int hashCode() {
        return Objects.hash(email, colorPalletColorId, imageColorPalletId);
    }


    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }


    public void setColorPalletColorId(int i) {
        this.colorPalletColorId = i;
    }

    public void setColorCode(String colorCode) {
        this.colorCode = colorCode;
    }

    public void setimageColorPalletId(int interiorImageId) {
        this.imageColorPalletId = interiorImageId;
    }

//    public void setImageColorPalletId(int interiorImageId) {
//        this.imageColorPalletId = interiorImageId;
//    }
}
