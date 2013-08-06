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
public class Meeting implements Sql {
    private DBAccess _dbAccess = null;
    private String _sql = null;

    public Meeting(DBAccess source) {
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
     * Getting all data on a particular meeting
     * Fields:
     * (0)ms_id (1)m_id (2)m_inidatetime (3)m_duration (4)m_iscancel (5)m_description (6)m_modpass (7)m_userpass
     * (8)m_setting(meeting)
     * @param result
     * @param ms_id
     * @param m_id
     * @return
     */
    public boolean getMeetingInfo(ArrayList<ArrayList<String>> result, int ms_id, int m_id) {
        _sql = "SELECT meeting.* "
                + "FROM meeting "
                + "WHERE meeting.ms_id = " + ms_id + " "
                + "AND meeting.m_id = " + m_id;
        return _dbAccess.queryDB(result, _sql);
    }
    
    /**
     * Getting all data of all meetings
     * Fields:
     * (0)ms_id (1)m_id (2)m_inidatetime (3)m_duration (4)m_iscancel (5)m_description (6)m_modpass (7)m_userpass
     * (8)m_setting(meeting) 
     * @param result
     * @return
     */
    public boolean getMeetingInfo(ArrayList<ArrayList<String>> result) {
        _sql = "SELECT meeting.* "
                + "FROM meeting";
        return _dbAccess.queryDB(result, _sql);
    }
    
    /**
     * (0)m_description
     * @param result
     * @param ms_id
     * @param m_id
     * @return
     */
    public boolean getMeetingDescription(ArrayList<ArrayList<String>> result, int ms_id, int m_id) {
        _sql = "SELECT m_description "
                + "FROM meeting "
                + "WHERE ms_id = " + ms_id + " "
                + "AND m_id = " + m_id;
        return _dbAccess.queryDB(result, _sql);
    }
    
    /**
     * (0)m_inidatetime
     * @param result
     * @param ms_id
     * @param m_id
     * @return
     */
    public boolean getMeetingInitialDatetime(ArrayList<ArrayList<String>> result, int ms_id, int m_id) {
        _sql = "SELECT m_inidatetime "
                + "FROM meeting "
                + "WHERE ms_id = " + ms_id + " "
                + "AND m_id = " + m_id;
        return _dbAccess.queryDB(result, _sql);
    }
    
    /**
     * (0)m_duration
     * @param result
     * @param ms_id
     * @param m_id
     * @return
     */
    public boolean getMeetingDuration(ArrayList<ArrayList<String>> result, int ms_id, int m_id) {
        _sql = "SELECT m_duration "
                + "FROM meeting "
                + "WHERE ms_id = " + ms_id + " "
                + "AND m_id = " + m_id;
        return _dbAccess.queryDB(result, _sql);
    } 
    
    /**
     * (0)m_iscancel
     * @param result
     * @param ms_id
     * @param m_id
     * @return
     */
    public boolean getIsMeetingCancelled(ArrayList<ArrayList<String>> result, int ms_id, int m_id) {
        _sql = "SELECT m_iscancel "
                + "FROM meeting "
                + "WHERE ms_id = " + ms_id + " "
                + "AND m_id = " + m_id;
        return _dbAccess.queryDB(result, _sql);
    }
    
    /**
     * (0)m_modpass
     * @param result
     * @param ms_id
     * @param m_id
     * @return
     */
    public boolean getMeetingModPass(ArrayList<ArrayList<String>> result, int ms_id, int m_id) {
        _sql = "SELECT m_modpass "
                + "FROM meeting "
                + "WHERE ms_id = " + ms_id + " "
                + "AND m_id = " + m_id;
        return _dbAccess.queryDB(result, _sql);
    }
    
    /**
     * (0)m_userpass
     * @param result
     * @param ms_id
     * @param m_id
     * @return
     */
    public boolean getMeetingUserPass(ArrayList<ArrayList<String>> result, int ms_id, int m_id) {
        _sql = "SELECT m_userpass "
                + "FROM meeting "
                + "WHERE ms_id = " + ms_id + " "
                + "AND m_id = " + m_id;
        return _dbAccess.queryDB(result, _sql);
    }
    
    public boolean createMeeting(int ms_id, int m_id, String inidatetime, 
            int m_duration, String m_description, String m_modpass, String m_userpass) {
        return _dbAccess.updateDB(_sql);
    }
}
