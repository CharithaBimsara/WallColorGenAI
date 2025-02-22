package com.example.nexa.service;
import com.example.nexa.entity.InteriorImage;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ImageMessageProducer {
    @Autowired
    private RabbitTemplate rabbitTemplate;

    public void sendImageForProcessing(InteriorImage image) {
        rabbitTemplate.convertAndSend(
                "image-exchange",
                "image.processing.routing-key",
                image
        );
    }
}