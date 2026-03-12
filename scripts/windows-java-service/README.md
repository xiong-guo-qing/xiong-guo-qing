# Windows Java Service Scripts

一套适用于 **Windows Server** 上运行 **Spring Boot / JEECG jar** 的维护脚本，目标是：

- 稳妥启动
- 保留控制台日志
- 保留 GC 日志
- OOM 时自动输出 heap dump
- 记录 PID
- 方便后续现场排查

## 文件说明

- `mes_start_back.bat`：后台启动脚本
- `mes_stop.bat`：停止脚本
- `mes_status.bat`：状态脚本
- `collect_diagnostics.bat`：故障现场采集脚本

## 默认参数（适合 32G 服务器的稳健起点）

- `-Xms4g`
- `-Xmx8g`
- `-Xss512k`
- `-XX:+UseG1GC`
- `-XX:MaxMetaspaceSize=512m`
- `-XX:MaxDirectMemorySize=1g`

这不是“越大越好”的配置，而是偏向：

1. 给 Java 足够空间
2. 给系统和 native memory 留余量
3. 让问题暴露时有日志可查

## 使用方式

1. 将这几个脚本和你的 jar 放在同一个目录，或修改脚本中的 `APP_NAME`
2. 双击或命令行运行：

```bat
mes_start_back.bat
```

停止：

```bat
mes_stop.bat
```

查看状态：

```bat
mes_status.bat
```

采集现场：

```bat
collect_diagnostics.bat
```

## 产物说明

默认会生成：

- `logs\console.log`：应用控制台日志
- `logs\gc.log`：GC 日志
- `logs\heapdump.hprof`：OOM 后堆转储
- `logs\startup_*.log`：启动参数留档
- `logs\diagnostics\...`：故障现场抓取文件
- `app.pid`：进程 PID 文件

## 需要的工具

建议服务器安装 **JDK 8+**，这样可以直接使用：

- `jps`
- `jstack`
- `jstat`
- `jmap`
- `jcmd`

如果只装了 JRE，`collect_diagnostics.bat` 里的部分命令可能不可用。
