package com.example.nexa.repository;

import com.example.nexa.entity.ColorPallet;
import com.example.nexa.entity.ColorPalletKey;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public interface ColorPalletRepository extends JpaRepository<ColorPallet, ColorPalletKey> {
    @Transactional
    void deleteByEmail(String email);

    List<ColorPallet> findByEmail(String email);
}
