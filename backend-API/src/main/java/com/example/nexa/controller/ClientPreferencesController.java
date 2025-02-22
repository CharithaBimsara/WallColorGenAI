//package com.example.nexa.controller;
//
//import com.example.nexa.entity.ClientPreferences;
//import com.example.nexa.service.ClientPreferencesService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.*;
//
//@RestController
//@RequestMapping("/api/client-preferences")
//public class ClientPreferencesController {
//
//    @Autowired
//    private ClientPreferencesService service;
//
//
//
//    @PostMapping
//    public ResponseEntity<ClientPreferences> saveOrUpdate(@RequestBody ClientPreferences clientPreferences) {
//        ClientPreferences savedPreferences = service.saveOrUpdate(clientPreferences);
//        return ResponseEntity.ok(savedPreferences);
//    }
//}

//package com.example.nexa.controller;
//
//import com.example.nexa.entity.ClientPreferences;
//import com.example.nexa.service.ClientPreferencesService;
//import com.example.nexa.service.ClusteringPublisher;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.*;
//
//@RestController
//@RequestMapping("/api/client-preferences")
//public class ClientPreferencesController {
//
//    @Autowired
//    private ClientPreferencesService service;
//
//    @Autowired
//    private ClusteringPublisher clusteringPublisher;
//
//    @PostMapping
//    public ResponseEntity<ClientPreferences> saveOrUpdate(@RequestBody ClientPreferences clientPreferences) {
//        // Save preferences
//        ClientPreferences savedPreferences = service.saveOrUpdate(clientPreferences);
//
//        // Trigger clustering process
//        clusteringPublisher.publishClusteringRequest(savedPreferences.getEmail());
//
//        return ResponseEntity.ok(savedPreferences);
//    }
//}


package com.example.nexa.controller;

import com.example.nexa.entity.ClientPreferences;
import com.example.nexa.service.ClientPreferencesService;
import com.example.nexa.service.PreferenceProcessingProducer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/client-preferences")
public class ClientPreferencesController {

    @Autowired
    private ClientPreferencesService service;

    @Autowired
    private PreferenceProcessingProducer preferenceProcessingProducer;

    @PostMapping
    public ResponseEntity<ClientPreferences> saveOrUpdate(@RequestBody ClientPreferences clientPreferences) {
        try {
            // First save the preferences as before
            ClientPreferences savedPreferences = service.saveOrUpdate(clientPreferences);

            // Then trigger the clustering process by sending message to RabbitMQ
            preferenceProcessingProducer.sendPreferenceForClustering(clientPreferences.getEmail());

            return ResponseEntity.ok(savedPreferences);
        } catch (Exception e) {
            // Log the error
            System.err.println("Error processing preferences: " + e.getMessage());
            throw new RuntimeException("Failed to process preferences", e);
        }
    }
}