# claude-wip

Staging area for portable, machine-wide Claude Code configuration drafted this
session. Review here, then move it into your dotfiles repo
(`~/Workspace/dotfiles`) and symlink it onto each machine. Nothing here is live
until you install it.

## Contents

    rules/                       Always-on global rules -> ~/.claude/rules/*.md
      brevity.md                 Concise, high-signal output
      git-commits.md             Commit message craft + when to commit
      atomic-commits.md          Phased plans -> atomic commits
      testing-and-validation.md  Test-first; validate vs the project's lint+tests
      sanity-check.md            The "Grand Poobah" canary (default + project override)
      claude-md-hygiene.md       Keep CLAUDE.md ~200 lines; factor into rules/
    hooks/                       Scripts referenced by settings.json
      block-catastrophic.py      PreToolUse(Bash) guard: blocks rm -rf /, mkfs, dd to disk
      session-reminder.sh        SessionStart: injects a short operating reminder
    settings.hooks.json          "hooks" block to MERGE into ~/.claude/settings.json
    agents-md-primer.md          Using AGENTS.md as a cross-tool single source of truth

## How loading works (Claude Code)

- `~/.claude/rules/*.md` auto-loads every session -- no imports needed. Files
  with `paths:` frontmatter load lazily; these have none, so they always load.
- Hooks live only in `settings.json`. `~/.claude/settings.json` is the
  user-global layer; a project's `.claude/settings.json` overrides it.

## Install on a machine

Keep the source of truth in dotfiles and symlink (matches your
`~/.config/<tool>` -> `dotfiles/config/<tool>` pattern). Note: put this under
`dotfiles/claude/` (no dot) -- the repo's existing `.claude/` is project
settings for the dotfiles repo itself, a different thing.

    mv ~/Workspace/claude-wip ~/Workspace/dotfiles/claude

Add to `scripts/linux-symlink.sh` (and the macOS sibling). Folders are safe to
symlink -- Claude reads them, never replaces them -- but back up any existing
real dir first so you don't nest the link inside it:

    DOTFILES=~/Workspace/dotfiles
    safelink() {  # safelink <path under ~/.claude>
      src="$DOTFILES/claude/$1"; dest="$HOME/.claude/$1"
      [ -e "$dest" ] && [ ! -L "$dest" ] && mv "$dest" "$dest.bak.$(date +%s)"
      ln -sfn "$src" "$dest"
    }
    mkdir -p ~/.claude
    safelink rules
    safelink hooks

Do NOT symlink `settings.json` -- it carries machine-specific keys and Claude
may rewrite it (breaking the link). Merge the hooks block instead:

    jq -s '.[0] * .[1]' ~/.claude/settings.json \
      "$DOTFILES/claude/settings.hooks.json" > /tmp/s && mv /tmp/s ~/.claude/settings.json

(If you already have a `hooks` key, merge by hand -- jq `*` replaces arrays.)

## Never commit these from ~/.claude

Machine-local or secret; keep them out of git:
`.credentials.json`, `history.jsonl`, `projects/`, `sessions/`,
`shell-snapshots/`, `*cache*`, `telemetry/`, `backups/`, `ide/`, `plugins/`,
`tasks/`, `session-env/`.

## Verify after install

Start a new session: the first reply should lead with the canary
("Grand Poobah." unless the project overrides it), and the operating reminder
should appear at session start. Then try a harmless guarded command
(`echo rm -rf /` is fine; the guard inspects the real tool call).
