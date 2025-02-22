package com.example.nexa.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

//@Service
//public class PreferenceProcessingProducer {
//    @Autowired
//    private RabbitTemplate rabbitTemplate;
//
//    private static final String CLUSTERING_QUEUE = "user-clustering-queue";
//
//    public void sendPreferenceForClustering(String email) {
//        try {
//            Map<String, String> message = new HashMap<>();
//            message.put("email", email);
//
//            rabbitTemplate.convertAndSend(CLUSTERING_QUEUE, message);
//            System.out.println("Sent clustering request for user: " + email);
//        } catch (Exception e) {
//            System.err.println("Error sending clustering message: " + e.getMessage());
//            throw new RuntimeException("Failed to process user clustering", e);
//        }
//    }
//}

@Service
public class PreferenceProcessingProducer {
    @Autowired
    private RabbitTemplate rabbitTemplate;

    @Autowired
    private ObjectMapper objectMapper;  // Add this

    private static final String CLUSTERING_QUEUE = "user-clustering-queue";

    public void sendPreferenceForClustering(String email) {
        try {
            Map<String, String> message = new HashMap<>();
            message.put("email", email);

            // Convert to JSON string explicitly
            String jsonMessage = objectMapper.writeValueAsString(message);

            // Send as byte array with UTF-8 encoding
            rabbitTemplate.convertAndSend(CLUSTERING_QUEUE,
                    jsonMessage.getBytes(StandardCharsets.UTF_8));

            System.out.println("Sent clustering request for user: " + email);
        } catch (Exception e) {
            System.err.println("Error sending clustering message: " + e.getMessage());
            throw new RuntimeException("Failed to process user clustering", e);
        }
    }
}
