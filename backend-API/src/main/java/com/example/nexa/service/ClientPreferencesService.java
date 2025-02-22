package com.example.nexa.service;

import com.example.nexa.entity.ClientPreferences;
import com.example.nexa.repository.ClientPreferencesRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ClientPreferencesService {

    @Autowired
    private ClientPreferencesRepository repository;

    public ClientPreferences saveOrUpdate(ClientPreferences clientPreferences) {
        return repository.save(clientPreferences);
    }

    public boolean existsByEmail(String email) {
        return repository.existsByEmail(email);
    }
}
