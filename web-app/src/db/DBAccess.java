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
    private boolean _flag = true; 
    
    GetExceptionLog elog = new GetExceptionLog();
    //private ArrayList<Connection> toClose; 

    public DBAccess() {
        //toClose = new ArrayList<Connection>();
        _db = DBConnection.getInstance();
    }
    
    /** Use this method if you need to reestablish connection */
    public boolean openConnection() {
        _conn = _db.openConnection();
        return (_conn != null);
    }
   
    public boolean closeConnection() {
        boolean flag = true;
        try {
            if (_stmt != null) { 
                _stmt.close();
            }
            if (_rs != null) {
                _rs.close();
            }
            if (_conn != null) {
                //toClose.add(_conn);
                _conn.close();
            }
        }
        catch (SQLException e) {
            flag = false;
            _errLog += "\nSQLException: failed to close Connection";
            elog.writeLog("[closeDBconnection:] " + e.getErrorCode() + "-" + e.getMessage() + "/n"+ e.getStackTrace().toString());           
        }
        return flag;
    }

    /*public void closeALL() {
        for(int i = 0; i<toClose.size(); i++) {
            try {
                toClose.get(i).close();
            } catch (SQLException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
    }*/
    
    public String getErrLog() {
        return _errLog;
    }
    
    public String getErrCode() {
        return _errCode;
    }
    
    /**
     * This MUST be called after an error is caught,
     * else no other SQL statements would run
     * @return
     */
    public boolean resetFlag() {
        _flag = true;
        return _flag;
    }

    /**
     * Executes all queries<p>
     * Note that once _flag is set to false, it must be manually set back to
     * true by the resetFlag() function before further SQL statement can be executed 
     * @param result
     * @param query
     * @return
     */
    public boolean queryDB2(ArrayList<HashMap<String, String>> result, String query) {
        result.clear();
        if(_flag) { //statement do no execute if there is previous error
            _flag = openConnection();
            if (!_flag) { //check connection error
                _errCode = _db.getErrCode();
                _errLog = _db.getErrLog();
            }
            else {
                try {
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
                }
                catch (SQLException e) {
                    _errCode = Integer.toString(e.getErrorCode());
                    _errLog = e.getMessage();
                    _flag = false;
                    elog.writeLog("[queryDB:] " + _errCode + "-" + _errLog + "/n"+ e.getStackTrace().toString());                    
                }
                finally {
                    _flag = closeConnection() && _flag; 
                }
            }
        }
        return _flag;
    }
    
    /**
     * Executes all queries<p>
     * Note that once _flag is set to false, it must be manually set back to
     * true by the resetFlag() function before further SQL statement can be executed 
     * @param result
     * @param query
     * @return
     */
//    public boolean queryDB(ArrayList<ArrayList<String>> result, String query) {
//        result.clear();
//        if(_flag) { //statement do no execute if there is previous error
//            _flag = openConnection();
//            if (!_flag) { //check connection error
//                _errCode = _db.getErrCode();
//                _errLog = _db.getErrLog();
//            }
//            else {
//                try {
//                    _stmt = _conn.prepareStatement(query);
//                    _rs = _stmt.executeQuery();
//                    int colCount = _rs.getMetaData().getColumnCount();
//                    while (_rs.next()) {
//                        ArrayList<String> row = new ArrayList<String>();
//                        for (int i=1; i<=colCount; i++) {
//                            row.add(_rs.getString(i));
//                        }
//                        result.add(row);
//                    }
//                }
//                catch (SQLException e) {
//                    _errCode = Integer.toString(e.getErrorCode());
//                    _errLog = e.getMessage();
//                    _flag = false;
//                    elog.writeLog("[queryDB:] " + _errCode + "-" + _errLog + "/n"+ e.getStackTrace().toString());                    
//                }
//                finally {
//                    _flag = closeConnection() && _flag; 
//                }
//            }
//        }
//        return _flag;
//    }
    
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
        if(_flag) { //statement do no execute if there is previous error
            _flag = openConnection();
            if (!_flag) {
                _errCode = _db.getErrCode();
                _errLog = _db.getErrLog();
            }
            else {
                try {
                    _stmt = _conn.prepareStatement(statement);
                    _stmt.executeUpdate();
                }
                catch (SQLException e) {
                    _errCode = Integer.toString(e.getErrorCode());
                    _errLog = e.getMessage();
                    _flag = false;
                    elog.writeLog("[updateDB:] " + _errCode + "-" + _errLog + "/n"+ e.getStackTrace().toString());                   
                }
                finally {
                    _flag = closeConnection() && _flag; 
                }
            }
        }
        return _flag;
    }
    
    public boolean getFlagStatus() {
        return _flag;
    }
}
