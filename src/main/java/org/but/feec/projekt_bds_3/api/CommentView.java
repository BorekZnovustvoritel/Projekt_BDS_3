package org.but.feec.projekt_bds_3.api;

import javafx.beans.property.IntegerProperty;
import javafx.beans.property.SimpleIntegerProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;

public class CommentView {
    private IntegerProperty userId = new SimpleIntegerProperty();
    private IntegerProperty id = new SimpleIntegerProperty();
    private StringProperty username = new SimpleStringProperty();
    private StringProperty text = new SimpleStringProperty();

    public int getUserId() {
        return userId.get();
    }

    public void setUserId(int userId) {
        this.userId.set(userId);
    }

    public int getId() {
        return id.get();
    }

    public void setId(int id) {
        this.id.set(id);
    }

    public String getUsername() {
        return username.get();
    }

    public void setUsername(String username) {
        this.username.set(username);
    }

    public String getText() {
        return text.get();
    }

    public void setText(String text) {
        this.text.set(text);
    }
}
