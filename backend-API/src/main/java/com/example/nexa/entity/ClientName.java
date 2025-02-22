package com.example.nexa.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToOne;

@Entity
@NoArgsConstructor
@AllArgsConstructor
@Data
public class ClientName {
    @Id
    private String email;
    private String Fname;
    private String Lname;

    @OneToOne(mappedBy = "clientName")
    private Client client;
}
