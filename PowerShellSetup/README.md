# PowerShell & Oh My Posh Setup Package

This package will automatically install and configure PowerShell with Oh My Posh themes and custom settings.

## What This Installs

1. **PowerShell 7** (latest version)
2. **Oh My Posh** (terminal prompt theme engine)
3. **Nerd Fonts** (required for icons in themes)
4. **Custom PowerShell Profile** with:
   - Multiple Oh My Posh themes (atomic, nu4a, night-owl, marcduiker, slim, cert, blueish, 1_shell, and custom 1_shell_blue_green)
   - Custom aliases and functions
   - Development cleanup utilities
   - Enhanced color schemes

## Installation Instructions

### Option 1: Automated Installation (Recommended)
1. Right-click on `install.bat` and select "Run as Administrator"
2. Follow the prompts
3. Restart your terminal when complete

### Option 2: PowerShell Script
1. Open PowerShell as Administrator
2. Run: `Set-ExecutionPolicy Bypass -Scope Process -Force`
3. Run: `.\install.ps1`
4. Restart your terminal when complete

## Files Included

- `install.bat` - Batch file for easy installation
- `install.ps1` - PowerShell installation script
- `Microsoft.PowerShell_profile.ps1` - Custom PowerShell profile
- `1_shell_blue_green.omp.json` - Custom Oh My Posh theme

## Post-Installation

After installation:
1. Open a new PowerShell window
2. The atomic theme will be active by default
3. To change themes, edit `$PROFILE` and uncomment your preferred theme

## Changing Themes

Edit your PowerShell profile:
```powershell
notepad $PROFILE
```

Find the Oh My Posh section and uncomment the theme you want to use (remove the `#` at the beginning of the line).

## Available Themes

- atomic (default)
- nu4a
- night-owl
- marcduiker
- slim
- cert
- blueish
- 1_shell (original pink/purple)
- 1_shell_blue_green (custom blue/green version)
- jv_sitecorian
- jonnychipz
- devious-diamonds

## Troubleshooting

If icons don't display correctly:
1. Install a Nerd Font (included in installation)
2. Set your terminal to use the installed Nerd Font (e.g., "CaskaydiaCove NF")

If themes don't load:
1. Verify Oh My Posh is installed: `oh-my-posh version`
2. Check theme path: `$env:POSH_THEMES_PATH`
3. Reload profile: `. $PROFILE`

## Custom Functions Included

- `clean` - Clear screen
- `clean-dev` - Clean development processes and temp files
- `clean-system` - Comprehensive system cleanup
- `show-dev-processes` - Show running development processes
- `kill-process <name>` - Kill processes by name
- `ls` / `ll` - Enhanced directory listing

## Notes

- The profile includes safety features to prevent accidental terminal exits
- Memory usage is displayed in the prompt
- Git status is shown when in a repository
- Execution time is shown for commands
