package org.but.feec.projekt_bds_3.data;


import org.but.feec.projekt_bds_3.App;
import org.but.feec.projekt_bds_3.api.CommentView;
import org.but.feec.projekt_bds_3.config.DataSourceConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.lang.model.type.UnionType;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class LessonCommentsRepository {
    private  static final Logger logger = LoggerFactory.getLogger(LessonCommentsRepository.class);
    public ArrayList<CommentView> findComments(int lessonId, boolean filterUserComments) {
        String query = "";
        if (filterUserComments) {
            query = "SELECT c.user_id, c.id, u.first_name || ' ' || u.last_name AS username, c.text " +
                "FROM project.user u RIGHT JOIN project.comments c " +
                "ON u.id = c.user_id " +
                "WHERE c.lesson_id = ? AND c.user_id = ?;";
        }
        else {
            query = "SELECT c.user_id, c.id, u.first_name || ' ' || u.last_name AS username, c.text " +
                    "FROM project.user u RIGHT JOIN project.comments c " +
                    "ON u.id = c.user_id " +
                    "WHERE c.lesson_id = ?;";
        }
        try (Connection connection = DataSourceConfig.getConnection();
                PreparedStatement prpstmt = connection.prepareStatement(query)) {
            prpstmt.setInt(1, lessonId);
            if (filterUserComments) {
                prpstmt.setInt(2, App.userId);
            }
            ResultSet rs = prpstmt.executeQuery();
            ArrayList<CommentView> comments = new ArrayList<>();
            while (rs.next()) {
                CommentView temp = new CommentView();
                temp.setUserId(rs.getInt("user_id"));
                temp.setId(rs.getInt("id"));
                temp.setUsername(rs.getString("username"));
                temp.setText(rs.getString("text"));
                comments.add(temp);
            }
            return comments;
        }
        catch (SQLException e) {
            logger.error(String.format("Couldn't find commets!\nMessage: %s", e.getMessage()));
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
            logger.error(String.format(" User %d couldn't send commets!\nMessage: %s", App.userId, e.getMessage()));
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
            logger.error(String.format("User %d couldn't mark lesson %d as completed!\nMessage: %s", App.userId, lessonId, e.getMessage()));
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
            logger.error(String.format("User %d couldn't register course %d!\nMessage: %s", App.userId, courseId, e.getMessage()));
        }
        return false;
    }
    public boolean removeComment(int id) {
        try (Connection connection = DataSourceConfig.getConnection();
             PreparedStatement prpstmt = connection.prepareStatement(
                     "DELETE FROM project.comments " +
                             "WHERE id = ?;"
             )) {
            prpstmt.setInt(1, id);
            prpstmt.executeUpdate();
            return true;
        }
        catch (SQLException e) {
            logger.error(String.format("User %d couldn't remove comment %d!", App.userId, id));
        }
        return false;
    }
    public boolean editComment(int id, String text) {
        Connection connection = null;
        try {
            connection = DataSourceConfig.getConnection();
            connection.setAutoCommit(false);
            PreparedStatement findLesson = connection.prepareStatement(
                    "SELECT lesson_id FROM project.comments WHERE id=? AND user_id=?;"
            );
            PreparedStatement prpstmt = connection.prepareStatement(
                    "UPDATE project.comments SET text=? " +
                            "WHERE id = ?;"
            );
            findLesson.setInt(1, id);
            findLesson.setInt(2, App.userId);
            ResultSet lessonId = findLesson.executeQuery();
            if (!lessonId.next()) {
                logger.warn(String.format("User %d tried to edit comment %d without a permission!", App.userId, id));
                throw new SQLException("You have no rights to edit this");
            }
            prpstmt.setString(1, text);
            prpstmt.setInt(2, id);
            prpstmt.executeUpdate();
            connection.commit();

            return true;
        }
        catch (SQLException e) {
            try {
                connection.rollback();
            } catch (Exception ex) {
                logger.error(String.format("Couldn't rollback transaction!"));
            }
            logger.error(String.format("Something went wrong while user %d tried to edit comment %d!\n Message: %s", App.userId, id, e.getMessage()));
        }
        return false;
    }
}
