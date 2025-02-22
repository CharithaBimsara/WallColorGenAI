package com.example.nexa.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;

@Setter
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Data
@IdClass(GenerateKey.class)
public class Generate {
    @Id
    private String email;
    @Id
    private int InteriorImageId;

    @Id
    private int colorPalletId;

    @ManyToOne
    @JoinColumns({
            @JoinColumn(name = "email", referencedColumnName = "email", insertable = false, updatable = false),
            @JoinColumn(name = "interiorImageId", referencedColumnName = "interiorImageId", insertable = false, updatable = false)
    })
    private InteriorImage interiorImage;

    @ManyToOne
    @JsonBackReference
    @JoinColumns({
            @JoinColumn(name = "colorPalletId", referencedColumnName = "imageColorPalletId", insertable = false, updatable = false),
            @JoinColumn(name = "email", referencedColumnName = "email", insertable = false, updatable = false)
    })
    private ColorPallet colorPallet;

    @ManyToOne
    @JoinColumn(name = "email", insertable = false, updatable = false)
    private Client client;

    public InteriorImage getInteriorImage() {
        return interiorImage;
    }

    public ColorPallet getColorPallet() {
        return colorPallet;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setInteriorImageId(int interiorImageId) {
        this.InteriorImageId = interiorImageId;
    }

    public void setColorPalletId(int interiorImageId) {
        this.colorPalletId = interiorImageId;
    }
}
