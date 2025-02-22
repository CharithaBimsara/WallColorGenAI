package com.example.nexa.controller;

import com.example.nexa.entity.Generate;
import com.example.nexa.service.GenerateService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/generate")
public class GenerateController {

    @Autowired
    private GenerateService generateService;

    @PostMapping("/updateGenerate")
    public void updateGenerate(@RequestBody Generate generate) {
        generateService.updateGenerate(generate);
    }
}
