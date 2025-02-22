package com.example.nexa.entity;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

import java.io.Serializable;


@NoArgsConstructor
public class GenerateKey implements Serializable {
    private String email;
    private int InteriorImageId;
    private int colorPalletId;

    public GenerateKey(String email, int interiorImageId, int colorPalletId) {
        this.email = email;
        this.InteriorImageId = interiorImageId;
        this.colorPalletId = colorPalletId;
    }

}

