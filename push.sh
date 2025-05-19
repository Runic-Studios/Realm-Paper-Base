#!/bin/bash
set -euo pipefail

echo "Pulling LFS files..."
git lfs pull

TARGET="/mnt/realm-paper-base/server"
SOURCE="./server"

# Copy the file
sudo mkdir -p "$TARGET" || true

echo "Copying $SOURCE to $TARGET"
sudo rm -rf $TARGET{*,.*}
sudo cp -r "$SOURCE" "$TARGET"
echo "Done."
