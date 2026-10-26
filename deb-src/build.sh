#!/bin/bash
# Build canoscan-lide400-driver_1.2-1_all.deb from deb-src.
# Run inside WSL:  bash /mnt/d/Projects/personal/canoscan/deb-src/build.sh
set -euo pipefail

SRC=/mnt/d/Projects/personal/canoscan/deb-src/canoscan-lide400-driver
OUT_WIN=/mnt/d/Projects/personal/canoscan
WORK=/tmp/canoscan-lide400-build
PKG=canoscan-lide400-driver
VER=1.2-1

rm -rf "$WORK"
mkdir -p "$WORK"
cp -a "$SRC" "$WORK/$PKG"
STAGE="$WORK/$PKG"

# Normalize permissions (drvfs exposes everything as 0777)
find "$STAGE" -type d -exec chmod 0755 {} +
find "$STAGE" -type f -exec chmod 0644 {} +
chmod 0755 "$STAGE/DEBIAN/postinst"

# Installed-Size (data files only, KiB) and md5sums
SIZE=$(du -sk "$STAGE/usr" | cut -f1)
sed -i "s/@@INSTALLED_SIZE@@/$SIZE/" "$STAGE/DEBIAN/control"
(cd "$STAGE" && find . -type f ! -path './DEBIAN/*' -print0 \
  | sort -z | xargs -0 md5sum > DEBIAN/md5sums)

# Build
dpkg-deb --root-owner-group --build "$STAGE" "$WORK/${PKG}_${VER}_all.deb"

# Validate structure
echo "--- dpkg-deb --info ---"
dpkg-deb --info "$WORK/${PKG}_${VER}_all.deb"
echo "--- dpkg-deb --contents ---"
dpkg-deb --contents "$WORK/${PKG}_${VER}_all.deb"

cp "$WORK/${PKG}_${VER}_all.deb" "$OUT_WIN/"
echo "Built: $OUT_WIN\\${PKG}_${VER}_all.deb"
