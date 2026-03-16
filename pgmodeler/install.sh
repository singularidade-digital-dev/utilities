#!/usr/bin/env bash
# =============================================================================
# pgModeler 1.2.1 - Build from source for Linux Mint 22.1 / Ubuntu 24.04
# =============================================================================
# Tested on: Linux Mint 22.1 Xia (Ubuntu 24.04 Noble base)
# PostgreSQL compatibility: up to PG 18 (with patch applied)
# License: This script is MIT. pgModeler itself is GPLv3.
# =============================================================================

set -euo pipefail

PGMODELER_VERSION="v1.2.1"
PGMODELER_REPO="https://github.com/pgmodeler/pgmodeler.git"
BUILD_DIR="/tmp/pgmodeler"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== pgModeler ${PGMODELER_VERSION} - Build from source ==="
echo ""

# --- 1. Install build dependencies ---
echo "[1/6] Installing build dependencies..."
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
echo "[2/6] Removing old pgmodeler (if installed via apt)..."
sudo apt remove -y pgmodeler pgmodeler-common 2>/dev/null || true

# --- 3. Clone and checkout ---
echo "[3/6] Cloning pgModeler ${PGMODELER_VERSION}..."
rm -rf "${BUILD_DIR}"
git clone "${PGMODELER_REPO}" "${BUILD_DIR}"
cd "${BUILD_DIR}"
git checkout "${PGMODELER_VERSION}"

# --- 4. Apply PostgreSQL 18 compatibility patch ---
echo "[4/6] Applying PostgreSQL 18 compatibility patch..."
if [ -f "${SCRIPT_DIR}/patches/pg18-support.patch" ]; then
  git apply "${SCRIPT_DIR}/patches/pg18-support.patch"
  echo "       Patch applied successfully."
else
  echo "       WARNING: Patch file not found at ${SCRIPT_DIR}/patches/pg18-support.patch"
  echo "       pgModeler will NOT work with PostgreSQL 18 without this patch."
  echo "       Continuing build anyway..."
fi

# --- 5. Build ---
echo "[5/6] Building (this may take a few minutes)..."
qmake6 pgmodeler.pro
make -j"$(nproc)"

# --- 6. Install ---
echo "[6/6] Installing to /usr/local/..."
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
