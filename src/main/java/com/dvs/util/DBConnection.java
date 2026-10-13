package com.dvs.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * DBConnection — Manages MySQL connections.
 * Author: Dharshan Sathish Kumar | Reg: 3122255002029
 */
public class DBConnection {

    private static String URL;
    private static String USERNAME;
    private static String PASSWORD;

    static {
        try (InputStream in = DBConnection.class.getClassLoader()
                .getResourceAsStream("db.properties")) {
            Properties props = new Properties();
            props.load(in);
            Class.forName(props.getProperty("db.driver"));
            URL      = props.getProperty("db.url");
            USERNAME = props.getProperty("db.username");
            PASSWORD = props.getProperty("db.password");
        } catch (Exception e) {
            throw new ExceptionInInitializerError("Failed to load DB config: " + e.getMessage());
        }
    }

    /**
     * Opens and returns a new MySQL connection.
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }

    /**
     * Quietly closes a connection (null-safe).
     */
    public static void close(Connection conn) {
        if (conn != null) {
            try { conn.close(); } catch (SQLException ignored) {}
        }
    }
}
