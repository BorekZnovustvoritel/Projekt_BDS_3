package org.but.feec.projekt_bds_3.data;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import org.but.feec.projekt_bds_3.App;
import org.but.feec.projekt_bds_3.api.LessonView;
import org.but.feec.projekt_bds_3.config.DataSourceConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class CourseDetailRepository {
    private int courseId;
    private final static Logger logger = LoggerFactory.getLogger(CourseDetailRepository.class);

    public CourseDetailRepository(int courseId) {
        this.courseId = courseId;
    }

    public ArrayList<LessonView> getUncompletedLessons() {
        try(Connection connection = DataSourceConfig.getConnection();
            PreparedStatement prpstmt = connection.prepareStatement(
                    "SELECT id, name, link FROM project.lesson WHERE course_id = ? AND id NOT IN " +
                            "(SELECT lesson_id FROM project.completed_lessons WHERE user_id = ?) ORDER BY id;"
            )) {
            prpstmt.setInt(1, courseId);
            prpstmt.setInt(2, App.userId);
            ResultSet rs = prpstmt.executeQuery();
            return mapToLessonView(rs, false);
        }
        catch (SQLException e) {
            e.printStackTrace();
            logger.error("Fetching uncompleted lessons from the db failed!\nMessage: "+e.getMessage());
        }
        return null;
    }
    public ArrayList<LessonView> getCompletedLessons() {
        try(Connection connection = DataSourceConfig.getConnection();
            PreparedStatement prpstmt = connection.prepareStatement(
                    "SELECT l.id, l.name, l.link FROM project.lesson l " +
                            "RIGHT JOIN project.completed_lessons cl " +
                            "ON l.id = cl.lesson_id WHERE l.course_id = ? " +
                            "AND cl.user_id = ?"
            )) {
            prpstmt.setInt(1, courseId);
            prpstmt.setInt(2, App.userId);
            ResultSet rs = prpstmt.executeQuery();
            return mapToLessonView(rs, true);
        }
        catch (SQLException e) {
            logger.error("Fetching completed lessons from the db failed!\nMessage: "+e.getMessage());
        }
        return null;
    }
    private ArrayList<LessonView> mapToLessonView(ResultSet rs, boolean completed) throws SQLException {
        ArrayList<LessonView> arr = new ArrayList<>();
        while (rs.next()) {
            LessonView temp = new LessonView();
            temp.setId(rs.getInt("id"));
            temp.setName(rs.getString("name"));
            temp.setLink(rs.getString("link"));
            temp.setCompleted(completed);
            arr.add(temp);
        }
        return arr;
    }
}
