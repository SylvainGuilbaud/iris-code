import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.*;
import javax.sql.*;

public class testIRIS {
    public static void main(String[] args) {
       try {
            // Connection conn = DriverManager.getConnection("jdbc:IRIS://127.0.0.1:1972/%SYS", "_SYSTEM", "SYS");
            Connection conn = DriverManager.getConnection("jdbc:IRIS://127.0.0.1:51000/%SYS", "_SYSTEM", "SYS");
            Statement stmt = conn.createStatement();
            String SQL = "SELECT * FROM Inventory.Scan";
            ResultSet rs = stmt.executeQuery(SQL);
            ResultSetMetaData rsmd = rs.getMetaData();
            int columnCount = rsmd.getColumnCount();
            int nbRows = 0;
            //String record = "";
            while (rs.next()) {
                System.out.println("\n--"+ ++nbRows +"----------------------------------------------");
                 for (int i = 1; i <= columnCount; i++ ) {  
                    System.out.println(rsmd.getColumnName(i)+"\t\t"+":"+rs.getString(i));
                }
                
            }
        }
        // Handle any errors that may have occurred.
        catch (SQLException e) {
            e.printStackTrace();
            System.out.println(e.getMessage());
            System.exit(1);
        }
        // catch (ClassNotFoundException e) {
        //     e.printStackTrace();
        //     System.out.println(e.getMessage());
        //     System.exit(2);
        // }
        // catch (InstantiationException e) {
        //     e.printStackTrace();
        //     System.out.println(e.getMessage());
        //     System.exit(3);
        // }
        // catch (IllegalAccessException e) {
        //     e.printStackTrace();
        //     System.out.println(e.getMessage());
        //     System.exit(4);
        // }
       
    }
}