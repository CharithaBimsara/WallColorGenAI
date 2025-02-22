package com.example.nexa.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;

@Entity
@NoArgsConstructor
@AllArgsConstructor
@Data
public class ClientPreferences {

    @Id
    private String email;

    private String ageGroup;
    private String architecturalStyle;
    private String budget;
    private String climate;
    private String colorToneTheme;
    private String favoriteColors;
    private String lifestyle;
    private boolean naturalLightChecked;
    private String numberOfMembers;
    private boolean photosensitivity;
    private boolean richColorChecked;
    private String preferredAmbiance;

    @OneToOne
    @JoinColumn(name = "email", referencedColumnName = "email")
    private Client client;

    public String getEmail() {
        return this.email;
    }
}
