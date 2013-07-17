package dao;

import java.util.ArrayList;
import java.util.HashMap;

import db.DBAccess;
import references.settings;

public class User {
    private DBAccess _dbAccess = null;
    private String _sql = null;

    public User(DBAccess source) {
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

    public boolean getHash(ArrayList<ArrayList<String>> result, String bu_id) {
        _sql = "SELECT non_ldap_user.nu_hash "
                + "FROM non_ldap_user "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    public boolean getSalt(ArrayList<ArrayList<String>> result, String bu_id) {
        _sql = "SELECT non_ldap_user.nu_salt "
                + "FROM non_ldap_user "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    public boolean getSaltAndHash(ArrayList<ArrayList<String>> result, String bu_id) {
        _sql = "SELECT non_ldap_user.nu_salt, non_ldap_user.nu_hash "
                + "FROM non_ldap_user "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.queryDB(result, _sql);
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
        _sql = "SELECT bbb_user.*, non_ldap_user.nu_name, non_ldap_user.nu_lastname, "
                + "non_ldap_user.nu_email, non_ldap_user.nu_createtime, user_role.pr_name, user_role.ur_rolemask "
                + "FROM bbb_user "
                + "LEFT OUTER JOIN non_ldap_user "
                + "ON bbb_user.bu_id = non_ldap_user.bu_id "
                + "INNER JOIN user_role "
                + "ON bbb_user.ur_id = user_role.ur_id "
                + "ORDER BY bbb_user.bu_id";
        return _dbAccess.queryDB(result, _sql);
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
        _sql = "SELECT bbb_user.*, non_ldap_user.nu_name, non_ldap_user.nu_lastname, "
                + "non_ldap_user.nu_email, non_ldap_user.nu_createtime, user_role.pr_name, user_role.ur_rolemask "
                + "FROM bbb_user "
                + "LEFT OUTER JOIN non_ldap_user "
                + "ON bbb_user.bu_id = non_ldap_user.bu_id "
                + "INNER JOIN user_role "
                + "ON bbb_user.ur_id = user_role.ur_id "
                + "ORDER BY bbb_user.bu_id "
                + "LIMIT " + start + "," + size;
        return _dbAccess.queryDB(result, _sql);
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
        _sql = "SELECT bbb_user.*, non_ldap_user.nu_name, non_ldap_user.nu_lastname, "
                + "non_ldap_user.nu_email, non_ldap_user.nu_createtime, user_role.pr_name, user_role.ur_rolemask "
                + "FROM bbb_user "
                + "LEFT OUTER JOIN non_ldap_user "
                + "ON bbb_user.bu_id = non_ldap_user.bu_id "
                + "INNER JOIN user_role "
                + "ON bbb_user.ur_id = user_role.ur_id "
                + "WHERE bbb_user.bu_id = '" + bu_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    public boolean getName(ArrayList<ArrayList<String>> result, String bu_id) {
        _sql = "SELECT nu_name "
                + "FROM non_ldap_user "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    public boolean getLastName(ArrayList<ArrayList<String>> result, String bu_id) {
        _sql = "SELECT nu_lastname "
                + "FROM non_ldap_user "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    public boolean getNickName(ArrayList<ArrayList<String>> result, String bu_id) {
        _sql = "SELECT bu_nick "
                + "FROM bbb_user "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    public boolean getRoleName(ArrayList<ArrayList<String>> result, String bu_id) {
        _sql = "SELECT user_role.pr_name "
                + "FROM user_role "
                + "INNER JOIN bbb_user "
                + "ON user_role.ur_id = bbb_user.ur_id "
                + "WHERE bbb_user.bu_id = '" + bu_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    public boolean getDepartment(ArrayList<ArrayList<String>> result, String bu_id) {
        _sql = "SELECT department.d_code, department.d_name "
                + "FROM department "
                + "INNER JOIN user_department "
                + "ON department.d_code = user_department.d_code "
                + "WHERE user_department.bu_id = '" + bu_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    public boolean getUserSetting(HashMap<String, Integer> result, String bu_id) {
        _sql = "SELECT bu_setting "
                + "FROM bbb_user "
                + "WHERE bu_id = '" + bu_id + "'";
        ArrayList<ArrayList<String>> tempResult = new ArrayList<ArrayList<String>>();
        boolean flag =_dbAccess.queryDB(tempResult, _sql);
        if (flag) {
            int value = Integer.valueOf(tempResult.get(0).get(0)).intValue();
            result.clear();
            result.put(settings.bu_setting[0], (value & (1<<2)) == 0 ? 0:1);
            result.put(settings.bu_setting[1], (value & (1<<1)) == 0 ? 0:1);
            result.put(settings.bu_setting[2], (value & 1) == 0 ? 0:1);
        }
        return flag;
    }

    public boolean getUserMeetingSetting(HashMap<String, Integer> result, String bu_id) {
        _sql = "SELECT m_setting "
                + "FROM bbb_user "
                + "WHERE bu_id = '" + bu_id + "'";
        ArrayList<ArrayList<String>> tempResult = new ArrayList<ArrayList<String>>();
        boolean flag =_dbAccess.queryDB(tempResult, _sql);
        if (flag) {
            int value = Integer.valueOf(tempResult.get(0).get(0)).intValue();
            result.clear();
            result.put(settings.meeting_setting[0], (value & (1<<6)) == 0 ? 0:1);
            result.put(settings.meeting_setting[1], (value & (1<<5)) == 0 ? 0:1);
            result.put(settings.meeting_setting[2], (value & (1<<4)) == 0 ? 0:1);
            result.put(settings.meeting_setting[3], (value & (1<<3)) == 0 ? 0:1);
            result.put(settings.meeting_setting[4], (value & (1<<2)) + (value & (1<<1)) + (value & 1));
        }
        return flag;
    }

    public boolean getSectionSetting(HashMap<String, Integer> result, String bu_id) {
        _sql = "SELECT sc_setting "
                + "FROM professor "
                + "WHERE bu_id = '" + bu_id + "'";
        ArrayList<ArrayList<String>> tempResult = new ArrayList<ArrayList<String>>();
        boolean flag =_dbAccess.queryDB(tempResult, _sql);
        if (flag) {
            int value = Integer.valueOf(tempResult.get(0).get(0)).intValue();
            result.clear();
            result.put(settings.section_setting[0], (value & (1<<6)) == 0 ? 0:1);
            result.put(settings.section_setting[1], (value & (1<<5)) == 0 ? 0:1);
            result.put(settings.section_setting[2], (value & (1<<4)) == 0 ? 0:1);
            result.put(settings.section_setting[3], (value & (1<<3)) == 0 ? 0:1);
            result.put(settings.section_setting[4], (value & (1<<2)) + (value & (1<<1)) + (value & 1));
        }
        return flag;
    }

    public boolean getLastLogin(ArrayList<ArrayList<String>> result, String bu_id) {
        _sql = "SELECT bu_lastlogin "
                + "FROM bbb_user "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    public boolean isActive(ArrayList<ArrayList<String>> result, String bu_id) {
        _sql = "SELECT bu_isactive "
                + "FROM bbb_user "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    public boolean isBannedFromSection(ArrayList<ArrayList<String>> result, String bu_id, String c_id, String sc_id, String sc_semesterid) {
        _sql = "SELECT s_isbanned "
                + "FROM student "
                + "WHERE bu_id = '" + bu_id + "' "
                + "AND c_id = '" + c_id + "' "
                + "AND sc_id = '" + sc_id + "' "
                + "AND sc_semesterid = '" + sc_semesterid + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    public boolean isBannedFromSystem(ArrayList<ArrayList<String>> result, String bu_id) {
        _sql = "SELECT bu_isbanned "
                + "FROM bbb_user "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    public boolean getComment(ArrayList<ArrayList<String>> result, String bu_id) {
        _sql = "SELECT bu_comment "
                + "FROM bbb_user "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    public boolean isSuperAdmin(ArrayList<ArrayList<String>> result, String bu_id) {
        _sql = "SELECT bu_issuper "
                + "FROM bbb_user "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    public boolean isDepartmentAdmin(ArrayList<ArrayList<String>> result, String bu_id, String d_code) {
        _sql = "SELECT ud_isadmin "
                + "FROM user_department "
                + "WHERE bu_id = '" + bu_id + "' "
                + "AND d_code = '" + d_code + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    /** 
     * the following are UPDATE Query classes
     */

    public boolean setSalt(String bu_id, String nu_salt) {
        _sql = "UPDATE non_ldap_user "
                + "SET nu_salt = '" + nu_salt +"' "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.updateDB(_sql);
    }
}
