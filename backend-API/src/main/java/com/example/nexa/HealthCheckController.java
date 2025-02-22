package com.example.nexa;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
public class HealthCheckController {

    @Autowired
    private DatabaseUtils databaseUtils;

    @GetMapping("/health-check")
    public Map<String, String> healthCheck() {
        Map<String, String> response = new HashMap<>();
        if (databaseUtils.isDatabaseConnectionValid()) {
            response.put("status", "success");
            response.put("message", "Database connection is valid.");
        } else {
            response.put("status", "error");
            response.put("message", "Failed to establish database connection.");
        }
        return response;
    }
}
