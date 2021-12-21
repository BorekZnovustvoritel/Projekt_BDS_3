package org.but.feec.projekt_bds_3.service;

import at.favre.lib.crypto.bcrypt.BCrypt;
import org.but.feec.projekt_bds_3.api.LoginView;
import org.but.feec.projekt_bds_3.controller.LoginController;
import org.but.feec.projekt_bds_3.data.LoginRepository;

public class LoginService {
    private LoginRepository loginRepository= new LoginRepository();
    public boolean login(String email, String password) {
        LoginView loginView = loginRepository.getLoginView(email);
        if (loginView != null) {
            return BCrypt.verifyer().verify(password.toCharArray(), loginView.getHashedPwd()).verified;
        } //logging is logged in LoginController class.
        return false;
    }
}
