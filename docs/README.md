# Documentation

Welcome to the Windows Scripts documentation! This folder contains comprehensive guides for setting up and maintaining a clean, efficient Windows development environment.

## 📚 Available Guides

### [Quick Start Guide](./quick-start.md)
**Start here!** A 15-minute checklist to get up and running immediately.

- ⚡ Fast setup process
- ✅ Verification steps
- 🚀 First project examples
- 💡 Pro tips

**Best for:** Getting started right now

---

### [Windows Dev Setup Guide](./windows-dev-setup.md)
Complete, in-depth guide covering everything you need to know.

**Topics covered:**
- Philosophy and strategy
- WSL2 setup and configuration
- Scoop package manager
- Bun + pnpm for JavaScript (no duplicate node_modules!)
- Python environment with pyenv
- Folder structure recommendations
- Maintenance scripts
- Best practices
- Troubleshooting

**Best for:** Understanding the full picture and long-term reference

---

## 🎯 Quick Navigation

### For Beginners
1. Start with [Quick Start Guide](./quick-start.md)
2. Follow the 15-minute setup
3. Create your first project
4. Return to [Windows Dev Setup Guide](./windows-dev-setup.md) as needed

### For Experienced Devs
1. Skim [Quick Start Guide](./quick-start.md) for commands
2. Jump to specific sections in [Windows Dev Setup Guide](./windows-dev-setup.md)
3. Customize to your workflow

---

## 🔑 Key Concepts

### The Hybrid Approach
- **Windows (Host):** PowerShell, VS Code, Windows-specific tools via Scoop
- **WSL2 (Ubuntu):** Primary dev environment, Bun, pnpm, Python, etc.

### Why Bun + pnpm?
- **Bun:** Blazing fast all-in-one JavaScript runtime, bundler, test runner
- **pnpm:** Saves gigabytes by storing packages once, hard-linking to projects
- **Result:** No more duplicate `node_modules` folders eating your disk!

### Clean Windows Philosophy
1. Minimal installations on Windows
2. Isolated package management (Scoop)
3. Dev work happens in WSL2
4. Regular automated cleanup
5. Version control everything

---

## 📖 Related Documentation

### In This Repository
- [PowerShell Setup README](../PowerShellSetup/README.md) - Oh My Posh themes and profile
- [WARP.md](../WARP.md) - Warp terminal configuration guide
- [Weekly Cleanup Script](../PowerShellSetup/weekly-cleanup.ps1) - Automated maintenance

### External Resources
- [WSL2 Official Docs](https://docs.microsoft.com/en-us/windows/wsl/)
- [Scoop Documentation](https://scoop.sh/)
- [Bun Documentation](https://bun.sh/docs)
- [pnpm Documentation](https://pnpm.io/)

---

## 💬 Feedback

Found an issue or have a suggestion? Please open an issue on GitHub!

---

## 🚀 Quick Commands

### Access These Docs
```powershell
# From anywhere in your terminal
cd $HOME/Documents/Github/windows-scripts/docs
code .  # Open in VS Code
```

### Essential Commands
```powershell
# Windows
wsl                    # Enter WSL
clean-dev              # Kill orphaned processes (from your profile)
show-dev-processes     # Monitor dev tools

# WSL
pnpm store status      # Check disk savings
bun --version          # Verify Bun installation
df -h                  # Check disk usage
```

---

**Last Updated:** January 2025  
**Maintained By:** Your friendly neighborhood PowerShell scripts repo 😄
