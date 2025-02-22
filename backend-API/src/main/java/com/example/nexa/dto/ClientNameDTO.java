package com.example.nexa.dto;

import javax.persistence.Id;

public class ClientNameDTO {

    @Id
    private String email;
    private String Fname;
    private String Lname;

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFname() {
        return Fname;
    }

    public void setFname(String fname) {
        Fname = fname;
    }

    public String getLname() {
        return Lname;
    }

    public void setLname(String lname) {
        Lname = lname;
    }
}
