@echo off
setlocal enabledelayedexpansion

rem =========================================================
rem Windows Java 故障现场采集脚本
rem 用途：服务内存异常、卡顿、疑似泄漏时，抓取现场信息
rem 需要 JDK 工具可用（jcmd/jmap/jstack/jstat/jps）
rem =========================================================

set APP_DIR=%~dp0
cd /d "%APP_DIR%"

set PID_FILE=%APP_DIR%app.pid
set LOG_DIR=%APP_DIR%logs
set DIAG_DIR=%LOG_DIR%\diagnostics

if not exist "%LOG_DIR%" (
    mkdir "%LOG_DIR%"
)
if not exist "%DIAG_DIR%" (
    mkdir "%DIAG_DIR%"
)

for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set TS=%%i
set OUT_DIR=%DIAG_DIR%\%TS%
mkdir "%OUT_DIR%" >nul 2>nul

if not exist "%PID_FILE%" (
    echo No PID file found. Application may not be running.
    exit /b 1
)

set /p PID=<"%PID_FILE%"

echo Collecting diagnostics for PID=%PID%
echo Output: %OUT_DIR%

rem 1) 基础进程信息
tasklist /FI "PID eq %PID%" > "%OUT_DIR%\tasklist.txt" 2>&1
wmic process where processid=%PID% get ProcessId,Name,CommandLine /format:list > "%OUT_DIR%\process.txt" 2>&1

rem 2) JVM 启动参数和系统属性
jcmd %PID% VM.command_line > "%OUT_DIR%\vm_command_line.txt" 2>&1
jcmd %PID% VM.flags > "%OUT_DIR%\vm_flags.txt" 2>&1
jcmd %PID% VM.system_properties > "%OUT_DIR%\vm_system_properties.txt" 2>&1

rem 3) 堆信息和 native memory
jcmd %PID% GC.heap_info > "%OUT_DIR%\gc_heap_info.txt" 2>&1
jcmd %PID% VM.native_memory summary > "%OUT_DIR%\native_memory_summary.txt" 2>&1

rem 4) GC 采样
jstat -gcutil %PID% 1000 20 > "%OUT_DIR%\jstat_gcutil.txt" 2>&1
jstat -gccapacity %PID% 1000 10 > "%OUT_DIR%\jstat_gccapacity.txt" 2>&1

rem 5) 线程栈
jstack -l %PID% > "%OUT_DIR%\jstack.txt" 2>&1

rem 6) 对象直方图
jmap -histo:live %PID% > "%OUT_DIR%\jmap_histo_live.txt" 2>&1

rem 7) Java 进程列表
jps -lv > "%OUT_DIR%\jps_lv.txt" 2>&1

rem 8) 系统内存快照（PowerShell）
powershell -NoProfile -Command "Get-CimInstance Win32_OperatingSystem | Select-Object TotalVisibleMemorySize,FreePhysicalMemory,TotalVirtualMemorySize,FreeVirtualMemory | Format-List" > "%OUT_DIR%\system_memory.txt" 2>&1

echo Diagnostics collected successfully.
echo Files saved to: %OUT_DIR%

endlocal
exit /b 0
