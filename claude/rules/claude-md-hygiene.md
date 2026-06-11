---
description: Keep project instruction files small and factored; AGENTS.md as source of truth.
---

# CLAUDE.md / AGENTS.md hygiene

When you create or grow a project's instruction file:

- Keep the top-level file lean -- aim for ~200 lines (a screen or two). It is
  an index plus the few always-on rules, not an encyclopedia.
- Factor large or situational sections out rather than inlining them:
  - Cross-cutting always-on rules -> `.claude/rules/*.md` (auto-loaded).
  - Rules that only matter for some files -> a rules file with `paths:`
    frontmatter, so it loads lazily only when those files are opened.
  - Long reference or how-to material -> a skill or a linked doc, not the
    always-loaded file.
- Prefer AGENTS.md as the single source of truth -- it is the cross-tool
  standard other agents read. Bridge it to Claude Code with a one-line
  `CLAUDE.md` containing `@AGENTS.md`, or symlink CLAUDE.md -> AGENTS.md.
  See ~/.claude/agents-md-primer.md.
- `@path` imports resolve relative to the importing file, accept `~/`, nest at
  most 4 hops, and do NOT support globs -- import each file by name.
- One concern per file. If a section needs its own heading hierarchy, it
  probably wants its own file.
