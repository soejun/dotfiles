# Windows 11 VM Setup

## Notes

### VirtualBox Settings
- Install Guest Additions
- 16gb memory allocated
- 8 CPU cores
- Disable 3D Acceleration
- Advanced -> Shared Clipboard: Bidirectional, Drag'n Drop: Bidirectional
- 128gb storage
- Enable CD Drive (If applicable)


### Windows Settings
- Personalization -> Task Bar -> Turn off: Task View, Widgets, Chat, OneDrive Icon
- Personalization -> Search -> Icon Only
- Personalization -> Themes -> Icon Settings; Turn all off
- Move all desktop shortcuts to `C:\Users\Users\Archive`
- Wallpaper: catppuccin/various-os-(1,2,3)-4k.png
- Taskbar -> Automatically hide taskbar
- Color: Metal blue
- Or, Color: #1e2030
    - Whatever catppuccin base is
- Install Nerd Fonts
- Chrome set as default
- System -> For Developers -> File Explorer; Toggle: Show File Extensions, Show Hidden Files, Show Full Path, Show Empty Drives


### General Dev Setup


- Install git
- Install any certs where necessary
- Install WSL
- Install scoop
    - Run Powershell (Regularly), not as administrator
    - ```powershell
            Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
            Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
        ```
- Powershell Customization
    - https://github.com/catppuccin/powershell
    - https://github.com/catppuccin/windows-terminal

- Setup git config and rsa keys
- Powershell (Run as administrator) -> Set-Service ssh-agent -StartupType Automatic
    - I think this is a Git executable sort of thing
- I mean, we're really only using this for Visual Studio C# and dotnet development
- Install VSCode and Visual Studio
     - VSCode for misc. powershell scripts and related, this is because it's much more lightweight than visual studio

### Visual Studio

- Catppuccin Theme
- VsVim Extension
    - Load _vsvimrc here: `C:\Users\User\_vsvimrc`

