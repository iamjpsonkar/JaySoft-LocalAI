#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION="${OLLAMA_VERSION:-0.31.2}"
RUNTIME="$ROOT/runtime"
ARCHIVE="${TMPDIR:-/tmp}/ollama-linux-amd64-${VERSION}.tar.zst"
URL="https://github.com/ollama/ollama/releases/download/v${VERSION}/ollama-linux-amd64.tar.zst"
SHA256="2c88f0f31a959bac5a3cad4cc5296ec568551d4aa79f548f554adb2b575b3133"
mkdir -p "$RUNTIME"
if [ -x "$RUNTIME/bin/ollama" ]; then echo "Ollama runtime already installed: $($RUNTIME/bin/ollama --version 2>&1 | tail -1)"; exit 0; fi
command -v curl >/dev/null || { echo "curl is required" >&2; exit 1; }
command -v zstd >/dev/null || { echo "zstd is required" >&2; exit 1; }
echo "Downloading Ollama v${VERSION}..."
curl --fail --location --retry 3 "$URL" -o "$ARCHIVE"
echo "$SHA256  $ARCHIVE" | sha256sum --check --status || {
  echo "Ollama runtime checksum verification failed" >&2
  rm -f "$ARCHIVE"
  exit 1
}
tar --use-compress-program=zstd -xf "$ARCHIVE" -C "$RUNTIME"
rm -f "$ARCHIVE"
[ -x "$RUNTIME/bin/ollama" ] || { echo "Archive did not contain bin/ollama" >&2; exit 1; }
"$RUNTIME/bin/ollama" --version || true
