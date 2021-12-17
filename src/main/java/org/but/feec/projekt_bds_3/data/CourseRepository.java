package org.but.feec.projekt_bds_3.data;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import org.but.feec.projekt_bds_3.App;
import org.but.feec.projekt_bds_3.api.CourseView;
import org.but.feec.projekt_bds_3.config.DataSourceConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;

public class CourseRepository {
    private static final Logger logger = LoggerFactory.getLogger(CourseRepository.class);
    public ObservableList<CourseView> findCourses() {
        try (Connection connection = DataSourceConfig.getConnection();
        PreparedStatement prpstmt = connection.prepareStatement(
                "SELECT c.id, c.name, c.description, u.user_id FROM project.course c " +
                        "LEFT JOIN (SELECT user_id, course_id FROM project.user_course WHERE user_id = ?) u " +
                        "ON u.course_id = c.id " +
                        "ORDER BY c.id;")
        ) {
            prpstmt.setInt(1, App.userId);
            return mapToCourseView(prpstmt, connection);
        } catch (SQLException e) {
            logger.error("Findig courses in db failed!\nMessage: "+e.getMessage());
        }
        return null;
    }

    private ObservableList<CourseView> mapToCourseView(PreparedStatement prpstmt, Connection connection) throws SQLException {
        ArrayList<CourseView> ans = new ArrayList<>();
        ResultSet rs = prpstmt.executeQuery();
        while (rs.next()) {
            CourseView course = new CourseView();
            int courseId = rs.getInt("id");
            course.setId(courseId);
            course.setName(rs.getString("name"));
            course.setDescription(rs.getString("description"));
            if (rs.getInt("user_id") == App.userId) {
                course.setUserHasIt(true);
            }
            else
                course.setUserHasIt(false);
            course.setProgress(findProgress(courseId, connection));
            course.setNextLesson(findLesson(courseId, connection));
            ans.add(course);
        }
        return FXCollections.observableArrayList(ans);
    }

    private String findProgress(int courseId, Connection connection) {
        try(PreparedStatement preparedStatement = connection.prepareStatement(
                "WITH num_of_lessons_in_course(num) AS " +
                        "(SELECT COUNT(DISTINCT l.id) FROM project.lesson l WHERE l.course_id = ?), " +
                        "num_of_completed_lessons(num) AS " +
                        "(SELECT COUNT(DISTINCT l.id) FROM project.lesson l RIGHT JOIN project.completed_lessons cl " +
                        "ON l.id = cl.lesson_id WHERE cl.user_id = ? AND l.course_id = ?) " +
                        "SELECT (CAST((SELECT num FROM num_of_completed_lessons) AS DECIMAL)/(SELECT num FROM num_of_lessons_in_course)) AS progress;")) {
            preparedStatement.setInt(1, courseId);
            preparedStatement.setInt(2, App.userId);
            preparedStatement.setInt(3, courseId);
            ResultSet rs = preparedStatement.executeQuery();
            if(rs.next()) {
                String progress = String.format("%.0f", rs.getFloat("progress") * 100);
                return progress + " %";
            }
        }
        catch (SQLException e) {
            logger.error("Findig progress in db failed!\nMessage: "+e.getMessage());
        }
        return "0 %";
    }
    private String findLesson(int courseId, Connection connection) {
        try(PreparedStatement preparedStatement = connection.prepareStatement(
                "WITH get_uncompleted_ids(id) AS " +
                        "(SELECT id FROM project.lesson WHERE id NOT IN (SELECT lesson_id FROM project.completed_lessons WHERE user_id = ?) AND course_id = ?), " +
                        "get_lowest_id(id) AS " +
                        "(SELECT MIN(id) FROM get_uncompleted_ids) " +
                        "SELECT name FROM project.lesson WHERE id = (SELECT id FROM get_lowest_id);")) {
            preparedStatement.setInt(1, App.userId);
            preparedStatement.setInt(2, courseId);
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                return rs.getString("name");
            }

        }
        catch (SQLException e) {
            logger.error("Findig next lesson in db failed!\nMessage: "+e.getMessage());
        }
        return "Link not found.";
    }
}
