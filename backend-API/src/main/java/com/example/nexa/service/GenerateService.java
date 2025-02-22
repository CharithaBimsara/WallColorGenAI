package com.example.nexa.service;

import com.example.nexa.entity.Generate;
import com.example.nexa.repository.GenerateRepository;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class GenerateService {

    @Autowired
    private ModelMapper modelMapper;

    @Autowired
    private GenerateRepository generateRepository;

    public void updateGenerate(Generate generate) {
        generateRepository.save(generate);
    }
}
