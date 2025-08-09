#!/usr/bin/env bash
set -euo pipefail

# Quick build script for MicroPython RP2 (HID enabled)
ROOT_DIR=$(pwd)

if ! command -v arm-none-eabi-gcc >/dev/null 2>&1; then
  echo "ERROR: Missing GNU Arm toolchain (arm-none-eabi-gcc)."
  echo "Ubuntu: sudo apt install gcc-arm-none-eabi"
  exit 1
fi

# Clone MicroPython if needed
if [ ! -d micropython ]; then
  git clone https://github.com/micropython/micropython.git
fi

cd micropython
git submodule update --init --recursive

# Prepare pico-sdk inside ports/rp2 if missing
if [ ! -d ports/rp2/pico-sdk ]; then
  git clone https://github.com/raspberrypi/pico-sdk.git ports/rp2/pico-sdk
  (cd ports/rp2/pico-sdk && git submodule update --init)
fi

# Apply HID patch (idempotent)
if [ -f ../patches/mpconfigport.h.patch ]; then
  patch -p0 < ../patches/mpconfigport.h.patch || true
fi

cd ports/rp2
make submodules

# Try PICO by default; adjust if needed (PICO_W, etc.)
: "${BOARD:=PICO}"
make BOARD="${BOARD}" -j"$(nproc)"

echo "Build done. Find firmware at: $(pwd)/build-${BOARD}/firmware.uf2"
