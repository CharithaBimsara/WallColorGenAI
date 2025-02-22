package com.example.nexa.service;

import com.example.nexa.dto.ColorPalletColorCodeDTO;
import com.example.nexa.dto.ColorPalletDTO;
import com.example.nexa.entity.ColorPallet;
import com.example.nexa.entity.ColorPalletColorCode;
import com.example.nexa.repository.ColorPalletColorCodeRepository;
import com.example.nexa.repository.ColorPalletRepository;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ColorPalletColorCodeService {

    @Autowired
    private ColorPalletColorCodeRepository colorPalletColorCodeRepository;

    @Autowired
    private ModelMapper modelMapper;

    public ColorPalletColorCodeDTO saveColorPallet(ColorPalletColorCodeDTO colorPalletColorCodeDTO) {
        colorPalletColorCodeRepository.save(modelMapper.map(colorPalletColorCodeDTO, ColorPalletColorCode.class));
        return colorPalletColorCodeDTO;
    }

    public void updateColorPalletColorCode(ColorPalletColorCode colorPalletColorCode) {
        colorPalletColorCodeRepository.save(colorPalletColorCode);
    }
}
