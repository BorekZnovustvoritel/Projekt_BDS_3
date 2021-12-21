package org.but.feec.projekt_bds_3.controller;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.TextField;
import javafx.stage.Stage;
import org.but.feec.projekt_bds_3.App;
import org.but.feec.projekt_bds_3.api.CommentView;
import org.but.feec.projekt_bds_3.data.LessonCommentsRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;

public class CommentEditController {
    private static final Logger logger = LoggerFactory.getLogger(CommentEditController.class);
    private LessonController parentController;
    private List<CommentView> comments = new ArrayList<>();
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
        logger.info(String.format("User %d edited comment %d", App.userId, idx));
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
