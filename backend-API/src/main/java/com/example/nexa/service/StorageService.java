package com.example.nexa.service;

import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.amazonaws.services.s3.model.S3Object;
import com.amazonaws.services.s3.model.S3ObjectInputStream;
import com.amazonaws.util.IOUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

@Service
@Slf4j
public class StorageService {
    @Autowired
    ClientService clientService;

//    @Autowired
//    InteriorImageService interiorImageService;

    @Value("${aws.s3.bucket}")
    private String bucketName;

    @Autowired
    private AmazonS3 s3Client;

    @Value("${aws.accessKeyId}")
    private String accessKeyId;

    @Value("${aws.secretKey}")
    private String secretKey;

    @Value("${aws.region}")
    private String region;

    public String upload(MultipartFile file) {
        File fileObj = convertMultiPartFileToFile(file);
        String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
        try {
            s3Client.putObject(new PutObjectRequest(bucketName, fileName, fileObj));
            return "File Uploaded: " + fileName;
        } catch (Exception e) {
            //log.error("Error uploading file to S3", e);
            throw new RuntimeException("Error uploading file to S3", e);
        } finally {
            fileObj.delete();
        }
    }

    public byte[] downloadFile(String fileName) {
        try {
            S3Object s3Object = s3Client.getObject(bucketName, fileName);
            S3ObjectInputStream inputStream = s3Object.getObjectContent();
            return IOUtils.toByteArray(inputStream);
        } catch (IOException e) {
            //log.error("Error downloading file from S3", e);
            throw new RuntimeException("Error downloading file from S3", e);
        }
    }

    public void deleteFile(String fileName) {
        try {
            s3Client.deleteObject(bucketName, fileName);
        } catch (Exception e) {
            //log.error("Error deleting file from S3", e);
            throw new RuntimeException("Error deleting file from S3", e);
        }
    }

    private File convertMultiPartFileToFile(MultipartFile file) {
        File convertedFile = new File(file.getOriginalFilename());
        try (FileOutputStream fos = new FileOutputStream(convertedFile)) {
            fos.write(file.getBytes());
        } catch (IOException e) {
            //log.error("Error converting multipart file to file", e);
            throw new RuntimeException("Error converting multipart file to file", e);
        }
        return convertedFile;
    }

    //upload file and input
//    public String uploadFileComment(MultipartFile file, String userInput) {
//        File fileObj = convertMultiPartFileToFile(file);
//        String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
//        try {
//            uploadToS3(fileObj, fileName);
//            // Process user input or store it as needed
//            //log.info("User input: {}", userInput);
//            //log.info("File Name: {}", fileName);
//            //passing to the feedback
////            Feedback newfeedback = new Feedback();
////            newfeedback.setComment(userInput);
////            newfeedback.setS3url(fileName);
//
//            feedbackService.saveFeedback(userInput,fileName);
//            return fileName; // Return the filename or other success indicator
//        } catch (Exception e) {
//            //log.error("Error uploading file to S3", e);
//            throw new RuntimeException("Error uploading file to S3", e);
//        } finally {
//            fileObj.delete();
//        }
//    }
    private void uploadToS3(File file, String fileName) {
        BasicAWSCredentials awsCredentials = new BasicAWSCredentials(accessKeyId, secretKey);
        AmazonS3 s3Client = AmazonS3ClientBuilder.standard()
                .withRegion(Regions.fromName(region))
                .withCredentials(new AWSStaticCredentialsProvider(awsCredentials))
                .build();
        try {
            s3Client.putObject(new PutObjectRequest(bucketName, fileName, file));
        } catch (Exception e) {
            //log.error("Error uploading file to S3", e);
            throw new RuntimeException("Error uploading file to S3", e);
        }
    }

    //updated feedback
//    //ok sofar file mandatory
//    public String uploadFileComment(MultipartFile file, String userInput, String email, String question1, String question2, String question3, String question4) {
//        File fileObj = convertMultiPartFileToFile(file);
//        String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
//        try {
//            uploadToS3(fileObj, fileName);
//
//            String s3Url = "https://feedbackimages3.s3.amazonaws.com/" + fileName;
////            feedbackService.saveFeedback(userInput, s3Url, email, question1, question2, question3, question4);
//            feedbackService.saveFeedback(email, userInput, question1, question2, question3, question4,s3Url);
//            return fileName; // Return the filename or other success indicator
//        } catch (Exception e) {
//            throw new RuntimeException("Error uploading file to S3", e);
//        } finally {
//            fileObj.delete();
//        }
//    }
    //file check
//    public String saveFeedback(MultipartFile file, String userInput, String email, String question1, String question2, String question3, String question4) {
//        String s3Url = null;
//        if (file != null) {
//            File fileObj = convertMultiPartFileToFile(file);
//            String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
//            try {
//                uploadToS3(fileObj, fileName);
//                s3Url = "https://feedbackimages3.s3.amazonaws.com/" + fileName;
//            } catch (Exception e) {
//                throw new RuntimeException("Error uploading file to S3", e);
//            } finally {
//                fileObj.delete();
//            }
//        }
//
////        clientService.saveFeedback(email, userInput, question1, question2, question3, question4, s3Url);
//        clientService.saveFeedback( question1, question2, question3, question4, s3Url,userInput,email);
//
//        return s3Url != null ? s3Url : "No file uploaded"; // Return the filename or other success indicator
//    }

    //new savefeedback
    public String saveFeedback(MultipartFile file, String userInput, String email, String question1, String question2, String question3, String question4) {
        String s3Url = null;
        if (file != null) {
            File fileObj = convertMultiPartFileToFile(file);
            String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
            try {
                uploadToS3(fileObj, fileName);
                s3Url = "https://feedbackimages3.s3.amazonaws.com/" + fileName;
                log.info("File uploaded to S3: {}", s3Url);
            } catch (Exception e) {
                log.error("Error uploading file to S3: {}", e.getMessage());
                throw new RuntimeException("Error uploading file to S3", e);
            } finally {
                fileObj.delete();
            }
        }

        log.info("Saving feedback to database: userInput={}, email={}, question1={}, question2={}, question3={}, question4={}, s3Url={}", userInput, email, question1, question2, question3, question4, s3Url);
        clientService.saveFeedback(question1, question2, question3, question4, userInput, s3Url, email);

        return s3Url != null ? s3Url : "No file uploaded";
    }


    //save to interiror image to db
//    public String uploadToInterior(MultipartFile file,String email) {
//        String s3Url = null;
//        if (file != null) {
//            File fileObj = convertMultiPartFileToFile(file);
//            String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
//            try {
//                uploadToS3(fileObj, fileName);
//                s3Url = "https://feedbackimages3.s3.amazonaws.com/" + fileName;
//            } catch (Exception e) {
//                throw new RuntimeException("Error uploading file to S3", e);
//            } finally {
//                fileObj.delete();
//            }
//        }
//
//        interiorImageService.saveToInterior(s3Url,email);
//        return s3Url != null ? s3Url : "No file uploaded"; // Return the filename or other success indicator
//    }


}
