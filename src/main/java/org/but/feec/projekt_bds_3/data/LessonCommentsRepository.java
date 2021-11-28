package org.but.feec.projekt_bds_3.data;


import org.but.feec.projekt_bds_3.App;
import org.but.feec.projekt_bds_3.api.CommentView;
import org.but.feec.projekt_bds_3.config.DataSourceConfig;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class LessonCommentsRepository {
    public ArrayList<CommentView> findComments(int lessonId) {
        try (Connection connection = DataSourceConfig.getConnection();
                PreparedStatement prpstmt = connection.prepareStatement(
                        "SELECT c.id, u.first_name || ' ' || u.last_name AS username, c.text " +
                "FROM project.user u RIGHT JOIN project.comments c " +
                "ON u.id = c.user_id " +
                "WHERE c.lesson_id = ?;"
        )) {
            prpstmt.setInt(1, lessonId);
            ResultSet rs = prpstmt.executeQuery();
            ArrayList<CommentView> comments = new ArrayList<>();
            while (rs.next()) {
                CommentView temp = new CommentView();
                temp.setId(rs.getInt("id"));
                temp.setUsername(rs.getString("username"));
                temp.setText(rs.getString("text"));
                comments.add(temp);
            }
            return comments;
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
        return new ArrayList<>();
    }
    public boolean sendComment(int lessonId, String text) {
        try (Connection connection = DataSourceConfig.getConnection();
        PreparedStatement prpstmt = connection.prepareStatement(
                "INSERT INTO project.comments " +
                        "(lesson_id, user_id, text) VALUES " +
                        "(?, ?, ?);"
        )) {
            prpstmt.setInt(1, lessonId);
            prpstmt.setInt(2, App.userId);
            prpstmt.setString(3, text);
            prpstmt.executeUpdate();
            return true;
        }
        catch (SQLException e) {
            e.printStackTrace();
            //TODO
        }
        return false;
    }
    public boolean completeLesson(int lessonId) {
        try (Connection connection = DataSourceConfig.getConnection();
        PreparedStatement prpstmt = connection.prepareStatement(
                "INSERT INTO project.completed_lessons " +
                        "(user_id, lesson_id, \"timestamp\") VALUES " +
                        "(?, ?, NOW());"
        )) {
            prpstmt.setInt(1, App.userId);
            prpstmt.setInt(2, lessonId);
            prpstmt.executeUpdate();
            return true;
        }
        catch (SQLException e) {
            e.printStackTrace();
            //TODO
        }
        return false;
    }
    public boolean registerCourse(int courseId) {
        try (Connection connection = DataSourceConfig.getConnection();
             PreparedStatement prpstmt = connection.prepareStatement(
                     "INSERT INTO project.user_course " +
                             "(user_id, course_id) VALUES " +
                             "(?, ?);"
             )) {
            prpstmt.setInt(1, App.userId);
            prpstmt.setInt(2, courseId);
            prpstmt.executeUpdate();
            return true;
        }
        catch (SQLException e) {
            e.printStackTrace();
            //TODO
        }
        return false;
    }
}