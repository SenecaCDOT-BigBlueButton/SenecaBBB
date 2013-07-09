package db;

import java.sql.Connection;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;

import snaq.db.ConnectionPool;

public class DBConnection {
    private static DBConnection _dbSingleton = null;
    private static ConnectionPool _pool = null;
    private long _idleTimeout;
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
            String name = "Local"; // Pool name.
            int minPool = 1; // Minimum number of pooled connections, or 0 for none.
            int maxPool = 3; // Maximum number of pooled connections, or 0 for none.
            int maxSize = 10; // Maximum number of possible connections, or 0 for no limit.
            _idleTimeout = 30; // Idle timeout (seconds) for idle pooled connections, or 0 for no timeout.
            String url = "jdbc:mysql://localhost:3309/db"; // JDBC connection URL.
            String username = "senecaBBB"; // Database username.
            String password = "db"; // Password for the database username supplied.
            try {
                _pool = new ConnectionPool(name, minPool, maxPool, maxSize, _idleTimeout, url, username, password);
            }
            finally {
                _pool.registerShutdownHook(); 
            }
        }
    }
    
    public Connection openConnection() {
        Connection conn = null;
        try {
            conn = _pool.getConnection(_idleTimeout);
            _flag = true;
        } 
        catch (SQLException e) {
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