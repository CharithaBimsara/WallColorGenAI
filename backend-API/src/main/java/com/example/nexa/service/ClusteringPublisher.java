package com.example.nexa.service;

import com.example.nexa.config.RabbitMQConfig;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Service
public class ClusteringPublisher {

    @Autowired
    private RabbitTemplate rabbitTemplate;

    @Autowired
    private ObjectMapper objectMapper;

    public void publishClusteringRequest(String email) {
        try {
            // Create message payload
            Map<String, Object> message = new HashMap<>();
            message.put("requestId", UUID.randomUUID().toString());
            message.put("email", email);
            message.put("timestamp", System.currentTimeMillis());

            // Convert to JSON string
            String jsonMessage = objectMapper.writeValueAsString(message);

            // Send to RabbitMQ
            rabbitTemplate.convertAndSend(RabbitMQConfig.CLUSTERING_QUEUE, jsonMessage);
        } catch (Exception e) {
            // Log error and possibly handle it
            throw new RuntimeException("Failed to publish clustering request", e);
        }
    }
}