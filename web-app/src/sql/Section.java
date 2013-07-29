package sql;


import helper.Settings;

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
 * 4. (set): normal UPDATE statement for single field (column)<p>
 * 5. (update): normal UPDATE statement for multiple fields (columns)<p>
 * 6. (create): INSERT INTO<p>
 * 7. (delete): DELETE<p>
 * @author Bo Li
 *
 */
public class Section implements Sql {
    private DBAccess _dbAccess = null;
    private String _sql = null;

    public Section(DBAccess source) {
        _dbAccess = source;
    }
    
    public String getErrLog() {
        return _dbAccess.getErrLog();
    }
    
    public String getSQL() {
        return _sql;
    }
    
    /**
     * This MUST be called after an error is caught,
     * else no other SQL statements would run
     * @return
     */
    public boolean resetFlag() {
        return _dbAccess.resetFlag();
    }
    
    /** 
     * the following are query (SELECT) classes
     * that begin with 'get' or 'is'
     * Examples:
     *  getHash
     *  isActive 
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
    
    public boolean getSectionInfo(ArrayList<ArrayList<String>> result) {
        _sql = "SELECT section.*, course.c_name, department.d_name "
                + "FROM section "
                + "INNER JOIN course "
                + "ON section.c_id = course.c_id "
                + "INNER JOIN department "
                + "ON section.d_code = department.d_code";
        return _dbAccess.queryDB(result, _sql);
    }
}
