@echo off
:: =====================================================
:: Digital Voting System — Stop Server
:: Kills any running Java/Tomcat process on port 8080
:: =====================================================
echo Stopping Tomcat / Java processes...

:: Kill by port 8080
for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":8080 "') do (
    echo Killing process %%a on port 8080...
    taskkill /F /PID %%a >nul 2>&1
)

:: Kill all java.exe processes (belt-and-suspenders)
taskkill /F /IM java.exe >nul 2>&1

echo Waiting 2 seconds...
timeout /t 2 /nobreak >nul

echo Tomcat stopped. Port 8080 is now free.
