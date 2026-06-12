# Hyprland Desktop on CachyOS — Implementation Plan

Stand up a fully working Hyprland desktop on this CachyOS laptop that mirrors the
Sway workflow from the Debian daily-driver, leans into Hyprland's effects, and
restores GNOME-era comforts. Everything lives in the dotfiles repo and is
symlinked, matching the existing `config/<tool>` pattern.

## Goal & Success Criteria

A reboot into Hyprland yields: themed bar, working launcher, notifications,
screenshots, clipboard history, auto-mounting USB, lock/idle, GUI auth prompts,
a GUI file manager, and a fish shell that carries over the zsh aliases/behavior —
all in Tokyo Night Storm, all version-controlled and re-deployable via one script.

## Locked Decisions

| Decision | Choice |
|----------|--------|
| Location | In the dotfiles repo, symlinked via a new CachyOS script |
| Base | Build on the existing `~/.config/hypr/hyprland.conf` template, split into sourced files |
| File manager | dolphin (kept), Qt-themed dark to match |
| Comforts | Screenshots+picker, clipboard history, USB automount, applets/OSD/polkit — all four |
| Shell | Port `shells/zshrc` → `config/fish/config.fish`; fish stays login shell |
| Prompt | starship (Tokyo Night) |
| Lock/idle/wallpaper | hyprlock + hypridle + hyprpaper (Hyprland-native) |
| Theme | Tokyo Night Storm across the stack |
| `$mod+V` | float toggle (Hyprland convention; sway's `splitv` dropped) |

## Packages

**Install from official repo (`pacman`):**
`waybar swaync hyprlock hypridle hyprpicker hyprshot cliphist udiskie blueman
hyprpolkitagent wlogout starship swayosd qt6ct qt5ct kvantum`

**Install from AUR (`paru`):**
`maplemono-nf` (waybar font; matches Debian's "Maple Mono NF")

**Already installed — no action:**
hyprpaper, wofi, wl-clipboard, network-manager-applet, playerctl, brightnessctl,
pavucontrol, kitty, fish, dolphin, yazi

Installs are a system change → **ask before running** (per CLAUDE.md). `grimblast`
and `pamixer` are intentionally omitted (hyprshot + wpctl cover those needs).

## Repo Layout

```
config/
├── hypr/
│   ├── hyprland.conf        # sources the files below + monitors
│   ├── monitors.conf        # MACHINE-LOCAL: eDP-1,1920x1080@60
│   ├── env.conf             # cursor, GTK/Qt platform theme, XDG
│   ├── looknfeel.conf       # general/decoration/animations/dwindle + theme colors
│   ├── input.conf           # ctrl:nocaps, touchpad tap + natural scroll
│   ├── binds.conf           # all keybinds (see parity table)
│   ├── rules.conf           # window/workspace rules
│   ├── autostart.conf       # bar, notify, idle, applets, polkit, cliphist, osd
│   ├── hyprlock.conf
│   ├── hypridle.conf
│   └── hyprpaper.conf
├── waybar/
│   ├── style.css            # REUSED (untouched; shared with sway)
│   ├── config               # existing sway config (untouched)
│   └── config-hyprland      # NEW: hyprland/* modules
├── wofi/                    # REUSED (symlinked as-is)
├── swaync/                  # REUSED (symlinked as-is)
├── fish/
│   └── config.fish          # NEW
└── qt/
    ├── qt5ct.conf
    └── qt6ct.conf           # dark theme for dolphin
scripts/
└── hyprland-symlink.sh      # NEW
```

`scripts/linux-symlink.sh` (Debian/Sway) is **not modified**.

## Hyprland Config Detail

**`hyprland.conf`** — sources, in order: monitors, env, looknfeel, input, binds,
rules, autostart.

**`monitors.conf`** — `monitor=eDP-1,1920x1080@60,0x0,1`. Documented as the
per-machine file to edit on other hosts.

**`looknfeel.conf`** (effects — the "bleeding edge" payoff):
- `general`: `gaps_in=5`, `gaps_out=10`, `border_size=2`, `layout=dwindle`
- borders: `col.active_border = rgba(7aa2f7ee) rgba(bb9af7ee) 45deg` (blue→magenta), `col.inactive_border = rgba(414868aa)`
- `decoration`: `rounding=10`, `inactive_opacity=0.92`, blur `enabled` size=6 passes=2, shadow enabled
- `animations`: keep template beziers (easeOutQuint etc.) + workspace slide/fade
- `dwindle`: `pseudotile=true`, `preserve_split=true`

**`env.conf`**: `XCURSOR_SIZE=24`, `HYPRCURSOR_SIZE=24`,
`QT_QPA_PLATFORMTHEME=qt6ct`, `GTK_THEME=Adwaita-dark` (parity with Sway's
gsettings), XDG desktop/session vars.

## Keybind Parity (Sway → Hyprland)

`$mod = SUPER`. Direct ports unless noted.

| Action | Bind | Hyprland dispatcher |
|--------|------|---------------------|
| Terminal (kitty) | `$mod+Return` | `exec kitty` |
| Kill | `$mod+Q` | `killactive` |
| Launcher | `$mod+Space` | `exec wofi --show drun` |
| File manager | `$mod+E` | `exec dolphin` |
| Focus h/j/k/l | `$mod+hjkl` | `movefocus l/d/u/r` |
| Move h/j/k/l | `$mod+Shift+hjkl` | `movewindow` |
| Workspaces 1–0 | `$mod+N` | `workspace N` |
| Move to ws | `$mod+Shift+N` | `movetoworkspace N` |
| Fullscreen | `$mod+F` | `fullscreen` |
| Float toggle | `$mod+V`, `$mod+Shift+Space` | `togglefloating` |
| Toggle split | `$mod+T` | `togglesplit` |
| Pseudotile | `$mod+P` | `pseudo` |
| Tabbed (≈) | `$mod+W` | `togglegroup`; `$mod+Tab` cycles |
| Resize mode | `$mod+R` | `submap=resize` (then hjkl, Esc/Return) |
| Direct resize | `$mod+Ctrl+hjkl` | `resizeactive` |
| Scratchpad show | `$mod+minus` | `togglespecialworkspace magic` |
| To scratchpad | `$mod+Shift+minus` | `movetoworkspace special:magic` |
| Reload | `$mod+Shift+C` | `exec hyprctl reload` |
| Notifications | `$mod+Shift+N` | `exec swaync-client -t -sw` |
| Clipboard history | `$mod+Shift+V` | `exec cliphist list \| wofi → copy` |
| Color picker | `$mod+Shift+P` | `exec hyprpicker -a` |
| Power menu | `$mod+Shift+E` | `exec wlogout` |
| Lock | `$mod+Escape` | `exec hyprlock` |
| Screenshot region | `$mod+Shift+A` | `exec hyprshot -m region` |
| Screenshot active | `$mod+Shift+S` | `exec hyprshot -m window` |
| Screenshot screen | `$mod+Shift+W` | `exec hyprshot -m output` |
| Volume / mute | `XF86Audio*` | `swayosd-client --output-volume …` (wraps wpctl + OSD) |
| Brightness | `XF86MonBrightness*` | `swayosd-client --brightness …` (wraps brightnessctl + OSD) |

**Known deltas (Hyprland has no i3 tree):** sway's `splith`/`splitv`
(`$mod+b`/`$mod+v`) and `stacking` (`$mod+s`) have no equivalent. `$mod+b`/`$mod+s`
are freed; tabbing is via groups.

## Comfort Tools

| Tool | Role | Wiring |
|------|------|--------|
| hyprshot | Screenshots | binds above |
| hyprpicker | Color picker | `$mod+Shift+P` |
| cliphist + wl-clipboard | Clipboard history | `wl-paste --watch cliphist store` in autostart; `$mod+Shift+V` popup |
| udiskie | USB automount | `udiskie &` in autostart (tray) |
| network-manager-applet | Network tray | `nm-applet --indicator &` |
| blueman | Bluetooth tray | `blueman-applet &` |
| hyprpolkitagent | GUI auth prompts | `exec-once = systemctl --user start hyprpolkitagent` |
| swayosd | Volume/brightness OSD | `swayosd-libinput-backend` + replace raw wpctl/brightnessctl binds with `swayosd-client` |
| dolphin | GUI file manager | `$mod+E`, Qt-dark themed |

## Theming — Tokyo Night Storm

Palette anchors (from `config/kitty/themes/tokyonight/tokyonight_storm.conf`):
bg `#24283b`, bg_dark `#1f2335`, fg `#c0caf5`, blue `#7aa2f7`, magenta `#bb9af7`,
inactive `#414868`.

| Surface | How |
|---------|-----|
| Hyprland borders | active blue→magenta gradient, inactive `#414868` |
| waybar | existing `style.css` (already Tokyo Night Storm) |
| wofi | retheme `config/wofi/style.css` to palette |
| swaync | style to palette |
| hyprlock | bg/inner/ring/text to palette |
| kitty | point `kitty.conf` → `tokyonight_storm.conf` |
| GTK apps | `gsettings` Adwaita-dark (parity with Sway) |
| Qt / dolphin | `qt6ct` dark + `kvantum` Tokyo Night theme; fallback Breeze-Dark |

## Fish Port (adapt, not transliterate)

**Carry over:** aliases (`sd` fzf-nav, `git-branch-name`, `lsplog`, `make-gif`,
`leetcode`, `play-docker`), `EDITOR=nvim`, `MANPAGER`, no-bell, kitty `ssh` fix,
terminal-title → fish `fish_title` function.

**Adapt to CachyOS (Arch):** drop dead Debian paths
(`/opt/nvim-linux-x86_64`, `java-17-openjdk-amd64`, linuxbrew, `/snap/bin`); keep
only what exists here — `~/.local/bin`, cargo (`~/.cargo/bin`), go (`~/go/bin`).
Tools installed via pacman are already on PATH.

**Built-in (no plugins):** fish ships autosuggestions + syntax highlighting,
replacing the oh-my-zsh plugins. `starship init fish` for the prompt.

## Deployment — `scripts/hyprland-symlink.sh`

Mirrors `linux-symlink.sh`. For each config, back up any existing real file/dir
(`.bak.<ts>`) before linking:
- `config/hypr` → `~/.config/hypr`
- `config/waybar/style.css` → `~/.config/waybar/style.css`
- `config/waybar/config-hyprland` → `~/.config/waybar/config`
- `config/wofi` → `~/.config/wofi`
- `config/swaync` → `~/.config/swaync`
- `config/fish/config.fish` → `~/.config/fish/config.fish`
- `config/qt/qt5ct.conf` → `~/.config/qt5ct/qt5ct.conf`
- `config/qt/qt6ct.conf` → `~/.config/qt6ct/qt6ct.conf`
- `config/kitty/kitty-linux.conf` → `~/.config/kitty/kitty.conf`

## Implementation Phases

Each phase = one atomic commit (message <60 chars). Verify before committing.

| # | Commit message | Verify |
|---|----------------|--------|
| 0 | (no commit) install packages | `pacman -Q` lists them |
| 1 | `Add hyprland config split + monitors` | `hyprctl reload` clean |
| 2 | `Add tokyonight look-and-feel + effects` | borders/blur/rounding visible |
| 3 | `Add hyprland keybinds with sway parity` | binds fire as expected |
| 4 | `Add waybar config for hyprland` | bar shows workspaces/window/tray |
| 5 | `Add hyprlock and hypridle configs` | lock + idle-lock work |
| 6 | `Add comfort tools to hypr autostart` | screenshot/clip/automount/applets |
| 7 | `Add fish config ported from zsh` | new shell: aliases + starship prompt |
| 8 | `Add hyprland-symlink install script` | re-run is idempotent |
| 9 | `Add Qt dark theming for dolphin` | dolphin opens dark |
| 10 | `Point kitty to tokyonight storm theme` | kitty colors match |

After all phases: offer to merge `hyprland-cachyos` (PR, matching your workflow).

## Out of Scope / Risks

- **Out of scope:** Debian/Sway configs (untouched); multi-monitor (laptop is
  single eDP-1); nvim config (not in this repo).
- **Risk — live session:** editing the running Hyprland config is live; a bad
  bind/exec can disrupt the session. Mitigation: `hyprctl reload` after each
  change; keep a TTY available.
- **Risk — Qt theming:** pixel-perfect Tokyo Night for Qt6/dolphin may need a
  Kvantum theme fetch; Breeze-Dark is the guaranteed dark fallback.
- **Risk — fonts:** waybar depends on `maplemono-nf` (AUR); if the build fails,
  fall back to the installed FantasqueSansM Nerd Font via a one-line style tweak.

## Final Verification Checklist

Reboot → Hyprland session → confirm: bar renders, `$mod+Space` launches wofi,
`$mod+E` opens dolphin, screenshot/clipboard/picker binds work, USB stick
automounts, notifications appear, idle locks, `wlogout` shows, fish prompt is
starship with aliases working, and the whole thing reads Tokyo Night Storm.
