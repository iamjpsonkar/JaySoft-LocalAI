#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
for script in "$ROOT/bin/localai" "$ROOT/scripts/"*.sh; do
  bash -n "$script"
done
grep -Fq 'qwen2.5-coder:3b' "$ROOT/bin/localai"
grep -Fq 'readlink -f' "$ROOT/bin/localai"
grep -Fq 'export OLLAMA_MODELS=' "$ROOT/scripts/install.sh"
grep -Fq 'export OLLAMA_HOME=' "$ROOT/scripts/install.sh"
grep -Fq 'approval_policy = "on-request"' "$ROOT/scripts/install.sh"
grep -Fq '[analytics]' "$ROOT/scripts/install.sh"
grep -Fq 'enabled = false' "$ROOT/scripts/install.sh"
grep -Fq '2c88f0f31a959bac5a3cad4cc5296ec568551d4aa79f548f554adb2b575b3133' "$ROOT/scripts/install-runtime.sh"
if grep -Fq 'ask_for_approval' "$ROOT/scripts/install.sh"; then
  echo "legacy config key found" >&2
  exit 1
fi
echo "localai script checks passed"
