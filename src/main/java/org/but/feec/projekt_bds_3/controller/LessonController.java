package org.but.feec.projekt_bds_3.controller;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.input.MouseEvent;
import javafx.stage.Stage;
import org.but.feec.projekt_bds_3.App;
import org.but.feec.projekt_bds_3.api.CommentView;
import org.but.feec.projekt_bds_3.api.CourseView;
import org.but.feec.projekt_bds_3.api.LessonView;
import org.but.feec.projekt_bds_3.data.LessonCommentsRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.List;
import java.util.Objects;

public class LessonController {
    private static final Logger logger = LoggerFactory.getLogger(LessonController.class);
    private CourseController parentController;
    private CommentView commentView = new CommentView();
    private LessonView lv;
    private CourseView courseView;
    @FXML
    private TextField commentTextField;

    @FXML
    private ListView<String> comments;
    private List<CommentView> commentsArr;

    ListView<String> getComments() {
        return comments;
    }
    List<CommentView> getCommentsArr() {
        return commentsArr;
    }

    @FXML
    private Button completeButton;

    @FXML
    private Button deleteCommentButton;

    @FXML
    private Button editCommentButton;

    @FXML
    private Label lessonName;

    @FXML
    private Label lessonUrl;

    @FXML
    private Button sendCommentButton;

    @FXML
    private Button backButton;

    @FXML
    private CheckBox checkBoxFilterUserComments;

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
        parentController.refreshAll();
        logger.info(String.format("User %d just finished lesson %d", App.userId, lv.getId()));
    }

    @FXML
    void handleSendComment(ActionEvent event) {
        String text = commentTextField.getText();
        if (Objects.equals(text, "")) return;
        LessonCommentsRepository comrep = new LessonCommentsRepository();
        if (comrep.sendComment(lv.getId(), text)) {
            System.out.println("Nahráno.");
            logger.info(String.format("User %d just submitted a comment to lesson %d.", App.userId, lv.getId()));
        }
        else
            logger.error(String.format("User %d failed to send a comment!", App.userId));

        loadComments();
    }
    @FXML
    void handleGoBack(ActionEvent event) {
        Stage stage = (Stage) backButton.getScene().getWindow();
        stage.close();
    }
    @FXML
    public void initialize() {}
    public void initData(LessonView lv, CourseView cv, CourseController parentController) {
        this.parentController = parentController;
        editCommentButton.setDisable(true);
        deleteCommentButton.setDisable(true);
        this.courseView = cv;
        this.lv = lv;
        lessonName.setText(lv.getName());
        lessonUrl.setText(lv.getLink());
        loadComments();
        if (lv.isCompleted()) {
            disableCompleteButton();
        }
    }

    @FXML
    void handleSelectComment(MouseEvent event) {
        int idx = comments.getSelectionModel().getSelectedIndex();
        if (idx != -1) {
            commentView = commentsArr.get(idx);
            if (commentView.getUserId() == App.userId) {
                editCommentButton.setDisable(false);
                deleteCommentButton.setDisable(false);
            } else {
                editCommentButton.setDisable(true);
                deleteCommentButton.setDisable(true);
            }
        }
    }

    @FXML
    private void handleDeleteComment() {
        comments.getItems().remove(comments.getSelectionModel().getSelectedIndex());
        commentsArr.remove(comments.getSelectionModel().getSelectedIndex());
        if ((new LessonCommentsRepository()).removeComment(commentView.getId())) {
            commentView = new CommentView();
            editCommentButton.setDisable(true);
            deleteCommentButton.setDisable(true);
            comments.refresh();
            logger.info(String.format("User %d removed a comment from lesson %d.", App.userId, lv.getId()));
        }
        else
            logger.error(String.format("User %d tried to remove a comment, but failed!", App.userId));
    }

    @FXML
    private void handleEditComment() {
        try {
            FXMLLoader loader = new FXMLLoader();
            loader.setLocation(App.class.getResource("fxml/CommentEdit.fxml"));
            Scene scene = new Scene(loader.load(), 600, 170);
            Stage stage = new Stage();
            stage.setTitle("Edit comment");
            stage.setScene(scene);
            CommentEditController controller = loader.getController();
            controller.initData(this, comments.getSelectionModel().getSelectedIndex());
            stage.show();
        } catch (IOException e) {

            e.printStackTrace();
            logger.error("Couldn't open comment editor window!");

        }
    }

    @FXML
    void handleCheckChanged(ActionEvent event) {
        loadComments();
    }

    private void loadComments() {
        LessonCommentsRepository comrep = new LessonCommentsRepository();
        comments.getItems().clear();
        commentsArr = comrep.findComments(lv.getId(), checkBoxFilterUserComments.isSelected());
        setAllComments(this.commentsArr);
        comments.refresh();
    }
    private void disableCompleteButton() {
        completeButton.setDisable(true);
        completeButton.setText("Already Completed");
    }
    void setAllComments(List<CommentView> commentsArr) {
        this.commentsArr = commentsArr;
        comments.getItems().clear();
        if (!commentsArr.isEmpty()) {
            for (CommentView com : commentsArr) {
                this.comments.getItems().add(com.getUsername() + ":\n" + com.getText());
            }
        }
    }
}
