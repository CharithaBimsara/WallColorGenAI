package com.example.nexa.repository;

import com.example.nexa.entity.ColorPalletColorCode;
import com.example.nexa.entity.ColorPalletColorCodeKey;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public interface ColorPalletColorCodeRepository extends JpaRepository<ColorPalletColorCode, ColorPalletColorCodeKey> {
    List<ColorPalletColorCode> findByEmail(String email);

    @Transactional
    void deleteByEmail(String email);
}
