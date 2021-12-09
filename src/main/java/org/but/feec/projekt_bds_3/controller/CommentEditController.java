package org.but.feec.projekt_bds_3.controller;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.TextField;
import javafx.stage.Stage;
import org.but.feec.projekt_bds_3.api.CommentView;
import org.but.feec.projekt_bds_3.data.LessonCommentsRepository;

import java.util.ArrayList;

public class CommentEditController {
    private LessonController parentController;
    private ArrayList<CommentView> comments = new ArrayList<>();
    private int idx;

    @FXML
    private TextField commentField;

    @FXML
    void handleCancel(ActionEvent event) {
        ((Stage)commentField.getScene().getWindow()).close();
    }

    @FXML
    void handleOk(ActionEvent event) {
        String text = commentField.getText();
        comments.get(idx).setText(text);
        parentController.setAllComments(comments);
        (new LessonCommentsRepository()).editComment(comments.get(idx).getId(), text);
        parentController.getComments().refresh();
        ((Stage)commentField.getScene().getWindow()).close();
    }

    @FXML
    public void initialize() {}
    public void initData(LessonController lc, int idx) {
        parentController = lc;
        comments = lc.getCommentsArr();
        this.idx = idx;
        commentField.setText(comments.get(idx).getText());
    }
}
