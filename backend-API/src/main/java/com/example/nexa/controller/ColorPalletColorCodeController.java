package com.example.nexa.controller;

import com.example.nexa.dto.ColorPalletColorCodeDTO;
import com.example.nexa.entity.ColorPalletColorCode;
import com.example.nexa.service.ColorPalletColorCodeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/colorCode")
public class ColorPalletColorCodeController {

    @Autowired
    private ColorPalletColorCodeService colorPalletColorCodeService;

    @PostMapping("/saveColorCode")
    public ColorPalletColorCodeDTO saveColorPallet(@RequestBody ColorPalletColorCodeDTO colorPalletColorCodeDTO) {
        return colorPalletColorCodeService.saveColorPallet(colorPalletColorCodeDTO);
    }

    @PostMapping("/updateColorPalletColorCode")
    public void updateColorPalletColorCode(@RequestBody ColorPalletColorCode colorPalletColorCode) {
        colorPalletColorCodeService.updateColorPalletColorCode(colorPalletColorCode);
    }
}
