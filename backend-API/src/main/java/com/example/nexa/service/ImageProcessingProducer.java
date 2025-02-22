package com.example.nexa.service;

import org.springframework.amqp.core.Queue;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class ImageProcessingProducer {

    @Autowired
    private RabbitTemplate rabbitTemplate;

    @Autowired
    @Qualifier("queue") // Specify the bean name
    private Queue imageProcessingQueue;

    public void sendImageForProcessing(Long interiorImageId, String imageUrl, String email) {
        try {
            Map<String, Object> message = new HashMap<>();
            message.put("interiorImageId", interiorImageId);
            message.put("imageUrl", imageUrl);
            message.put("email", email);

            rabbitTemplate.convertAndSend(
                    imageProcessingQueue.getName(),
                    message
            );

            // Optional: Log the message sent
            System.out.println("Sent message for image processing: " + interiorImageId);
        } catch (Exception e) {
            // Handle any messaging errors
            System.err.println("Error sending message to RabbitMQ: " + e.getMessage());
            // Optionally, you might want to implement a retry mechanism or error tracking
        }
    }
}