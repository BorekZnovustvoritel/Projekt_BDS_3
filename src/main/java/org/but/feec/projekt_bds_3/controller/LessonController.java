package org.but.feec.projekt_bds_3.controller;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.ListView;
import javafx.scene.control.TextField;
import javafx.stage.Stage;
import javafx.stage.Window;
import org.but.feec.projekt_bds_3.api.CommentView;
import org.but.feec.projekt_bds_3.api.CourseView;
import org.but.feec.projekt_bds_3.api.LessonView;
import org.but.feec.projekt_bds_3.data.LessonCommentsRepository;

import java.util.ArrayList;
import java.util.Objects;

public class LessonController {
    private LessonView lv;
    private CourseView courseView;
    @FXML
    private TextField commentTextField;

    @FXML
    private ListView<String> comments;
    private ArrayList<CommentView> commentsArr;

    @FXML
    private Button completeButton;

    @FXML
    private Label lessonName;

    @FXML
    private Label lessonUrl;

    @FXML
    private Button sendCommentButton;

    @FXML
    private Button backButton;

    @FXML
    void handleCompleteLesson(ActionEvent event) {
        LessonCommentsRepository comrep = new LessonCommentsRepository();
        comrep.completeLesson(lv.getId());
        disableCompleteButton();
        lv.setCompleted(true);
        if (!courseView.getUserHasIt()) {
            courseView.setUserHasIt(true);
            comrep.registerCourse(courseView.getId());
        }
    }

    @FXML
    void handleSendComment(ActionEvent event) {
        String text = commentTextField.getText();
        if (Objects.equals(text, "")) return;
        LessonCommentsRepository comrep = new LessonCommentsRepository();
        if (comrep.sendComment(lv.getId(), text)) {
            System.out.println("Nahráno.");
            //TODO
        }
        else System.out.println("Ded");

        loadComments();
    }
    @FXML
    void handleGoBack(ActionEvent event) {
        Stage stage = (Stage) backButton.getScene().getWindow();
        stage.close();
    }
    @FXML
    public void initialize() {}
    public void initData(LessonView lv, CourseView cv) {
        this.courseView = cv;
        this.lv = lv;
        lessonName.setText(lv.getName());
        lessonUrl.setText(lv.getLink());
        loadComments();
        if (lv.isCompleted()) {
            disableCompleteButton();
        }
    }
    private void loadComments() {
        LessonCommentsRepository comrep = new LessonCommentsRepository();
        comments.getItems().clear();
        commentsArr = comrep.findComments(lv.getId());
        if (!commentsArr.isEmpty()) {
            for (CommentView com : commentsArr) {
                comments.getItems().add(com.getUsername() + ":\n" + com.getText());
            }
        }
        comments.refresh();
    }
    private void disableCompleteButton() {
        completeButton.setDisable(true);
        completeButton.setText("Already Completed");
    }
}
