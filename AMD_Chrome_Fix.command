#!/bin/bash
cd "$(dirname "$0")"

# AMD Hackintosh Chrome Fixer
# Disables GPU acceleration for Google Chrome to prevent system crashes on AMD Hackintosh systems.

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}---------------------------------------------------${NC}"
echo -e "${GREEN}      AMD Hackintosh Chrome Fixer (No Sudo)        ${NC}"
echo -e "${GREEN}---------------------------------------------------${NC}"
echo ""
echo "This tool will patch Google Chrome to disable GPU acceleration."
echo "This prevents system freezes and reboots on AMD Hackintosh setups."
echo ""

# Function to patch an application
patch_app() {
    APP_PATH="$1"
    APP_NAME="$2"
    EXECUTABLE_PATH="$APP_PATH/Contents/MacOS/$APP_NAME"
    REAL_EXECUTABLE_PATH="$EXECUTABLE_PATH.real"

    if [ ! -d "$APP_PATH" ]; then
        echo "Searching for $APP_NAME..."
        echo "  - Not found at $APP_PATH. Skipping."
        return
    fi

    echo "Found $APP_NAME. Checking status..."

    if [ -f "$REAL_EXECUTABLE_PATH" ]; then
        echo -e "  - ${GREEN}Already patched.${NC}"
    else
        echo "  - Patching..."
        
        # Check write permission
        if [ ! -w "$EXECUTABLE_PATH" ]; then
             echo -e "${RED}Error: Cannot write to $EXECUTABLE_PATH. Please run with sudo manually if needed.${NC}"
             return
        fi

        # Renaissance Backup
        mv "$EXECUTABLE_PATH" "$REAL_EXECUTABLE_PATH"
        
        # Create Wrapper
        cat <<EOF > "$EXECUTABLE_PATH"
#!/bin/bash
# Wrapper to force safe mode flags
# Created by AMD Chrome Fixer

USER_FLAGS="--disable-gpu --disable-software-rasterizer"
exec "\$0.real" "\$@" \$USER_FLAGS
EOF
        
        chmod +x "$EXECUTABLE_PATH"
        echo -e "  - ${GREEN}Success! $APP_NAME is now safe to launch.${NC}"
    fi
}

# Only patch Google Chrome
patch_app "/Applications/Google Chrome.app" "Google Chrome"

echo ""
echo -e "${GREEN}All done! You can close this window.${NC}"
echo ""
read -p "Press any key to exit..."
