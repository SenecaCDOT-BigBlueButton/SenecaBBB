package dao;

import java.util.ArrayList;
import db.DBAccess;
import references.settings;

/**
 * For the parameters, please use DB column names
 * Example: setNickName(String bu_id, String bu_nick) 
 *          bu_id and bu_nick are both DB column names        
 * @author
 *
 */
public class Meeting {
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
     * the following are query (SELECT) classes
     * that begin with 'get' or 'is'
     * Examples:
     *  getHash
     *  isActive 
     */

    public boolean getMeetingInfo(ArrayList<ArrayList<String>> result, String ms_id, String m_id) {
        _sql = "SELECT meeting.*, meeting_presentation.mp_title "
                + "FROM meeting "
                + "INNER JOIN meeting_presentation " 
                + "ON meeting.ms_id = meeting_presentation.ms_id "
                + "AND meeting.m_id = meeting_presentation.m_id "
                + "WHERE meeting.ms_id = '" + ms_id + "' "
                + "AND meeting.m_id = '" + m_id + "'";
        return _dbAccess.queryDB(result, _sql);
    }
    
    public boolean getMeetingInfo(ArrayList<ArrayList<String>> result) {
        _sql = "SELECT meeting.*, meeting_presentation.mp_title "
                + "FROM meeting "
                + "INNER JOIN meeting_presentation " 
                + "ON meeting.ms_id = meeting_presentation.ms_id "
                + "AND meeting.m_id = meeting_presentation.m_id";
        return _dbAccess.queryDB(result, _sql);
    }
}
