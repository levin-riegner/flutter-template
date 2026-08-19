#!/usr/bin/env bash
# Build & run the Flutter app on Linux for this box.
#
# This host's NVIDIA EGL driver segfaults (SIGSEGV in libnvidia-eglcore.so,
# raster thread) even on the real DISPLAY :0. The workaround is a virtual X
# server (Xvfb) with Mesa's software rasterizer (swrast).
#
# Usage:
#   scripts/run-linux.sh            # release build, then run (headless Xvfb)
#   scripts/run-linux.sh --visible  # show on real desktop (Xephyr window)
#   scripts/run-linux.sh --debug    # debug build
#   scripts/run-linux.sh --run-only # skip rebuild, run existing bundle
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FLUTTER="${FLUTTER:-$HOME/flutter_sdk/bin/flutter}"

BUILD_TYPE="release"
RUN_ONLY=0
VISIBLE=0
for arg in "$@"; do
  case "$arg" in
    --debug) BUILD_TYPE="debug" ;;
    --run-only) RUN_ONLY=1 ;;
    --visible) VISIBLE=1 ;;
  esac
done

BUNDLE_DIR="build/linux/arm64/${BUILD_TYPE}/bundle"

if [ "$RUN_ONLY" -ne 1 ]; then
  echo ">> flutter build linux --${BUILD_TYPE}"
  "$FLUTTER" build linux --"$BUILD_TYPE"
fi

BIN="$ROOT/$BUNDLE_DIR/swiss_ai"
if [ ! -x "$BIN" ]; then
  echo "Binary not found: $BIN" >&2
  echo "Build it first: $FLUTTER build linux --${BUILD_TYPE}" >&2
  exit 1
fi

# Visible on the real desktop (--visible): Xephyr software-rendered window.
# Xephyr must use -dumb -fakexa (pure software); with GPU accel it crashes
# during display reconfigurations (NVIDIA EGL driver bug).
if [ "$VISIBLE" -eq 1 ]; then
  DESKTOP="${DESKTOP:-:0}"
  VDISPLAY="${VDISPLAY:-:1}"
  echo ">> Starting Xephyr $VDISPLAY (software) inside $DESKTOP"
  Xephyr "$VDISPLAY" -screen 1280x720 -ac -br -dumb -fakexa -softCursor &
  XEPHYR_PID=$!
  trap 'kill $XEPHYR_PID 2>/dev/null' EXIT
  for _ in $(seq 1 20); do
    DISPLAY="$VDISPLAY" xdpyinfo >/dev/null 2>&1 && break
    sleep 0.5
  done
  echo ">> Running app on $VDISPLAY (window: 'Xephyr on $VDISPLAY')"
  DISPLAY="$VDISPLAY" MESA_LOADER_DRIVER_OVERRIDE=swrast LIBGL_DEBUG=disable \
    exec "$BIN"
fi

# Headless: virtual X server.
echo ">> Running under Xvfb (Mesa software rasterizer)"
MESA_LOADER_DRIVER_OVERRIDE=swrast \
LIBGL_DEBUG=disable \
exec xvfb-run -a --server-args="-screen 0 1280x720x24" "$BIN"
