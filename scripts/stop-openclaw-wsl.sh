#!/usr/bin/env bash
set -euo pipefail

# OpenClaw WSL 后台停止脚本
# 用途：在 Ubuntu/WSL 中检查 OpenClaw Gateway 状态，若正在运行则停止。
# 日志：~/.openclaw/logs/stop-openclaw-wsl.log

LOG_DIR="$HOME/.openclaw/logs"
LOG_FILE="$LOG_DIR/stop-openclaw-wsl.log"
mkdir -p "$LOG_DIR"

timestamp() {
  date '+%Y-%m-%d %H:%M:%S'
}

log() {
  printf '[%s] [openclaw-stop] %s\n' "$(timestamp)" "$*" | tee -a "$LOG_FILE"
}

run_and_log() {
  log "RUN: $*"
  "$@" 2>&1 | tee -a "$LOG_FILE"
}

[ -f "$HOME/.profile" ] && . "$HOME/.profile" || true
[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc" || true
export PATH="$HOME/.npm-global/bin:$HOME/.local/bin:$PATH"

log "===== script start ====="
log "User: $(whoami)"
log "PWD: $(pwd)"
log "PATH: $PATH"

if ! command -v openclaw >/dev/null 2>&1; then
  log "未找到 openclaw 命令。请先确认它已安装在 WSL 中。"
  exit 1
fi

OPENCLAW_BIN="$(command -v openclaw)"
log "OpenClaw binary: $OPENCLAW_BIN"

log "停止前检查 Gateway 状态..."
STATUS_OUTPUT="$(openclaw gateway status 2>&1 || true)"
printf '%s\n' "$STATUS_OUTPUT" | tee -a "$LOG_FILE"

if printf '%s' "$STATUS_OUTPUT" | grep -qiE 'runtime:\s*stopped'; then
  log "OpenClaw 已经是停止状态，无需重复停止。"
  log "日志文件：$LOG_FILE"
  exit 0
fi

log "开始停止 Gateway..."
run_and_log openclaw gateway stop

log "等待 3 秒后再次检查状态..."
sleep 3
run_and_log openclaw gateway status

log "停止流程完成。"
log "日志文件：$LOG_FILE"
