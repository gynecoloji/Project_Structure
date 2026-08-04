#!/usr/bin/env bash
# PostToolUse hook: when Claude Code writes a script, processed-data file, or
# analysis output under a matched project folder, remind it to update the
# matching Markdown docs (via the doc-writer agent / /sync-docs).
#
# Wired up in .claude/settings.json. Non-blocking: it only injects a reminder,
# it never fails a tool call. Doc files themselves (.md/.json/.log) are ignored
# so the doc-writer's own writes can't retrigger it.
set -euo pipefail

payload="$(cat)"

# Pull the edited path out of the hook payload (python3 keeps this jq-free).
path="$(printf '%s' "$payload" | python3 -c 'import sys, json
try: print(json.load(sys.stdin).get("tool_input", {}).get("file_path", ""))
except Exception: print("")' 2>/dev/null || true)"

[ -z "$path" ] && exit 0

# Ignore the documentation artifacts themselves (avoids self-triggering loops).
case "$path" in
  *.md|*.json|*.log) exit 0 ;;
esac

# React only to artifacts that need docs: scripts, processed data, analysis output.
case "$path" in
  */02-scripts/*|*/03-data/*/Processed/*|*/04-analysis/*)
    cat <<'JSON'
{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"A project artifact (script / processed data / analysis output) just changed. Before finishing, update the matching Markdown docs for that project code — delegate to the doc-writer agent (or run /sync-docs). Keep script_summary.md, run summary.md, overview.md, Processed/README.md, report_summary.md, and 01-documentation metadata in sync."}}
JSON
    ;;
  *) exit 0 ;;
esac
