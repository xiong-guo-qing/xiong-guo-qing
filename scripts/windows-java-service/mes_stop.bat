@echo off
setlocal enabledelayedexpansion

rem =========================================================
rem Windows Java 服务停止脚本
rem 通过 app.pid 停止对应 Java 进程
rem =========================================================

set APP_DIR=%~dp0
cd /d "%APP_DIR%"

set PID_FILE=%APP_DIR%app.pid
set LOG_DIR=%APP_DIR%logs
set STOP_LOG=%LOG_DIR%\stop.log

if not exist "%LOG_DIR%" (
    mkdir "%LOG_DIR%"
)

if not exist "%PID_FILE%" (
    echo No PID file found. Application may not be running.
    exit /b 1
)

set /p PID=<"%PID_FILE%"

tasklist /FI "PID eq %PID%" | findstr /I "%PID%" >nul
if errorlevel 1 (
    echo Process %PID% not found. Removing stale PID file.
    del /f /q "%PID_FILE%" >nul 2>nul
    exit /b 1
)

echo [%date% %time%] Stopping PID=%PID% >> "%STOP_LOG%"
taskkill /PID %PID% /F >nul 2>nul

if errorlevel 1 (
    echo Failed to stop process %PID%.
    exit /b 1
) else (
    del /f /q "%PID_FILE%" >nul 2>nul
    echo Process %PID% stopped successfully.
    echo [%date% %time%] Stopped PID=%PID% successfully >> "%STOP_LOG%"
)

endlocal
exit /b 0
