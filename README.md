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
