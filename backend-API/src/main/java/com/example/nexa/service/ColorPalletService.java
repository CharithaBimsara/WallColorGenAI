package com.example.nexa.service;


import com.example.nexa.config.RabbitMQConfig;
import com.example.nexa.dto.ColorInfo;
import com.example.nexa.dto.ColorPaletteRequest;
import com.example.nexa.dto.ColorPaletteResponse;
import com.example.nexa.dto.ColorPalletDTO;
import com.example.nexa.entity.ColorPallet;
import com.example.nexa.repository.ColorPalletRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.modelmapper.ModelMapper;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ColorPalletService {

    @Autowired
    private ColorPalletRepository colorPalletRepository;

    @Autowired
    private ModelMapper modelMapper;

    @Autowired
    private RabbitTemplate rabbitTemplate;

//    private final RabbitTemplate rabbitTemplate;
    private final ObjectMapper objectMapper;

    public ColorPalletService(RabbitTemplate rabbitTemplate, ObjectMapper objectMapper) {
        this.rabbitTemplate = rabbitTemplate;
        this.objectMapper = objectMapper;
    }

    public ColorPaletteResponse generatePalette(ColorPaletteRequest request) {
        try {
            // Convert request to JSON string for logging
            String requestJson = objectMapper.writeValueAsString(request);
            System.out.println("Sending request: " + requestJson);

            // Send message and receive response
            Object response = rabbitTemplate.convertSendAndReceive(
                    RabbitMQConfig.COLOR_PALETTE_EXCHANGE,
                    RabbitMQConfig.COLOR_ROUTING_KEY,
                    request
            );

            if (response == null) {
                return new ColorPaletteResponse(
                        null,
                        "error",
                        "No response received from color generation service"
                );
            }

            // Convert the response to a Map first
            Map<String, Object> responseMap;
            if (response instanceof Map) {
                responseMap = (Map<String, Object>) response;
            } else {
                responseMap = objectMapper.readValue(
                        objectMapper.writeValueAsString(response),
                        Map.class
                );
            }

            // Check if there's an error in the response
            if (responseMap.containsKey("error")) {
                return new ColorPaletteResponse(
                        null,
                        "error",
                        responseMap.get("error").toString()
                );
            }

            // Convert palette data to List<ColorInfo>
            List<ColorInfo> palette = objectMapper.convertValue(
                    responseMap.get("palette"),
                    objectMapper.getTypeFactory().constructCollectionType(
                            List.class,
                            ColorInfo.class
                    )
            );

            return new ColorPaletteResponse(
                    palette,
                    "success",
                    "Color palette generated successfully"
            );

        } catch (Exception e) {
            e.printStackTrace();
            return new ColorPaletteResponse(
                    null,
                    "error",
                    "Error generating color palette: " + e.getMessage()
            );
        }
    }

//    public ColorPaletteResponse generatePalette(ColorPaletteRequest request) {
//        // Send message to RabbitMQ
//        rabbitTemplate.convertAndSend("color-palette-exchange", "color.generate", request);
//
//        // Wait for response from SageMaker model (implement response handling)
//        // This is a simplified version - you'll need to implement proper async handling
//        @SuppressWarnings("unchecked")
//        ColorPaletteResponse response = (ColorPaletteResponse) rabbitTemplate.receiveAndConvert("color-palette-response-queue");
//
//        return response;
//    }

//    public ColorPaletteResponse generatePalette(ColorPaletteRequest request) {
//        try {
//            // Convert request to JSON string for logging
//            ObjectMapper mapper = new ObjectMapper();
//            String requestJson = mapper.writeValueAsString(request);
//            System.out.println("Sending request: " + requestJson);
//
//            // Send message and receive response
//            Object response = rabbitTemplate.convertSendAndReceive(
//                    RabbitMQConfig.COLOR_PALETTE_EXCHANGE,
//                    RabbitMQConfig.COLOR_ROUTING_KEY,
//                    request
//            );
//
//            if (response == null) {
//                return new ColorPaletteResponse(
//                        null,
//                        "error",
//                        "No response received from color generation service"
//                );
//            }
//
//            return (ColorPaletteResponse) response;
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            return new ColorPaletteResponse(
//                    null,
//                    "error",
//                    "Error generating color palette: " + e.getMessage()
//            );
//        }
//    }
    public ColorPalletDTO saveColorPallet(ColorPalletDTO colorpalletDTO) {
        colorPalletRepository.save(modelMapper.map(colorpalletDTO, ColorPallet.class));
        return colorpalletDTO;
    }

    public void updateColorPallet(ColorPallet colorPallet) {
        colorPalletRepository.save(colorPallet);
    }
}
