---
description: How to write commit messages and when to commit.
---

# Commit messages

- Commit or push only when the user asks. If you are on the default branch
  (main / master / develop), create a branch first.
- One imperative-mood subject line ("Add", "Fix", "Lay out" -- not "Added"
  or "Fixes"). Keep it under ~72 characters.
- The subject states what the diff does and the behaviour it changes, not how.
  Strip implementation jargon (internal class / package names, phase or
  roadmap framing, "X to follow later").
- Add a body only when the change isn't self-evident, and keep it to a few
  bullets. Don't restate what `git log --stat` already shows; if a bullet
  duplicates the file list, drop it.
- Follow the project's own commit conventions when it states them (length
  limits, trailers, scopes, ticket refs). If none are stated, omit a
  Co-Authored-By trailer unless your harness requires one.
- Never bundle planning notes, scratch files, or generated artifacts with a
  code change. Commit those separately, or not at all.
