package com.blooddonationmanagementsystem.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL = "jdbc:mysql://localhost:3306/bloodbridge";
    private static final String USER = "root";
    private static final String PASSWORD = "12345";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("Critical Error: MySQL JDBC Driver not found!");
            e.printStackTrace();
            throw new SQLException("JDBC Driver missing", e);
        }

        try {
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (SQLException e) {
            System.err.println("Critical Error: Could not connect to database!");
            System.err.println("URL: " + URL);
            System.err.println("User: " + USER);
            e.printStackTrace();
            throw e;
        }
    }
}
