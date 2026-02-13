#!/bin/bash

# One-Line Installer for AMD Hackintosh Chrome Fix
# Downloads and runs the patcher directly.

echo "Downloading AMD Hackintosh Chrome Fix..."

# Create a temporary directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Download the fix script (Simulation - assumes repo structure)
# In a real scenario, this would curl from raw.githubusercontent.com
echo "Fetching patcher..."
curl -fsSL -o AMD_Chrome_Fix.command "https://raw.githubusercontent.com/IM-SPYBOY/AMD-Hackintosh-Chrome-Fix/main/AMD_Chrome_Fix.command"

if [ $? -ne 0 ]; then
    echo "Error: Failed to download the patcher. Please check your internet connection."
    exit 1
fi

chmod +x AMD_Chrome_Fix.command

echo "Running patcher..."
./AMD_Chrome_Fix.command

# Cleanup
rm AMD_Chrome_Fix.command
cd ..
rmdir "$TEMP_DIR"
