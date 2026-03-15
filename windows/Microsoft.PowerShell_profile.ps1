# PowerShell profile — catppuccin-themed, mirrors zsh workflow
# Deploy to: $PROFILE  (usually Documents\PowerShell\Microsoft.PowerShell_profile.ps1)
# Or let setup.ps1 deploy it automatically.

# ─── Catppuccin theme ────────────────────────────────────────────────────────
$catppuccin = @{
    Rosewater = [System.ConsoleColor]::White
    Flamingo  = [System.ConsoleColor]::Red
    Pink      = [System.ConsoleColor]::Magenta
    Mauve     = [System.ConsoleColor]::Magenta
    Red       = [System.ConsoleColor]::Red
    Maroon    = [System.ConsoleColor]::DarkRed
    Peach     = [System.ConsoleColor]::Yellow
    Yellow    = [System.ConsoleColor]::Yellow
    Green     = [System.ConsoleColor]::Green
    Teal      = [System.ConsoleColor]::Cyan
    Sky       = [System.ConsoleColor]::Cyan
    Sapphire  = [System.ConsoleColor]::Blue
    Blue      = [System.ConsoleColor]::Blue
    Lavender  = [System.ConsoleColor]::Blue
    Text      = [System.ConsoleColor]::White
    Subtext1  = [System.ConsoleColor]::Gray
    Overlay2  = [System.ConsoleColor]::DarkGray
    Base      = [System.ConsoleColor]::Black
}

# Try loading the Catppuccin module if installed
if (Get-Module -ListAvailable -Name Catppuccin -ErrorAction SilentlyContinue) {
    Import-Module Catppuccin
    $flavor = $Catppuccin['Mocha']
    function prompt {
        $flavor.Blue.Foreground()
    }
}

# ─── Modules ─────────────────────────────────────────────────────────────────
if (Get-Module -ListAvailable -Name Terminal-Icons -ErrorAction SilentlyContinue) {
    Import-Module Terminal-Icons
}

if (Get-Module -ListAvailable -Name posh-git -ErrorAction SilentlyContinue) {
    Import-Module posh-git
}

# ─── oh-my-posh (catppuccin theme) ───────────────────────────────────────────
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\catppuccin_mocha.omp.json" | Invoke-Expression
}

# ─── PSFzf ───────────────────────────────────────────────────────────────────
if (Get-Module -ListAvailable -Name PSFzf -ErrorAction SilentlyContinue) {
    Import-Module PSFzf
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
}

# ─── fnm (Node version manager) ──────────────────────────────────────────────
if (Get-Command fnm -ErrorAction SilentlyContinue) {
    fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression
}

# ─── PSReadLine (better history/completion) ───────────────────────────────────
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Vi                  # vim bindings — matches your nvim workflow
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# ─── Aliases (mirrors common zsh/Unix aliases) ───────────────────────────────
Set-Alias vim  nvim
Set-Alias vi   nvim
Set-Alias cat  bat   -ErrorAction SilentlyContinue
Set-Alias grep rg    -ErrorAction SilentlyContinue

# Unix-style navigation
function which($cmd) { (Get-Command $cmd).Source }
function touch($file) { New-Item -ItemType File $file | Out-Null }
function ll { Get-ChildItem -Force @args }
function la { Get-ChildItem -Force @args }

# Open file explorer at current path (mirrors `ii .`)
function e. { Invoke-Item . }

# fzf-powered directory jump (mirrors your `sd` alias)
function sd {
    $dir = Get-ChildItem -Recurse -Directory -ErrorAction SilentlyContinue |
           Select-Object -ExpandProperty FullName |
           fzf --height 40% --reverse
    if ($dir) { Set-Location $dir }
}

# man equivalent (mirrors powershell tip in your windows_11.md)
function man($cmd) { Get-Help $cmd -ShowWindow }

# git branch name (mirrors `git-branch-name` alias)
function git-branch-name { git rev-parse --abbrev-ref HEAD }

# ─── Environment ─────────────────────────────────────────────────────────────
$env:EDITOR = 'nvim'

# uv
if (Test-Path "$env:USERPROFILE\.local\bin") {
    $env:PATH += ";$env:USERPROFILE\.local\bin"
}
