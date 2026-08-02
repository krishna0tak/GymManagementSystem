package p1;
import java.sql.*;

public class dbcon {
    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/gym_management?useSSL=false&allowPublicKeyRetrieval=true",
                    "root",
                    "Root@123");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return con;
    }
}

