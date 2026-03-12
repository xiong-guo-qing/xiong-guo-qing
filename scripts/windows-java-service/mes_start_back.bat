@echo off
setlocal enabledelayedexpansion

rem =========================================================
rem Windows Java 服务后台启动脚本（适合 32G 服务器）
rem 用途：Spring Boot / JEECG jar 后台启动、记日志、保留 GC/OOM 现场
rem =========================================================

rem -------------------------
rem 基础配置
rem -------------------------
rem 应用 Jar 名称：按你的实际文件名修改
set APP_NAME=jeecg-system-start-3.4.0.jar

rem bat 所在目录，通常就是应用目录
set APP_DIR=%~dp0
cd /d "%APP_DIR%"

rem 日志目录
set LOG_DIR=%APP_DIR%logs

rem PID 文件：用于 stop/status 脚本读取进程号
set PID_FILE=%APP_DIR%app.pid

rem Java 命令：如果系统已配置 JAVA_HOME/PATH，通常不用改
set JAVA_CMD=java

if not exist "%LOG_DIR%" (
    mkdir "%LOG_DIR%"
)

rem -------------------------
rem 生成稳定时间戳（PowerShell 方式，比 %%date%%/%%time%% 更稳）
rem -------------------------
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set TS=%%i

set CONSOLE_LOG=%LOG_DIR%\console.log
set STARTUP_LOG=%LOG_DIR%\startup_%TS%.log
set ERROR_LOG=%LOG_DIR%\error.log
set GC_LOG=%LOG_DIR%\gc.log
set HEAP_DUMP=%LOG_DIR%\heapdump.hprof

rem -------------------------
rem JVM 参数：基于 32G 服务器的稳妥起点
rem -------------------------
set JAVA_OPTS=

rem -server
rem 使用 Server VM，服务端 Java 程序常规推荐
set JAVA_OPTS=%JAVA_OPTS% -server

rem -Xms4g
rem 初始堆 4G：避免启动时过小频繁扩容，也不至于一上来吃太满
set JAVA_OPTS=%JAVA_OPTS% -Xms4g

rem -Xmx8g
rem 最大堆 8G：对 32G 服务器是比较均衡的起点，给系统/线程/堆外内存留余量
set JAVA_OPTS=%JAVA_OPTS% -Xmx8g

rem -Xss512k
rem 每个线程栈 512KB：线程较多时可降低 native memory 压力
set JAVA_OPTS=%JAVA_OPTS% -Xss512k

rem -XX:+UseG1GC
rem 使用 G1 垃圾回收器，适合服务端和较大堆场景
set JAVA_OPTS=%JAVA_OPTS% -XX:+UseG1GC

rem -XX:MaxGCPauseMillis=200
rem 告诉 G1 期望暂停时间目标约 200ms（目标值，不是强保证）
set JAVA_OPTS=%JAVA_OPTS% -XX:MaxGCPauseMillis=200

rem -XX:InitiatingHeapOccupancyPercent=45
rem 老年代占用到 45%% 左右时开始并发标记，帮助更早回收
set JAVA_OPTS=%JAVA_OPTS% -XX:InitiatingHeapOccupancyPercent=45

rem -XX:+ParallelRefProcEnabled
rem 并行处理引用对象，可减少某些 GC 阶段停顿
set JAVA_OPTS=%JAVA_OPTS% -XX:+ParallelRefProcEnabled

rem -XX:MaxMetaspaceSize=512m
rem 限制元空间最大 512MB，避免类元数据无限增长
set JAVA_OPTS=%JAVA_OPTS% -XX:MaxMetaspaceSize=512m

rem -XX:MaxDirectMemorySize=1g
rem 限制直接内存（堆外内存）上限 1G，防止 NIO/DirectBuffer 无限制膨胀
set JAVA_OPTS=%JAVA_OPTS% -XX:MaxDirectMemorySize=1g

rem -XX:+HeapDumpOnOutOfMemoryError
rem 发生 OOM 时自动输出 heap dump，便于后续用 MAT/VisualVM 分析
set JAVA_OPTS=%JAVA_OPTS% -XX:+HeapDumpOnOutOfMemoryError

rem -XX:HeapDumpPath
rem 指定 OOM 堆转储输出路径
set JAVA_OPTS=%JAVA_OPTS% -XX:HeapDumpPath="%HEAP_DUMP%"

rem -XX:+UnlockDiagnosticVMOptions
rem 解锁诊断参数，配合 NativeMemoryTracking 使用
set JAVA_OPTS=%JAVA_OPTS% -XX:+UnlockDiagnosticVMOptions

rem -XX:NativeMemoryTracking=summary
rem 开启本地内存跟踪（概要模式），便于后续用 jcmd 分析 native memory
set JAVA_OPTS=%JAVA_OPTS% -XX:NativeMemoryTracking=summary

rem -Xloggc
rem GC 日志输出位置
set JAVA_OPTS=%JAVA_OPTS% -Xloggc:"%GC_LOG%"

rem -XX:+PrintGCDetails
rem 输出 GC 详细信息
set JAVA_OPTS=%JAVA_OPTS% -XX:+PrintGCDetails

rem -XX:+PrintGCDateStamps
rem GC 日志中打印日期时间，便于和业务日志对时
set JAVA_OPTS=%JAVA_OPTS% -XX:+PrintGCDateStamps

rem -XX:+PrintTenuringDistribution
rem 打印对象年龄分布，用于分析对象晋升和年轻代压力
set JAVA_OPTS=%JAVA_OPTS% -XX:+PrintTenuringDistribution

rem -XX:+PrintHeapAtGC
rem 每次 GC 前后打印堆摘要，方便看回收效果
set JAVA_OPTS=%JAVA_OPTS% -XX:+PrintHeapAtGC

rem 可选：应用级参数，按需取消注释
rem set JAVA_OPTS=%JAVA_OPTS% -Dspring.profiles.active=prod
rem set JAVA_OPTS=%JAVA_OPTS% -Dserver.port=8080
rem set JAVA_OPTS=%JAVA_OPTS% -Dfile.encoding=UTF-8

rem -------------------------
rem 启动前检查
rem -------------------------
if not exist "%APP_DIR%%APP_NAME%" (
    echo [%date% %time%] ERROR: Jar file not found: %APP_DIR%%APP_NAME% >> "%ERROR_LOG%"
    echo Jar file not found: %APP_DIR%%APP_NAME%
    exit /b 1
)

if exist "%PID_FILE%" (
    set /p OLD_PID=<"%PID_FILE%"
    tasklist /FI "PID eq !OLD_PID!" | findstr /I "!OLD_PID!" >nul
    if not errorlevel 1 (
        echo Application is already running. PID=!OLD_PID!
        exit /b 0
    ) else (
        del /f /q "%PID_FILE%" >nul 2>nul
    )
)

echo ========================================================== >> "%STARTUP_LOG%"
echo [%date% %time%] Starting %APP_NAME% >> "%STARTUP_LOG%"
echo APP_DIR   = %APP_DIR% >> "%STARTUP_LOG%"
echo LOG_DIR   = %LOG_DIR% >> "%STARTUP_LOG%"
echo JAVA_CMD  = %JAVA_CMD% >> "%STARTUP_LOG%"
echo JAVA_OPTS = %JAVA_OPTS% >> "%STARTUP_LOG%"
echo ========================================================== >> "%STARTUP_LOG%"

echo ==========================================================
echo Starting %APP_NAME% ...
echo Console Log : %CONSOLE_LOG%
echo Startup Log : %STARTUP_LOG%
echo GC Log      : %GC_LOG%
echo Heap Dump   : %HEAP_DUMP%
echo ==========================================================

rem -------------------------
rem 后台启动：输出重定向到 console.log
rem -------------------------
start "jeecg-system" /b cmd /c ""%JAVA_CMD%" %JAVA_OPTS% -jar "%APP_NAME%" >> "%CONSOLE_LOG%" 2>&1"

rem 等几秒，让进程起来
timeout /t 3 /nobreak >nul

rem -------------------------
rem 用 PowerShell 按命令行匹配 jar 名称获取 PID
rem 比 wmic 更适合较新的 Windows
rem -------------------------
set NEW_PID=
for /f %%i in ('powershell -NoProfile -Command "(Get-CimInstance Win32_Process | Where-Object { $_.Name -eq 'java.exe' -and $_.CommandLine -like '*%APP_NAME%*' } | Sort-Object ProcessId -Descending | Select-Object -First 1 -ExpandProperty ProcessId)"') do set NEW_PID=%%i

if defined NEW_PID (
    echo !NEW_PID!>"%PID_FILE%"
    echo [%date% %time%] Started successfully. PID=!NEW_PID! >> "%STARTUP_LOG%"
    echo Started successfully. PID=!NEW_PID!
) else (
    echo [%date% %time%] WARNING: Started, but PID not captured. >> "%STARTUP_LOG%"
    echo WARNING: Process may have started, but PID was not captured.
    echo Please check log: %CONSOLE_LOG%
)

endlocal
exit /b 0
