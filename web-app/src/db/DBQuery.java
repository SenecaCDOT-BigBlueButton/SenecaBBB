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
    private boolean _flag = true;
    private boolean _isClosed = false; //separate flag for closeQuery() method

    public DBQuery() {
        _db = DBConnection.getInstance();
        openConnection();
    }

    public boolean closeQuery() {
        _isClosed = true;
        if (_rs != null) {
            try {
                _rs.close();
            } 
            catch (SQLException e) {
                _isClosed = false;
                _errLog = "SQLException: fail to close ResultSet";
            }
        }    
        if (_stmt != null) {
            try {
                _stmt.close();
            } 
            catch (SQLException e) {
                _isClosed = false;
                _errLog = "SQLException: fail to close PreparedStatement";
            }
        }
        return _isClosed;
    }

    /** This closes the single DB connection, try not to use this method */
    public boolean closeConnection() {
        return _db.closeConnection();
    }
    
    /** Use this method if closeConnection() is called and you need to reestablish connection */
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
        // Executes all SQLQueries
        if (!_db.getConnectionStatus()) {
            _errLog = "SQLException: Bad or No Connection";
            _flag = false;
        }
        else {
            _flag = true;
            try {
                _stmt = _conn.prepareStatement(query);
            }
            catch (SQLException e) {
                _errLog = "SQLException: problem preparing query statement";
                _flag = false;
            }
            if (_flag) {
                try {
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
                    _errLog = "SQLException: problem executing query statement";
                    _flag = false;
                }
            }
        }
        return _flag;
    }
}
