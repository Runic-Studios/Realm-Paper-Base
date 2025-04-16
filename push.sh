#!/bin/bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <registry-username> <registry-password>"
  exit 1
fi

REGISTRY_USER="$1"
REGISTRY_PASSWORD="$2"

ARTIFACT="registry.runicrealms.com/library/realm-paper-base:latest"

rm -f artifact.zip || true
echo 'Zipping artifact...'
cd server
zip -r ../artifact.zip .
cd ..
echo 'Logging into registry...'
oras login registry.runicrealms.com -u "$REGISTRY_USER" -p "$REGISTRY_PASSWORD"
echo 'Pushing artifact...'
oras push "$ARTIFACT" artifact.zip
rm artifact.zip
