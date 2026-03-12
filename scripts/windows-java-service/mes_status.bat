@echo off
setlocal

rem =========================================================
rem Windows Java 服务状态脚本
rem 根据 app.pid 判断服务是否仍在运行
rem =========================================================

set APP_DIR=%~dp0
cd /d "%APP_DIR%"

set PID_FILE=%APP_DIR%app.pid

if not exist "%PID_FILE%" (
    echo Application is NOT running. (No PID file)
    exit /b 1
)

set /p PID=<"%PID_FILE%"

tasklist /FI "PID eq %PID%" | findstr /I "%PID%" >nul
if errorlevel 1 (
    echo Application is NOT running, but PID file exists: %PID%
    exit /b 1
) else (
    echo Application is RUNNING. PID=%PID%
    tasklist /FI "PID eq %PID%"
)

endlocal
exit /b 0
