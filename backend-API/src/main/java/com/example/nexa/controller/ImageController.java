//package com.example.nexa.controller;
//
//import com.example.nexa.config.RabbitMQConfig;
//import com.example.nexa.entity.InteriorImage;
//import com.example.nexa.repository.InteriorImageRepository;
//import com.example.nexa.service.S3Service;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.PostMapping;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RequestParam;
//import org.springframework.web.bind.annotation.RestController;
//import org.springframework.web.multipart.MultipartFile;
//
//import java.io.File;
//import java.io.FileOutputStream;
//import java.io.IOException;
//import java.sql.Timestamp;
//import java.util.HashMap;
//import java.util.Map;
//
//import org.springframework.amqp.rabbit.core.RabbitTemplate;
//
//@RestController
//@RequestMapping("/api/images")
//public class ImageController {
//
//    @Autowired
//    private S3Service s3Service;
//
//    @Autowired
//    private InteriorImageRepository interiorImageRepository;
//
////    @PostMapping("/room")
////    public ResponseEntity<Map<String, Object>> uploadRoomImage(
////            @RequestParam("file") MultipartFile file,
////            @RequestParam("email") String email) throws IOException {
////        String keyName = "room-images/" + file.getOriginalFilename();
////        File convertedFile = convertMultipartFileToFile(file);
////        String imageUrl;
////        try {
////            imageUrl = s3Service.uploadFile(convertedFile.getAbsolutePath(), keyName);
////        } finally {
////            convertedFile.delete();
////        }
////
////        InteriorImage image = new InteriorImage();
////        image.setEmail(email);
////        image.setInteriorImageUrl(imageUrl);
////        image.setTimeStamp(new Timestamp(System.currentTimeMillis()).toString());
////        InteriorImage savedImage = interiorImageRepository.save(image);
////
////        Map<String, Object> response = new HashMap<>();
////        response.put("interiorImageId", savedImage.getInteriorImageId()); // Ensure ID is from saved entity
////        response.put("imageUrl", imageUrl);
////
////        return ResponseEntity.ok(response);
////    }
//
//    @Autowired
//    private RabbitTemplate rabbitTemplate;
//
//    @PostMapping("/room")
//    public ResponseEntity<Map<String, Object>> uploadRoomImage(
//            @RequestParam("file") MultipartFile file,
//            @RequestParam("email") String email) throws IOException {
//        String keyName = "room-images/" + file.getOriginalFilename();
//        File convertedFile = convertMultipartFileToFile(file);
//        String imageUrl;
//        try {
//            imageUrl = s3Service.uploadFile(convertedFile.getAbsolutePath(), keyName);
//        } finally {
//            convertedFile.delete();
//        }
//
//        InteriorImage image = new InteriorImage();
//        image.setEmail(email);
//        image.setInteriorImageUrl(imageUrl);
//        image.setTimeStamp(new Timestamp(System.currentTimeMillis()).toString());
//        InteriorImage savedImage = interiorImageRepository.save(image);
//
//        // Publish a message to RabbitMQ
//        Map<String, Object> message = new HashMap<>();
//        message.put("interiorImageId", savedImage.getInteriorImageId());
//        message.put("email", email);
//        message.put("imageUrl", imageUrl);
//
//        rabbitTemplate.convertAndSend(RabbitMQConfig.QUEUE_NAME, message);
//
//        Map<String, Object> response = new HashMap<>();
//        response.put("interiorImageId", savedImage.getInteriorImageId());
//        response.put("imageUrl", imageUrl);
//
//        return ResponseEntity.ok(response);
//    }
//    private File convertMultipartFileToFile(MultipartFile file) throws IOException {
//        File convertedFile = new File(file.getOriginalFilename());
//        try (FileOutputStream fos = new FileOutputStream(convertedFile)) {
//            fos.write(file.getBytes());
//        }
//        return convertedFile;
//    }
//}
//
////package com.example.nexa.controller;
////
////import com.example.nexa.entity.InteriorImage;
////import com.example.nexa.repository.InteriorImageRepository;
////import com.example.nexa.service.S3Service;
////import com.example.nexa.service.ImageAnalysisPublisher;
////
////import org.springframework.beans.factory.annotation.Autowired;
////import org.springframework.http.ResponseEntity;
////import org.springframework.web.bind.annotation.PostMapping;
////import org.springframework.web.bind.annotation.RequestMapping;
////import org.springframework.web.bind.annotation.RequestParam;
////import org.springframework.web.bind.annotation.RestController;
////import org.springframework.web.multipart.MultipartFile;
////
////import java.io.File;
////import java.io.FileOutputStream;
////import java.io.IOException;
////import java.sql.Timestamp;
////import java.util.HashMap;
////import java.util.Map;
////
////@RestController
////@RequestMapping("/api/images")
////public class ImageController {
////
////    @Autowired
////    private S3Service s3Service;
////
////    @Autowired
////    private InteriorImageRepository interiorImageRepository;
////
////    @Autowired
////    private ImageAnalysisPublisher imageAnalysisPublisher;
////
////    @PostMapping("/room")
////    public ResponseEntity<Map<String, Object>> uploadRoomImage(
////            @RequestParam("file") MultipartFile file,
////            @RequestParam("email") String email) throws IOException {
////
////        // Generate unique key name to prevent overwriting
////        String keyName = "room-images/" + System.currentTimeMillis() + "_" + file.getOriginalFilename();
////
////        // Convert MultipartFile to File
////        File convertedFile = convertMultipartFileToFile(file);
////        String imageUrl;
////
////        try {
////            // Upload to S3
////            imageUrl = s3Service.uploadFile(convertedFile.getAbsolutePath(), keyName);
////        } finally {
////            // Ensure file is deleted after upload
////            convertedFile.delete();
////        }
////
////        // Create and save InteriorImage entity
////        InteriorImage image = new InteriorImage();
////        image.setEmail(email);
////        image.setInteriorImageUrl(imageUrl);
////        image.setTimeStamp(new Timestamp(System.currentTimeMillis()).toString());
////        InteriorImage savedImage = interiorImageRepository.save(image);
////
////        // Publish message to RabbitMQ for AI model processing
////        imageAnalysisPublisher.publishImageForAnalysis(
////                savedImage.getInteriorImageId(),
////                imageUrl,
////                email
////        );
////
////        // Prepare response
////        Map<String, Object> response = new HashMap<>();
////        response.put("interiorImageId", savedImage.getInteriorImageId());
////        response.put("imageUrl", imageUrl);
////
////        return ResponseEntity.ok(response);
////    }
////
////    private File convertMultipartFileToFile(MultipartFile file) throws IOException {
////        File convertedFile = new File(file.getOriginalFilename());
////        try (FileOutputStream fos = new FileOutputStream(convertedFile)) {
////            fos.write(file.getBytes());
////        }
////        return convertedFile;
////    }
////}



//package com.example.nexa.controller;
//
//import com.example.nexa.config.RabbitMQConfig;
//import com.example.nexa.entity.InteriorImage;
//import com.example.nexa.repository.InteriorImageRepository;
//import com.example.nexa.service.S3Service;
//import com.fasterxml.jackson.databind.ObjectMapper;  // Import ObjectMapper for JSON serialization
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.PostMapping;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RequestParam;
//import org.springframework.web.bind.annotation.RestController;
//import org.springframework.amqp.rabbit.core.RabbitTemplate;
//import org.springframework.web.multipart.MultipartFile;
//
//import java.io.File;
//import java.io.FileOutputStream;
//import java.io.IOException;
//import java.sql.Timestamp;
//import java.util.HashMap;
//import java.util.Map;
//
//@RestController
//@RequestMapping("/api/images")
//public class ImageController {
//
//    @Autowired
//    private S3Service s3Service;
//
//    @Autowired
//    private InteriorImageRepository interiorImageRepository;
//
//    @Autowired
//    private RabbitTemplate rabbitTemplate;
//
//    @Autowired
//    private ObjectMapper objectMapper;  // ObjectMapper bean to serialize objects to JSON
//
//    @PostMapping("/room")
//    public ResponseEntity<Map<String, Object>> uploadRoomImage(
//            @RequestParam("file") MultipartFile file,
//            @RequestParam("email") String email) throws IOException {
//        String keyName = "room-images/" + file.getOriginalFilename();
//        File convertedFile = convertMultipartFileToFile(file);
//        String imageUrl;
//        try {
//            imageUrl = s3Service.uploadFile(convertedFile.getAbsolutePath(), keyName);
//        } finally {
//            convertedFile.delete();
//        }
//
//        // Get the latest interior_image_id for the given email
////        Integer latestId = interiorImageRepository.findMaxInteriorImageIdByEmail(email);
//        Integer latestId = interiorImageRepository.findMaxInteriorImageId();
//
//        // Increment the latest ID to get the new interior_image_id
//        int newInteriorImageId = (latestId != null) ? latestId + 1 : 1;
//
//
//        InteriorImage image = new InteriorImage();
//        image.setEmail(email);
//        image.setInteriorImageUrl(imageUrl);
//        image.setTimeStamp(new Timestamp(System.currentTimeMillis()).toString());
//        InteriorImage savedImage = interiorImageRepository.save(image);
//
//        // Create a message map
//        Map<String, Object> message = new HashMap<>();
////        message.put("interiorImageId", savedImage.getInteriorImageId());
//        message.put("interiorImageId", newInteriorImageId);
//        message.put("email", email);
//        message.put("imageUrl", imageUrl);
//
//        // Convert the message map to a JSON string
//        String jsonMessage = objectMapper.writeValueAsString(message);
//
//        // Publish the JSON message to RabbitMQ
//        rabbitTemplate.convertAndSend(RabbitMQConfig.QUEUE_NAME, jsonMessage);
//
//        Map<String, Object> response = new HashMap<>();
////        response.put("interiorImageId", savedImage.getInteriorImageId());
//        response.put("interiorImageId", newInteriorImageId);
//        response.put("imageUrl", imageUrl);
//
//        return ResponseEntity.ok(response);
//    }
//
//    private File convertMultipartFileToFile(MultipartFile file) throws IOException {
//        File convertedFile = new File(file.getOriginalFilename());
//        try (FileOutputStream fos = new FileOutputStream(convertedFile)) {
//            fos.write(file.getBytes());
//        }
//        return convertedFile;
//    }
//}


package com.example.nexa.controller;

import com.example.nexa.config.RabbitMQConfig;
import com.example.nexa.entity.InteriorImage;
import com.example.nexa.repository.InteriorImageRepository;
import com.example.nexa.service.S3Service;
import com.fasterxml.jackson.databind.ObjectMapper;  // Import ObjectMapper for JSON serialization
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/images")
public class ImageController {

    @Autowired
    private S3Service s3Service;

    @Autowired
    private InteriorImageRepository interiorImageRepository;

    @Autowired
    private RabbitTemplate rabbitTemplate;

    @Autowired
    private ObjectMapper objectMapper;  // ObjectMapper bean to serialize objects to JSON

    @PostMapping("/room")
    public ResponseEntity<Map<String, Object>> uploadRoomImage(
            @RequestParam("file") MultipartFile file,
            @RequestParam("email") String email,
            @RequestParam(required = false) Double roomWidth,
            @RequestParam(required = false) Double roomHeight,
            @RequestParam(required = false) String markedObjects) throws IOException {

        String keyName = "room-images/" + file.getOriginalFilename();
        File convertedFile = convertMultipartFileToFile(file);
        String imageUrl;
        try {
            imageUrl = s3Service.uploadFile(convertedFile.getAbsolutePath(), keyName);
        } finally {
            convertedFile.delete();
        }

        Integer latestId = interiorImageRepository.findMaxInteriorImageId();
        int newInteriorImageId = (latestId != null) ? latestId + 1 : 1;

        InteriorImage image = new InteriorImage();
        image.setEmail(email);
        image.setInteriorImageUrl(imageUrl);
        image.setTimeStamp(new Timestamp(System.currentTimeMillis()).toString());
        InteriorImage savedImage = interiorImageRepository.save(image);

        // Message for texture/color detection
        Map<String, Object> processingMessage = new HashMap<>();
        processingMessage.put("interiorImageId", newInteriorImageId);
        processingMessage.put("email", email);
        processingMessage.put("imageUrl", imageUrl);
        rabbitTemplate.convertAndSend(RabbitMQConfig.QUEUE_NAME,
                objectMapper.writeValueAsString(processingMessage));

        // Message for complexity analysis
        if (roomWidth != null && roomHeight != null && markedObjects != null) {
            Map<String, Object> complexityMessage = new HashMap<>();
            complexityMessage.put("interiorImageId", newInteriorImageId);
            complexityMessage.put("email", email);
            complexityMessage.put("imageUrl", imageUrl);
            complexityMessage.put("roomWidth", roomWidth);
            complexityMessage.put("roomHeight", roomHeight);
            complexityMessage.put("markedObjects", markedObjects);
            rabbitTemplate.convertAndSend(RabbitMQConfig.COMPLEXITY_QUEUE,
                    objectMapper.writeValueAsString(complexityMessage));
        }

        Map<String, Object> response = new HashMap<>();
        response.put("interiorImageId", newInteriorImageId);
        response.put("imageUrl", imageUrl);

        return ResponseEntity.ok(response);
    }

    private File convertMultipartFileToFile(MultipartFile file) throws IOException {
        File convertedFile = new File(file.getOriginalFilename());
        try (FileOutputStream fos = new FileOutputStream(convertedFile)) {
            fos.write(file.getBytes());
        }
        return convertedFile;
    }
}
