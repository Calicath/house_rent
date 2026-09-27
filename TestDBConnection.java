import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.house.rental.util.DBUtil;

public class TestDBConnection {
    public static void main(String[] args) {
        System.out.println("开始测试数据库连接...");
        
        try (Connection conn = DBUtil.getConnection()) {
            System.out.println("数据库连接成功！");
            
            DatabaseMetaData metaData = conn.getMetaData();
            System.out.println("数据库产品名称: " + metaData.getDatabaseProductName());
            System.out.println("数据库版本: " + metaData.getDatabaseProductVersion());
            
            // 检查users表是否存在
            ResultSet tables = metaData.getTables(null, null, "users", null);
            if (tables.next()) {
                System.out.println("users表存在");
                
                // 检查表结构
                ResultSet columns = metaData.getColumns(null, null, "users", null);
                System.out.println("users表结构:");
                while (columns.next()) {
                    String columnName = columns.getString("COLUMN_NAME");
                    String columnType = columns.getString("TYPE_NAME");
                    System.out.println("  " + columnName + " - " + columnType);
                }
            } else {
                System.out.println("users表不存在！");
            }
            
        } catch (SQLException e) {
            System.err.println("数据库连接失败: " + e.getMessage());
            e.printStackTrace();
        }
    }
} 