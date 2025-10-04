# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Repository Purpose

This repository contains Windows PowerShell setup scripts designed to automatically configure a complete PowerShell 7 development environment with Oh My Posh themes, custom profiles, and utility functions. The setup creates a personalized terminal experience optimized for development workflows.

## Repository Structure

```
windows-scripts/
└── PowerShellSetup/
    ├── install.bat                          # Windows batch installer (requires Admin)
    ├── install.ps1                         # PowerShell installation script
    ├── Microsoft.PowerShell_profile.ps1    # Custom PowerShell profile with utilities
    ├── 1_shell_blue_green.omp.json        # Custom Oh My Posh theme (blue/green variant)
    └── README.md                           # Installation and usage documentation
```

## Core Components

### Installation Scripts
- **`install.bat`**: Windows batch wrapper that checks for admin privileges and executes the PowerShell installer
- **`install.ps1`**: Main installation script that handles dependency installation and configuration

### PowerShell Profile (`Microsoft.PowerShell_profile.ps1`)
The profile contains several key sections:
- **Theme Configuration**: Multiple Oh My Posh theme options (atomic is default, custom blue/green available)
- **PSReadLine Settings**: Enhanced command-line editing with prediction and history
- **Development Cleanup Functions**: Utilities for managing development processes and system resources
- **Safety Features**: Modified `exit` command to prevent accidental session termination
- **Custom Aliases**: Enhanced directory listings and shortcuts

### Custom Theme
- **`1_shell_blue_green.omp.json`**: Custom Oh My Posh theme with blue/green color scheme showing user info, time, git status, execution time, and system memory usage

## Common Commands

### Installation
```powershell
# Option 1: Right-click install.bat and "Run as Administrator"
# Option 2: From PowerShell (as Administrator)
Set-ExecutionPolicy Bypass -Scope Process -Force
.\install.ps1
```

### Profile Management
```powershell
# Edit PowerShell profile
notepad $PROFILE

# Reload profile after changes
. $PROFILE

# Check Oh My Posh themes directory
$env:POSH_THEMES_PATH
```

### Development Cleanup Functions
```powershell
# Quick clear screen
clean

# Kill orphaned development processes and clean temp files
clean-dev

# Comprehensive system cleanup (includes clean-dev + system tasks)
clean-system

# Show running development processes
show-dev-processes

# Kill specific process by name
kill-process "node"
```

### Theme Switching
To change Oh My Posh themes, edit `$PROFILE` and uncomment the desired theme line:
- `atomic` (default)
- `1_shell_blue_green` (custom)
- `nu4a`, `night-owl`, `marcduiker`, `slim`, `cert`, `blueish`, `1_shell`
- Plus several others

## Architecture Notes

### Installation Flow
1. **Dependency Check**: Verifies admin privileges and existing installations
2. **Package Managers**: Installs Chocolatey if not present, uses winget as primary for Oh My Posh
3. **Core Components**: PowerShell 7, Oh My Posh, Nerd Fonts (CaskaydiaCove)
4. **Profile Setup**: Copies custom profile and theme files to appropriate locations
5. **Module Installation**: Ensures PSReadLine is available

### Safety Features
- Admin privilege verification before installation
- Existing installation detection to prevent conflicts
- Modified `exit` command with confirmation to prevent accidental Warp session termination
- Error handling for locked files during cleanup operations

### Development Process Management
The profile includes sophisticated cleanup functions that:
- Target common development processes (Node.js, Python, Java, Git)
- Clean temporary files older than 7 days
- Force garbage collection
- Preserve system-critical processes

## Environment Integration

### PowerShell Profile Variables
- Uses `$PROFILE` automatic variable for profile location
- Leverages `$env:POSH_THEMES_PATH` for theme management
- Integrates with `$env:TEMP` and system temp directories

### Terminal Features
- Git status integration when in repositories
- Memory usage display in prompt
- Command execution time tracking
- Enhanced command history with search capabilities

## Testing and Validation

### Post-Installation Verification
```powershell
# Verify Oh My Posh installation
oh-my-posh version

# Test profile functions
clean
show-dev-processes

# Check theme loading
$env:POSH_THEMES_PATH
```

### Common Issues
- **Font Display**: Ensure terminal uses "CaskaydiaCove NF" font
- **Theme Loading**: Verify Oh My Posh themes path is accessible
- **Module Errors**: Ensure PSReadLine module is installed correctly