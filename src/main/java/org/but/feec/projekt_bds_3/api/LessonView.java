package org.but.feec.projekt_bds_3.api;

import javafx.beans.property.*;

import java.util.ArrayList;

public class LessonView {
    public int getId() {
        return id.get();
    }
    public String getName() {
        return name.get();
    }
    public String getLink() {
        return link.get();
    }
    public void setId(int id) {
        this.id.set(id);
    }
    public void setName(String name) {
        this.name.set(name);
    }
    public void setLink(String link) {
        this.link.set(link);
    }
    public void setCompleted(boolean completed) {this.completed.set(completed);}
    public boolean isCompleted() {return completed.get();}

    private IntegerProperty id = new SimpleIntegerProperty();
    private StringProperty name = new SimpleStringProperty();
    private StringProperty link = new SimpleStringProperty();
    private BooleanProperty completed = new SimpleBooleanProperty();

    @Override
    public String toString() {
        return "LessonView{" +
                "id=" + id +
                ", name=" + name +
                ", link=" + link +
                ", completed=" + completed +
                '}';
    }
}
