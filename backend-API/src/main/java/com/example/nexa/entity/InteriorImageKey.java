package com.example.nexa.entity;


import lombok.NoArgsConstructor;

import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import java.io.Serializable;

@NoArgsConstructor
public class InteriorImageKey implements Serializable {
    private String email;
    private int interiorImageId;
    public InteriorImageKey(String email, int interiorImageId) {
        this.email = email;
        this.interiorImageId = interiorImageId;
    }
}
