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
public class Department extends Sql {

    public Department(DBAccess source) {
        super(source);
    }

    /**
     * Fields:<p>
     * (0)d_code (1)d_name
     * @param result
     * @return
     */
    public boolean getDepartment(ArrayList<ArrayList<String>> result) {
        _sql = "SELECT * "
                + "FROM department";
        return _dbAccess.queryDB(result, _sql);
    }
    
    /**
     * Fields:<p>
     * (0)d_code (1)d_name
     * @param result
     * @param d_code
     * @return
     */
    public boolean getDepartment(ArrayList<ArrayList<String>> result, String d_code) {
        _sql = "SELECT * "
                + "FROM department "
                + "WHERE d_code = '" + d_code +"'";
        return _dbAccess.queryDB(result, _sql);
    }
    
    /**
     * Fields:<p>
     * (0)bu_id (1)d_code (2)ud_isadmin
     * @param result
     * @return
     */
    public boolean getDepartmentUser(ArrayList<ArrayList<String>> result) {
        _sql = "SELECT * "
                + "FROM user_department";
        return _dbAccess.queryDB(result, _sql);   
    }
    
    /**
     * Fields:<p>
     * (0)bu_id (1)d_code (2)ud_isadmin
     * @param result
     * @param bu_id
     * @param d_code
     * @return
     */
    public boolean getDepartmentUser(ArrayList<ArrayList<String>> result, String bu_id, String d_code) {
        _sql = "SELECT * "
                + "FROM user_department "
                + "WHERE bu_id = '" + bu_id + "' "
                + "AND d_code = '" + d_code + "'";
        return _dbAccess.queryDB(result, _sql);   
    }
    
    public boolean setDepartmentCode(String old_d_code, String new_d_code) {
        _sql = "UPDATE department "
                + "SET d_code = '" + new_d_code + "' "
                + "WHERE d_code ='" + old_d_code + "'";
        return _dbAccess.updateDB(_sql);
    }
    
    public boolean setDepartmentName(String d_code, String d_name) {
        _sql = "UPDATE department "
                + "SET d_name = '" + d_name + "' "
                + "WHERE d_code ='" + d_code + "'";
        return _dbAccess.updateDB(_sql);
    }
    
    public boolean setDepartmentAdmin(
            String bu_id, String d_code, boolean ud_isadmin) {
        int flag = (ud_isadmin == true) ? 1 : 0;
        _sql = "UPDATE user_department "
                + "set ud_isadmin = " + flag + " "
                + "WHERE bu_id = '" + bu_id + "' "
                + "AND d_code = '" + d_code + "'";
        return _dbAccess.updateDB(_sql);
    }
    
    public boolean createDepartment(String d_code, String d_name) {
        _sql = "INSERT INTO department VALUES ('"
                + d_code + "', '" + d_name + "')";
        return _dbAccess.updateDB(_sql);
    }
    
    public boolean createDepartmentUser(String bu_id, String d_code, boolean ud_isadmin) {
        int flag = (ud_isadmin == true) ? 1 : 0;
        _sql = "INSERT INTO user_department VALUES ('"
                +  bu_id + "', '" + d_code + "' , " + flag + ")";
        return _dbAccess.updateDB(_sql);
    }
    
    /**
     * WARNING: you need to delete child dependences first before
     * deleting a department
     * @param d_code
     * @return
     */
    public boolean removeDepartment(String d_code) {
        _sql = "DELETE FROM department "
                + "WHERE d_code = '" + d_code + "'";
        return _dbAccess.updateDB(_sql);
    }
    
    public boolean removeDepartmentUser(String bu_id, String d_code) {
        _sql = "DELETE FROM user_department "
                + "WHERE bu_id = '" + bu_id + "' "
                + "AND d_code = '" + d_code + "'";
        return _dbAccess.updateDB(_sql);
    }
    
}
