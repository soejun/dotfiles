#!/usr/bin/env python3
"""PreToolUse(Bash) safety guard for Claude Code.

Reads the hook JSON payload on stdin and blocks a small, conservative set of
near-irreversible, whole-system-destructive shell commands.

Contract:
  exit 2  -> block the command; the text on stderr is shown to the model/user.
  exit 0  -> allow.
It fails OPEN (exit 0) on any parse error so it can never wedge a session, and
it is deliberately narrow to keep false positives near zero.
"""
import json
import re
import sys


def is_catastrophic(cmd):
    """Return a human-readable reason if cmd looks catastrophic, else None."""
    c = cmd
    nospace = re.sub(r"\s+", "", c)

    # Fork bomb: :(){ :|:& };:
    if ":(){" in nospace and ":|:" in nospace:
        return "fork bomb"

    # rm with a recursive flag targeting / , /* , ~ , or $HOME
    if re.search(r"\brm\b", c):
        recursive = bool(re.search(r"(?:^|\s)-{1,2}[a-z]*r", c, re.I)) or "--recursive" in c
        root_target = bool(re.search(r"(?:^|\s)(/|/\*|~|~/|\$HOME|\$\{HOME\})(?=\s|$)", c))
        if recursive and (root_target or "--no-preserve-root" in c):
            return "recursive remove of / , ~ , or $HOME"

    # Making a new filesystem
    if re.search(r"\bmkfs(\.\w+)?\b", c):
        return "filesystem creation (mkfs)"

    # Writing straight to a raw block device
    if re.search(r"\bdd\b.*\bof=/dev/(sd|nvme|vd|hd|disk|mmcblk)", c):
        return "dd writing to a raw block device"
    if re.search(r">\s*/dev/(sd|nvme|vd|hd|disk|mmcblk)", c):
        return "redirect onto a raw block device"

    # Recursive chmod/chown on the filesystem root
    if re.search(r"\bch(mod|own)\b\s+-{1,2}[a-z]*r\S*\s+\S*\s*/(?=\s|$)", c, re.I):
        return "recursive permission/owner change on /"

    return None


def main():
    try:
        payload = json.load(sys.stdin)
    except Exception:
        return 0  # fail open

    cmd = (payload.get("tool_input") or {}).get("command") or ""
    if not cmd:
        return 0

    reason = is_catastrophic(cmd)
    if reason:
        sys.stderr.write(
            "Blocked by ~/.claude safety guard: " + reason + ".\n"
            "Command: " + cmd + "\n"
            "This guard only blocks whole-system-destructive commands. If it is\n"
            "truly intended, run it yourself in a terminal outside the agent.\n"
        )
        return 2
    return 0


if __name__ == "__main__":
    sys.exit(main())
