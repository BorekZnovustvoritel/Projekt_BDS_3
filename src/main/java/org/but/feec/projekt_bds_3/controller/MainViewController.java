package org.but.feec.projekt_bds_3.controller;

import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.stage.Stage;
import org.but.feec.projekt_bds_3.App;
import org.but.feec.projekt_bds_3.api.CourseView;
import org.but.feec.projekt_bds_3.data.CourseRepository;

import java.awt.event.MouseEvent;
import java.io.IOException;

public class MainViewController {

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
        CourseRepository cr = new CourseRepository();

        courseNameColumn.setCellValueFactory(new PropertyValueFactory<CourseView, String>("name"));
        registeredColumn.setCellValueFactory(new PropertyValueFactory<CourseView, Boolean>("userHasIt"));
        progressColumn.setCellValueFactory(new PropertyValueFactory<CourseView, Float>("progress"));
        nextLessonColumn.setCellValueFactory(new PropertyValueFactory<CourseView, String>("nextLesson"));

        ObservableList<CourseView> obsCList = cr.findCourses();
        courseTable.setItems(obsCList);
        courseTable.getSortOrder().add(registeredColumn);

    }
    @FXML
    public void handleRowSelect() {
        CourseView row = courseTable.getSelectionModel().getSelectedItem();
        if (row == null) return;
        try {
            FXMLLoader loader = new FXMLLoader();
            loader.setLocation(App.class.getResource("fxml/Course.fxml"));
            Scene scene = new Scene(loader.load(), 1050, 600);
            Stage stage = new Stage();
            stage.setTitle(row.getName());
            stage.setScene(scene);
            CourseController controller = loader.getController();
            controller.initData(row);
            //Stage stageOld = (Stage) courseTable.getScene().getWindow();
            //stageOld.close();

            stage.show();
        }
        catch (IOException e) {
            e.printStackTrace();
            //TODO
        }
    }
}
