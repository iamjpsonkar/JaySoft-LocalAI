#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCALAI_HOME="${LOCALAI_HOME:-$HOME/.localai}"
OLLAMA="$ROOT/runtime/bin/ollama"
PID_FILE="$LOCALAI_HOME/ollama/ollama.pid"
LOG_FILE="$LOCALAI_HOME/logs/ollama.log"
MODEL="${LOCALAI_MODEL:-qwen2.5-coder:3b}"
export OLLAMA_MODELS="${OLLAMA_MODELS:-$LOCALAI_HOME/models}"
export OLLAMA_HOME="${OLLAMA_HOME:-$LOCALAI_HOME/ollama}"
export OLLAMA_HOST="${OLLAMA_HOST:-127.0.0.1:11434}"
export OLLAMA_CONTEXT_LENGTH="${OLLAMA_CONTEXT_LENGTH:-8192}"
mkdir -p "$OLLAMA_MODELS" "$OLLAMA_HOME" "$LOCALAI_HOME/logs"
healthy() { curl --silent --fail --max-time 2 "http://$OLLAMA_HOST/api/tags" >/dev/null 2>&1; }
valid_managed_pid() {
  [ -r "$PID_FILE" ] || return 1
  local pid
  pid="$(cat "$PID_FILE")"
  [[ "$pid" =~ ^[0-9]+$ ]] || return 1
  [ -r "/proc/$pid/cmdline" ] || return 1
  tr '\0' ' ' < "/proc/$pid/cmdline" | grep -Fq "$OLLAMA serve"
}
start_server() {
  healthy && return 0
  [ -x "$OLLAMA" ] || { echo "localai: runtime missing; run ./scripts/install-runtime.sh" >&2; return 1; }
  nohup "$OLLAMA" serve >>"$LOG_FILE" 2>&1 &
  echo "$!" > "$PID_FILE"
  printf 'Starting local model service'
  for _ in $(seq 1 120); do
    if healthy; then echo " ready"; return 0; fi
    if ! kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
      echo; echo "localai: Ollama exited; see $LOG_FILE" >&2; rm -f "$PID_FILE"; return 1
    fi
    printf '.'; sleep 1
  done
  echo; echo "localai: Ollama startup timed out; see $LOG_FILE" >&2; return 1
}
case "${1:-ensure}" in
  ensure|serve) start_server ;;
  stop)
    if valid_managed_pid; then kill "$(cat "$PID_FILE")"; rm -f "$PID_FILE"; echo "Stopped project-managed Ollama."
    else rm -f "$PID_FILE"; echo "No project-managed Ollama process found."; fi ;;
  models) start_server; "$OLLAMA" list ;;
  runtime) "$OLLAMA" --version ;;
  benchmark)
    start_server; start="$(date +%s)"
    curl --silent --fail "http://$OLLAMA_HOST/api/generate" -H 'Content-Type: application/json' \
      -d "{\"model\":\"$MODEL\",\"prompt\":\"Reply with exactly: ready\",\"stream\":false,\"options\":{\"num_ctx\":4096}}" \
      | jq '{response,total_duration,load_duration,prompt_eval_count,eval_count,eval_duration}'
    echo "Wall time: $(( $(date +%s) - start ))s" ;;
  *) echo "Usage: localai {runtime|models|serve|stop|benchmark}" >&2; exit 2 ;;
esac
