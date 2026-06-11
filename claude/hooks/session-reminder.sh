#!/usr/bin/env bash
# SessionStart hook for Claude Code: inject a short operating reminder.
# stdout from a SessionStart hook (exit 0) is added to the model's context.
cat <<'EOF'
Operating reminder (see ~/.claude/rules): keep replies brief and high-signal;
write the test first and validate every change against the project's own lint
and test commands; make atomic commits and commit only when asked; honor the
project's AGENTS.md / CLAUDE.md and lead the first reply with its sanity-check
canary.
EOF
exit 0
