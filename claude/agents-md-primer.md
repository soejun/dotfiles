# AGENTS.md as a portable single source of truth

A practical primer for keeping ONE set of project instructions that every
coding agent (Claude Code, Cursor, Codex, Copilot, ...) reads, instead of
maintaining a separate file per tool.

## The problem

Each tool looks for its own instructions file:
- Claude Code: `CLAUDE.md`
- Cursor / Codex / Copilot / others: increasingly `AGENTS.md`

Keeping the same rules in several files means they drift. Pick ONE file as the
source of truth and have the others point at it.

## The standard: AGENTS.md

`AGENTS.md` is the emerging cross-tool convention -- a plain-markdown file of
project instructions. Make it the source of truth. The catch: Claude Code does
NOT read `AGENTS.md` natively; it reads `CLAUDE.md`. So you bridge the two.

## The bridge (recommended): a one-line CLAUDE.md

Put everything in `AGENTS.md`, then add a `CLAUDE.md` beside it that contains a
single import line:

    @AGENTS.md

Claude Code loads `CLAUDE.md`, which pulls in `AGENTS.md`. Other tools read
`AGENTS.md` directly. One source, no duplication. If you ever need
Claude-only notes, add them under the import:

    @AGENTS.md

    ## Claude Code only
    - ...

### Alternative: symlink

    ln -s AGENTS.md CLAUDE.md

Simpler, but symlinks need Developer Mode on Windows and some tools or CI
dislike them. The import is more portable; prefer it.

## How `@` imports behave (Claude Code)

- Paths resolve relative to the importing file; `~/` is allowed.
- Nesting goes at most 4 hops deep.
- No globs -- import each file by name.

## The full portable layout

Per project:

    repo/
      AGENTS.md             <- single source of truth (lean, ~200 lines)
      CLAUDE.md             <- one line: @AGENTS.md
      .claude/
        rules/*.md          <- project rules; auto-loaded, can be path-scoped
        settings.json       <- project hooks / permissions (committed)
        settings.local.json <- personal overrides (gitignored)

Machine-wide (what we set up in ~/.claude):

    ~/.claude/
      rules/*.md            <- always-on conventions, every project
      settings.json         <- global hooks
      agents-md-primer.md   <- this file

## What goes where

- Habits that apply to ALL your projects -> `~/.claude/rules/`.
- Project-specific facts and contracts -> that project's `AGENTS.md`.
- Rules that only matter for some files -> a `.claude/rules/*.md` with
  `paths:` frontmatter, so it loads lazily.
- Long how-to or reference material -> a skill, not the always-loaded file.

## Loading and precedence (Claude Code)

Instruction files concatenate, more specific reinforcing or overriding more
general:
1. managed / enterprise policy
2. `~/.claude/CLAUDE.md` + `~/.claude/rules/*` (user-global)
3. ancestor `CLAUDE.md` files walking down to the project
4. project `CLAUDE.md` (which imports `AGENTS.md`) + `.claude/rules/*`
5. `CLAUDE.local.md` (personal, gitignored)

Settings precedence, highest first: managed > CLI flags >
`.claude/settings.local.json` > `.claude/settings.json` > `~/.claude/settings.json`.

## Recipe: convert an existing CLAUDE.md

1. `git mv CLAUDE.md AGENTS.md`
2. Create `CLAUDE.md` containing just `@AGENTS.md`.
3. Trim `AGENTS.md` toward ~200 lines: move cross-cutting rules into
   `~/.claude/rules/` (global) or `.claude/rules/`, and long reference
   sections into skills or linked docs.
4. Commit. Other tools now read `AGENTS.md`; Claude Code reads it via the
   import.
