package dao;

import java.util.ArrayList;
import db.DBQuery;

public class Meeting {
    private DBQuery _dbQuery = null;
    private String _query = null;

    public Meeting() {
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

    public boolean getMeetingInfo(ArrayList<ArrayList<String>> result, String ms_id, String m_id) {
        _query = "SELECT meeting.*, meeting_presentation.mp_title "
                + "FROM meeting "
                + "INNER JOIN meeting_presentation " 
                + "ON meeting.ms_id = meeting_presentation.ms_id "
                + "AND meeting.m_id = meeting_presentation.m_id "
                + "WHERE meeting.ms_id = '" + ms_id + "' "
                + "AND meeting.m_id = '" + m_id + "'";
        return _dbQuery.queryDB(result, _query);
    }
    
    public boolean getMeetingInfo(ArrayList<ArrayList<String>> result) {
        _query = "SELECT meeting.*, meeting_presentation.mp_title "
                + "FROM meeting "
                + "INNER JOIN meeting_presentation " 
                + "ON meeting.ms_id = meeting_presentation.ms_id "
                + "AND meeting.m_id = meeting_presentation.m_id";
        return _dbQuery.queryDB(result, _query);
    }
}
