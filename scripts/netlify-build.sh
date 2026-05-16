#!/usr/bin/env bash
set -euo pipefail

FLUTTER_VERSION="${FLUTTER_VERSION:-3.38.7}"

if ! command -v flutter >/dev/null 2>&1; then
  CACHE_ROOT="${NETLIFY_BUILD_BASE:-$HOME/.cache}"
  FLUTTER_ROOT="$CACHE_ROOT/flutter"

  if [ ! -x "$FLUTTER_ROOT/bin/flutter" ]; then
    rm -rf "$FLUTTER_ROOT"
    git clone --depth 1 --branch "$FLUTTER_VERSION" https://github.com/flutter/flutter.git "$FLUTTER_ROOT"
  fi

  export PATH="$FLUTTER_ROOT/bin:$PATH"
fi

flutter --version
flutter config --enable-web
flutter pub get
flutter build web --release --no-tree-shake-icons --no-wasm-dry-run
