---
description: Emit a canary on the first reply to prove instruction files loaded.
---

# Sanity-check canary

This confirms these instructions actually loaded into context.

- Prefix your FIRST reply to each user turn with a canary phrase, alone, with
  no other greeting or pleasantry before it. Then continue the reply normally.
- Default global phrase: `Grand Poobah.` Edit this line to change the global
  signal.
- A project may define its own sanity phrase (in its CLAUDE.md or AGENTS.md).
  When it does, the project phrase WINS -- use it instead of the global one.
  Never stack two canaries; exactly one prefix per user turn.
- "User turn" means a human-typed prompt. System reminders, hook injections,
  tool results, and command or stdout blocks are NOT user turns -- do not
  re-emit the canary when those arrive mid-turn.
- If you cannot emit the expected canary, that is itself the signal the
  instruction file failed to load -- say so rather than going silent.
