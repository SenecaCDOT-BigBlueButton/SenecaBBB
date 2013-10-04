package sql;

import java.util.ArrayList;
import db.DBAccess;

/**
 * For the parameters, please use DB column names
 * Example: setNickName(String bu_id, String bu_nick) 
 *          bu_id and bu_nick are both DB column names
 * <p>
 * SQL Method prefix Legend:<p>
 * 1. (get): simple query<p>
 * 2. (is): query that use SELECT 1 to check existence<p>
 * 3. (default): UPDATE statement that set targeted data back to default values<p>
 * 4. (set): normal UPDATE statement, single column<p>
 * 5. (setMul): UPDATE statement, multi column<p>
 * 6. (update): UPDATE multiple tables using MySQL Stored Procedure (SP) or complex SQL statements
 *    if the method needs to be changed, edit would like be done in SQL script: bbb_db_init.sql<p>
 * 7. (create): INSERT INTO<p>
 * 8. (remove): DELETE<p>
 * @author Kelan (Bo) Li
 *
 */
public class Section extends Sql {
    
    public Section(DBAccess source) {
        super(source);
    }
    
    /**
     * Get a particular section info based on c_id, sc_id and sc_semesterid<p>
     * Results<p>
     * (0)c_id (1)sc_id (2)sc_semesterid (3)d_code
     * (4)c_name (5)d_name
     * @param result
     * @param c_id
     * @param sc_id
     * @param sc_semesterid
     * @return
     */
    public boolean getSectionInfo(ArrayList<ArrayList<String>> result, String c_id, String sc_id, String sc_semesterid) {
        _sql = "SELECT section.*, course.c_name, department.d_name "
                + "FROM section "
                + "INNER JOIN course "
                + "ON section.c_id = course.c_id "
                + "INNER JOIN department "
                + "ON section.d_code = department.d_code "
                + "WHERE section.c_id = '" + c_id + "' "
                + "AND section.sc_id = '" + sc_id + "' "
                + "AND section.sc_semesterid = '" + sc_semesterid + "'";
        return _dbAccess.queryDB(result, _sql);
    }
    
    /**
     * Get all sections<p>
     * Results<p>
     * (0)c_id (1)sc_id (2)sc_semesterid (3)d_code
     * (4)c_name (5)d_name
     * @param result
     * @return
     */
    public boolean getSectionInfo(ArrayList<ArrayList<String>> result) {
        _sql = "SELECT section.*, course.c_name, department.d_name "
                + "FROM section "
                + "INNER JOIN course "
                + "ON section.c_id = course.c_id "
                + "INNER JOIN department "
                + "ON section.d_code = department.d_code";
        return _dbAccess.queryDB(result, _sql);
    }
    
    /**
     * Get all sections with same c_id and sc_semesterid<p>
     * Results<p>
     * (0)c_id (1)sc_id (2)sc_semesterid (3)d_code
     * (4)c_name (5)d_name
     * @param result
     * @param c_id
     * @param sc_semesterid
     * @return
     */
    public boolean getSectionInfo(ArrayList<ArrayList<String>> result, String c_id, String sc_semesterid) {
        _sql = "SELECT section.*, course.c_name, department.d_name "
                + "FROM section "
                + "INNER JOIN course "
                + "ON section.c_id = course.c_id "
                + "INNER JOIN department "
                + "ON section.d_code = department.d_code "
                + "WHERE section.c_id = '" + c_id + "' "
                + "AND section.sc_semesterid = '" + sc_semesterid + "'";
        return _dbAccess.queryDB(result, _sql);
    }
    
    /**
     * Get all sections with same c_id<p>
     * Results<p>
     * (0)c_id (1)sc_id (2)sc_semesterid (3)d_code
     * @param result
     * @param c_id
     * @return
     */
    public boolean getSectionInfoByCourse(ArrayList<ArrayList<String>> result, String c_id) {
        _sql = "SELECT * "
                + "FROM section "
                + "WHERE c_id = '" + c_id + "' ";
        return _dbAccess.queryDB(result, _sql);
    }
    
    /**
     * (0)c_id (1)c_name
     * @param result
     * @return
     */
    public boolean getCourse(ArrayList<ArrayList<String>> result,String c_id) {
        _sql = "SELECT * "
                + "FROM course "
                + "WHERE c_id = '" + c_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }
    
    
    /**
     * (0)c_id (1)c_name
     * @param result
     * @return
     */
    public boolean getCourse(ArrayList<ArrayList<String>> result) {
        _sql = "SELECT * "
                + "FROM course";            
        return _dbAccess.queryDB(result, _sql);
    }
    
    /**
     * get all professors<p>
     * (0)bu_id (1)c_id (2)sc_id (3)sc_semesterid (4)sc_setting
     * @param result
     * @return
     */
    public boolean getProfessor(ArrayList<ArrayList<String>> result) {
        _sql = "SELECT * "
                + "FROM professor";
        return _dbAccess.queryDB(result, _sql);
    }
    
    /**
     * get professor by bu_id<p>
     * (0)bu_id (1)c_id (2)sc_id (3)sc_semesterid (4)sc_setting
     * @param result
     * @param bu_id
     * @return
     */
    public boolean getProfessor(ArrayList<ArrayList<String>> result,String bu_id) {
        _sql = "SELECT * "
                + "FROM professor"
        		+ "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }
    
    /**
     * get professors teaching a particular section<p>
     * (0)bu_id (1)c_id (2)sc_id (3)sc_semesterid (4)sc_setting
     * @param result
     * @param c_id
     * @param sc_id
     * @param sc_semesterid
     * @return
     */
    public boolean getProfessor(ArrayList<ArrayList<String>> result, 
            String c_id, String sc_id, String sc_semesterid) {
        _sql = "SELECT * "
                + "FROM professor "
                + "WHERE c_id = '" + c_id + "' "
                + "AND sc_id = '" + sc_id + "' "
                + "AND sc_semesterid = '" + sc_semesterid + "'";
        return _dbAccess.queryDB(result, _sql);
    }
    
    /**
     * get lecture schedule for a particular section<p>
     * (0)c_id (1)sc_id (2)sc_semesterid (3)sc_setting
     * @param result
     * @param c_id
     * @param sc_id
     * @param sc_semesterid
     * @return
     */
    public boolean getLectureSchedule(ArrayList<ArrayList<String>> result, 
            String c_id, String sc_id, String sc_semesterid) {
        _sql = "SELECT * "
                + "FROM lecture_schedule "
                + "WHERE c_id = '" + c_id + "' "
                + "AND sc_id = '" + sc_id + "' "
                + "AND sc_semesterid = '" + sc_semesterid + "'";
        return _dbAccess.queryDB(result, _sql);
    }
    
    /**
     * get all students<p>
     * (0)bu_id (1)c_id (2)sc_id (3)sc_semesterid (4)s_isbanned
     * @param result
     * @return
     */
    public boolean getStudent(ArrayList<ArrayList<String>> result) {
        _sql = "SELECT * "
                + "FROM student";
        return _dbAccess.queryDB(result, _sql);
    }
    
    /**
     * get all students in a lecture<p>
     * (0)bu_id (1)c_id (2)sc_id (3)sc_semesterid (4)s_isbanned (5)bu_nick
     * @param result
     * @return
     */
    public boolean getStudent(ArrayList<ArrayList<String>> result, String ls_id) {
        _sql = "SELECT s.*, bu.bu_nick "
                + "FROM student s "
                + "JOIN lecture_schedule ls "
                + "ON s.c_id = ls.c_id "
                + "AND s.sc_id = ls.sc_id "
                + "AND s.sc_semesterid = ls.sc_semesterid "
                + "JOIN bbb_user bu "
                + "ON bu.bu_id = s.bu_id "
                + "WHERE ls.ls_id = '" + ls_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }
    
    /**
     * get all students of a particular section<p>
     * (0)bu_id (1)c_id (2)sc_id (3)sc_semesterid (4)s_isbanned
     * @param result
     * @param c_id
     * @param sc_id
     * @param sc_semesterid
     * @return
     */
    public boolean getStudent(ArrayList<ArrayList<String>> result, 
            String c_id, String sc_id, String sc_semesterid) {
        _sql = "SELECT * "
                + "FROM student "
                + "WHERE c_id = '" + c_id + "' "
                + "AND sc_id = '" + sc_id + "' "
                + "AND sc_semesterid = '" + sc_semesterid + "'";
        return _dbAccess.queryDB(result, _sql);
    }
    
    public boolean setBannedFromSection(
            String bu_id, String c_id, String sc_id, String sc_semesterid, boolean s_isbanned) {
        int flag = (s_isbanned == true) ? 1 : 0;
        _sql = "UPDATE student "
                + "SET s_isbanned = " + flag + " "
                + "WHERE bu_id = '" + bu_id + "' "
                + "AND c_id = '" + c_id + "' "
                + "AND sc_id = '" + sc_id + "' "
                + "AND sc_semesterid = '" + sc_semesterid + "'";
        return _dbAccess.updateDB(_sql);
    }
    
    public boolean setCourseId(String old_c_id, String new_c_id) {
        _sql = "UPDATE course "
                + "SET c_id = '" + new_c_id + "' "
                + "WHERE c_id ='" + old_c_id + "'";
        return _dbAccess.updateDB(_sql);
    }
    
    public boolean setCourseName(String c_id, String c_name) {
        _sql = "UPDATE course "
                + "SET c_name = '" + c_name + "' "
                + "WHERE c_id ='" + c_id + "'";
        return _dbAccess.updateDB(_sql);
    }
    
    public boolean createCourse(String c_id, String c_name) {
        _sql = "INSERT INTO course VALUES ('"
                + c_id + "', '" + c_name + "')";
        return _dbAccess.updateDB(_sql);
    }
    
    public boolean createSection(String c_id, String sc_id, 
            String sc_semesterid, String d_code) {
        _sql = "INSERT INTO section VALUES ('"
                + c_id + "', '" + sc_id + "', '" + sc_semesterid + "', '" + d_code + "')";
        return _dbAccess.updateDB(_sql);
    }
    
    public boolean createProfessor(String bu_id, String c_id, 
            String sc_id, String sc_semesterid) {
        _sql = "INSERT INTO professor VALUES ('"
                + bu_id + "', '" + c_id + "', '" + sc_id + "', '" + sc_semesterid + "', " 
                + "(SELECT key_value FROM bbb_admin WHERE key_name='default_user'))";
        return _dbAccess.updateDB(_sql);
    }
    
    public boolean createStudent(String bu_id, String c_id,
            String sc_id, String sc_semesterid, boolean s_isbanned) {
        int flag = (s_isbanned == true) ? 1 : 0;
        _sql = "INSERT INTO student VALUES ('"
                + bu_id + "', '" + c_id + "', '" + sc_id + "', '" + sc_semesterid + "', "
                + flag + ")";
        return _dbAccess.updateDB(_sql);
    }
    
    /**
     * WARNING: you need to delete child dependences first before
     * deleting a section 
     * @param c_id
     * @param sc_id
     * @param sc_semesterid
     * @return
     */
    public boolean removeSection(String c_id, String sc_id, String sc_semesterid) {
        _sql = "DELETE FROM section "
                + "WHERE c_id = '" + c_id + "' "
                + "AND sc_id = '" + sc_id + "' "
                + "AND sc_semesterid = '" + sc_semesterid + "'";
        return _dbAccess.updateDB(_sql);
    }
    
    /**
     * WARNING: you need to delete child dependences first before
     * deleting a course
     * @param c_id
     * @return
     */
    public boolean removeCourse(String c_id) {
        _sql = "DELETE FROM course "
                + "WHERE c_id = '" + c_id + "'";
        return _dbAccess.updateDB(_sql);
    }
    
    public boolean removeProfessor(String bu_id, String c_id, String sc_id, String sc_semesterid) {
        _sql = "DELETE FROM professor "
                + "WHERE bu_id = '" + bu_id + "' "
                + "AND c_id = '" + c_id + "' "
                + "AND sc_id = '" + sc_id + "' "
                + "AND sc_semesterid = '" + sc_semesterid + "'";
        return _dbAccess.updateDB(_sql);
    }
    
    public boolean removeStudent(String bu_id, String c_id, String sc_id, String sc_semesterid) {
        _sql = "DELETE FROM student "
                + "WHERE bu_id = '" + bu_id + "' "
                + "AND c_id = '" + c_id + "' "
                + "AND sc_id = '" + sc_id + "' "
                + "AND sc_semesterid = '" + sc_semesterid + "'";
        return _dbAccess.updateDB(_sql);
    }
    
}
