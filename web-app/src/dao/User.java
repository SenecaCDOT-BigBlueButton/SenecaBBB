package dao;

import java.util.ArrayList;
import java.util.HashMap;

import db.DBQuery;

public class User {
    private DBQuery _dbQuery = null;
    private String _query = null;

    public User() {
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
    
    public boolean getHash(ArrayList<ArrayList<String>> result, String bu_id) {
        _query = "SELECT non_ldap_user.nu_hash "
                + "FROM non_ldap_user "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbQuery.queryDB(result, _query);
    }

    public boolean getSalt(ArrayList<ArrayList<String>> result, String bu_id) {
        _query = "SELECT non_ldap_user.nu_salt "
                + "FROM non_ldap_user "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbQuery.queryDB(result, _query);
    }

    public boolean getSaltAndHash(ArrayList<ArrayList<String>> result, String bu_id) {
        _query = "SELECT non_ldap_user.nu_salt, non_ldap_user.nu_hash "
                + "FROM non_ldap_user "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbQuery.queryDB(result, _query);
    }

    /**
     * Getting all data of all bbb_users
     * Fields:
     * (0)bu_id (1)bu_nick (2)bu_isbanned (3)bu_isactive (4)bu_comment (5)bu_lastlogin (6)bu_isldap (7)bu_issuper
     * (8)ur_id (9)bu_setting (10)m_setting (11)nu_name (12)nu_lastname (13)nu_email (14)nu_createtime
     * (15)pr_name (16)ur_rolemask 
     * @param result
     * @return
     */
    public boolean getUserInfo(ArrayList<ArrayList<String>> result) {
        _query = "SELECT bbb_user.*, non_ldap_user.nu_name, non_ldap_user.nu_lastname, "
                + "non_ldap_user.nu_email, non_ldap_user.nu_createtime, user_role.pr_name, user_role.ur_rolemask "
                + "FROM bbb_user "
                + "LEFT OUTER JOIN non_ldap_user "
                + "ON bbb_user.bu_id = non_ldap_user.bu_id "
                + "INNER JOIN user_role "
                + "ON bbb_user.ur_id = user_role.ur_id "
                + "ORDER BY bbb_user.bu_id";
        return _dbQuery.queryDB(result, _query);
    }
    
    /**
     * Getting all data of all bbb_users limited by page
     * Fields:
     * (0)bu_id (1)bu_nick (2)bu_isbanned (3)bu_isactive (4)bu_comment (5)bu_lastlogin (6)bu_isldap (7)bu_issuper
     * (8)ur_id (9)bu_setting (10)m_setting (11)nu_name (12)nu_lastname (13)nu_email (14)nu_createtime
     * (15)pr_name (16)ur_rolemask 
     * @param result
     * @param page first page is 1
     * @param size
     * @return
     */
    public boolean getUserInfo(ArrayList<ArrayList<String>> result, int page, int size) {
        int start = (page-1)*size;
        _query = "SELECT bbb_user.*, non_ldap_user.nu_name, non_ldap_user.nu_lastname, "
                + "non_ldap_user.nu_email, non_ldap_user.nu_createtime, user_role.pr_name, user_role.ur_rolemask "
                + "FROM bbb_user "
                + "LEFT OUTER JOIN non_ldap_user "
                + "ON bbb_user.bu_id = non_ldap_user.bu_id "
                + "INNER JOIN user_role "
                + "ON bbb_user.ur_id = user_role.ur_id "
                + "ORDER BY bbb_user.bu_id "
                + "LIMIT " + start + "," + size;
        return _dbQuery.queryDB(result, _query);
    }
    
    /**
     * Getting all data related to a bbb_user
     * Fields:
     * (0)bu_id (1)bu_nick (2)bu_isbanned (3)bu_isactive (4)bu_comment (5)bu_lastlogin (6)bu_isldap (7)bu_issuper
     * (8)ur_id (9)bu_setting (10)m_setting (11)nu_name (12)nu_lastname (13)nu_email (14)nu_createtime
     * (15)pr_name (16)ur_rolemask 
     * @param result
     * @param bu_id
     * @return
     */
    public boolean getUserInfo(ArrayList<ArrayList<String>> result, String bu_id) {
        _query = "SELECT bbb_user.*, non_ldap_user.nu_name, non_ldap_user.nu_lastname, "
                + "non_ldap_user.nu_email, non_ldap_user.nu_createtime, user_role.pr_name, user_role.ur_rolemask "
                + "FROM bbb_user "
                + "LEFT OUTER JOIN non_ldap_user "
                + "ON bbb_user.bu_id = non_ldap_user.bu_id "
                + "INNER JOIN user_role "
                + "ON bbb_user.ur_id = user_role.ur_id "
                + "WHERE bbb_user.bu_id = '" + bu_id + "'";
        return _dbQuery.queryDB(result, _query);
    }
    
    public boolean getName(ArrayList<ArrayList<String>> result, String bu_id) {
        _query = "SELECT nu_name "
                + "FROM non_ldap_user "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbQuery.queryDB(result, _query);
    }
    
    public boolean getLastName(ArrayList<ArrayList<String>> result, String bu_id) {
        _query = "SELECT nu_lastname "
                + "FROM non_ldap_user "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbQuery.queryDB(result, _query);
    }
    
    public boolean getNickName(ArrayList<ArrayList<String>> result, String bu_id) {
        _query = "SELECT bu_nick "
                + "FROM bbb_user "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbQuery.queryDB(result, _query);
    }
    
    public boolean getRoleName(ArrayList<ArrayList<String>> result, String bu_id) {
        _query = "SELECT user_role.pr_name "
                + "FROM user_role "
                + "INNER JOIN bbb_user "
                + "ON user_role.ur_id = bbb_user.ur_id "
                + "WHERE bbb_user.bu_id = '" + bu_id + "'";
        return _dbQuery.queryDB(result, _query);
    }
    
    public boolean getDepartment(ArrayList<ArrayList<String>> result, String bu_id) {
        _query = "SELECT department.d_code, department.d_name "
                + "FROM department "
                + "INNER JOIN user_department "
                + "ON department.d_code = user_department.d_code "
                + "WHERE user_department.bu_id = '" + bu_id + "'";
        return _dbQuery.queryDB(result, _query);
    }
    
    public boolean getUserSetting(ArrayList<ArrayList<String>> result, String bu_id) {
        _query = "SELECT bu_setting "
                + "FROM bbb_user "
                + "WHERE bu_id = '" + bu_id + "'";
        boolean flag =_dbQuery.queryDB(result, _query);
        return flag;
    }
    
    public boolean getUserMeetingSetting(HashMap<String, Integer> result, String bu_id) {
        _query = "SELECT m_setting "
                + "FROM bbb_user "
                + "WHERE bu_id = '" + bu_id + "'";
        ArrayList<ArrayList<String>> tempResult = new ArrayList<ArrayList<String>>();
        boolean flag =_dbQuery.queryDB(tempResult, _query);
        int value = Integer.valueOf(tempResult.get(0).get(0)).intValue();
        
        return flag;
    }
    
}
