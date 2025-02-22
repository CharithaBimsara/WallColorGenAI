package com.example.nexa.service;

import com.example.nexa.repository.InteriorImageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class InteriorImageService {
    @Autowired
    private InteriorImageRepository interiorImageRepository;
    private String email;

    public boolean existsByEmail(String email) {
        this.email = email;
        return interiorImageRepository.existsByEmail(email);
    }
}