package dao;

import java.util.ArrayList;
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
    
    public boolean getSaltAndHash(ArrayList<ArrayList<String>> result, String bu_id) {
        _query = "SELECT non_ldap_user.nu_salt, non_ldap_user.nu_hash "
                + "FROM non_ldap_user "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbQuery.queryDB(result, _query);
    }
}
