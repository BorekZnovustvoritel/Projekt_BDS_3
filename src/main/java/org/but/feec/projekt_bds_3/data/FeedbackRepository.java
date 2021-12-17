package org.but.feec.projekt_bds_3.data;

import org.but.feec.projekt_bds_3.App;
import org.but.feec.projekt_bds_3.config.DataSourceConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class FeedbackRepository {
    private  static final Logger logger = LoggerFactory.getLogger(FeedbackRepository.class);
    public void submitFeedback(String feedback) {
        try (Connection connection = DataSourceConfig.getConnection();
             Statement stmt = connection.createStatement())
        {
            String query = String.format("INSERT INTO project.feedback (user_id, feedback) " +
                    "VALUES (%d, '%s');", App.userId, feedback);
            logger.info(String.format("User %d submitted feedback: '%s'.\nUsed query: %s", App.userId, feedback, query));
            stmt.execute(query);
        }
        catch (SQLException e) {
            logger.error(String.format("User %d failed to submit a query.\nError message: %s", App.userId, e.getMessage()));
        }
    }
    public String getLastFeedback() {
        try (Connection connection = DataSourceConfig.getConnection();
             Statement stmt = connection.createStatement())
        {
            String query = String.format("SELECT feedback FROM project.feedback " +
                    "WHERE user_id = %d AND id = (SELECT MAX(id) FROM project.feedback " +
                    "WHERE user_id = %d)", App.userId, App.userId);
            ResultSet rs = stmt.executeQuery(query);
            if (rs.next()) {
                return rs.getString("feedback");
            }
            return "No feedback provided";
        }
        catch (SQLException e) {
            logger.error(String.format("Failed to retrieve last feedback.\nError message: %s", e.getMessage()));
        }
        return null;
    }
    public ArrayList<String> getSearchedFeedback(String text) {
        try (Connection connection = DataSourceConfig.getConnection();
             Statement stmt = connection.createStatement())
        {
            String query = String.format("SELECT f.feedback FROM project.feedback f " +
                    "WHERE f.feedback like '%s' AND user_id = %d ", "%"+text+"%", App.userId);
            logger.info(String.format("User searched for feedbacks using a query: %s", query));
            ResultSet rs = stmt.executeQuery(query);
            ArrayList<String> ans = new ArrayList<>();
            while (rs.next()) {
                ans.add(rs.getString("feedback"));
            }
            if (ans.isEmpty()) ans.add("Nothing found.");
            return ans;
        }
        catch (SQLException e) {
            logger.error(String.format("Failed to retrieve searched feedbacks.\nError message: %s", e.getMessage()));
        }
        return null;
    }
}
