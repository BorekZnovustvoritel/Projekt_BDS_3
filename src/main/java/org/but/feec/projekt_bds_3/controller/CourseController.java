package org.but.feec.projekt_bds_3.controller;

import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.JavaFXBuilderFactory;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.ListView;
import javafx.scene.control.ProgressBar;
import javafx.scene.layout.AnchorPane;
import javafx.stage.Stage;
import org.but.feec.projekt_bds_3.App;
import org.but.feec.projekt_bds_3.api.CourseView;
import org.but.feec.projekt_bds_3.api.LessonView;
import org.but.feec.projekt_bds_3.data.CourseDetailRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.ArrayList;

public class CourseController {
    private static final Logger logger = LoggerFactory.getLogger(CourseController.class);
    private CourseView cv;
    private MainViewController parentController;

    @FXML
    private ListView<String> completed;
    private ArrayList<LessonView> completedArr;

    @FXML
    private ProgressBar progressbar;

    @FXML
    private ListView<String> uncompleted;
    private ArrayList<LessonView> uncompletedArr;

    @FXML
    private Button backButton;

    @FXML
    void handleGoBack(ActionEvent event) {
        Stage st = (Stage) backButton.getScene().getWindow();
        st.close();
    }

    @FXML
    public void initialize() {}

    public void initData(CourseView cv, MainViewController parentController) {
        this.parentController = parentController;
        this.cv = cv;
        loadAll();
    }

    public void handleUncompletedLessonClick(javafx.scene.input.MouseEvent mouseEvent) {
        int idx = uncompleted.getSelectionModel().getSelectedIndex();
        LessonView temp = uncompletedArr.get(idx);

        loadLesson(temp);
    }
    public void handleCompletedLessonClick(javafx.scene.input.MouseEvent mouseEvent) {
        int idx = completed.getSelectionModel().getSelectedIndex();
        LessonView temp = completedArr.get(idx);

        loadLesson(temp);
    }
    public void loadLesson(LessonView temp) {
        try {
            FXMLLoader loader = new FXMLLoader();
            loader.setLocation(App.class.getResource("fxml/Lesson.fxml"));
            Scene scene = new Scene(loader.load(), 1050, 600);
            Stage stage = new Stage();
            stage.setTitle(temp.getName());
            stage.setScene(scene);
            LessonController controller = loader.getController();
            controller.initData(temp, cv, this);
            stage.show();

        } catch (IOException e) {
            e.printStackTrace();
            logger.error("Loading lesson failed! "+e.getMessage());
        }
    }
    public void refreshAll() {
        completed.getItems().clear();
        uncompleted.getItems().clear();
        loadAll();
        parentController.refreshAll();
    }

    private void loadAll() {
        CourseDetailRepository rep = new CourseDetailRepository(cv.getId());
        completedArr = rep.getCompletedLessons();
        uncompletedArr = rep.getUncompletedLessons();
        completed.getItems().clear();
        for (LessonView lv : completedArr) {
            completed.getItems().add(lv.getName());
        }
        for (LessonView lv : uncompletedArr) {
            uncompleted.getItems().add(lv.getName());
        }
        float progress;
        try {
            progress = ((float)completedArr.size())/(completedArr.size()+uncompletedArr.size());
        }
        catch (ArithmeticException e) {
            progress = 0;
        }
        progressbar.setProgress(progress);
    }
}
