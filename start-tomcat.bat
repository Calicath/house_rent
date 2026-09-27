@echo off
echo ========================================
echo 房屋租赁系统 - Tomcat 启动脚本
echo ========================================

echo.
echo 1. 检查Java环境...
java -version
if %errorlevel% neq 0 (
    echo 错误: Java未安装或未配置PATH
    echo 请安装Java 11并配置环境变量
    pause
    exit /b 1
)

echo.
echo 2. 检查Maven环境...
mvn -version
if %errorlevel% neq 0 (
    echo 错误: Maven未安装或未配置PATH
    echo 请安装Maven并配置环境变量
    pause
    exit /b 1
)

echo.
echo 3. 清理并编译项目...
mvn clean compile
if %errorlevel% neq 0 (
    echo 错误: 项目编译失败
    pause
    exit /b 1
)

echo.
echo 4. 打包项目...
mvn package
if %errorlevel% neq 0 (
    echo 错误: 项目打包失败
    pause
    exit /b 1
)

echo.
echo 5. 启动Tomcat服务器...
echo 服务器将在 http://localhost:8080/house-rental/ 启动
echo 按 Ctrl+C 停止服务器
echo.
mvn tomcat7:run

pause 