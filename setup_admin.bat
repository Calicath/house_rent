@echo off
echo 正在设置管理员账号...
echo.

REM 检查MySQL是否安装
where mysql >nul 2>nul
if %errorlevel% neq 0 (
    echo 错误: 未找到MySQL命令行工具
    echo 请确保MySQL已安装并添加到系统PATH中
    echo 或者手动执行以下SQL语句:
    echo.
    echo USE house_rental_db;
    echo INSERT INTO users (username, password, email, type, status) 
    echo VALUES ('root', '123', 'root@example.com', 'ADMIN', 'ACTIVE')
    echo ON DUPLICATE KEY UPDATE 
    echo     password = VALUES(password),
    echo     email = VALUES(email),
    echo     type = VALUES(type),
    echo     status = VALUES(status);
    echo.
    pause
    exit /b 1
)

echo 请输入MySQL root密码:
mysql -u root -p -e "USE house_rental_db; INSERT INTO users (username, password, email, type, status) VALUES ('root', '123', 'root@example.com', 'ADMIN', 'ACTIVE') ON DUPLICATE KEY UPDATE password = VALUES(password), email = VALUES(email), type = VALUES(type), status = VALUES(status);"

if %errorlevel% equ 0 (
    echo.
    echo 管理员账号设置成功！
    echo 用户名: root
    echo 密码: 123
    echo.
    echo 现在可以使用此账号登录管理员面板了。
) else (
    echo.
    echo 设置失败，请检查数据库连接和权限。
)

pause 