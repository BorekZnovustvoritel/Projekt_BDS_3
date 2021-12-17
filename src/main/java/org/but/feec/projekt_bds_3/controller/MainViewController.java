package org.but.feec.projekt_bds_3.controller;

import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.stage.Stage;
import org.but.feec.projekt_bds_3.App;
import org.but.feec.projekt_bds_3.api.CourseView;
import org.but.feec.projekt_bds_3.data.CourseRepository;
import org.but.feec.projekt_bds_3.data.FeedbackRepository;
import org.controlsfx.validation.ValidationSupport;
import org.controlsfx.validation.Validator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.awt.event.MouseEvent;
import java.io.IOException;

public class MainViewController {
    private static final Logger logger = LoggerFactory.getLogger(MainViewController.class);
    CourseRepository cr = new CourseRepository();

    @FXML
    private RadioButton lastFRadioButton;

    @FXML
    private RadioButton searchFRadioButton;

    @FXML
    private Button searchButton;

    @FXML
    private TextField searchField;

    @FXML
    private TextField feedbackTextField;

    @FXML
    private Label feedbackTitleLabel;

    @FXML
    private Label feedbackLabel;

    @FXML
    private TableView<CourseView> courseTable;

    @FXML
    private TableColumn<CourseView, String> courseNameColumn;

    @FXML
    private TableColumn<CourseView, Boolean> registeredColumn;

    @FXML
    private TableColumn<CourseView, String> nextLessonColumn;

    @FXML
    private TableColumn<CourseView, Float> progressColumn;


    @FXML
    public void initialize() {
        courseNameColumn.setCellValueFactory(new PropertyValueFactory<CourseView, String>("name"));
        registeredColumn.setCellValueFactory(new PropertyValueFactory<CourseView, Boolean>("userHasIt"));
        progressColumn.setCellValueFactory(new PropertyValueFactory<CourseView, Float>("progress"));
        nextLessonColumn.setCellValueFactory(new PropertyValueFactory<CourseView, String>("nextLesson"));

        ObservableList<CourseView> obsCList = cr.findCourses();
        courseTable.setItems(obsCList);
        registeredColumn.setSortType(TableColumn.SortType.DESCENDING);
        courseTable.getSortOrder().add(registeredColumn);

        feedbackLabel.setText((new FeedbackRepository()).getLastFeedback());
        searchButton.setDisable(true);
        searchField.setDisable(true);
    }
    @FXML
    public void handleRowSelect() {
        CourseView row = courseTable.getSelectionModel().getSelectedItem();
        if (row == null) return;
        try {
            FXMLLoader loader = new FXMLLoader();
            loader.setLocation(App.class.getResource("fxml/Course.fxml"));
            Scene scene = new Scene(loader.load(), 330, 400);
            Stage stage = new Stage();
            stage.setTitle(row.getName());
            stage.setScene(scene);
            CourseController controller = loader.getController();
            controller.initData(row, this);
            //Stage stageOld = (Stage) courseTable.getScene().getWindow();
            //stageOld.close();

            stage.show();
        }
        catch (IOException e) {
            e.printStackTrace();
            logger.error("Couldn't open Course window!");
        }
    }

    @FXML
    void handleSendFeedback(ActionEvent event) {
        String feedback = feedbackTextField.getText();
        feedbackTextField.setText("");
        FeedbackRepository rep = new FeedbackRepository();
        rep.submitFeedback(feedback);
        feedbackLabel.setText(rep.getLastFeedback());
        logger.info(String.format("'%s' entered into feedback textfield.", feedback));
    }

    @FXML
    void handleSearch(ActionEvent event) {
        String text = searchField.getText();
        String feedbacks = "";
        for (String feedback : (new FeedbackRepository()).getSearchedFeedback(text)) {
            feedbacks = feedbacks + "\n" + feedback;
        }
        feedbackLabel.setText(feedbacks);
        logger.info(String.format("'%s' entered into feedback searchfield.", text));
    }

    @FXML
    void handleSwitchRadioB(ActionEvent event) {
        if (lastFRadioButton.isSelected()) {
            searchButton.setDisable(true);
            feedbackTitleLabel.setText("Your last feedback: ");
            feedbackLabel.setText((new FeedbackRepository()).getLastFeedback());
            searchField.setDisable(true);
        }
        else {
            searchButton.setDisable(false);
            feedbackTitleLabel.setText("Searched feedbacks: ");
            searchField.setDisable(false);
        }
    }

    public void refreshAll() {
        ObservableList<CourseView> obsCList = cr.findCourses();
        courseTable.getItems().clear();
        courseTable.setItems(obsCList);
    }


}
