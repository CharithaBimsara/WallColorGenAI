package com.example.nexa.service;

import org.springframework.stereotype.Service;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

@Service
public class DatabaseUtilityService {

    public boolean loadDatabaseDriver() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return true;
        } catch (ClassNotFoundException e) {
            // Log the exception
            e.printStackTrace();
            return false;
        }
    }

    public boolean createDatabaseConnection() {
        String url = "jdbc:mysql://54.221.51.240:3306/nexa?createDatabaseIfNotExist=true";
        String username = "theuser";
        String password = "thepassword";
        try (Connection connection = DriverManager.getConnection(url, username, password)) {
            return connection != null;
        } catch (SQLException e) {
            // Log the exception
            e.printStackTrace();
            return false;
        }
    }
}
