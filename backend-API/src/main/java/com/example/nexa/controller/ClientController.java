package com.example.nexa.controller;

import com.example.nexa.dto.ClientDTO;
import com.example.nexa.entity.Client;
import com.example.nexa.service.ClientPreferencesService;
import com.example.nexa.service.ClientService;
import com.example.nexa.service.InteriorImageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping(value = "/api/client")
public class ClientController {

    @Autowired
    private ClientService clientService;

    @Autowired
    private InteriorImageService interiorImageService;
    @Autowired
    private ClientPreferencesService clientPreferencesService;


    @GetMapping("/checkData/{email}")
    public boolean checkClientData(@PathVariable String email) {
        boolean hasPreferences = clientPreferencesService.existsByEmail(email);
        boolean hasInteriorImages = interiorImageService.existsByEmail(email);
        return hasPreferences && hasInteriorImages;
    }

    @PostMapping("/saveClient")
    public Client registerClient(@RequestBody ClientDTO clientDTO) {
        return clientService.saveClient(clientDTO);
    }

    @GetMapping("/getClientByClientEmailAndPassword/{clientEmail}/{password}")
    public ClientDTO getClientByClientEmailAndPassword(@PathVariable String clientEmail, @PathVariable String password) {
        System.out.println("Client Email :" + clientEmail + " Password :" + password);
        return clientService.getClientByClientEmailAndPassword(clientEmail, password);
    }

    @PostMapping("/check-email")
    public boolean checkEmailExists(@RequestBody String email) {
        return clientService.checkEmailExists(email);
    }

//    @PostMapping("/savefeedback")
//    public ResponseEntity<String> uploadFile(
//            @RequestParam(value = "file", required = false) MultipartFile file,
//            @RequestParam("userInput") String userInput,
//            @RequestParam("email") String email,
//            @RequestParam("question1") String question1,
//            @RequestParam("question2") String question2,
//            @RequestParam("question3") String question3,
//            @RequestParam("question4") String question4) {
//        try {
//            String fileName = clientService.saveFeedback(file, userInput, email, question1, question2, question3, question4);
//            return new ResponseEntity<>(fileName, HttpStatus.OK);
//        } catch (Exception e) {
//            return new ResponseEntity<>("File upload failed: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
//        }
//    }
}
