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
public class Lecture extends Sql {

    public Lecture(DBAccess source) {
        super(source);
    }

    /**
     * Get data on a particular Lecture<p>
     * Fields:<p>
     * (0)ls_id (1)l_id (2)l_inidatetime (3)l_duration (4)l_iscancel
     * (5)l_description (6)l_modpass (7)l_userpass
     * @param result
     * @param ls_id
     * @param l_id
     * @return
     */
    public boolean getLectureInfo(ArrayList<ArrayList<String>> result, int ls_id, int l_id) {
        _sql = "SELECT lecture.* "
                + "FROM lecture "
                + "WHERE lecture.ls_id = " + ls_id + " "
                + "AND lecture.l_id = " + l_id;
        return _dbAccess.queryDB(result, _sql);
    }

    /**
     * Get data on lectures in a particular Lecture Schedule<p>
     * Fields:<p>
     * (0)ls_id (1)l_id (2)l_inidatetime (3)l_duration (4)l_iscancel
     * (5)l_description (6)l_modpass (7)l_userpass
     * @param result
     * @param ls_id
     * @param l_id
     * @return
     */
    public boolean getLectureInfo(ArrayList<ArrayList<String>> result, int ls_id) {
        _sql = "SELECT lecture.* "
                + "FROM lecture "
                + "WHERE ls_id = " + ls_id;
        return _dbAccess.queryDB(result, _sql);
    }

    /**
     * Fields:<p>
     * (0)ls_id (1)c_id (2)sc_id (3)sc_semesterid (4)ls_inidatetime
     * (5)ls_intervals (6)ls_repeats (7)ls_duration
     * @param result
     * @return
     */
    public boolean getLectureScheduleInfo(ArrayList<ArrayList<String>> result) {
        _sql = "SELECT * "
                + "FROM lecture_schedule";
        return _dbAccess.queryDB(result, _sql);
    }

    /**
     * Fields:<p>
     * (0)ls_id (1)c_id (2)sc_id (3)sc_semesterid (4)ls_inidatetime
     * (5)ls_intervals (6)ls_repeats (7)ls_duration
     * @param result
     * @param ls_id
     * @return
     */
    public boolean getLectureScheduleInfo(ArrayList<ArrayList<String>> result, int ls_id) {
        _sql = "SELECT * "
                + "FROM lecture_schedule "
                + "WHERE ls_id = " + ls_id;
        return _dbAccess.queryDB(result, _sql);
    }

    /**
     * (0)l_description
     * @param result
     * @param ls_id
     * @param l_id
     * @return
     */
    public boolean getLectureDescription(ArrayList<ArrayList<String>> result, int ls_id, int l_id) {
        _sql = "SELECT l_description "
                + "FROM lecture "
                + "WHERE ls_id = " + ls_id + " "
                + "AND l_id = " + l_id;
        return _dbAccess.queryDB(result, _sql);
    }

    /**
     * (0)l_inidatetime
     * @param result
     * @param ls_id
     * @param l_id
     * @return
     */
    public boolean getLectureInitialDatetime(ArrayList<ArrayList<String>> result, int ls_id, int l_id) {
        _sql = "SELECT l_inidatetime "
                + "FROM lecture "
                + "WHERE ls_id = " + ls_id + " "
                + "AND l_id = " + l_id;
        return _dbAccess.queryDB(result, _sql);
    }

    /**
     * (0)l_duration
     * @param result
     * @param ls_id
     * @param l_id
     * @return
     */
    public boolean getLectureDuration(ArrayList<ArrayList<String>> result, int ls_id, int l_id) {
        _sql = "SELECT l_duration "
                + "FROM lecture "
                + "WHERE ls_id = " + ls_id + " "
                + "AND l_id = " + l_id;
        return _dbAccess.queryDB(result, _sql);
    } 

    /**
     * (0)l_iscancel
     * @param result
     * @param ls_id
     * @param l_id
     * @return
     */
    public boolean getIsLectureCancelled(ArrayList<ArrayList<String>> result, int ls_id, int l_id) {
        _sql = "SELECT l_iscancel "
                + "FROM lecture "
                + "WHERE ls_id = " + ls_id + " "
                + "AND l_id = " + l_id;
        return _dbAccess.queryDB(result, _sql);
    }

    /**
     * (0)l_modpass
     * @param result
     * @param ls_id
     * @param l_id
     * @return
     */
    public boolean getLectureModPass(ArrayList<ArrayList<String>> result, int ls_id, int l_id) {
        _sql = "SELECT l_modpass "
                + "FROM lecture "
                + "WHERE ls_id = " + ls_id + " "
                + "AND l_id = " + l_id;
        return _dbAccess.queryDB(result, _sql);
    }

    /**
     * (0)l_userpass
     * @param result
     * @param ls_id
     * @param l_id
     * @return
     */
    public boolean getLectureUserPass(ArrayList<ArrayList<String>> result, int ls_id, int l_id) {
        _sql = "SELECT l_userpass "
                + "FROM lecture "
                + "WHERE ls_id = " + ls_id + " "
                + "AND l_id = " + l_id;
        return _dbAccess.queryDB(result, _sql);
    }

    /**
     * Fields<p>
     * (0)lp_title
     * @param result
     * @param ls_id
     * @param l_id
     * @return
     */
    public boolean getLecturePresentation(ArrayList<ArrayList<String>> result, int ls_id, int l_id) {
        _sql = "SELECT lp_title "
                + "FROM lecture_presentation "
                + "WHERE ls_id = " + ls_id + " "
                + "AND l_id = " + l_id;
        return _dbAccess.queryDB(result, _sql);
    }

    /**
     * (0)bu_id (1)la_isattend
     * @param result
     * @param ls_id
     * @return
     */
    public boolean getLectureAttendance(ArrayList<ArrayList<String>> result, int ls_id, int l_id) {
        _sql = "SELECT bu_id, la_isattend "
                + "FROM lecture_attendance "
                + "WHERE ls_id = " + ls_id + " "
                + "AND l_id = " + l_id;
        return _dbAccess.queryDB(result, _sql);
    }

    /**
     * (0)bu_id (1)la_isattend
     * @param result
     * @param ls_id
     * @param bu_id
     * @return
     */
    public boolean getLectureAttendance(ArrayList<ArrayList<String>> result, int ls_id, int l_id, String bu_id) {
        _sql = "SELECT bu_id, la_isattend "
                + "FROM lecture_attendance "
                + "WHERE ls_id = " + ls_id + " "
                + "AND l_id = " + l_id + " "
                + "AND bu_id = '" + bu_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    /**
     * (0)bu_id (1)gl_ismod
     * @param result
     * @param ls_id
     * @param l_id
     * @return
     */
    public boolean getLectureGuest(ArrayList<ArrayList<String>> result, int ls_id, int l_id) {
        _sql = "SELECT bu_id, gl_ismod "
                + "FROM guest_lecturer "
                + "WHERE ls_id = " + ls_id + " "
                + "AND l_id = " + l_id;
        return _dbAccess.queryDB(result, _sql);
    }

    /**
     * Fields:<p>
     * (0)ls_id (1)l_id (2)l_inidatetime (3)l_duration (4)l_iscancel (5)l_description (6)l_modpass (7)l_userpass (8)c_name
     * @param result
     * @param bu_id
     * @param professor
     * @param student
     * @return
     */
    public boolean getLecturesForUser(ArrayList<ArrayList<String>> result, String bu_id, boolean professor, boolean student) {
    	String _professor = "(SELECT lecture.*, course.c_name " 
    			+ "FROM lecture "
    			+ "INNER JOIN lecture_schedule ON lecture.ls_id = lecture_schedule.ls_id "
    			+ "INNER JOIN professor ON lecture_schedule.c_id = professor.c_id AND lecture_schedule.sc_id = professor.sc_id AND lecture_schedule.sc_semesterid = professor.sc_semesterid "
    			+ "INNER JOIN course ON lecture_schedule.c_id = course.c_id) ";
    			//+ "WHERE professor.bu_id = '" + bu_id +"') ";
    			
    	String _student = "(SELECT lecture.*, course.c_name " 
    			+ "FROM lecture "
    			+ "INNER JOIN lecture_schedule ON lecture.ls_id = lecture_schedule.ls_id "
    			+ "INNER JOIN student ON lecture_schedule.c_id = student.c_id AND lecture_schedule.sc_id = student.sc_id AND lecture_schedule.sc_semesterid = student.sc_semesterid "
    			+ "INNER JOIN course ON lecture_schedule.c_id = course.c_id "
    			+ "WHERE student.bu_id = '" + bu_id +"') ";
    	
    	if (professor && student) {
    		_sql = _professor + "UNION DISTINCT " + _student;
    	} else if (professor) {
    		_sql = _professor;
    	} else if (student) {
    		_sql = _student;
    	} else {
    		result.clear();
    		return true;
    	}
    	return (_dbAccess.queryDB(result, _sql));
    }
    
    /**
     * (0)bu_id (1)gl_ismod
     * @param result
     * @param ls_id
     * @param l_id
     * @param bu_id
     * @return
     */
    public boolean getLectureGuest(ArrayList<ArrayList<String>> result, int ls_id, int l_id, String bu_id) {
        _sql = "SELECT bu_id, gl_ismod "
                + "FROM guest_lecturer "
                + "WHERE ls_id = " + ls_id + " "
                + "AND l_id = " + l_id + " "
                + "AND bu_id = '" + bu_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    public boolean setLectureDescription(int ls_id, int l_id, String l_description) {
        _sql = "UPDATE lecture "
                + "SET l_description = '" + l_description + "' "
                + "WHERE ls_id = " + ls_id + " "
                + "AND l_id = " + l_id;
        return _dbAccess.updateDB(_sql);
    }

    public boolean setLectureIsCancel(int ls_id, int l_id, boolean l_iscancel) {
        int flag = (l_iscancel == true) ? 1 : 0;
        _sql = "UPDATE lecture "
                + "SET l_iscancel = " + flag + " "
                + "WHERE ls_id = " + ls_id + " "
                + "AND l_id = " + l_id;
        return _dbAccess.updateDB(_sql);
    }

    public boolean setLectureAttendance(String bu_id, int ls_id, int l_id, boolean la_isattend) {
        int flag = (la_isattend == true) ? 1 : 0;
        _sql = "UPDATE lecture_attendance "
                + "SET la_isattend = " + flag + " "
                + "WHERE ls_id = " + ls_id + " "
                + "AND l_id = " + l_id + " "
                + "AND bu_id = '" + bu_id + "'";
        return _dbAccess.updateDB(_sql);
    }

    public boolean setLectureGuestIsMod(String bu_id, int ls_id, int l_id, boolean gl_ismod) {
        int flag = (gl_ismod == true) ? 1 : 0;
        _sql = "UPDATE guest_lecturer "
                + "SET gl_ismod = " + flag + " "
                + "WHERE ls_id = " + ls_id + " "
                + "AND l_id = " + l_id + " "
                + "AND bu_id = '" + bu_id + "'";
        return _dbAccess.updateDB(_sql);
    }
    

    /**
     * 
     * @param num (1, 2, 3)<p>
     * (1) change the current Lecture only<p>
       (2) change all sessions after and including the current one<p>
       (3) change all sessions not yet passed (reference to sysdate())
     * @param ls_id
     * @param l_id
     * @param l_duration
     * @return
     */
    public boolean updateLectureDuration(int num, int ls_id, int l_id, int l_duration) {
        _sql = "CALL sp_update_l_duration("
                + num + ", "
                + ls_id + ", "
                + l_id + ", "
                + l_duration + ")";
        return _dbAccess.updateDB(_sql);
    }

    /**
     * 
     * @param num (1, 2, 3)<p>
     * (1) change the current Lecture only<p>
       (2) change all sessions after and including the current one<p>
       (3) change all sessions not yet passed (reference to sysdate())
     * @param ls_id
     * @param l_id
     * @param time (format HH:MM:SS)
     * @return
     */
    public boolean updateLectureTime(int num, int ls_id, int l_id, String time) {
        _sql = "CALL sp_update_l_time("
                + num + ", "
                + ls_id + ", "
                + l_id + ", '"
                + time + "')";
        return _dbAccess.updateDB(_sql);
    }

    /**
     * 
     * @param ls_id
     * @param ls_repeats
     * @return
     */
    public boolean updateLectureRepeats(int ls_id, int ls_repeats) {
        _sql = "CALL sp_update_ls_repeats("
                + ls_id + ", "
                + ls_repeats + ")";
        return _dbAccess.updateDB(_sql);
    }
    
    /**
     * Format of datetime must be exactly as specified<p>
     * Check to make sure datetime is greatly than current time<p>
     * If method updateLectureTime has been to alter time of day,
     * calling this method will reset all custom changes
     * @param ls_id
     * @param datetime (format: 'YYYY-MM-DD HH:MM:SS')
     * @return
     */
    public boolean updateLectureScheduleInitialTime(int ls_id, String datetime) {
        _sql = "CALL sp_update_ls_inidatetime("
                + ls_id + ", '"
                + datetime + "')";
        return _dbAccess.updateDB(_sql);
    }
    
    public boolean createLecturePresentation(String lp_title, int ls_id, int l_id) {
        _sql = "INSERT INTO lecture_presentation VALUES ('"
                + lp_title + "', " + ls_id + ", " + l_id + ")";
        return _dbAccess.updateDB(_sql);
    }

    public boolean createLectureAttendance(String bu_id, int ls_id, int l_id, boolean la_isattend) {
        int flag = (la_isattend == true) ? 1 : 0;
        _sql = "INSERT INTO lecture_attendance VALUES ('"
                + bu_id + "', " + ls_id + ", " + l_id + ", " + flag + ")";
        return _dbAccess.updateDB(_sql);
    }

    public boolean createLectureGuest(String bu_id, int ls_id, int l_id, boolean gl_ismod) {
        int flag = (gl_ismod == true) ? 1 : 0;
        _sql = "INSERT INTO guest_lecturer VALUES ('"
                + bu_id + "', " + ls_id + ", " + l_id + ", " + flag + ")";
        return _dbAccess.updateDB(_sql);
    }
    
    /**
     * Create lecture schedule as well as all lectures in this lecture schedule
     * @param c_id
     * @param sc_id
     * @param sc_semesterid
     * @param ls_inidatetime (format: 'YYYY-MM-DD HH:MM:SS')
     * @param ls_intervals (in days)
     * @param ls_repeats
     * @param ls_duration (in minutes, round to nearest integer)
     * @param l_description
     * @return
     */
    public boolean createLectureSchedule(String c_id, String sc_id, String sc_semesterid, 
            String ls_inidatetime, int ls_intervals, int ls_repeats, int ls_duration, 
            String l_description) {
        _sql = "CALL sp_create_ls('"
                + c_id + "', '"
                + sc_id + "', '"
                + sc_semesterid + "', '"
                + ls_inidatetime + "', "
                + ls_intervals + ", "
                + ls_repeats + ", "
                + ls_duration + ", '"
                + l_description + "')";
        return _dbAccess.updateDB(_sql);
    }
    
    public boolean removeLectureAttendance(String bu_id, int ls_id, int l_id) {
        _sql = "DELETE FROM lecture_attendance "
                + "WHERE ls_id = " + ls_id + " "
                + "AND l_id = " + l_id + " "
                + "AND bu_id = '" + bu_id + "'";
        return _dbAccess.updateDB(_sql);
    }
    
    public boolean removeLectureGuest(String bu_id, int ls_id, int l_id) {
        _sql = "DELETE FROM guest_lecturer "
                + "WHERE ls_id = " + ls_id + " "
                + "AND l_id = " + l_id + " "
                + "AND bu_id = '" + bu_id + "'";
        return _dbAccess.updateDB(_sql);
    }
    
    public boolean removeLecturePresentation(String lp_title, int ls_id, int l_id) {
        _sql = "DELETE FROM lecture_presentation "
                + "WHERE ls_id = " + ls_id + " "
                + "AND l_id = " + l_id + " "
                + "AND lp_title = '" + lp_title + "'";
        return _dbAccess.updateDB(_sql);
    }
    
    /**
     * Only lectures yet to happen will be removed
     * lecture schedule only removed if there is no lecture associated with it
     * @param ls_id
     * @return
     */
    public boolean removeMeetingSchedule(int ls_id) {
        _sql = "CALL sp_delete_ls(" + ls_id + ")";
        return _dbAccess.updateDB(_sql);
    }
}
