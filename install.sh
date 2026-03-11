#!/bin/bash

# One-Line Installer for AMD Hackintosh Chromium Fix
# Downloads and runs the patcher directly.

set -e

echo "Downloading AMD Hackintosh Chromium Fix..."

# Create a temporary directory
TEMP_DIR=$(mktemp -d)

cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

echo "Fetching patcher..."
curl -fsSL -o "$TEMP_DIR/AMD_Chrome_Fix.command" \
    "https://raw.githubusercontent.com/IM-SPYBOY/AMD-Hackintosh-Chrome-Fix/main/AMD_Chrome_Fix.command"

chmod +x "$TEMP_DIR/AMD_Chrome_Fix.command"

echo "Running patcher..."
"$TEMP_DIR/AMD_Chrome_Fix.command"
