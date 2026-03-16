#!/usr/bin/env bash
# =============================================================================
# pgModeler 1.2.1 - Build from source for Linux Mint 22.1 / Ubuntu 24.04
# =============================================================================
# Tested on: Linux Mint 22.1 Xia (Ubuntu 24.04 Noble base)
# PostgreSQL compatibility: up to PG 18
# License: This script is MIT. pgModeler itself is GPLv3.
# =============================================================================

set -euo pipefail

PGMODELER_VERSION="v1.2.1"
PGMODELER_REPO="https://github.com/pgmodeler/pgmodeler.git"
BUILD_DIR="/tmp/pgmodeler"

echo "=== pgModeler ${PGMODELER_VERSION} - Build from source ==="
echo ""

# --- 1. Install build dependencies ---
echo "[1/5] Installing build dependencies..."
sudo apt update -qq
sudo apt install -y \
  build-essential \
  qt6-base-dev \
  qt6-base-dev-tools \
  qt6-svg-dev \
  libpq-dev \
  libxml2-dev \
  libxslt1-dev \
  libxext-dev \
  libx11-dev \
  pkg-config

# --- 2. Remove old version (if installed from apt) ---
echo "[2/5] Removing old pgmodeler (if installed via apt)..."
sudo apt remove -y pgmodeler pgmodeler-common 2>/dev/null || true

# --- 3. Clone and checkout ---
echo "[3/5] Cloning pgModeler ${PGMODELER_VERSION}..."
rm -rf "${BUILD_DIR}"
git clone "${PGMODELER_REPO}" "${BUILD_DIR}"
cd "${BUILD_DIR}"
git checkout "${PGMODELER_VERSION}"

# --- 4. Build ---
echo "[4/5] Building (this may take a few minutes)..."
qmake6 pgmodeler.pro
make -j"$(nproc)"

# --- 5. Install ---
echo "[5/5] Installing to /usr/local/..."
sudo make install

echo ""
echo "=== Done! ==="
echo "Binaries installed:"
echo "  pgmodeler          - GUI application"
echo "  pgmodeler-cli      - Command-line interface"
echo "  pgmodeler-ch       - Crash handler"
echo "  pgmodeler-se       - Schema editor"
echo ""
echo "Run 'pgmodeler' to start the GUI."
echo "Run 'pgmodeler-cli --help' for CLI usage."
