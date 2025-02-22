package com.example.nexa.service;

import com.example.nexa.dto.HistoryResponse;
import com.example.nexa.entity.Generate;
import com.example.nexa.repository.ColorPalletColorCodeRepository;
import com.example.nexa.repository.ColorPalletRepository;
import com.example.nexa.repository.GenerateRepository;
import com.example.nexa.repository.InteriorImageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class HistoryService {

    @Autowired
    private GenerateRepository generateRepository;
    @Autowired
    private InteriorImageRepository interiorImageRepository;

    @Autowired
    private ColorPalletRepository colorPalletRepository;

    @Autowired
    private ColorPalletColorCodeRepository colorPalletColorCodeRepository;

    public List<HistoryResponse> getHistoryByEmail(String email) {
        System.out.println("Email :"+ email);
        List<Generate> generates = generateRepository.findByEmail(email);

//        System.out.println(generates.size());
//        System.out.println(generates);

        return generates.stream().map(generate -> {
            List<String> palette = Collections.singletonList(generate.getColorPallet().getColorCodes().stream()
                    .map(colorCode -> colorCode.getColorCode())
                    .collect(Collectors.joining(" ")));
//            List<String> palette = generate.getColorPallet().getColorCodes().stream()
//                    .map(colorCode -> colorCode.getColorCode())
//                    .collect(Collectors.toList());
            //meh comment karpu eka ain kargnna List ekak vidihta data onenm ita passe uda code kalla ain karnna

            return new HistoryResponse(generate.getInteriorImage().getInteriorImageUrl(), palette);
        }).collect(Collectors.toList());
    }


}
