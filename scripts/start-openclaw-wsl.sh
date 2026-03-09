#!/usr/bin/env bash
set -euo pipefail

# OpenClaw WSL 后台启动脚本
# 用途：在 Ubuntu/WSL 中检查 OpenClaw Gateway 状态，未启动时自动后台启动。
# 日志：~/.openclaw/logs/start-openclaw-wsl.log

LOG_DIR="$HOME/.openclaw/logs"
LOG_FILE="$LOG_DIR/start-openclaw-wsl.log"
mkdir -p "$LOG_DIR"

timestamp() {
  date '+%Y-%m-%d %H:%M:%S'
}

log() {
  printf '[%s] [openclaw-start] %s\n' "$(timestamp)" "$*" | tee -a "$LOG_FILE"
}

run_and_log() {
  log "RUN: $*"
  "$@" 2>&1 | tee -a "$LOG_FILE"
}

# 尽量恢复交互 shell 常见 PATH，避免 Windows -> WSL 调用时找不到 npm 全局命令
[ -f "$HOME/.profile" ] && . "$HOME/.profile" || true
[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc" || true
export PATH="$HOME/.npm-global/bin:$HOME/.local/bin:$PATH"

log "===== script start ====="
log "User: $(whoami)"
log "PWD: $(pwd)"
log "PATH: $PATH"

if ! command -v openclaw >/dev/null 2>&1; then
  log "未找到 openclaw 命令。请先确认它已安装在 WSL 中。"
  log "提示：当前脚本已尝试加载 ~/.profile、~/.bashrc，并追加 ~/.npm-global/bin 到 PATH。"
  exit 1
fi

OPENCLAW_BIN="$(command -v openclaw)"
log "OpenClaw binary: $OPENCLAW_BIN"

log "检查 Gateway 状态..."
STATUS_OUTPUT="$(openclaw gateway status 2>&1 || true)"
printf '%s\n' "$STATUS_OUTPUT" | tee -a "$LOG_FILE"

if printf '%s' "$STATUS_OUTPUT" | grep -qiE 'runtime:\s*running|rpc probe:\s*ok'; then
  log "OpenClaw 已在运行，无需重复启动。"
  log "日志文件：$LOG_FILE"
  exit 0
fi

log "检测到 OpenClaw 未运行，开始后台启动 Gateway..."
run_and_log openclaw gateway start

log "等待 5 秒后再次检查状态..."
sleep 5
run_and_log openclaw gateway status

log "启动流程完成。"
log "日志文件：$LOG_FILE"
