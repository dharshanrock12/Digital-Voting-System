@echo off
:: =====================================================
:: Digital Voting System — Start Server
:: Stops any old Tomcat first, then starts fresh
:: App URL: http://localhost:8080/dvs
:: =====================================================
set MVN=C:\Users\dhars\Downloads\apache-maven-3.10.0-bin\apache-maven-3.10.0\bin\mvn.cmd
set PROJECT=%~dp0

echo =====================================================
echo  Digital Voting System - Starting...
echo  URL: http://localhost:8080/dvs
echo =====================================================

:: Step 1: Kill any existing Java/Tomcat on port 8080
echo [1/3] Stopping any running Tomcat...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":8080 " 2^>nul') do (
    taskkill /F /PID %%a >nul 2>&1
)
taskkill /F /IM java.exe >nul 2>&1
timeout /t 2 /nobreak >nul

:: Step 2: Delete locked target\tomcat folder (logs etc.)
echo [2/3] Cleaning old Tomcat files...
if exist "%PROJECT%target\tomcat" (
    rd /s /q "%PROJECT%target\tomcat" 2>nul
)

:: Step 3: Build and run (skip clean to avoid lock issues)
echo [3/3] Building and starting Tomcat...
echo.
"%MVN%" package tomcat7:run -f "%PROJECT%pom.xml" -DskipTests

pause
