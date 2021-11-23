package org.but.feec.projekt_bds_3.api;

import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;

public class LoginView {
    private StringProperty email = new SimpleStringProperty();
    private StringProperty hashedPwd = new SimpleStringProperty();

    public String getEmail() {return this.email.get();}
    public void setEmail(String email) {this.email.setValue(email);}
    public String getHashedPwd() {return this.hashedPwd.get();}
    public void setHashedPwd(String hashedPwd) {this.hashedPwd.setValue(hashedPwd);}
}
