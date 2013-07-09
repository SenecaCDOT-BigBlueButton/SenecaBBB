package db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class DBQuery {
    private DBConnection _db = null;
    private PreparedStatement _stmt = null;
    private ResultSet _rs = null;
    private Connection _conn = null;
    private String _errLog = null;

    public DBQuery() {
        _db = DBConnection.getInstance();
        openConnection();
    }

    public boolean closeQuery() {
        boolean isClosed = true;
        if (_rs != null) {
            try {
                _rs.close();
            } 
            catch (SQLException e) {
                isClosed = false;
                _errLog = "SQLException: fail to close ResultSet";
            }
        }    
        if (_stmt != null) {
            try {
                _stmt.close();
            } 
            catch (SQLException e) {
                isClosed = false;
                _errLog = "SQLException: fail to close PreparedStatement";
            }
        }
        if (_conn != null) {
            try {
                _conn.close();
            } 
            catch (SQLException e) {
                isClosed = false;
                _errLog = "SQLException: fail to close Connection";
            }
        }
        return isClosed;
    }
    
    /** Use this method if you need to reestablish connection */
    public void openConnection() {
        _conn = _db.openConnection();
    }

    /** Normally not used */
    public ResultSet getResultSet() {
        return _rs;
    }

    public String getErrLog() {
        return _errLog;
    }

    public boolean queryDB(ArrayList<ArrayList<String>> result, String query) {
        boolean flag = true;
        // Executes all SQLQueries
        if (!_db.getConnectionStatus()) {
            _errLog = "SQLException: Bad or No Connection";
            flag = false;
        }
        else {
            try {
                _stmt = _conn.prepareStatement(query);
            }
            catch (SQLException e) {
                _errLog = "SQLException: problem preparing query statement";
                flag = false;
            }
            if (flag) {
                try {
                    _rs = _stmt.executeQuery();
                    int colCount = _rs.getMetaData().getColumnCount();
                    result.clear();
                    while (_rs.next()) {
                        ArrayList<String> row = new ArrayList<String>();
                        for (int i=1; i<=colCount; i++) {
                            row.add(_rs.getString(i));
                        }
                        result.add(row);
                    }
                }
                catch (SQLException e) {
                    _errLog = "SQLException: problem executing query statement";
                    flag = false;
                }
            }
        }
        return flag;
    }
}
