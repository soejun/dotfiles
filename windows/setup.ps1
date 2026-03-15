#Requires -Version 5.1
<#
.SYNOPSIS
    Windows development environment setup — mirrors your Linux/macOS dotfiles workflow.
.DESCRIPTION
    Installs:
      - WSL2 (requires admin — see below; defaults to Ubuntu)
      - Scoop + core CLI tools (git, neovim, ripgrep, fzf, lf, gcc, make)
      - CaskaydiaCove Nerd Font via Scoop
      - GlazeWM tiling window manager (i3/sway-like, via winget)
      - Windows Terminal (via winget)
      - fnm (Node version manager)
      - uv (Python toolchain)
      - PowerShell modules: PSFzf, Terminal-Icons, posh-git, Catppuccin
      - oh-my-posh (prompt, catppuccin theme)
      - SSH agent auto-start
      - GlazeWM config to %USERPROFILE%\.glaze-wm\config.yaml

.NOTES
    WSL REQUIRES ADMIN — run the WSL block separately in an elevated shell:
        wsl --install
        # Restart, then run setup-wsl.sh inside WSL.

    Everything else (Scoop, winget installs, modules) should be run as a NORMAL user.

    Usage:
        # Normal PowerShell (non-admin):
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
        .\setup.ps1

        # Or skip parts:
        .\setup.ps1 -SkipWSL -SkipGlazeWM
#>

param(
    [switch]$SkipWSL,
    [switch]$SkipScoop,
    [switch]$SkipGlazeWM,
    [switch]$SkipModules,
    [switch]$SkipFonts
)

$ErrorActionPreference = "Stop"

function Write-Step($msg) {
    Write-Host "`n==> $msg" -ForegroundColor Cyan
}

function Test-Admin {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    $p  = New-Object Security.Principal.WindowsPrincipal($id)
    return $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-Command($cmd) {
    return $null -ne (Get-Command $cmd -ErrorAction SilentlyContinue)
}

# ---------------------------------------------------------------------------
# 1. WSL2 (admin required)
# ---------------------------------------------------------------------------
Write-Step "WSL2"
if ($SkipWSL) {
    Write-Host "  Skipped." -ForegroundColor DarkGray
} elseif (-not (Test-Admin)) {
    Write-Warning "  WSL install requires admin. Skipping. Run manually:`n    wsl --install"
} else {
    wsl --install
    Write-Host "  WSL installed. Restart Windows, then run setup-wsl.sh inside your Debian shell." -ForegroundColor Yellow
}

# ---------------------------------------------------------------------------
# 2. Scoop
# ---------------------------------------------------------------------------
Write-Step "Scoop"
if ($SkipScoop) {
    Write-Host "  Skipped." -ForegroundColor DarkGray
} else {
    if (-not (Test-Command scoop)) {
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    } else {
        Write-Host "  scoop already installed." -ForegroundColor DarkGray
    }

    # Buckets
    scoop bucket add extras   2>$null
    scoop bucket add nerd-fonts 2>$null

    # Core tools
    $tools = @('git', 'neovim', 'ripgrep', 'fzf', 'lf', 'gcc', 'make', 'wget', 'jq')
    foreach ($t in $tools) {
        Write-Host "  Installing $t..."
        scoop install $t 2>$null
    }
}

# ---------------------------------------------------------------------------
# 3. Nerd Font
# ---------------------------------------------------------------------------
Write-Step "CaskaydiaCove Nerd Font"
if ($SkipFonts) {
    Write-Host "  Skipped." -ForegroundColor DarkGray
} else {
    # Requires admin for system-wide install, but scoop installs per-user
    scoop install CaskaydiaCove-NF 2>$null
    Write-Host "  Font installed. Set it in Windows Terminal settings." -ForegroundColor Yellow
}

# ---------------------------------------------------------------------------
# 4. GlazeWM (tiling WM — closest Windows equivalent to sway/i3)
# ---------------------------------------------------------------------------
Write-Step "GlazeWM"
if ($SkipGlazeWM) {
    Write-Host "  Skipped." -ForegroundColor DarkGray
} else {
    winget install glzr-io.glazewm `
        --accept-source-agreements `
        --accept-package-agreements `
        --silent 2>$null
    Write-Host "  GlazeWM installed." -ForegroundColor Green

    # Deploy config
    $glazeDir = "$env:USERPROFILE\.glaze-wm"
    if (-not (Test-Path $glazeDir)) { New-Item -ItemType Directory -Path $glazeDir | Out-Null }

    $configSrc = Join-Path $PSScriptRoot "glazewm-config.yaml"
    if (Test-Path $configSrc) {
        Copy-Item $configSrc "$glazeDir\config.yaml" -Force
        Write-Host "  GlazeWM config deployed to $glazeDir\config.yaml" -ForegroundColor Green
    } else {
        Write-Warning "  glazewm-config.yaml not found next to setup.ps1 — deploy it manually."
    }
}

# ---------------------------------------------------------------------------
# 5. Windows Terminal
# ---------------------------------------------------------------------------
Write-Step "Windows Terminal"
winget install Microsoft.WindowsTerminal `
    --accept-source-agreements `
    --accept-package-agreements `
    --silent 2>$null

# ---------------------------------------------------------------------------
# 6. fnm (Node version manager — mirrors nvm in WSL)
# ---------------------------------------------------------------------------
Write-Step "fnm"
winget install Schniz.fnm `
    --accept-source-agreements `
    --accept-package-agreements `
    --silent 2>$null

# ---------------------------------------------------------------------------
# 7. uv (Python toolchain)
# ---------------------------------------------------------------------------
Write-Step "uv"
if (-not (Test-Command uv)) {
    Invoke-RestMethod https://astral.sh/uv/install.ps1 | Invoke-Expression
} else {
    Write-Host "  uv already installed." -ForegroundColor DarkGray
}

# ---------------------------------------------------------------------------
# 8. oh-my-posh (shell prompt)
# ---------------------------------------------------------------------------
Write-Step "oh-my-posh"
winget install JanDeDobbeleer.OhMyPosh `
    --accept-source-agreements `
    --accept-package-agreements `
    --silent 2>$null

# ---------------------------------------------------------------------------
# 9. PowerShell modules
# ---------------------------------------------------------------------------
Write-Step "PowerShell modules"
if ($SkipModules) {
    Write-Host "  Skipped." -ForegroundColor DarkGray
} else {
    $modules = @(
        'PSFzf',
        'Terminal-Icons',
        'posh-git',
        'Catppuccin'
    )
    foreach ($m in $modules) {
        Write-Host "  Installing $m..."
        Install-Module -Name $m -Scope CurrentUser -Force -AllowClobber
    }
}

# ---------------------------------------------------------------------------
# 10. SSH agent
# ---------------------------------------------------------------------------
Write-Step "SSH agent"
if (Test-Admin) {
    Set-Service ssh-agent -StartupType Automatic
    Start-Service ssh-agent
    Write-Host "  SSH agent set to auto-start." -ForegroundColor Green
} else {
    Write-Warning "  SSH agent config requires admin. Run manually:`n    Set-Service ssh-agent -StartupType Automatic"
}

# ---------------------------------------------------------------------------
# 11. PowerShell profile
# ---------------------------------------------------------------------------
Write-Step "PowerShell profile"
$profileSrc = Join-Path $PSScriptRoot "Microsoft.PowerShell_profile.ps1"
if (Test-Path $profileSrc) {
    $profileDir = Split-Path $PROFILE -Parent
    if (-not (Test-Path $profileDir)) { New-Item -ItemType Directory -Path $profileDir | Out-Null }
    Copy-Item $profileSrc $PROFILE -Force
    Write-Host "  PowerShell profile deployed to $PROFILE" -ForegroundColor Green
} else {
    Write-Warning "  Microsoft.PowerShell_profile.ps1 not found — deploy manually."
}

# ---------------------------------------------------------------------------
Write-Host @"

Done! Next steps:
  1. Restart Windows (required for WSL and fonts to fully activate).
  2. Open WSL and run:
       bash /path/to/dotfiles/windows/setup-wsl.sh
  3. Start GlazeWM from the Start menu (or set it to run at startup).
  4. In Windows Terminal settings, set font to 'CaskaydiaCove Nerd Font Mono'.
  5. Apply catppuccin Windows Terminal theme — see:
       https://github.com/catppuccin/windows-terminal
  6. Set up git identity:
       git config --global user.name  "Your Name"
       git config --global user.email "your@email.com"

"@ -ForegroundColor Green
