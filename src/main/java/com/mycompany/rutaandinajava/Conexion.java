package com.mycompany.rutaandinajava;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
    private static final String URL = "jdbc:mysql://localhost:3306/ruta_andina?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASS = "200515"; // <--- PON AQUI TU CONTRASENA DE MYSQL

    public static Connection getConexion() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}