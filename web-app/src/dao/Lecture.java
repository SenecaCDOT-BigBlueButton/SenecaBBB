package dao;

import java.util.ArrayList;
import db.DBAccess;
import references.settings;

public class Lecture {
    private DBAccess _dbAccess = null;
    private String _sql = null;

    public Lecture(DBAccess source) {
        _dbAccess = source;
    }
    
    public String getErrLog() {
        return _dbAccess.getErrLog();
    }
    
    public String getSQL() {
        return _sql;
    }
    
    /** 
     * the following are query (SELECT) classes
     * that begin with 'get' or 'is'
     * Examples:
     *  getHash
     *  isActive 
     */
    
    public boolean getLectureInfo(ArrayList<ArrayList<String>> result, String ls_id, String l_id) {
        _sql = "SELECT lecture.*, lecture_presentation.lp_title "
                + "FROM lecture "
                + "INNER JOIN lecture_presentation " 
                + "ON lecture.ls_id = lecture_presentation.ls_id "
                + "AND lecture.l_id = lecture_presentation.l_id "
                + "WHERE lecture.ls_id = '" + ls_id + "' "
                + "AND lecture.l_id = '" + l_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }
    
    public boolean getLectureInfo(ArrayList<ArrayList<String>> result) {
        _sql = "SELECT lecture.*, lecture_presentation.lp_title "
                + "FROM lecture "
                + "INNER JOIN lecture_presentation " 
                + "ON lecture.ls_id = lecture_presentation.ls_id "
                + "AND lecture.l_id = lecture_presentation.l_id";
        return _dbAccess.queryDB(result, _sql);
    }
}
