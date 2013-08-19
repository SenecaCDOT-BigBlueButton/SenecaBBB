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
    
    
}
