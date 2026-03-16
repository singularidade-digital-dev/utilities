#!/usr/bin/env bash
# =============================================================================
# pgModeler 1.2.1 - Build from source for Linux Mint 22.1 / Ubuntu 24.04
# =============================================================================
# Tested on: Linux Mint 22.1 Xia (Ubuntu 24.04 Noble base)
# PostgreSQL compatibility: up to PG 18 (patch applied automatically)
# License: This script is MIT. pgModeler itself is GPLv3.
# =============================================================================

set -euo pipefail

PGMODELER_VERSION="v1.2.1"
PGMODELER_REPO="https://github.com/pgmodeler/pgmodeler.git"
BUILD_DIR="/tmp/pgmodeler"

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
# pgModeler 1.2.1 only supports up to PG 17. When it connects to PG 18,
# the version parser falls back to PG 10.0 (MinimumVersion), which causes
# catalog queries to use the removed column `pg_proc.proisagg` (removed in PG 11).
# This patch adds PgSqlVersion180 and sets it as the new DefaultVersion.
echo "[4/6] Applying PostgreSQL 18 compatibility patch..."
git apply - <<'PATCH'
diff --git a/libs/libutils/src/pgsqlversions.cpp b/libs/libutils/src/pgsqlversions.cpp
index 726e713c8..ccf15d6e5 100644
--- a/libs/libutils/src/pgsqlversions.cpp
+++ b/libs/libutils/src/pgsqlversions.cpp
@@ -29,12 +29,13 @@ namespace PgSqlVersions {
 	PgSqlVersion150("15.0"),
 	PgSqlVersion160("16.0"),
 	PgSqlVersion170("17.0"),
-	DefaulVersion = PgSqlVersion170,
+	PgSqlVersion180("18.0"),
+	DefaulVersion = PgSqlVersion180,
 	MinimumVersion = PgSqlVersion100;

 	const QStringList
 	AllVersions = {
-		PgSqlVersion170, PgSqlVersion160,
+		PgSqlVersion180, PgSqlVersion170, PgSqlVersion160,
 		PgSqlVersion150, PgSqlVersion140,
 		PgSqlVersion130, PgSqlVersion120,
 		PgSqlVersion110, PgSqlVersion100
diff --git a/libs/libutils/src/pgsqlversions.h b/libs/libutils/src/pgsqlversions.h
index 58101edb8..0737684dd 100644
--- a/libs/libutils/src/pgsqlversions.h
+++ b/libs/libutils/src/pgsqlversions.h
@@ -39,6 +39,7 @@ namespace PgSqlVersions {
 	PgSqlVersion150,
 	PgSqlVersion160,
 	PgSqlVersion170,
+	PgSqlVersion180,
 	MinimumVersion,
 	DefaulVersion;
PATCH
echo "       Patch applied successfully."

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
