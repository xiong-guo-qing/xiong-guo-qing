#!/usr/bin/env bash
set -euo pipefail

# OpenClaw WSL 后台启动脚本
# 用途：在 Ubuntu/WSL 中检查 OpenClaw Gateway 状态，未启动时自动后台启动。
# 依赖：已完成 openclaw 安装，并已通过 `openclaw onboard --install-daemon` 或等效方式配置服务。

log() {
  printf '[openclaw-start] %s\n' "$*"
}

if ! command -v openclaw >/dev/null 2>&1; then
  log "未找到 openclaw 命令。请先安装 OpenClaw。"
  exit 1
fi

log "检查 Gateway 状态..."
STATUS_OUTPUT="$(openclaw gateway status 2>&1 || true)"
printf '%s\n' "$STATUS_OUTPUT"

if printf '%s' "$STATUS_OUTPUT" | grep -qiE 'runtime:\s*running|rpc probe:\s*ok'; then
  log "OpenClaw 已在运行，无需重复启动。"
  exit 0
fi

log "检测到 OpenClaw 未运行，开始后台启动 Gateway..."
openclaw gateway start

log "等待 3 秒后再次检查状态..."
sleep 3
openclaw gateway status

log "启动流程完成。"
