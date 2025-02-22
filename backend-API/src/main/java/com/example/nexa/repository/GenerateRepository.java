package com.example.nexa.repository;

import com.example.nexa.entity.Generate;
import com.example.nexa.entity.GenerateKey;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public interface GenerateRepository extends JpaRepository<Generate, GenerateKey> {

    List<Generate> findByEmail(String email);
    @Transactional
    void deleteByEmail(String email);
}