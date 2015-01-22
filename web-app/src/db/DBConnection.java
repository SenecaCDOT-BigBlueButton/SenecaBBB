package db;

import java.sql.Connection;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;

import com.jolbox.bonecp.BoneCP;
import com.jolbox.bonecp.BoneCPConfig;

import config.Config;
import helper.GetExceptionLog;

public class DBConnection {
    private static DBConnection _dbSingleton = null;
    private static BoneCP _pool = null;
    private String _errCode = null;
    private String _errLog = null;
    GetExceptionLog elog = new GetExceptionLog();

    /** A private Constructor prevents any other class from instantiating. */
    private DBConnection() {
        try {
            Class<?> c = Class.forName("com.mysql.jdbc.Driver");
            Driver driver = null;
            driver = (Driver)c.newInstance();
            DriverManager.registerDriver(driver);
            
            BoneCPConfig config = new BoneCPConfig();
            config.setJdbcUrl(Config.getProperty("jdburl")+Config.getProperty("databasename"));
            config.setUsername(Config.getProperty("databaseuser")); 
            config.setPassword(Config.getProperty("databasepass"));
            config.setMinConnectionsPerPartition(5);
            config.setMaxConnectionsPerPartition(30);
            config.setPartitionCount(5);
            _pool = new BoneCP(config); // setup the connection pool
        } catch (ClassNotFoundException e) {
            elog.writeLog("[DBConnection:] " + _errCode + "-" + _errLog + "/n"+ e.getStackTrace().toString());
        } catch (InstantiationException | IllegalAccessException e) {
            
        } catch (SQLException e) {
            _errCode = Integer.toString(e.getErrorCode());
            _errLog = e.getMessage();
            elog.writeLog("[DBConnection:] " + _errCode + "-" + _errLog + "/n"+ e.getStackTrace().toString());
        }
    }
    
    public Connection getConnectionFromPool() {
        Connection conn = null;
        if (_pool != null) {
            try {
                System.out.println("Connections (Created/Leased/Free): " 
                        + _pool.getTotalCreatedConnections() + "/"
                        + _pool.getTotalLeased() + "/"
                        + _pool.getTotalFree()); //debug 
                
                conn = _pool.getConnection();
            } catch (SQLException e) {
                conn = null; // To be safe, since I don't know the actual behavior of getConnection
                _errCode = Integer.toString(e.getErrorCode());
                _errLog = e.getMessage();
                elog.writeLog("[DBConnection:] " + _errCode + "-" + _errLog + "/n"+ e.getStackTrace().toString());
            }
        }
        return conn;
    }

    /** Static 'instance' method */
    public static synchronized DBConnection getInstance() {
        if (_dbSingleton == null) {
            _dbSingleton = new DBConnection();
        }
        return _dbSingleton;
    }
    
    public String getErrLog() {
        return _errLog;
    }
    
    public String getErrCode() {
        return _errCode;
    }

}