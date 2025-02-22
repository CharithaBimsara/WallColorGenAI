package com.example.nexa.repository;

import com.example.nexa.dto.ClientDTO;
import com.example.nexa.entity.Client;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
public interface ClientRepository extends JpaRepository<Client, Long> {

    @Transactional
    @Query(value = "SELECT * FROM client WHERE email = ?1 AND password = ?2", nativeQuery = true)
    Client getClientByClientEmailAndPassword(@Param("email") String email, @Param("password") String password);
    Client findByEmail(String email);
    boolean existsByEmail(String email);

//    //get name too
//    @Transactional
//    @Query(value = "SELECT new com.example.ClientDTO(c.email, c.birthDate, c.feedbackAnswer1, c.feedbackAnswer2, c.feedbackAnswer3, c.feedbackAnswer4, c.feedbackComment, c.feedbackImageUrl, c.gender, c.password, c.userGroup, cn.fname, cn.lname) FROM client c LEFT JOIN client_name cn ON c.email = cn.email WHERE c.email = ?1 AND c.password = ?2")
//    ClientDTO getClientByClientEmailAndPassword(@Param("email") String email, @Param("password") String password);


    //feedback save
//    @Query(value = "INSERT INTO feedback (email, comment, s3url, question1, question2, question3, question4) VALUES (:email, :comment, :s3url, :question1, :question2, :question3, :question4)", nativeQuery = true)
//    void insertFeedback(@Param("email") String email, @Param("comment") String comment, @Param("question1") String question1, @Param("question2") String question2, @Param("question3") String question3, @Param("question4") String question4, @Param("s3url") String s3url);

    //Feedback save new
//    @Modifying
//    @Query(value = "UPDATE client SET feedback_comment = :feedbackComment, feedback_answer1 = :question1, feedback_answer2 = :question2, feedback_answer3 = :question3, feedback_answer4 = :question4, feedback_image_url = :s3url WHERE email = :email", nativeQuery = true)
//    void insertFeedback(@Param("email") String email, @Param("feedbackComment") String comment, @Param("question1") String question1, @Param("question2") String question2, @Param("question3") String question3, @Param("question4") String question4, @Param("s3url") String s3url);

//    @Modifying
//    @Query(value = "UPDATE client SET feedback_comment = :feedbackComment, feedback_answer1 = :feedback_answer1, feedback_answer2 = :feedback_answer2, feedback_answer3 = :feedback_answer3, feedback_answer4 = :feedback_answer4, feedback_image_url = :feedback_image_url WHERE email = :email", nativeQuery = true)
//    void insertFeedback(@Param("email") String email, @Param("feedbackComment") String comment, @Param("feedback_answer1") String question1, @Param("feedback_answer2") String question2, @Param("feedback_answer3") String question3, @Param("feedback_answer4") String question4, @Param("feedback_image_url") String s3url);

//    @Modifying
//    @Query(value = "UPDATE client SET feedback_comment = :feedbackComment, feedback_answer1 = :feedback_answer1, feedback_answer2 = :feedback_answer2, feedback_answer3 = :feedback_answer3, feedback_answer4 = :feedback_answer4, feedback_image_url = :feedback_image_url WHERE email = :email", nativeQuery = true)
//    void insertFeedback( @Param("feedbackComment") String comment, @Param("feedback_answer1") String question1, @Param("feedback_answer2") String question2, @Param("feedback_answer3") String question3, @Param("feedback_answer4") String question4, @Param("feedback_image_url") String s3url,@Param("email") String email);
//    @Modifying
//    @Query(value = "UPDATE client SET feedback_answer1 = :feedback_answer1, feedback_answer2 = :feedback_answer2, feedback_answer3 = :feedback_answer3, feedback_answer4 = :feedback_answer4, feedback_comment = :feedbackComment, feedback_image_url = :feedback_image_url WHERE email = :email", nativeQuery = true)
//    void insertFeedback(@Param("feedback_answer1") String question1, @Param("feedback_answer2") String question2, @Param("feedback_answer3") String question3, @Param("feedback_answer4") String question4, @Param("feedbackComment") String comment, @Param("feedback_image_url") String s3url,@Param("email") String email);

    @Modifying
    @Query(value = "UPDATE client SET feedback_answer1 = :feedback_answer1, feedback_answer2 = :feedback_answer2, feedback_answer3 = :feedback_answer3, feedback_answer4 = :feedback_answer4, feedback_comment = :feedbackComment, feedback_image_url = :feedback_image_url WHERE email = :email", nativeQuery = true)
    void insertFeedback(@Param("feedback_answer1") String question1, @Param("feedback_answer2") String question2, @Param("feedback_answer3") String question3, @Param("feedback_answer4") String question4, @Param("feedbackComment") String comment, @Param("feedback_image_url") String s3url,@Param("email") String email);


//    @Query(value = "SELECT COUNT(*) > 0 FROM client WHERE email = ?1", nativeQuery = true)
//    boolean existsByEmail(String email);
}
