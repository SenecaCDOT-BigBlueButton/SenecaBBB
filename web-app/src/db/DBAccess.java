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
    private String _errCode = null;
    private String _errLog = null; 
    
    GetExceptionLog elog = new GetExceptionLog();

    public DBAccess() {
        _db = DBConnection.getInstance();
    }
    
    public void closeResources(Connection connection, PreparedStatement statement, ResultSet resultSet) {
        try {
            if (statement != null) { 
                statement.close();
            }
            if (resultSet != null) {
                resultSet.close();
            }
            if (connection != null) {
                connection.close();
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
     * @param result
     * @param query
     * @return
     */
    public boolean queryDB(ArrayList<HashMap<String, String>> result, String query) {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        try {
            connection = _db.getConnectionFromPool();
            statement = connection.prepareStatement(query);
            resultSet = statement.executeQuery();                   
            parseResultSet(resultSet, result);
        } catch (SQLException e) {
            _errCode = Integer.toString(e.getErrorCode());
            _errLog = e.getMessage();
            elog.writeLog("[queryDB:] " + _errCode + "-" + _errLog + "/n"+ e.getStackTrace().toString());                    
        } finally {
            closeResources(connection, statement, resultSet);
        }
        return true;
    }
    
    private void parseResultSet(ResultSet resultSet, ArrayList<HashMap<String, String>> parsedResults) throws SQLException {
        int colCount = resultSet.getMetaData().getColumnCount();
        while (resultSet.next()) {
            HashMap<String, String> row = new HashMap<String, String>();
            for (int i = 1; i <= colCount; i++) {
                row.put(resultSet.getMetaData().getColumnName(i), resultSet.getString(i));
            }
            parsedResults.add(row);
        }
    }
    
    /**
     * Execute SQL Data Manipulation Language (DML) statement, 
     * such as INSERT, UPDATE or DELETE; or an SQL statement that returns nothing, 
     * such as a DDL statements<p>
     * @param statement
     * @return
     */
    public boolean updateDB(String updateStatement) {
        Connection connection = null;
        PreparedStatement statement = null;
        try {
            connection = _db.getConnectionFromPool();
            statement = connection.prepareStatement(updateStatement);
            statement.executeUpdate();
        } catch (SQLException e) {
            _errCode = Integer.toString(e.getErrorCode());
            _errLog = e.getMessage();
            elog.writeLog("[updateDB:] " + _errCode + "-" + _errLog + "/n"+ e.getStackTrace().toString());                   
        } finally {
            closeResources(connection, statement, null);
        }
        return true;
    }
    
    public boolean getFlagStatus() {
        return true;
    }
    
}
