package com.example.nexa.controller;

import com.example.nexa.dto.HistoryResponse;
import com.example.nexa.repository.*;
import com.example.nexa.service.HistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/history")
public class HistoryController {

    @Autowired
    private HistoryService historyService;
    @Autowired
    private ClientRepository clientRepo;

    @Autowired
    InteriorImageRepository interiorImageRepo;
    @Autowired
    ColorPalletRepository colorPalletRepo;
    @Autowired
    ColorPalletColorCodeRepository colorPalletColorCodeRepo;
    @Autowired
    GenerateRepository generateRepo;


    @GetMapping("/{email}")
    public ResponseEntity<List<HistoryResponse>> getHistory(@PathVariable String email) {
        List<HistoryResponse> history = historyService.getHistoryByEmail(email);
        return ResponseEntity.ok(history);
    }

    @DeleteMapping("/{email}")
    public ResponseEntity<Void> clearHistory(@PathVariable String email) {
        if (clientRepo.existsByEmail(email)) {
            interiorImageRepo.deleteAll(interiorImageRepo.findByClientEmail(email));
            colorPalletRepo.deleteAll(colorPalletRepo.findByEmail(email));
            colorPalletColorCodeRepo.deleteAll(colorPalletColorCodeRepo.findByEmail(email));
            generateRepo.deleteAll(generateRepo.findByEmail(email));

            return ResponseEntity.ok().build();
        }
        return ResponseEntity.notFound().build();
    }
}
