package com.example.nexa.controller;

import com.example.nexa.service.DatabaseUtilityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/database")
public class DatabaseCheckController {

    @Autowired
    private DatabaseUtilityService databaseUtilityService;

    @GetMapping("/check-driver")
    public boolean checkDriver() {
        return databaseUtilityService.loadDatabaseDriver();
    }

    @GetMapping("/check-connection")
    public boolean checkConnection() {
        return databaseUtilityService.createDatabaseConnection();
    }
}





