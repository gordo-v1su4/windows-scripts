# Quick Start Guide

A streamlined checklist to get your clean Windows dev environment up and running ASAP.

## ⚡ 15-Minute Setup

### Step 1: Install WSL2 (5 minutes)

```powershell
# Run PowerShell as Administrator
wsl --install -d Ubuntu-22.04

# Restart computer when prompted
# After restart, Ubuntu will open automatically - set username and password
```

### Step 2: Install Scoop (2 minutes)

```powershell
# Regular PowerShell (no admin needed)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

# Install essential tools
scoop bucket add extras
scoop install git aria2 7zip
```

### Step 3: Set Up WSL2 Development Environment (5 minutes)

```bash
# In WSL (Ubuntu)
sudo apt update && sudo apt upgrade -y

# Install build tools
sudo apt install -y build-essential curl wget git unzip

# Install Bun
curl -fsSL https://bun.sh/install | bash
source ~/.bashrc

# Install pnpm
bun install -g pnpm

# Configure pnpm
pnpm config set store-dir ~/.pnpm-store
```

### Step 4: Configure Git (1 minute)

```bash
# In WSL
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
git config --global init.defaultBranch main
```

### Step 5: Create Project Directory (1 minute)

```bash
# In WSL
mkdir -p ~/projects/{web,python,scripts}

# Create symlink to Windows repos for easy access
ln -s /mnt/c/Users/Gordo/Documents/Github ~/windows-repos
```

---

## ✅ Verification Checklist

Run these commands to verify everything works:

```bash
# Check versions
wsl --version          # In PowerShell
bun --version          # In WSL
pnpm --version         # In WSL
git --version          # In both

# Test Bun
bun --version

# Test pnpm store
pnpm store status

# Check disk space
df -h
```

---

## 📋 First Project Setup

### JavaScript Project with Bun

```bash
cd ~/projects/web
bun init my-app
cd my-app
bun add express
bun run index.ts
```

### JavaScript Project with pnpm

```bash
cd ~/projects/web
mkdir my-app && cd my-app
pnpm init
pnpm add fastify
```

### Python Project

```bash
cd ~/projects/python
mkdir my-app && cd my-app
python -m venv .venv
source .venv/bin/activate
pip install requests
```

---

## 🔧 Optional Enhancements

### VS Code Integration with WSL

```powershell
# In Windows
scoop install vscode

# In VS Code, install extension:
# "WSL" by Microsoft
```

Then open any WSL folder:
```bash
cd ~/projects/web/my-app
code .
```

### Useful Scoop Packages

```powershell
scoop install ripgrep fzf bat jq gh
```

### Python Version Manager

```bash
# In WSL
curl https://pyenv.run | bash

# Add to ~/.bashrc (already done by installer)
source ~/.bashrc

# Install Python version
pyenv install 3.12.0
pyenv global 3.12.0
```

---

## 🧹 Daily Maintenance Commands

```powershell
# Windows (run weekly)
.\PowerShellSetup\weekly-cleanup.ps1

# Your profile functions
clean-dev              # Kill orphaned processes
show-dev-processes     # Monitor dev tools
```

```bash
# WSL (run monthly)
pnpm store prune       # Clean unused packages
sudo apt autoremove    # Remove unused packages
```

---

## 🚀 What's Next?

1. Read the full guide: [windows-dev-setup.md](./windows-dev-setup.md)
2. Set up your first project
3. Configure your favorite tools
4. Star this repo! 😄

---

## 💡 Pro Tips

1. **Always work in WSL for dev projects** - it's faster and cleaner
2. **Use `pnpm` for existing projects, `bun` for new ones** - both save disk space
3. **Keep Windows repos in `/mnt/c/Users/Gordo/Documents/Github`** - accessible from both
4. **Use your PowerShell profile functions** - `clean-dev`, `show-dev-processes`, etc.
5. **Pin WSL to taskbar** - right-click Ubuntu in Start menu

---

## 🆘 Quick Troubleshooting

### WSL won't start
```powershell
wsl --shutdown
wsl
```

### Bun command not found
```bash
source ~/.bashrc
```

### pnpm slow first install
```bash
# Normal! It's downloading to central store
# Subsequent installs will be instant
pnpm store status  # Check progress
```

### Can't access Windows files
```bash
cd /mnt/c/Users/Gordo/Documents
```

### Can't access WSL files from Windows
```
# In File Explorer address bar:
\\wsl.localhost\Ubuntu-22.04\home\gordo
```

---

**Time to setup:** ~15 minutes  
**Time saved forever:** Countless hours  
**Disk space saved:** GBs (thanks to pnpm)  
**Windows cleanliness:** 💯
