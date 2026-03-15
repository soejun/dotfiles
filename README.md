# Dotfiles

My coworkers say I have a problem.

## Maybe Useful

- `lazydocker`, `lazytail`, `lazygit`

`^M` Represents a carriage return character `\r` in ASCII.

- On Linux only `\n` is used.

On MacOS:

`Last login: Fri Apr  4 12:05:32 on ttys002
compinit:527: no such file or directory: /opt/homebrew/share/zsh/site-functions/_brew_services`

```bash
brew cleanup && rm -f $ZSH_COMPDUMP && omz reload
# should solve the issue.
```

### FZF

- Faster directory navigation

```bash
cd $(find * -type d | fzf)
```

- cp or mv (file only)

```bash
cp $(find * -type f | fzf) .
```

- cp or mv (folder)

```bash
cp ($find * -type d | fzf).
```

Is there a better way to reconcile these two commands together?
only way i can think of is

### Sway

Useful Links:
[Sway Modules - Win-Rules](https://gitlab.com/that1communist/dotfiles/-/blob/master/.config/sway/modules/win-rules)

### Audio - Linux

PulseAudio, turn off profiles as needed to narrow down outputs--useful for external speakers.

#### idk

```bash
ls ~/Downloads | grep -E '\.png$|\.jpg$' | xargs -I {} mv ~/Downloads/{} .

```

