#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALL_DIR="$HOME/.local/bin"
LOCALAI_HOME="${LOCALAI_HOME:-$HOME/.localai}"
MODEL="${LOCALAI_MODEL:-qwen2.5-coder:3b}"
export OLLAMA_MODELS="${OLLAMA_MODELS:-$LOCALAI_HOME/models}"
export OLLAMA_HOME="${OLLAMA_HOME:-$LOCALAI_HOME/ollama}"
export OLLAMA_HOST="${OLLAMA_HOST:-127.0.0.1:11434}"
export OLLAMA_CONTEXT_LENGTH="${OLLAMA_CONTEXT_LENGTH:-8192}"
mkdir -p "$INSTALL_DIR" "$LOCALAI_HOME/codex" "$LOCALAI_HOME/models"
chmod +x \
  "$ROOT/bin/localai" \
  "$ROOT/scripts/install-runtime.sh" \
  "$ROOT/scripts/install.sh" \
  "$ROOT/scripts/localai-runtime.sh" \
  "$ROOT/scripts/uninstall.sh"
ln -sfn "$ROOT/bin/localai" "$INSTALL_DIR/localai"
PATH_MARKER="# Added by JaySoft LocalAI installer"
if ! grep -Fq "$PATH_MARKER" "$HOME/.bashrc" 2>/dev/null; then
  {
    printf '\n%s\n' "$PATH_MARKER"
    printf 'export PATH="$HOME/.local/bin:$PATH"\n'
  } >> "$HOME/.bashrc"
fi
"$ROOT/scripts/install-runtime.sh"
if [ ! -f "$LOCALAI_HOME/codex/config.toml" ]; then
  cat > "$LOCALAI_HOME/codex/config.toml" <<EOF
model = "$MODEL"
model_provider = "ollama"
oss_provider = "ollama"
model_context_window = 8192
model_auto_compact_token_limit = 6144
approval_policy = "on-request"
sandbox_mode = "workspace-write"
web_search = "disabled"
personality = "pragmatic"

[analytics]
enabled = false

[feedback]
enabled = false
EOF
fi
"$ROOT/scripts/localai-runtime.sh" ensure
if ! "$ROOT/runtime/bin/ollama" list | awk 'NR > 1 {print $1}' | grep -Fxq "$MODEL"; then
  echo "Downloading $MODEL (about 1.9 GB)..."; "$ROOT/runtime/bin/ollama" pull "$MODEL"
fi
echo "Installed localai at $INSTALL_DIR/localai"
case ":$PATH:" in *":$INSTALL_DIR:"*) ;; *) echo 'Open a new terminal, or run: source ~/.bashrc' ;; esac
echo "Run: localai doctor"
