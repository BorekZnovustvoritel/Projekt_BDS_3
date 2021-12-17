package org.but.feec.projekt_bds_3;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.layout.AnchorPane;
import javafx.stage.Stage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class App extends Application {
    private FXMLLoader floader;
    private AnchorPane mainStage;
    public static int userId;
    private static final Logger logger = LoggerFactory.getLogger(App.class);

    public static void main(String[] args) {launch(args); }

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
            logger.info("Application started.");
        }
        catch (Exception e) {
            e.printStackTrace();
            logger.error("Exception in method start: " + e.getMessage());
            return;
        }
    }
}
