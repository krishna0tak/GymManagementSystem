package p1;
import java.sql.*;

public class dbcon{
    static Connection con = null;
  public static Connection getConnection(){
    try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/gym_management",
                    "root",
                    "Root@123");

        } catch (Exception e) {

            System.out.println(e);

        }

        return con;

    }
}
