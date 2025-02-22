package com.example.nexa.entity;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.Objects;
import java.util.Set;

@Entity
@NoArgsConstructor
@AllArgsConstructor
@Data
@IdClass(ColorPalletKey.class)
public class ColorPallet {
    @Id
    private int imageColorPalletId;
    @Id
    private String email;
    private String rating;
    private String selectedColor;
    private String colorGroup;

    @OneToMany(mappedBy = "colorPallet", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<ColorPalletColorCode> colorCodes;

    @OneToMany(mappedBy = "colorPallet", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonManagedReference
    private Set<Generate> generates;

    public Set<ColorPalletColorCode> getColorCodes() {
        return colorCodes;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ColorPallet that = (ColorPallet) o;
        return imageColorPalletId == that.imageColorPalletId && Objects.equals(email, that.email);
    }

    @Override
    public int hashCode() {
        return Objects.hash(imageColorPalletId, email);
    }

    public String getEmail() {
        return this.email;
    }


    public void setEmail(String email) {
        this.email = email;
    }

    public void setImageColorPalletId(int interiorImageId) {
        this.imageColorPalletId = interiorImageId;
    }

    public void setRating(String rating) {

        this.rating = rating;
    }

    public void setSelectedColor(String selectedColor) {
        this.selectedColor = selectedColor;
    }

    public void setColorGroup(String colorGroup) {
        this.colorGroup = colorGroup;
    }
}
