# xiong-guo-qing

This repository stores my AI coding agent rules and project guidance.

## Files

- `AGENTS.md` — operational rules for AI coding tools, optimized for Antigravity
- `GEMINI-global.md` — global execution rules, including short-term vs long-term memory guidance
- `BASIC-MEMORY-RULES.md` — long-term knowledge base rules for `basic-memory`

## Memory model

This repo now uses a two-layer memory model:

- **Short-term memory**: for conversation state, temporary constraints, debugging progress, and task process notes
- **Long-term memory (`basic-memory`)**: for stable, verified, reusable knowledge

Recommended short-term memory structure inside a project:

```text
memory/
  inbox.md
  daily/
  tasks/
```

Recommended usage:
- `memory/inbox.md` — temporary capture
- `memory/daily/` — daily context and session notes
- `memory/tasks/` — per-task progress and intermediate findings

## OpenClaw WSL 后台启动脚本

已提供脚本：`scripts/start-openclaw-wsl.sh`

用途：
- 检查 OpenClaw Gateway 是否已运行
- 若未运行，则调用官方命令 `openclaw gateway start` 后台启动
- 启动后再次输出状态

使用方法：

```bash
bash scripts/start-openclaw-wsl.sh
```

前提：
- 已在 WSL Ubuntu 中安装 OpenClaw
- 建议先完成：`openclaw onboard --install-daemon`

### 日志说明

Ubuntu / WSL 启动脚本会把日志写到：`~/.openclaw/logs/start-openclaw-wsl.log`

如果 Windows 双击后窗口一闪而过，请：
- 重新运行 `scripts/start-openclaw-wsl.bat`
- 脚本现在会自动 `pause`，方便查看错误
- 也可以进入 WSL 查看日志：

```bash
cat ~/.openclaw/logs/start-openclaw-wsl.log
```

### Windows 一键启动（调用 WSL）

已提供批处理文件：`scripts/start-openclaw-wsl.bat`

作用：
- 在 Windows 中一键调用 WSL Ubuntu
- 执行仓库内的 `scripts/start-openclaw-wsl.sh`
- 自动检查并启动 OpenClaw Gateway

使用方式：
- 在 Windows 中双击 `.bat` 文件
- 或在 cmd / PowerShell 中执行：

```bat
scripts\start-openclaw-wsl.bat
```

注意：
- 默认发行版名写的是 `Ubuntu`
- 如果你的 WSL 发行版不是这个名字，请编辑 `.bat` 中的 `WSL_DISTRO`
- 当前脚本内的 WSL 路径写的是：`/home/xgq/xiong-guo-qing/scripts/start-openclaw-wsl.sh`


### 停止脚本

已提供：
- `scripts/stop-openclaw-wsl.sh`（Ubuntu / WSL）
- `scripts/stop-openclaw-wsl.bat`（Windows 调用 WSL）

Ubuntu / WSL 中执行：

```bash
bash scripts/stop-openclaw-wsl.sh
```

Windows 中执行：

```bat
scripts\stop-openclaw-wsl.bat
```

日志位置：
- `~/.openclaw/logs/stop-openclaw-wsl.log`
