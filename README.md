# AMD Hackintosh Chrome Fix

This utility resolves system instability issues on AMD Hackintosh environments caused by hardware acceleration in Google Chrome and Chromium-based browsers. It functions by disabling GPU acceleration and software rasterization flags at launch.

## Overview

On macOS systems running on AMD processers (Raphael, Ryzen, Threadripper), Chromium's GPU process can trigger kernel panics or system freezes. This tool patches the application bundle to enforce safe launch parameters permanently.

### Features

- Disables GPU acceleration (--disable-gpu)
- Disables software rasterization (--disable-software-rasterizer)
- Targeting Google Chrome specifically
- No system file modifications (Application bundle only)

## Usage

### One-Line Installation

Execute the following command in Terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/IM-SPYBOY/AMD-Hackintosh-Chrome-Fix/main/install.sh | bash
```

### Manual Installation

1. Download `AMD_Chrome_Fix.command` from the [releases page](https://github.com/IM-SPYBOY/AMD-Hackintosh-Chrome-Fix/releases/latest) or directly: [Download v1.0.0](https://github.com/IM-SPYBOY/AMD-Hackintosh-Chrome-Fix/releases/download/v1.0.0/AMD_Chrome_Fix.command)
2. Execute the script by double-clicking the file.
3. If prompted, enter your system password to allow modification of the Application bundle.

## Technical Details

The script replaces the main specific executable within the Application bundle with a shell wrapper. The original executable is backed up with a `.real` extension. The wrapper invokes the original binary with appended safety flags.

To revert changes, reinstall the browser application.
