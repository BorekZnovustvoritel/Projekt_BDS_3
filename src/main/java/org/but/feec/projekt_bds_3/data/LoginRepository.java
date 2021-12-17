package org.but.feec.projekt_bds_3.data;

import at.favre.lib.crypto.bcrypt.BCrypt;
import org.but.feec.projekt_bds_3.App;
import org.but.feec.projekt_bds_3.api.LoginView;
import org.but.feec.projekt_bds_3.config.DataSourceConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class LoginRepository {
    private static final Logger logger = LoggerFactory.getLogger(LoginRepository.class);
    private LoginView getLoginView(String email) {
        try (Connection connection = DataSourceConfig.getConnection();
             PreparedStatement prpstmt = connection.prepareStatement(
                     "SELECT id, email, password FROM project.\"user\" WHERE email = ?;"
             )) {
            prpstmt.setString(1, email);
            try (ResultSet rs = prpstmt.executeQuery()) {
            if (rs.next()) {
                return mapToLoginView(rs);
                }
            }
        }
        catch (SQLException e) {
            logger.error(String.format("Couldn't get login view!\nMeassage: %s", e.getMessage()));
        }
        return null;
    }
    private LoginView mapToLoginView(ResultSet rs) throws SQLException{
        LoginView lw = new LoginView();
        lw.setEmail(rs.getString("email"));
        lw.setHashedPwd(rs.getString("password"));
        App.userId = rs.getInt("id");
        return lw;
    }

    public boolean login(String email, String password) {
        LoginView lw = getLoginView(email);
        if (lw != null) {
            return BCrypt.verifyer().verify(password.toCharArray(), lw.getHashedPwd()).verified;
        } //logging is logged in LoginController class.
        return false;
    }
}

