#!/usr/bin/env bash
# claudezak installer — wires the spinner verbs into a target Claude Code
# settings.json. Defaults to user-wide install (~/.claude/).
#
# Usage:
#   ./install.sh                    # user-wide (~/.claude/settings.json)
#   ./install.sh --user             # same as above
#   ./install.sh --project PATH     # install into PATH/.claude/settings.json
#   ./install.sh --uninstall        # remove spinnerVerbs from target
#   ./install.sh --dry-run          # show what would change, don't write
#
# Re-runnable. Existing settings are preserved; only spinnerVerbs is touched.
# A timestamped backup is written next to the file before any change.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_SETTINGS="$SCRIPT_DIR/.claude/settings.json"

scope="user"
project_path=""
uninstall=0
dry_run=0

usage() {
  sed -n '2,13p' "$0" | sed 's/^# \{0,1\}//'
  exit "${1:-0}"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --user)       scope="user"; shift ;;
    --project)    scope="project"; project_path="${2:?--project requires a path}"; shift 2 ;;
    --uninstall)  uninstall=1; shift ;;
    --dry-run)    dry_run=1; shift ;;
    -h|--help)    usage 0 ;;
    *)            echo "unknown arg: $1" >&2; usage 1 ;;
  esac
done

err()  { printf '\033[31merror:\033[0m %s\n' "$*" >&2; exit 1; }
info() { printf '\033[36m==>\033[0m %s\n' "$*" >&2; }
ok()   { printf '\033[32m ok\033[0m %s\n' "$*" >&2; }

command -v jq >/dev/null 2>&1 || err "jq is required (apt: jq, brew: jq)"
[[ -f "$SOURCE_SETTINGS" ]] || err "missing source settings: $SOURCE_SETTINGS"

# Resolve target path
if [[ "$scope" == "user" ]]; then
  target_dir="$HOME/.claude"
else
  project_path="$(cd "$project_path" && pwd)" || err "project path not found"
  target_dir="$project_path/.claude"
fi
target_settings="$target_dir/settings.json"

info "scope:    $scope"
info "settings: $target_settings"
[[ $dry_run -eq 1 ]] && info "(dry run — no changes will be written)"

# Read or seed target settings
mkdir -p "$target_dir"
if [[ -f "$target_settings" ]]; then
  jq -e . "$target_settings" >/dev/null 2>&1 || err "target settings is not valid JSON: $target_settings"
  current=$(cat "$target_settings")
else
  current='{"$schema":"https://json.schemastore.org/claude-code-settings.json"}'
fi

# Backup if a real file exists
if [[ -f "$target_settings" && $dry_run -eq 0 ]]; then
  backup_path="$target_settings.bak.$(date +%Y%m%d-%H%M%S)"
  cp "$target_settings" "$backup_path"
  ok "backup: $backup_path"
fi

if [[ $uninstall -eq 1 ]]; then
  new=$(jq 'del(.spinnerVerbs)' <<<"$current")
  if [[ $dry_run -eq 1 ]]; then
    info "would write:"; jq . <<<"$new"
  else
    printf '%s\n' "$new" | jq . > "$target_settings"
    ok "removed spinnerVerbs from $target_settings"
  fi
  exit 0
fi

verbs=$(jq '.spinnerVerbs' "$SOURCE_SETTINGS")
[[ "$verbs" == "null" ]] && err "source settings has no spinnerVerbs"

new=$(jq --argjson verbs "$verbs" '.spinnerVerbs = $verbs' <<<"$current")

if [[ $dry_run -eq 1 ]]; then
  info "would write:"; jq . <<<"$new"
  exit 0
fi

printf '%s\n' "$new" | jq . > "$target_settings"
ok "merged spinnerVerbs into $target_settings"

cat <<EOF

Done. Restart Claude Code (or open a new session) to pick up the changes.
EOF
