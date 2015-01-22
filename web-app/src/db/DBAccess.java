package db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import helper.GetExceptionLog;

/**
 * One DBAccess object is created per session by using Bean:
 * <jsp:useBean id="db" scope="session" class="db.DBAccess" />
 * each dao object takes the DBAccess object into its constructor
 * @author Bo Li
 *
 */
public class DBAccess {
    private DBConnection _db = null;
    private PreparedStatement _stmt = null;
    private ResultSet _rs = null;
    private Connection _conn = null;
    private String _errCode = null;
    private String _errLog = null; 
    
    GetExceptionLog elog = new GetExceptionLog();

    public DBAccess() {
        _db = DBConnection.getInstance();
    }
    
    /** Use this method if you need to reestablish connection */
    public boolean openConnection() {
        _conn = _db.getConnectionFromPool();
        return (_conn != null);
    }
   
    public void closeConnection() {
        try {
            if (_stmt != null) { 
                _stmt.close();
            }
            if (_rs != null) {
                _rs.close();
            }
            if (_conn != null) {
                _conn.close();
            }
        } catch (SQLException e) {
            _errLog += "\nSQLException: failed to close Connection";
            elog.writeLog("[closeDBconnection:] " + e.getErrorCode() + "-" + e.getMessage() + "/n"+ e.getStackTrace().toString());           
        }
    }
    
    public String getErrLog() {
        return _errLog;
    }
    
    public String getErrCode() {
        return _errCode;
    }
    
    /**
     * Executes all queries<p>
     * Note that once _flag is set to false, it must be manually set back to
     * true by the resetFlag() function before further SQL statement can be executed 
     * @param result
     * @param query
     * @return
     */
    public boolean queryDB(ArrayList<HashMap<String, String>> result, String query) {
        result.clear();
        try {
            openConnection();
            _stmt = _conn.prepareStatement(query);
            _rs = _stmt.executeQuery();
            int colCount = _rs.getMetaData().getColumnCount();                    
            while (_rs.next()) {
                HashMap<String, String> row = new HashMap<String, String>();
                for (int i=1; i<=colCount; i++) {
                    row.put(_rs.getMetaData().getColumnName(i), _rs.getString(i));
                }
                result.add(row);
            }
        } catch (SQLException e) {
            _errCode = Integer.toString(e.getErrorCode());
            _errLog = e.getMessage();
            elog.writeLog("[queryDB:] " + _errCode + "-" + _errLog + "/n"+ e.getStackTrace().toString());                    
        } finally {
            closeConnection();
        }
        return true;
    }
    
    /**
     * Execute SQL Data Manipulation Language (DML) statement, 
     * such as INSERT, UPDATE or DELETE; or an SQL statement that returns nothing, 
     * such as a DDL statements<p>
     * Note that once _flag is set to false, it must be manually set back to
     * true by the resetFlag() function before further SQL statement can be executed 
     * @param statement
     * @return
     */
    public boolean updateDB(String statement) {
        try {
            openConnection();
            _stmt = _conn.prepareStatement(statement);
            _stmt.executeUpdate();
        } catch (SQLException e) {
            _errCode = Integer.toString(e.getErrorCode());
            _errLog = e.getMessage();
            elog.writeLog("[updateDB:] " + _errCode + "-" + _errLog + "/n"+ e.getStackTrace().toString());                   
        } finally {
            closeConnection();
        }
        return true;
    }
    
    public boolean getFlagStatus() {
        return true;
    }
    
}
