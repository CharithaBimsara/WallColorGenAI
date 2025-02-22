package com.example.nexa.controller;

import com.example.nexa.dto.ColorPaletteRequest;
import com.example.nexa.dto.ColorPaletteResponse;
import com.example.nexa.entity.*;
import com.example.nexa.repository.ColorPalletColorCodeRepository;
import com.example.nexa.repository.ColorPalletRepository;
import com.example.nexa.repository.GenerateRepository;
import com.example.nexa.service.ColorPalletService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping("/api/color_pallet_generate")
public class ColorPalletController {

    @Autowired
    ColorPalletRepository colorPalletRepository;
    @Autowired
    ColorPalletColorCodeRepository colorPalletColorCodeRepository;
    @Autowired
    GenerateRepository generateRepository;

    @Autowired
    private ColorPalletService colorPaletteService;

    @PostMapping
    public ResponseEntity<String> createColorPallet(
            @RequestParam String email,
            @RequestParam int interiorImageId,
            @RequestParam String selectedColor,
            @RequestParam String colorGroup,
            @RequestParam String rating,
            @RequestBody String[] colorCodes) {


        try {
            // Logging the inputs
            System.out.println("Email: " + email);
            System.out.println("InteriorImageId: " + interiorImageId);
            System.out.println("Selected Color: " + selectedColor);
            System.out.println("Color Group: " + colorGroup);
            System.out.println("Rating: " + rating);
            System.out.println("Color Codes: " + String.join(", ", colorCodes));

            ColorPallet colorPallet = new ColorPallet();
            colorPallet.setEmail(email);
            colorPallet.setImageColorPalletId(interiorImageId);
            colorPallet.setSelectedColor(selectedColor);
            colorPallet.setColorGroup(colorGroup);
            colorPallet.setRating(rating);
            colorPalletRepository.save(colorPallet);

            for (int i = 0; i < colorCodes.length; i++) {
                ColorPalletColorCode colorPalletColorCode = new ColorPalletColorCode();
                colorPalletColorCode.setEmail(email);
                colorPalletColorCode.setColorPalletColorId(i + 1);
                colorPalletColorCode.setimageColorPalletId(interiorImageId);
                colorPalletColorCode.setColorCode(colorCodes[i]);

                System.out.println("Email :-"+email+"\npallet id: "+(i + 1)+"\nInterior Image Id :-"+interiorImageId+"\ncolor : "+colorCodes[i]);

                colorPalletColorCodeRepository.save(colorPalletColorCode);
            }

            Generate generate = new Generate();
            generate.setEmail(email);
            generate.setInteriorImageId(interiorImageId);
            generate.setColorPalletId(interiorImageId);
            generateRepository.save(generate);

            System.out.println("Generation complete");

            return ResponseEntity.ok("Generation complete");
        } catch (StackOverflowError e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error occurred while processing: " + e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Unexpected error occurred: " + e.getMessage());
        }


    }

    @PostMapping("/generate")
    public ResponseEntity<ColorPaletteResponse> generatePalette(@RequestBody ColorPaletteRequest request) {
        ColorPaletteResponse response = colorPaletteService.generatePalette(request);
        return ResponseEntity.ok(response);
    }
}
