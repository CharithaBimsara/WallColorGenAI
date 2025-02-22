package com.example.nexa.repository;


import com.example.nexa.entity.Generate;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.skyscreamer.jsonassert.JSONAssert.assertEquals;

@SpringBootTest
public class GenerateRepositoryTest {

    @Autowired
    private GenerateRepository generateRepository;

    @Test
    public void testFindByEmail() {
        String email = "charithabimsjara@gmail.com";
        List<Generate> generates = generateRepository.findByEmail(email);
//        assertFalse(generates.isEmpty(), "Generates should not be empty");
        assertFalse(generates.isEmpty(), "Generates should not be empty");

    }

    private void assertEquals(String email, String email1, boolean emailsShouldMatch) {
    }
}
