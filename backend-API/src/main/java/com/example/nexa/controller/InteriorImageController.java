package com.example.nexa.controller;

import com.example.nexa.entity.InteriorImage;
import com.example.nexa.repository.InteriorImageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
@RestController
public class InteriorImageController {
    @Autowired
    private InteriorImageRepository interiorImageRepository;


    @GetMapping("/api/v1/outputimage/getAllDataByAllValue/{complexity}/{texture}/{color}")
    public List<InteriorImage> getAllDataByAllValue(@PathVariable String complexity,
                                                    @PathVariable String texture,
                                                    @PathVariable String color) {
        return interiorImageRepository.getAllDataByAllValue(complexity, texture, color);
    }


}
