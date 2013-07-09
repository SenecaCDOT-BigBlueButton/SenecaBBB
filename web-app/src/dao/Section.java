package dao;

import java.util.ArrayList;
import db.DBQuery;

public class Section {
    private DBQuery _dbQuery = null;
    private String _query = null;

    public Section() {
        _dbQuery = new DBQuery();
    }
    
    public boolean clean() {
        return _dbQuery.closeQuery();
    }
    
    /** use this method if you need to reestablish connection */
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
    
    public boolean getSectionInfo(ArrayList<ArrayList<String>> result, String c_id, String sc_id, String sc_semesterid) {
        _query = "SELECT section.*, course.c_name, department.d_name "
                + "FROM section "
                + "INNER JOIN course "
                + "ON section.c_id = course.c_id "
                + "INNER JOIN department "
                + "ON section.d_code = department.d_code "
                + "WHERE section.c_id = '" + c_id + "' "
                + "AND section.sc_id = '" + sc_id + "' "
                + "AND section.sc_semesterid = '" + sc_semesterid + "'";
        return _dbQuery.queryDB(result, _query);
    }
    
    public boolean getSectionInfo(ArrayList<ArrayList<String>> result) {
        _query = "SELECT section.*, course.c_name, department.d_name "
                + "FROM section "
                + "INNER JOIN course "
                + "ON section.c_id = course.c_id "
                + "INNER JOIN department "
                + "ON section.d_code = department.d_code";
        return _dbQuery.queryDB(result, _query);
    }
}
