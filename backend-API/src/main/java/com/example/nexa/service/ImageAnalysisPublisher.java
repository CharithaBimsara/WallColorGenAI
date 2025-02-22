package com.example.nexa.service;

import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class ImageAnalysisPublisher {
    @Autowired
    private RabbitTemplate rabbitTemplate;

    public void publishImageForAnalysis(Long interiorImageId, String imageUrl) {
        Map<String, Object> message = new HashMap<>();
        message.put("interiorImageId", interiorImageId);
        message.put("imageUrl", imageUrl);

        rabbitTemplate.convertAndSend(
                "interior-image-analysis-exchange",
                "image.upload",
                message
        );
    }


}
