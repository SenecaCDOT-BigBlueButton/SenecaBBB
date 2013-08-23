package sql;


import helper.*;

import java.util.ArrayList;
import java.util.HashMap;


import db.DBAccess;

/**
 * For the parameters, please use DB column names
 * Example: setNickName(String bu_id, String bu_nick) 
 *          bu_id and bu_nick are both DB column names        
 * @author Bo Li
 *
 */
public class User implements Sql {
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
     * the following are query (SELECT) methods
     * that begin with 'get'
     */

    /**
     * Fields:
     * (0)nu_hash
     * @param result
     * @param bu_id
     * @return
     */
    public boolean getHash(ArrayList<ArrayList<String>> result, String bu_id) {
        _sql = "SELECT non_ldap_user.nu_hash "
                + "FROM non_ldap_user "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    /**
     * Fields:
     * (0)nu_salt
     * @param result
     * @param bu_id
     * @return
     */
    public boolean getSalt(ArrayList<ArrayList<String>> result, String bu_id) {
        _sql = "SELECT non_ldap_user.nu_salt "
                + "FROM non_ldap_user "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    /**
     * (0)nu_salt (1)nu_hash
     * @param result
     * @param bu_id
     * @return
     */
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
     * (8)ur_id (9)bu_setting (10)bbb_user.m_setting (11)nu_name (12)nu_lastname (13)nu_email (14)nu_createtime
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
     * (8)ur_id (9)bu_setting (10)bbb_user.m_setting (11)nu_name (12)nu_lastname (13)nu_email (14)nu_createtime
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
     * (8)ur_id (9)bu_setting (10)bbb_user.m_setting (11)nu_name (12)nu_lastname (13)nu_email (14)nu_createtime
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

    /**
     * Fields:
     * (0)nu_name
     * @param result
     * @param bu_id
     * @return
     */
    public boolean getName(ArrayList<ArrayList<String>> result, String bu_id) {
        _sql = "SELECT nu_name "
                + "FROM non_ldap_user "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    /**
     * Fields:
     * (0)nu_lastname
     * @param result
     * @param bu_id
     * @return
     */
    public boolean getLastName(ArrayList<ArrayList<String>> result, String bu_id) {
        _sql = "SELECT nu_lastname "
                + "FROM non_ldap_user "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    /**
     * Fields:
     * (0)bu_nick
     * @param result
     * @param bu_id
     * @return
     */
    public boolean getNickName(ArrayList<ArrayList<String>> result, String bu_id) {
        _sql = "SELECT bu_nick "
                + "FROM bbb_user "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    /**
     * Fields:
     * (0)ur_id (1)pr_name
     * @param result
     * @param bu_id
     * @return
     */
    public boolean getRoleInfo(ArrayList<ArrayList<String>> result, String bu_id) {
        _sql = "SELECT user_role.ur_id, user_role.pr_name "
                + "FROM user_role "
                + "INNER JOIN bbb_user "
                + "ON user_role.ur_id = bbb_user.ur_id "
                + "WHERE bbb_user.bu_id = '" + bu_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    /**
     * (0)d_code, (1)d_name
     * @param result
     * @param bu_id
     * @return
     */
    public boolean getDepartment(ArrayList<ArrayList<String>> result, String bu_id) {
        _sql = "SELECT department.d_code, department.d_name "
                + "FROM department "
                + "INNER JOIN user_department "
                + "ON department.d_code = user_department.d_code "
                + "WHERE user_department.bu_id = '" + bu_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    /**
     * (0)bu_lastlogin
     * @param result
     * @param bu_id
     * @return
     */
    public boolean getLastLogin(ArrayList<ArrayList<String>> result, String bu_id) {
        _sql = "SELECT bu_lastlogin "
                + "FROM bbb_user "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    /**
     * (0)bu_isactive
     * @param result
     * @param bu_id
     * @return
     */
    public boolean getIsActive(ArrayList<ArrayList<String>> result, String bu_id) {
        _sql = "SELECT bu_isactive "
                + "FROM bbb_user "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    /**
     * (0)s_isbanned
     * @param result
     * @param bu_id
     * @param c_id
     * @param sc_id
     * @param sc_semesterid
     * @return
     */
    public boolean getIsBannedFromSection(ArrayList<ArrayList<String>> result, 
            String bu_id, String c_id, String sc_id, String sc_semesterid) {
        _sql = "SELECT s_isbanned "
                + "FROM student "
                + "WHERE bu_id = '" + bu_id + "' "
                + "AND c_id = '" + c_id + "' "
                + "AND sc_id = '" + sc_id + "' "
                + "AND sc_semesterid = '" + sc_semesterid + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    /**
     * (0)bu_isbanned
     * @param result
     * @param bu_id
     * @return
     */
    public boolean getIsBannedFromSystem(ArrayList<ArrayList<String>> result, String bu_id) {
        _sql = "SELECT bu_isbanned "
                + "FROM bbb_user "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    /**
     * (0)bu_comment
     * @param result
     * @param bu_id
     * @return
     */
    public boolean getComment(ArrayList<ArrayList<String>> result, String bu_id) {
        _sql = "SELECT bu_comment "
                + "FROM bbb_user "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    /**
     * (0)bu_issuper
     * @param result
     * @param bu_id
     * @return
     */
    public boolean getIsSuperAdmin(ArrayList<ArrayList<String>> result, String bu_id) {
        _sql = "SELECT bu_issuper "
                + "FROM bbb_user "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    /**
     * (0)ud_isadmin
     * @param result
     * @param bu_id
     * @param d_code
     * @return
     */
    public boolean getIsDepartmentAdmin(ArrayList<ArrayList<String>> result, String bu_id, String d_code) {
        _sql = "SELECT ud_isadmin "
                + "FROM user_department "
                + "WHERE bu_id = '" + bu_id + "' "
                + "AND d_code = '" + d_code + "'";
        return _dbAccess.queryDB(result, _sql);
    }

    /**
     * get setting methods 
     */
    
    public boolean getUserSetting(HashMap<String, Integer> result, String bu_id) {
        _sql = "SELECT bu_setting "
                + "FROM bbb_user "
                + "WHERE bu_id = '" + bu_id + "'";
        ArrayList<ArrayList<String>> tempResult = new ArrayList<ArrayList<String>>();
        boolean flag =_dbAccess.queryDB(tempResult, _sql);
        if (flag) {
            int value = Integer.valueOf(tempResult.get(0).get(0)).intValue();
            result.clear();
            result.put(Settings.bu_setting[0], (value & (1<<2)) == 0 ? 0:1);
            result.put(Settings.bu_setting[1], (value & (1<<1)) == 0 ? 0:1);
            result.put(Settings.bu_setting[2], (value & 1) == 0 ? 0:1);
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
            result.put(Settings.meeting_setting[0], (value & (1<<6)) == 0 ? 0:1);
            result.put(Settings.meeting_setting[1], (value & (1<<5)) == 0 ? 0:1);
            result.put(Settings.meeting_setting[2], (value & (1<<4)) == 0 ? 0:1);
            result.put(Settings.meeting_setting[3], (value & (1<<3)) == 0 ? 0:1);
            result.put(Settings.meeting_setting[4], (value & (1<<2)) + (value & (1<<1)) + (value & 1));
        }
        return flag;
    }

    public boolean getSectionSetting(HashMap<String, Integer> result, 
            String bu_id, String c_id, String sc_id, String sc_semesterid) {
        _sql = "SELECT sc_setting "
                + "FROM professor "
                + "WHERE bu_id = '" + bu_id + "' "
                + "AND c_id = '" + c_id + "' "
                + "AND sc_id = '" + sc_id + "' "
                + "AND sc_semesterid = '" + sc_semesterid + "'";
        ArrayList<ArrayList<String>> tempResult = new ArrayList<ArrayList<String>>();
        boolean flag =_dbAccess.queryDB(tempResult, _sql);
        if (flag) {
            int value = Integer.valueOf(tempResult.get(0).get(0)).intValue();
            result.clear();
            result.put(Settings.section_setting[0], (value & (1<<6)) == 0 ? 0:1);
            result.put(Settings.section_setting[1], (value & (1<<5)) == 0 ? 0:1);
            result.put(Settings.section_setting[2], (value & (1<<4)) == 0 ? 0:1);
            result.put(Settings.section_setting[3], (value & (1<<3)) == 0 ? 0:1);
            result.put(Settings.section_setting[4], (value & (1<<2)) + (value & (1<<1)) + (value & 1));
        }
        return flag;
    }

    public boolean getUserRoleSetting(HashMap<String, Integer> result, int ur_id) {
        _sql = "SELECT ur_rolemask "
                + "FROM user_role "
                + "WHERE ur_id = " + ur_id;
        ArrayList<ArrayList<String>> tempResult = new ArrayList<ArrayList<String>>();
        boolean flag =_dbAccess.queryDB(tempResult, _sql);
        if (flag) {
            int value = Integer.valueOf(tempResult.get(0).get(0)).intValue();
            result.clear();
            result.put(Settings.ur_rolemask[0], (value & (1<<1)) == 0 ? 0:1);
            result.put(Settings.ur_rolemask[1], (value & 1) == 0 ? 0:1);
        }
        return flag;
    }
    
    /*public boolean setDepartmentInfo(String d_code_old, String d_code_new, String d_name) {
        _sql = "UPDATE department "
                + "SET d_code = '" +  d_code_new + "', "
                + "d_name='" + d_name + "' "
                + "WHERE d_code = '" + d_code_old + "'";
        return _dbAccess.updateDB(_sql);
    }*/
    
    /**
     * the following queries used to test the exist of a value in a table
     * these methods begin with 'is'
     * WARNING: the return boolean value is the first parameter (boolean result)
     * NOT the method return boolean value, which is used to determine the success/failure of SQL execution
     */
    
    public boolean isProfessor(MyBoolean bool, String bu_id) {
        _sql = "SELECT 1 "
                + "FROM professor "
                + "WHERE bu_id = '" + bu_id + "' "
                + "LIMIT 1";
        ArrayList<ArrayList<String>> tempResult = new ArrayList<ArrayList<String>>();
        boolean flag =_dbAccess.queryDB(tempResult, _sql);
        if (flag) {
            bool.set_value(tempResult.isEmpty() ? false : true);
        }
        return flag;
    }
    
    public boolean isUser(MyBoolean bool, String bu_id) {
        _sql = "SELECT 1 "
                + "FROM bbb_user "
                + "WHERE bu_id = '" + bu_id + "' "
                + "LIMIT 1";
        ArrayList<ArrayList<String>> tempResult = new ArrayList<ArrayList<String>>();
        boolean flag =_dbAccess.queryDB(tempResult, _sql);
        if (flag) {
            bool.set_value(tempResult.isEmpty() ? false : true);
        }
        return flag;
    }
    
    /**
     * the following are UPDATE methods that begin wih 'default'
     */
    
    public boolean defaultUserSetting(String bu_id) {
        _sql = "UPDATE bbb_user as a "
                + "CROSS JOIN (SELECT key_value FROM bbb_admin WHERE key_name='default_user') as b "
                + "SET a.bu_setting = b.key_value "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.updateDB(_sql);   
    }

    public boolean defaultUserMeetingSetting(String bu_id) {
        _sql = "UPDATE bbb_user as a "
                + "CROSS JOIN (SELECT key_value FROM bbb_admin WHERE key_name='default_meeting') as b "
                + "SET a.m_setting = b.key_value "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.updateDB(_sql);   
    }

    public boolean defaultSectionSetting(String bu_id, String c_id, String sc_id, String sc_semesterid) {
        _sql = "UPDATE professor as a "
                + "CROSS JOIN (SELECT key_value FROM bbb_admin WHERE key_name='default_class') as b "
                + "SET a.sc_setting = b.key_value "
                + "WHERE bu_id = '" + bu_id + "' "
                + "AND c_id = '" + c_id + "' "
                + "AND sc_id = '" + sc_id + "' "
                + "AND sc_semesterid = '" + sc_semesterid + "'";
        return _dbAccess.updateDB(_sql);   
    }
    
    public boolean defaultUserRoleSetting(int ur_id) {
        _sql = "UPDATE user_role as a "
                + "CROSS JOIN (SELECT * FROM predefined_role) as b "
                + "SET a.ur_rolemask = b.pr_defaultmask "
                + "WHERE a.ur_id = " + ur_id + " "
                + "AND a.pr_name = b.pr_name";
        return _dbAccess.updateDB(_sql);   
    }
    

    /**
     * the following are UPDATE methods that begin with 'set'
     */
    
    public boolean setUserSetting(HashMap<String, Integer> map, String bu_id) {
        int value;
        value = (map.get(Settings.bu_setting[0]) << 2)
                + (map.get(Settings.bu_setting[1]) << 1)
                + (map.get(Settings.bu_setting[2]));
        _sql = "UPDATE bbb_user "
                + "SET bu_setting = " + value + " "
                + "WHERE bu_id='" + bu_id + "'";
        return _dbAccess.updateDB(_sql);
    }

    public boolean setUserMeetingSetting(HashMap<String, Integer> map, String bu_id) {
        int value;
        value = (map.get(Settings.meeting_setting[0]) << 6)
                + (map.get(Settings.meeting_setting[1]) << 5)
                + (map.get(Settings.meeting_setting[2]) << 4)
                + (map.get(Settings.meeting_setting[3]) << 3)
                + (map.get(Settings.meeting_setting[4]));
        _sql = "UPDATE bbb_user "
                + "SET m_setting = " + value + " "
                + "WHERE bu_id='" + bu_id + "'";
        return _dbAccess.updateDB(_sql);
    }

    public boolean setSectionSetting(HashMap<String, Integer> map, 
            String bu_id, String c_id, String sc_id, String sc_semesterid) {
        int value;
        value = (map.get(Settings.section_setting[0]) << 6)
                + (map.get(Settings.section_setting[1]) << 5)
                + (map.get(Settings.section_setting[2]) << 4)
                + (map.get(Settings.section_setting[3]) << 3)
                + (map.get(Settings.section_setting[4]));
        _sql = "UPDATE professor "
                + "SET sc_setting = " + value + " "
                + "WHERE bu_id = '" + bu_id + "' "
                + "AND c_id = '" + c_id + "' "
                + "AND sc_id = '" + sc_id + "' "
                + "AND sc_semesterid = '" + sc_semesterid + "'";
        return _dbAccess.updateDB(_sql);
    }
    
    public boolean setUserRoleSetting(HashMap<String, Integer> map, int ur_id) {
        int value;
        value = (map.get(Settings.ur_rolemask[0]) << 1)
                + (map.get(Settings.ur_rolemask[1]));
        _sql = "UPDATE user_role "
                + "SET ur_rolemask = " + value + " "
                + "WHERE ur_id=" + ur_id;
        return _dbAccess.updateDB(_sql);
    }

    /** 
     * the following are UPDATE SQL methods
     */

    public boolean setSalt(String bu_id, String nu_salt) {
        _sql = "UPDATE non_ldap_user "
                + "SET nu_salt = '" + nu_salt + "' "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.updateDB(_sql);
    }
    
    public boolean setHash(String bu_id, String nu_hash) {
        _sql = "UPDATE non_ldap_user "
                + "SET nu_hash = '" + nu_hash + "' "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.updateDB(_sql);
    }
    
    public boolean setName(String bu_id, String nu_name) {
        _sql = "UPDATE non_ldap_user "
                + "SET nu_name = '" +  nu_name + "' "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.updateDB(_sql);
    }
    
    public boolean setLastName(String bu_id, String nu_lastname) {
        _sql = "UPDATE non_ldap_user "
                + "SET nu_lastname = '" +  nu_lastname + "' "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.updateDB(_sql);
    }
    
    public boolean setNickName(String bu_id, String bu_nick) {
        _sql = "UPDATE bbb_user "
                + "SET bu_nick = '" +  bu_nick + "' "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.updateDB(_sql);
    }
    
    public boolean setRoleName(String pr_name_old, String pr_name_new) {
        _sql = "UPDATE predefined_role "
                + "SET pr_name = '" +  pr_name_new + "' "
                + "WHERE pr_name = '" + pr_name_old + "'";
        return _dbAccess.updateDB(_sql);
    }
    
    /**
     * Uses the current system time when method called
     * @param bu_id
     * @return
     */
    public boolean setLastLogin(String bu_id) {
        _sql = "UPDATE bbb_user "
                + "SET bu_lastlogin = SYSDATE() "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.updateDB(_sql);
    }
    
    public boolean setActive(String bu_id, boolean bu_isactive) {
        int flag = (bu_isactive == true) ? 1 : 0;
        _sql = "UPDATE bbb_user "
                + "SET bu_isactive = " + flag + " "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.updateDB(_sql);
    }
    
    public boolean setBannedFromSection(
            String bu_id, String c_id, String sc_id, String sc_semesterid, boolean s_isbanned) {
        int flag = (s_isbanned == true) ? 1 : 0;
        _sql = "UPDATE student "
                + "set s_isbanned = " + flag + " "
                + "WHERE bu_id = '" + bu_id + "' "
                + "AND c_id = '" + c_id + "' "
                + "AND sc_id = '" + sc_id + "' "
                + "AND sc_semesterid = '" + sc_semesterid + "'";
        return _dbAccess.updateDB(_sql);
    }
    
    public boolean setBannedFromSystem(String bu_id, boolean bu_isbanned) {
        int flag = (bu_isbanned == true) ? 1 : 0;
        _sql = "UPDATE bbb_user "
                + "set bu_isbanned = " + flag + " "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.updateDB(_sql);
    }
    
    public boolean setComment(String bu_id, String bu_comment) {
        _sql = "UPDATE bbb_user "
                + "SET bu_comment = '" + bu_comment + "' "
                + "WHERE bu_id = '" + bu_id + "'";
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
    
    public boolean setSuperAdmin(String bu_id, boolean bu_issuper) {
        int flag = (bu_issuper == true) ? 1 : 0;
        _sql = "UPDATE bbb_user "
                + "set bu_issuper = " + flag + " "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.updateDB(_sql);
    }
    
    public boolean setUserRole(String bu_id, int ur_id) {
        _sql = "UPDATE bbb_user "
                + "set ur_id = " + ur_id + " "
                + "WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.updateDB(_sql);
    }
    
    /**
     * the following are methods dealing with create or remove user
     */
    
    /**
     * This creates a general LDAP user
     * to create a non-ldap user call this method first (1st part)
     * then call method createNonLdapUser (2nd part)
     * @param bu_id
     * @param bu_comment
     * @param ur_id
     * @return
     */
    public boolean createUser(String bu_id, String bu_comment, boolean bu_isldap, int ur_id) {
        _sql = "INSERT INTO bbb_user " 
                + "VALUES ('" + bu_id + "', '" + bu_id + "', 0, 1, '"
                + bu_comment + "', NULL, " + bu_isldap + ", 0, " + ur_id + ", "
                + "(SELECT key_value FROM bbb_admin WHERE key_name='default_user'), "
                + "(SELECT key_value FROM bbb_admin WHERE key_name='default_meeting'))";
        return _dbAccess.updateDB(_sql);
    }
    
    
    /**
     * 2nd part in creating non-ldap user
     * @param bu_id
     * @param nu_name
     * @param nu_lastname
     * @param nu_salt
     * @param nu_hash
     * @param nu_email
     * @return
     */
    public boolean createNonLdapUser(String bu_id, 
            String nu_name, String nu_lastname, String nu_salt, String nu_hash, String nu_email) {
        _sql = "INSERT INTO non_ldap_user "
                + "VALUES ('" + bu_id + "', '" + nu_name + "', '" + nu_lastname + "', '"
                + nu_salt + "', '" + nu_hash + "', '" + nu_email + "', SYSDATE())";
        return _dbAccess.updateDB(_sql);
    }
    
    /**
     * WARNING: remove user from database
     * @param bu_id
     * @return
     */
    public boolean removeUser(String bu_id) {
        _sql = "DELETE FROM bbb_user WHERE bu_id = '" + bu_id + "'";
        return _dbAccess.updateDB(_sql);
    }
}
