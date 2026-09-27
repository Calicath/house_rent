@echo off
echo ========================================
echo 环境检查脚本
echo ========================================

echo.
echo 1. 检查Java版本...
java -version 2>&1
if %errorlevel% equ 0 (
    echo ✓ Java环境正常
) else (
    echo ✗ Java环境异常
)

echo.
echo 2. 检查Maven版本...
mvn -version 2>&1
if %errorlevel% equ 0 (
    echo ✓ Maven环境正常
) else (
    echo ✗ Maven环境异常
)

echo.
echo 3. 检查8080端口占用...
netstat -ano | findstr :8080
if %errorlevel% equ 0 (
    echo ✗ 8080端口被占用
) else (
    echo ✓ 8080端口可用
)

echo.
echo 4. 检查项目结构...
if exist "pom.xml" (
    echo ✓ pom.xml存在
) else (
    echo ✗ pom.xml不存在
)

if exist "src\main\java" (
    echo ✓ Java源码目录存在
) else (
    echo ✗ Java源码目录不存在
)

if exist "src\main\webapp" (
    echo ✓ Web应用目录存在
) else (
    echo ✗ Web应用目录不存在
)

echo.
echo 5. 检查数据库脚本...
if exist "database_init.sql" (
    echo ✓ 主数据库脚本存在
) else (
    echo ✗ 主数据库脚本不存在
)

if exist "forum_database_init.sql" (
    echo ✓ 论坛数据库脚本存在
) else (
    echo ✗ 论坛数据库脚本不存在
)

echo.
echo ========================================
echo 检查完成
echo ========================================
pause 