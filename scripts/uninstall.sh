#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
"$ROOT/scripts/localai-runtime.sh" stop || true
rm -f "$HOME/.local/bin/localai"
if [ -f "$HOME/.bashrc" ]; then
  sed -i '/^# Added by JaySoft LocalAI installer$/,+1d' "$HOME/.bashrc"
fi
echo "Removed localai. User data remains in ${LOCALAI_HOME:-$HOME/.localai}."
