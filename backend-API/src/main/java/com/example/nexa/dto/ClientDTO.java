package com.example.nexa.dto;

public class ClientDTO {

    private String email;
    private String gender;
    private String birthDate;
    private String userGroup;
    private String password;
    private String feedbackComment;
    private String feedbackImageUrl;
    private String feedbackAnswer1;
    private String feedbackAnswer2;
    private String feedbackAnswer3;
    private String feedbackAnswer4;
    private String Fname;
    private String Lname;

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getBirthDate() {
        return birthDate;
    }
    public String getFname() {
        return Fname;
    }

    public void setFname(String fname) {
        Fname = fname;
    }

    public String getLname() {
        return Lname;
    }

    public void setLname(String lname) {
        Lname = lname;
    }
    public void setBirthDate(String birthDate) {
        this.birthDate = birthDate;
    }

    public String getUserGroup() {
        return userGroup;
    }

    public void setUserGroup(String userGroup) {
        this.userGroup = userGroup;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFeedbackComment() {
        return feedbackComment;
    }

    public void setFeedbackComment(String feedbackComment) {
        this.feedbackComment = feedbackComment;
    }

    public String getFeedbackImageUrl() {
        return feedbackImageUrl;
    }

    public void setFeedbackImageUrl(String feedbackImageUrl) {
        this.feedbackImageUrl = feedbackImageUrl;
    }

    public String getFeedbackAnswer1() {
        return feedbackAnswer1;
    }

    public void setFeedbackAnswer1(String feedbackAnswer1) {
        this.feedbackAnswer1 = feedbackAnswer1;
    }

    public String getFeedbackAnswer2() {
        return feedbackAnswer2;
    }

    public void setFeedbackAnswer2(String feedbackAnswer2) {
        this.feedbackAnswer2 = feedbackAnswer2;
    }

    public String getFeedbackAnswer3() {
        return feedbackAnswer3;
    }

    public void setFeedbackAnswer3(String feedbackAnswer3) {
        this.feedbackAnswer3 = feedbackAnswer3;
    }

    public String getFeedbackAnswer4() {
        return feedbackAnswer4;
    }

    public void setFeedbackAnswer4(String feedbackAnswer4) {
        this.feedbackAnswer4 = feedbackAnswer4;
    }
}
