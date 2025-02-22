package com.example.nexa.controller;

import com.example.nexa.service.StorageService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
@Slf4j
@RestController
@RequestMapping("/file")
//@CrossOrigin
public class StorageController {

    @Autowired
    private StorageService storageService;

    @PostMapping("/upload")
    public ResponseEntity<String> uploadFile(@RequestParam("file") MultipartFile file){
        try {
            String fileName = storageService.upload(file);
            return new ResponseEntity<>(fileName, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>("File upload failed: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/download/{fileName}")
    public ResponseEntity<ByteArrayResource> downloadFile(@PathVariable String fileName){
        try {
            byte[] data = storageService.downloadFile(fileName);
            ByteArrayResource resource = new ByteArrayResource(data);
            return ResponseEntity.ok()
                    .contentLength(data.length)
                    .header("Content-Type", "application/octet-stream")
                    .header("Content-Disposition", "attachment; filename=\"" + fileName + "\"")
                    .body(resource);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    @DeleteMapping("/delete/{fileName}")
    public ResponseEntity<String> deleteFile(@PathVariable String fileName){
        try {
            storageService.deleteFile(fileName);
            return new ResponseEntity<>(fileName + " removed...", HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>("File deletion failed: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    //new function to upload file and user input
//    @PostMapping("/uploadFileComment")
//    public ResponseEntity<String> uploadFile(
//            @RequestParam("file") MultipartFile file,
//            @RequestParam("userInput") String userInput) {
//        try {
//            String fileName = service.uploadFileComment(file, userInput);
//            return new ResponseEntity<>(fileName, HttpStatus.OK);
//        } catch (Exception e) {
//            return new ResponseEntity<>("File upload failed: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
//        }
//    }
    //updated feedback
//    @PostMapping("/uploadFileComment")
//    public ResponseEntity<String> uploadFile(
//            @RequestParam("file") MultipartFile file,
//            @RequestParam("userInput") String userInput,
//            @RequestParam("email") String email,
//            @RequestParam("question1") String question1,
//            @RequestParam("question2") String question2,
//            @RequestParam("question3") String question3,
//            @RequestParam("question4") String question4) {
//        try {
//            String fileName = service.uploadFileComment(file, userInput, email, question1, question2, question3, question4);
//            return new ResponseEntity<>(fileName, HttpStatus.OK);
//        } catch (Exception e) {
//            return new ResponseEntity<>("File upload failed: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
//        }
//    }//ok sofar but file mandatory

    //file check
//    @PostMapping("/uploadFileComment")
//    public ResponseEntity<String> uploadFile(
//            @RequestParam(value = "file", required = false) MultipartFile file,
//            @RequestParam("userInput") String userInput,
//            @RequestParam("email") String email,
//            @RequestParam("question1") String question1,
//            @RequestParam("question2") String question2,
//            @RequestParam("question3") String question3,
//            @RequestParam("question4") String question4) {
//        try {
//            String fileName = storageService.saveFeedback(file, userInput, email, question1, question2, question3, question4);
//            return new ResponseEntity<>(fileName, HttpStatus.OK);
//        } catch (Exception e) {
//            return new ResponseEntity<>("File upload failed: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
//        }
//    }

    //new
    @PostMapping("/uploadFileComment")
    public ResponseEntity<String> uploadFile(
            @RequestParam(value = "file", required = false) MultipartFile file,
            @RequestParam("userInput") String userInput,
            @RequestParam("email") String email,
            @RequestParam("question1") String question1,
            @RequestParam("question2") String question2,
            @RequestParam("question3") String question3,
            @RequestParam("question4") String question4) {
        try {
            log.info("Received feedback: userInput={}, email={}, question1={}, question2={}, question3={}, question4={}", userInput, email, question1, question2, question3, question4);
            String fileName = storageService.saveFeedback(file, userInput, email, question1, question2, question3, question4);
            log.info("File uploaded successfully: {}", fileName);
            return new ResponseEntity<>(fileName, HttpStatus.OK);
        } catch (Exception e) {
            log.error("Error uploading file: {}", e.getMessage());
            return new ResponseEntity<>("File upload failed: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }


    //upload to interior image the captured photo
//    @PostMapping("/uploadToInterior")
//    public ResponseEntity<String> uploadFile(
//            @RequestParam(value = "file", required = true) MultipartFile file,
//            @RequestParam("email") String email
//            ) {
//        try {
//            String fileName = storageService.uploadToInterior(file,email);
//            return new ResponseEntity<>(fileName, HttpStatus.OK);
//        } catch (Exception e) {
//            return new ResponseEntity<>("File upload failed: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
//        }
//    }

}
