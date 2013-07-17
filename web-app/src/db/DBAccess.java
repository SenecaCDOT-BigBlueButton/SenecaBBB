package db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class DBAccess {
    private DBConnection _db = null;
    private PreparedStatement _stmt = null;
    private ResultSet _rs = null;
    private Connection _conn = null;
    private String _errLog = null;

    public DBAccess() {
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
                _conn.close();
            }
        }
        catch (SQLException e) {
            flag = false;
            _errLog += "\nSQLException: failed to close Connection";
        }
        return flag;
    }

    public String getErrLog() {
        return _errLog;
    }

    /**
     * Executes all queries 
     * @param result
     * @param query
     * @return
     */
    public boolean queryDB(ArrayList<ArrayList<String>> result, String query) {
        boolean flag = openConnection();
        if (!flag) {
            _errLog = "SQLException: Bad or No Connection";
        }
        else {
            try {
                result.clear();
                _stmt = _conn.prepareStatement(query);
                _rs = _stmt.executeQuery();
                int colCount = _rs.getMetaData().getColumnCount();
                while (_rs.next()) {
                    ArrayList<String> row = new ArrayList<String>();
                    for (int i=1; i<=colCount; i++) {
                        row.add(_rs.getString(i));
                    }
                    result.add(row);
                }
            }
            catch (SQLException e) {
                _errLog = "SQLException: problem with query statement";
                flag = false;
            }
            finally {
               flag = closeConnection() && flag; 
            }
        }
        return flag;
    }
    
    /**
     * Execute SQL Data Manipulation Language (DML) statement, 
     * such as INSERT, UPDATE or DELETE; or an SQL statement that returns nothing, 
     * such as a DDL statements
     * @param statement
     * @return
     */
    public boolean updateDB(String statement) {
        boolean flag = openConnection();
        if (!flag) {
            _errLog = "SQLException: Bad or No Connection";
        }
        else {
            try {
                _stmt = _conn.prepareStatement(statement);
                _stmt.executeUpdate();
            }
            catch (SQLException e) {
                _errLog = "SQLException: problem with SQL statement";
                flag = false;
            }
            finally {
               flag = closeConnection() && flag; 
            }
        }
        return flag;
    }
}
