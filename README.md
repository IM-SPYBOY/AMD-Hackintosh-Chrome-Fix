# AMD Hackintosh Chrome Fix

Fixes system crashes and reboots on AMD Hackintosh systems when launching Google Chrome or Chromium.
This tool disables GPU acceleration and software rasterization for the browser application bundle.

## Features
- **AMD Specific**: Optimized for AMD Ryzen/Threadripper Hackintosh builds.
- **Safe**: Does not modify system files, only the application bundle.
- **Easy**: Double-clickable script or one-line terminal command.
- **Chrome Only**: Targets Google Chrome (can be modified for Chromium).

## Usage

### Option 1: One-Line Command (Recommended)
Open Terminal and paste this command:

```bash
curl -fsSL https://raw.githubusercontent.com/IM-SPYBOY/AMD-Hackintosh-Chrome-Fix/main/install.sh | bash
```
*(Replace `YOUR_GITHUB_USERNAME` with your actual GitHub username after forking/pushing)*

### Option 2: Manual Download
1. Download `AMD_Chrome_Fix.command` from releases.
2. Double-click to run.
3. Enter password if prompted (only required if standard user).

## How it works
It replaces the main executable within `Google Chrome.app` with a wrapper script that forces the following flags:
- `--disable-gpu`
- `--disable-software-rasterizer`

To revert changes, simply reinstall Chrome.
