package org.but.feec.projekt_bds_3;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.layout.AnchorPane;
import javafx.stage.Stage;
import org.but.feec.projekt_bds_3.api.CourseView;
import org.but.feec.projekt_bds_3.data.CourseRepository;

public class App extends Application {
    private FXMLLoader floader;
    private AnchorPane mainStage;
    public static int userId;

    public static void main(String[] args) {
        //System.out.println("User 1 has course of this ID:");
        //System.out.println(new CourseRepository().findCourses(1).getName());
        launch(args); }

    @Override
    public void start(Stage primaryStage) {
        try {
            floader = new FXMLLoader(getClass().getResource("App.fxml"));
            mainStage = floader.load();

            primaryStage.setTitle("Login Screen");
            Scene scene = new Scene(mainStage);
            setUserAgentStylesheet(STYLESHEET_MODENA);

            primaryStage.setScene(scene);
            primaryStage.show();
        }
        catch (Exception e) {
            System.out.println("Exception timee");
            e.printStackTrace();
            //TODO rework this
            return;
        }
    }
}
