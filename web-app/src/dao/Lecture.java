package dao;

import java.util.ArrayList;
import db.DBQuery;

public class Lecture {
    private DBQuery _dbQuery = null;
    private String _query = null;

    public Lecture() {
        _dbQuery = new DBQuery();
    }
    
    public boolean clean() {
        return _dbQuery.closeQuery();
    }
    
    /** this closes the single DB connection, caution when calling this */
    public boolean closeConnection() {
        return _dbQuery.closeConnection();
    }
    
    /** use this method if closeConnection() is called and you need to reestablish connection */
    public void openConnection() {
        _dbQuery.openConnection();
    }
    
    public String getErrLog() {
        return _dbQuery.getErrLog();
    }
    
    public String getQuery() {
        return _query;
    }
    
    /** the following are Query classes */
    
    public boolean getLectureInfo(ArrayList<ArrayList<String>> result, String ls_id, String l_id) {
        _query = "SELECT lecture.*, lecture_presentation.lp_title "
                + "FROM lecture "
                + "INNER JOIN lecture_presentation " 
                + "ON lecture.ls_id = lecture_presentation.ls_id "
                + "AND lecture.l_id = lecture_presentation.l_id "
                + "WHERE lecture.ls_id = '" + ls_id + "' "
                + "AND lecture.l_id = '" + l_id + "'";
        return _dbQuery.queryDB(result, _query);
    }
    
    public boolean getLectureInfo(ArrayList<ArrayList<String>> result) {
        _query = "SELECT lecture.*, lecture_presentation.lp_title "
                + "FROM lecture "
                + "INNER JOIN lecture_presentation " 
                + "ON lecture.ls_id = lecture_presentation.ls_id "
                + "AND lecture.l_id = lecture_presentation.l_id";
        return _dbQuery.queryDB(result, _query);
    }
}
