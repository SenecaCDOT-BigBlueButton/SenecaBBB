package db;

import java.sql.Connection;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;

import com.jolbox.bonecp.BoneCP;
import com.jolbox.bonecp.BoneCPConfig;


public class DBConnection {
    private static DBConnection _dbSingleton = null;
    private static BoneCP _pool = null;
    private boolean _flag = true; //true: connection open, false: bad or no connection

    /** A private Constructor prevents any other class from instantiating. */
    private DBConnection() {
        Class<?> c = null;
        try {
            c = Class.forName("com.mysql.jdbc.Driver");
        } 
        catch (ClassNotFoundException e) {
            _flag = false;
        }

        Driver driver = null;
        try {
            driver = (Driver)c.newInstance();
        }
        catch (InstantiationException | IllegalAccessException e) {
            _flag = false;
        }
        try {
            DriverManager.registerDriver(driver);
        }
        catch (SQLException e) {
            _flag = false;
        }
        if (_flag) {
            try {
                BoneCPConfig config = new BoneCPConfig();
                config.setJdbcUrl("jdbc:mysql://localhost:3309/db");
                config.setUsername("senecaBBB"); 
                config.setPassword("db");
                config.setMinConnectionsPerPartition(5);
                config.setMaxConnectionsPerPartition(10);
                config.setPartitionCount(5);
                _pool = new BoneCP(config); // setup the connection pool
            }
            catch (SQLException e) {
                _flag = false;
            }
        }
    }
    
    public Connection openConnection() {
        Connection conn = null;
        System.out.println("connection created: " + _pool.getTotalCreatedConnections()); //debug
        System.out.println("connection leased: " + _pool.getTotalLeased()); //debug
        System.out.println("connection free: " + _pool.getTotalFree()); //debug
        if (_pool.getTotalFree() > 0) {
            try {
                conn = _pool.getConnection();
                _flag = true;
            } catch (SQLException e) {
                _flag = false;
            }
        }
        else {
            _flag = false;
        }
        return conn;
    }

    /** Static 'instance' method */
    public static DBConnection getInstance() {
        if (_dbSingleton == null) {
            _dbSingleton = new DBConnection();
        }
        return _dbSingleton;
    }

    public boolean getConnectionStatus() {
        return _flag;
    }
}