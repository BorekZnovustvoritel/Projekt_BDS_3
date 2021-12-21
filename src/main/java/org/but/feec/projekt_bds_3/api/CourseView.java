package org.but.feec.projekt_bds_3.api;

import javafx.beans.property.*;

public class CourseView {
    private IntegerProperty id = new SimpleIntegerProperty();
    private StringProperty name = new SimpleStringProperty();
    private StringProperty description = new SimpleStringProperty();
    private BooleanProperty userHasIt = new SimpleBooleanProperty();
    private StringProperty progress = new SimpleStringProperty();
    private StringProperty nextLesson = new SimpleStringProperty();

    public int getId() {
        return id.get();
    }
    public void setId(int id) {
        this.id.setValue(id);
    }
    public String getName() {
        return this.name.get();
    }
    public void setName(String name) {
        this.name.setValue(name);
    }
    public String getDescription() {
        return  this.description.get();
    }
    public void setDescription(String description) {
        this.description.setValue(description);
    }
    public boolean getUserHasIt() {
        return this.userHasIt.get();
    }
    public void setUserHasIt(boolean userHasIt) {
        this.userHasIt.setValue(userHasIt);
    }
    public String getProgress() {
        return progress.get();
    }
    public void setProgress(String progress) {
        this.progress.setValue(progress);
    }
    public String getNextLesson() {
        return this.nextLesson.get();
    }
    public void setNextLesson(String link) {
        this.nextLesson.setValue(link);
    }

    @Override
    public String toString() {
        return "CourseView{" +
                "id=" + id +
                ", name=" + name +
                ", description=" + description +
                ", userHasIt=" + userHasIt +
                ", progress=" + progress +
                ", nextLesson=" + nextLesson +
                '}';
    }
}
