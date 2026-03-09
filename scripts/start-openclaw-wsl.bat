@echo off
setlocal

REM Windows 一键启动 OpenClaw（通过 WSL Ubuntu 调用）
REM 用法：双击运行，或在 cmd / PowerShell 中执行

set "WSL_DISTRO=Ubuntu"
set "WSL_SCRIPT=/home/xgq/xiong-guo-qing/scripts/start-openclaw-wsl.sh"
set "WSL_LOG=~/.openclaw/logs/start-openclaw-wsl.log"

echo [openclaw-start] Starting OpenClaw via WSL distro: %WSL_DISTRO%
echo [openclaw-start] Script: %WSL_SCRIPT%
wsl -d %WSL_DISTRO% -- bash %WSL_SCRIPT%

if errorlevel 1 (
  echo.
  echo [openclaw-start] Failed. Please check:
  echo 1. WSL distro name is correct ^(current: %WSL_DISTRO%^) 
  echo 2. The script exists: %WSL_SCRIPT%
  echo 3. OpenClaw is installed inside WSL
  echo 4. Log file inside WSL: %WSL_LOG%
  echo.
  pause
  exit /b 1
)

echo.
echo [openclaw-start] Done.
echo [openclaw-start] Log file inside WSL: %WSL_LOG%
pause
exit /b 0
