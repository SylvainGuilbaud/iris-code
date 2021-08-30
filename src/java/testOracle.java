import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.*;
import javax.sql.*;

public class testOracle {
    public static void main(String[] args) {
       try {
            Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@serveurlims.oncodesign.com:1521:lims", "coreread", "oncoD3sign");
            Statement stmt = conn.createStatement();
            String SQL = "select * from v$version";
            ResultSet rs = stmt.executeQuery(SQL);
            ResultSetMetaData rsmd = rs.getMetaData();
            int columnCount = rsmd.getColumnCount();
            int nbRows = 0;
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