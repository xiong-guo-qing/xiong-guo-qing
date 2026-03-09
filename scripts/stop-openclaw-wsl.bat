@echo off
setlocal

REM Windows 一键停止 OpenClaw（通过 WSL Ubuntu 调用）

set "WSL_DISTRO=Ubuntu"
set "WSL_SCRIPT=/home/xgq/xiong-guo-qing/scripts/stop-openclaw-wsl.sh"
set "WSL_LOG=~/.openclaw/logs/stop-openclaw-wsl.log"

echo [openclaw-stop] Stopping OpenClaw via WSL distro: %WSL_DISTRO%
echo [openclaw-stop] Script: %WSL_SCRIPT%
wsl -d %WSL_DISTRO% -- bash %WSL_SCRIPT%

if errorlevel 1 (
  echo.
  echo [openclaw-stop] Failed. Please check:
  echo 1. WSL distro name is correct ^(current: %WSL_DISTRO%^) 
  echo 2. The script exists: %WSL_SCRIPT%
  echo 3. OpenClaw is installed inside WSL
  echo 4. Log file inside WSL: %WSL_LOG%
  echo.
  pause
  exit /b 1
)

echo.
echo [openclaw-stop] Done.
echo [openclaw-stop] Log file inside WSL: %WSL_LOG%
pause
exit /b 0
