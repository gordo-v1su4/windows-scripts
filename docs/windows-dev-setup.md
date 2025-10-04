# Windows Development Environment Setup Guide

A comprehensive guide to maintaining a clean Windows installation while having a powerful development environment.

## Table of Contents
- [Philosophy](#philosophy)
- [Package Management Strategy](#package-management-strategy)
- [WSL2 Setup](#wsl2-setup)
- [Scoop Installation](#scoop-installation)
- [JavaScript Runtime Setup (Bun + pnpm)](#javascript-runtime-setup-bun--pnpm)
- [Python Environment](#python-environment)
- [Folder Structure](#recommended-folder-structure)
- [Maintenance Scripts](#maintenance-scripts)
- [Best Practices](#best-practices)

---

## Philosophy

**Goal:** Keep Windows clean while maintaining a professional development environment without Docker overhead.

**Key Principles:**
1. Use **WSL2** for Unix-based development
2. Use **Scoop** for Windows-native tools (isolated, no admin)
3. Use **Bun** and **pnpm** to avoid redundant package installations
4. Keep everything version-controlled and reproducible
5. Regular automated cleanup

---

## Package Management Strategy

### The Hybrid Approach

```
┌─────────────────────────────────────────────────┐
│               Windows (Host)                     │
│  • Scoop for Windows-native tools               │
│  • Git, PowerShell, VS Code                     │
│  • Windows-specific development                 │
└─────────────────────────────────────────────────┘
                      ↕
┌─────────────────────────────────────────────────┐
│              WSL2 (Ubuntu/Debian)                │
│  • Primary development environment              │
│  • Bun (fast JS runtime & package manager)      │
│  • pnpm (efficient Node package manager)        │
│  • Python, Go, Rust, etc.                       │
└─────────────────────────────────────────────────┘
```

**Why Bun + pnpm?**
- **Bun:** All-in-one (runtime + bundler + test runner + package manager)
- **pnpm:** Stores packages once globally, hard-links to projects (saves GB of space)
- Both are significantly faster than npm/yarn
- No duplicate `node_modules` bloat

---

## WSL2 Setup

### Installation

```powershell
# Install WSL2 with Ubuntu (run in PowerShell as Admin)
wsl --install -d Ubuntu-22.04

# Or if WSL is already enabled
wsl --install -d Ubuntu-22.04

# Check version
wsl --list --verbose

# Set as default
wsl --set-default Ubuntu-22.04
```

### First-Time Configuration

```bash
# After WSL launches, update system
sudo apt update && sudo apt upgrade -y

# Install essential build tools
sudo apt install -y \
  build-essential \
  curl \
  wget \
  git \
  unzip \
  ca-certificates

# Set up Git
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

### WSL2 Performance Tweaks

Create/edit `.wslconfig` in `C:\Users\Gordo\.wslconfig`:

```ini
[wsl2]
# Limit memory usage
memory=8GB
# Limit CPU cores
processors=4
# Enable swap
swap=2GB
# Disable page reporting (improves performance)
pageReporting=false
# Enable localhost forwarding
localhostForwarding=true
```

Restart WSL after changes:
```powershell
wsl --shutdown
```

---

## Scoop Installation

### Install Scoop

```powershell
# Set execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Install Scoop
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

### Essential Scoop Packages

```powershell
# Add useful buckets
scoop bucket add extras
scoop bucket add nerd-fonts

# Core development tools
scoop install git
scoop install 7zip
scoop install aria2  # Faster downloads

# Terminal enhancements (if not using your custom setup)
scoop install pwsh
scoop install oh-my-posh

# Useful utilities
scoop install ripgrep  # Fast grep
scoop install fzf      # Fuzzy finder
scoop install jq       # JSON processor
scoop install bat      # Better cat
scoop install gh       # GitHub CLI

# Windows-specific dev tools
scoop install visualstudio2022-workload-vctools  # C++ build tools
scoop install dotnet-sdk  # If doing .NET development
```

### Scoop Management

```powershell
# Update all packages
scoop update *

# Check for outdated packages
scoop status

# Cleanup old versions
scoop cleanup *

# Uninstall cleanly (removes all traces)
scoop uninstall <package>
```

---

## JavaScript Runtime Setup (Bun + pnpm)

### Install Bun in WSL2

```bash
# Enter WSL
wsl

# Install Bun (fast, all-in-one JavaScript runtime)
curl -fsSL https://bun.sh/install | bash

# Add to PATH (usually done automatically, verify in ~/.bashrc or ~/.zshrc)
source ~/.bashrc

# Verify installation
bun --version
```

### Install pnpm in WSL2

```bash
# Install pnpm globally with Bun
bun install -g pnpm

# Or using official installer
curl -fsSL https://get.pnpm.io/install.sh | sh -

# Verify
pnpm --version
```

### Configure pnpm for Maximum Efficiency

```bash
# Set global store location (centralized package storage)
pnpm config set store-dir ~/.pnpm-store

# Enable shamefully-hoist for compatibility (optional)
pnpm config set shamefully-hoist true

# Set global bin location
pnpm config set global-bin-dir ~/.local/bin

# View all settings
pnpm config list
```

### Using Bun vs pnpm

**Use Bun when:**
- Running TypeScript/JavaScript directly (`bun run script.ts`)
- Building projects (`bun build`)
- Running tests (`bun test`)
- Installing packages in new projects (`bun install`)

**Use pnpm when:**
- Working with existing npm/pnpm projects
- Need specific npm registry features
- Multi-package workspaces (monorepos)

### Project Setup Example

```bash
# Create new project with Bun
bun init
bun add fastify
bun run index.ts

# Or with pnpm
pnpm init
pnpm add express
pnpm start

# Convert existing project to pnpm
cd your-project
pnpm import  # Converts package-lock.json
pnpm install
```

---

## Python Environment

### Install Python in WSL2

```bash
# Install pyenv (Python version manager)
curl https://pyenv.run | bash

# Add to ~/.bashrc
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc

# Reload
source ~/.bashrc

# Install Python version
pyenv install 3.12.0
pyenv global 3.12.0

# Verify
python --version
```

### Python Project Management

```bash
# Use virtual environments (isolated per project)
cd your-project
python -m venv .venv
source .venv/bin/activate

# Or use pipenv (better dependency management)
pip install pipenv
pipenv install requests
pipenv shell

# Or use poetry (modern dependency management)
curl -sSL https://install.python-poetry.org | python3 -
poetry new my-project
poetry add fastapi
```

---

## Recommended Folder Structure

```
C:\Users\Gordo\
├── scoop\                          # Scoop installations (auto-managed)
├── Documents\
│   ├── Github\                     # Your repositories (Windows accessible)
│   │   └── windows-scripts\
│   └── PowerShell\                 # PowerShell profile
└── .wslconfig                      # WSL configuration

WSL: /home/gordo/
├── projects\                       # Active development (WSL primary)
│   ├── web\
│   │   ├── app1\
│   │   │   ├── node_modules\      # Symlinks to ~/.pnpm-store
│   │   │   └── package.json
│   │   └── app2\
│   ├── python\
│   └── go\
├── .pnpm-store\                   # Global package storage (ONE COPY)
├── .pyenv\                        # Python versions
├── .bun\                          # Bun installation
└── .config\                       # Tool configurations
```

### Access Windows Files from WSL

```bash
# Windows C:\ drive is mounted at /mnt/c/
cd /mnt/c/Users/Gordo/Documents/Github

# Or create symlink for easier access
ln -s /mnt/c/Users/Gordo/Documents/Github ~/windows-repos
```

### Access WSL Files from Windows

```
\\wsl$\Ubuntu-22.04\home\gordo\projects
```

Or in File Explorer: `\\wsl.localhost\Ubuntu-22.04\home\gordo\projects`

---

## Maintenance Scripts

### Weekly Cleanup (Already Created)

Located at: `PowerShellSetup\weekly-cleanup.ps1`

Run manually or schedule with Task Scheduler:
```powershell
# Run as Admin
.\PowerShellSetup\weekly-cleanup.ps1
```

### pnpm Cleanup

```bash
# Remove unused packages from global store
pnpm store prune

# Check disk usage
du -sh ~/.pnpm-store

# Clean cache
pnpm cache clean --force
```

### WSL Disk Cleanup

```bash
# Clear apt cache
sudo apt clean
sudo apt autoremove

# Clean Docker (if installed)
docker system prune -a

# Find large directories
du -sh ~/.* | sort -h

# Clean old Python packages
pip cache purge
```

### Compact WSL2 Disk (PowerShell)

```powershell
# Shutdown WSL
wsl --shutdown

# Compact the virtual disk
Optimize-VHD -Path C:\Users\Gordo\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu*\LocalState\ext4.vhdx -Mode Full
```

---

## Best Practices

### 1. Always Use Virtual Environments

**JavaScript:**
```bash
# Each project has its own node_modules (via pnpm hardlinks)
cd project
pnpm install  # Only downloads missing packages
```

**Python:**
```bash
# Always create venv per project
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### 2. Use .gitignore Properly

```gitignore
# Node
node_modules/
.pnpm-debug.log
bun.lockb

# Python
.venv/
__pycache__/
*.pyc
.pytest_cache/

# General
.env
.DS_Store
```

### 3. Keep Dependencies Updated

```bash
# Bun
bun update

# pnpm
pnpm update --latest

# Python
pip list --outdated
pip install -U package_name
```

### 4. Use Your Profile Functions

```powershell
# From your PowerShell profile
clean           # Clear screen
clean-dev       # Kill orphaned processes
clean-system    # Deep cleanup
show-dev-processes  # Monitor dev tools
```

### 5. Regular Git Maintenance

```bash
# In your repos
git gc --aggressive
git prune
git remote prune origin
```

### 6. Monitor Disk Usage

```bash
# WSL
df -h
du -sh ~/projects/*

# Check pnpm savings
pnpm store status
```

```powershell
# Windows
Get-PSDrive C | Select-Object Used,Free
```

---

## Quick Commands Reference

### WSL Management
```powershell
wsl                          # Enter default distro
wsl -d Ubuntu-22.04          # Enter specific distro
wsl --shutdown               # Shutdown all WSL instances
wsl --list --verbose         # List installed distros
wsl --export Ubuntu backup.tar   # Backup
wsl --import Ubuntu2 C:\WSL backup.tar  # Restore
```

### Scoop Management
```powershell
scoop search <package>       # Search
scoop install <package>      # Install
scoop update *               # Update all
scoop cleanup *              # Remove old versions
scoop list                   # List installed
```

### Bun Commands
```bash
bun install                  # Install dependencies
bun add <package>            # Add package
bun remove <package>         # Remove package
bun run <script>             # Run script
bun build ./index.ts         # Build
bun test                     # Run tests
```

### pnpm Commands
```bash
pnpm install                 # Install dependencies
pnpm add <package>           # Add package
pnpm remove <package>        # Remove package
pnpm update                  # Update packages
pnpm store status            # Check store usage
pnpm store prune             # Clean unused packages
```

---

## Troubleshooting

### WSL2 Not Starting
```powershell
# Restart WSL service
wsl --shutdown
wsl

# Check Windows features
Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```

### pnpm Store Issues
```bash
# Reset store
rm -rf ~/.pnpm-store
pnpm install --force
```

### Bun Installation Issues
```bash
# Reinstall
curl -fsSL https://bun.sh/install | bash

# Check PATH
echo $PATH | grep bun
```

---

## Additional Resources

- [WSL2 Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
- [Scoop Documentation](https://scoop.sh/)
- [Bun Documentation](https://bun.sh/docs)
- [pnpm Documentation](https://pnpm.io/)
- [Your PowerShell Setup](../PowerShellSetup/README.md)
