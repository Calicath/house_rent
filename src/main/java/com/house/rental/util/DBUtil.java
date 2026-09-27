package com.house.rental.util;

import org.apache.commons.dbcp2.BasicDataSource;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

public class DBUtil {
    private static final BasicDataSource dataSource = new BasicDataSource();

    static {
        dataSource.setDriverClassName("com.mysql.cj.jdbc.Driver");

        // V V V 就是修改这一行 V V V
        // 在URL末尾添加 "&allowPublicKeyRetrieval=true"
        dataSource.setUrl("jdbc:mysql://localhost:3306/house_rental_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true");
        // A A A 就是修改这一行 A A A

        dataSource.setUsername("root");
        dataSource.setPassword("123456"); // 请修改为你的实际MySQL密码
        dataSource.setInitialSize(5);
        dataSource.setMaxTotal(20);
    }

    public static Connection getConnection() throws SQLException {
        try {
            return dataSource.getConnection();
        } catch (SQLException e) {
            System.err.println("数据库连接失败: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    public static DataSource getDataSource() {
        return dataSource;
    }
}