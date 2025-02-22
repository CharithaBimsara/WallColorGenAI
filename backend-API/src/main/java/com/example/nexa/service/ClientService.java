package com.example.nexa.service;

import com.example.nexa.dto.ClientDTO;
import com.example.nexa.entity.Client;
import com.example.nexa.entity.ClientName;
import com.example.nexa.repository.ClientRepository;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
@Slf4j
@Service
public class ClientService {
    @Autowired
    private ClientRepository clientRepository;

    public Client saveClient(ClientDTO clientDTO) {
        Client client = new Client();
        client.setEmail(clientDTO.getEmail());
        client.setGender(clientDTO.getGender());
        client.setBirthDate(clientDTO.getBirthDate());
        client.setPassword(clientDTO.getPassword());
        client.setUserGroup(null); // Or set a default value if needed

        ClientName clientName = new ClientName();
        clientName.setEmail(clientDTO.getEmail());
        clientName.setFname(clientDTO.getFname());
        clientName.setLname(clientDTO.getLname());

        client.setClientName(clientName);

        return clientRepository.save(client);
    }


    public ClientDTO getClientByClientEmailAndPassword(String email, String password) {
        Client client = clientRepository.getClientByClientEmailAndPassword(email, password);
        if (client != null) {
            ClientDTO clientDTO = new ClientDTO();
            clientDTO.setEmail(client.getEmail());
            clientDTO.setGender(client.getGender());
            clientDTO.setBirthDate(client.getBirthDate());
            clientDTO.setUserGroup(client.getUserGroup());
            clientDTO.setPassword(client.getPassword());

            ClientName clientName = client.getClientName();
            clientDTO.setFname(clientName.getFname());
            clientDTO.setLname(clientName.getLname());

            return clientDTO;
        }
        return null;
    }

    public boolean checkEmailExists(String email) {
        return clientRepository.existsByEmail(email);
    }
    //feedback
//    @Transactional
//    public void saveFeedback(String email, String feedbackComment , String feedback_answer1, String feedback_answer2, String feedback_answer3, String feedback_answer4 ,String feedback_image_url) {
//        clientRepository.insertFeedback(email, feedbackComment, feedback_answer1, feedback_answer2, feedback_answer3, feedback_answer4,feedback_image_url);
//    }

//    @Transactional
//    public void saveFeedback(String feedback_answer1, String feedback_answer2, String feedback_answer3, String feedback_answer4, String feedbackComment, String feedback_image_url, String email) {
//        clientRepository.insertFeedback(feedback_answer1, feedback_answer2, feedback_answer3, feedback_answer4, feedbackComment, feedback_image_url, email);
//    }

    @Transactional

    public void saveFeedback(String question1, String question2, String question3, String question4, String userInput, String s3Url, String email) {
        log.info("Inserting feedback into database: question1={}, question2={}, question3={}, question4={}, userInput={}, s3Url={}, email={}", question1, question2, question3, question4, userInput, s3Url, email);
        clientRepository.insertFeedback(question1, question2, question3, question4, userInput, s3Url, email);
    }




//    public void saveFeedback(String email, String comment, String question1, String question2, String question3, String question4, String url) {
//        clientRepository.insertFeedback(email, comment, question1, question2, question3, question4, url);
//    }

//    public boolean checkEmailExists(String email) {
//        return clientRepository.existsByEmail(email);
//    }

}
