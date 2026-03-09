# xiong-guo-qing

This repository stores my AI coding agent rules and project guidance.

## Files

- `AGENTS.md` — operational rules for AI coding tools, optimized for Antigravity

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
