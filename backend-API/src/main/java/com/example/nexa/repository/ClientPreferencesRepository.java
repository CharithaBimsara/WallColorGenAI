package com.example.nexa.repository;

import com.example.nexa.entity.ClientPreferences;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ClientPreferencesRepository extends JpaRepository<ClientPreferences, String> {

    boolean existsByEmail(String email);
}
