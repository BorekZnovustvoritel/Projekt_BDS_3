package org.but.feec.projekt_bds_3.controller;

import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import org.but.feec.projekt_bds_3.api.CourseView;
import org.but.feec.projekt_bds_3.data.CourseRepository;

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
}
