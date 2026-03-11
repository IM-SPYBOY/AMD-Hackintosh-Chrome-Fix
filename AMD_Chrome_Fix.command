#!/bin/bash
cd "$(dirname "$0")"

# AMD Hackintosh Chromium Fixer
# Disables GPU acceleration for Chromium-based browsers to prevent
# system crashes on AMD Hackintosh systems.

set -eo pipefail

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

SAFE_FLAGS="--disable-gpu --disable-software-rasterizer --disable-gpu-rasterization"

echo -e "${GREEN}---------------------------------------------------${NC}"
echo -e "${GREEN}    AMD Hackintosh Chromium Fixer                   ${NC}"
echo -e "${GREEN}---------------------------------------------------${NC}"
echo ""
echo "This tool patches Chromium-based browsers to disable GPU acceleration."
echo "This prevents system freezes and reboots on AMD Hackintosh setups."
echo ""

# Function to patch an application
patch_app() {
    APP_PATH="$1"
    APP_NAME="$2"
    EXECUTABLE_PATH="$APP_PATH/Contents/MacOS/$APP_NAME"
    REAL_EXECUTABLE_PATH="$EXECUTABLE_PATH.real"

    if [ ! -d "$APP_PATH" ]; then
        echo -e "  ${YELLOW}⊘${NC} $APP_NAME — not installed. Skipping."
        return
    fi

    echo -n "  • $APP_NAME — "

    # Case 1: .real exists AND the current executable is already our wrapper → already patched
    if [ -f "$REAL_EXECUTABLE_PATH" ]; then
        if head -1 "$EXECUTABLE_PATH" 2>/dev/null | grep -q "^#!/bin/bash"; then
            # Wrapper is in place, but ensure flags are up-to-date
            if grep -q -- "$SAFE_FLAGS" "$EXECUTABLE_PATH" 2>/dev/null; then
                echo -e "${GREEN}already patched.${NC}"
                return
            else
                echo -e "${YELLOW}updating flags...${NC}"
                # Regenerate wrapper with current flags
                cat <<WRAPPER > "$EXECUTABLE_PATH"
#!/bin/bash
# Wrapper to force safe mode flags
# Created by AMD Hackintosh Chromium Fixer

USER_FLAGS="$SAFE_FLAGS"
exec "\$0.real" "\$@" \$USER_FLAGS
WRAPPER
                chmod +x "$EXECUTABLE_PATH"
                echo -e "    ${GREEN}✓ flags updated.${NC}"
                return
            fi
        else
            # .real exists but the main executable is a native binary again (browser updated itself)
            if [ ! -w "$EXECUTABLE_PATH" ]; then
                echo -e "${RED}browser updated but no write permission. Run with sudo if needed.${NC}"
                return
            fi
            echo -e "${YELLOW}browser was updated, re-patching...${NC}"
            # The current native binary is newer; replace the stale .real backup
            mv "$EXECUTABLE_PATH" "$REAL_EXECUTABLE_PATH"
            # Fall through to create wrapper below
        fi
    fi

    # Case 2: Fresh patch needed (no .real exists, or we just refreshed .real above)
    # Check write permission
    if [ ! -w "$EXECUTABLE_PATH" ] && [ ! -f "$REAL_EXECUTABLE_PATH" ]; then
        echo -e "${RED}no write permission. Run with sudo if needed.${NC}"
        return
    fi

    # Backup original if not already done above
    if [ ! -f "$REAL_EXECUTABLE_PATH" ]; then
        mv "$EXECUTABLE_PATH" "$REAL_EXECUTABLE_PATH"
    fi

    # Create wrapper
    cat <<WRAPPER > "$EXECUTABLE_PATH"
#!/bin/bash
# Wrapper to force safe mode flags
# Created by AMD Hackintosh Chromium Fixer

USER_FLAGS="$SAFE_FLAGS"
exec "\$0.real" "\$@" \$USER_FLAGS
WRAPPER

    chmod +x "$EXECUTABLE_PATH"
    echo -e "${GREEN}✓ patched successfully.${NC}"
}

echo "Scanning for Chromium-based browsers..."
echo ""

# Patch supported Chromium-based browsers
patch_app "/Applications/Google Chrome.app" "Google Chrome"
patch_app "/Applications/Brave Browser.app" "Brave Browser"
patch_app "/Applications/Microsoft Edge.app" "Microsoft Edge"
patch_app "/Applications/Arc.app" "Arc"
patch_app "/Applications/Vivaldi.app" "Vivaldi"

# Disable auto-updates only for installed browsers
echo ""
echo "Disabling background auto-update services..."

if [ -d "/Applications/Google Chrome.app" ]; then
    defaults write com.google.Keystone.Agent checkInterval 0 2>/dev/null || true
    echo -e "  ${GREEN}✓${NC} Chrome auto-update disabled."
fi
if [ -d "/Applications/Microsoft Edge.app" ]; then
    defaults write com.microsoft.autoupdate2 HowToCheck "Manual" 2>/dev/null || true
    echo -e "  ${GREEN}✓${NC} Edge auto-update disabled."
fi
if [ -d "/Applications/Brave Browser.app" ]; then
    defaults write com.brave.Browser SUEnableAutomaticChecks -bool NO 2>/dev/null || true
    echo -e "  ${GREEN}✓${NC} Brave auto-update disabled."
fi

# Patch Antigravity AI Agent if installed
if [ -d "$HOME/.gemini/antigravity" ]; then
    echo ""
    echo "Antigravity Agent detected. Patching safe_chromium script..."
    mkdir -p "$HOME/.gemini/antigravity/scripts"
    cat <<'EOF' > "$HOME/.gemini/antigravity/scripts/safe_chromium"
#!/bin/bash
# Patched by AMD Hackintosh Chromium Fixer
# Launches Chrome with all GPU-related features disabled for AMD stability.
open -a "Google Chrome" --args --disable-gpu --disable-software-rasterizer --disable-gpu-rasterization
EOF
    chmod +x "$HOME/.gemini/antigravity/scripts/safe_chromium"
    echo -e "  ${GREEN}✓${NC} Antigravity now launches Chrome in safe mode."
fi

echo ""
echo -e "${GREEN}All done! You can close this window.${NC}"
echo ""
read -rp "Press any key to exit..." || true
