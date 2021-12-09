package org.but.feec.projekt_bds_3.controller;

import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.image.ImageView;
import javafx.scene.input.KeyCode;
import javafx.stage.Stage;
import javafx.util.Duration;
import org.but.feec.projekt_bds_3.App;
import org.but.feec.projekt_bds_3.data.LoginRepository;
import org.controlsfx.validation.ValidationSupport;
import org.controlsfx.validation.Validator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import javafx.fxml.FXML;

import java.io.IOException;
import java.util.Optional;


public class LoginController {
    private static final Logger logger = LoggerFactory.getLogger(LoginController.class);

    @FXML
    private TextField emailField;

    @FXML
    private Button loginButton;

    @FXML
    private PasswordField passwordField;

    private LoginRepository lr;

    @FXML
    private void initialize() {
        lr = new LoginRepository();
        passwordField.setOnKeyPressed(event -> {
            if (event.getCode() == KeyCode.ENTER) {
                handleSignIn();
            }
        });
        ValidationSupport validation = new ValidationSupport();
        validation.registerValidator(emailField, Validator.createEmptyValidator("Email must not be empty"));
        validation.registerValidator(passwordField, Validator.createEmptyValidator("The password must not be empty"));
        loginButton.disableProperty().bind(validation.invalidProperty());

        loginButton.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent actionEvent) {
                handleSignIn();
            }
        });

        logger.info("LoginController initialized");
    }
    private void handleSignIn() {
        String email = emailField.getText();
        String password = passwordField.getText();
        if (lr.login(email, password)) {
            logger.info("User " + email + " logged in!");
            handleGoodLogin();
        }
        else {
            showBadLogin();
            logger.info("Bad login attempt with email " +email + ".");
        }
    }
    private void showBadLogin() {
        Alert alert = new Alert(Alert.AlertType.ERROR);
        alert.setTitle("Wrong credentials");
        alert.setHeaderText("Wrong login or password!");
        alert.showAndWait();
    }
    private void handleGoodLogin() {
        try {
            FXMLLoader fxmlLoader = new FXMLLoader();
            fxmlLoader.setLocation(App.class.getResource("fxml/Main.fxml"));
            Scene scene = new Scene(fxmlLoader.load(), 614, 350);
            Stage stage = new Stage();
            stage.setTitle("Your courses");
            stage.setScene(scene);

            Stage stageOld = (Stage) loginButton.getScene().getWindow();
            stageOld.close();

            stage.show();
        }
        catch (IOException e) {
            e.printStackTrace();
            //TODO
        }

        Alert alert = new Alert(Alert.AlertType.CONFIRMATION);
        alert.setTitle("Login successful");
        alert.setHeaderText("Login successful!");
        alert.setContentText("You may proceed to the application now.");

        Timeline idlestage = new Timeline(new KeyFrame(Duration.seconds(3), new EventHandler<ActionEvent>() {

            @Override
            public void handle(ActionEvent event) {
                alert.setResult(ButtonType.CANCEL);
                alert.hide();
            }
        }));
        idlestage.setCycleCount(1);
        idlestage.play();

        /*Optional<ButtonType> result = alert.showAndWait();

        if (result.get() == ButtonType.OK) {
            System.out.println("ok clicked");
        } else if (result.get() == ButtonType.CANCEL) {
            System.out.println("cancel clicked");
        }*/
    }
}
