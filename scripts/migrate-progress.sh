#!/usr/bin/env bash
# Migrate progress files from the single-skill mentor (depth stored as `level: L1..L3`)
# to senior-mentor (`depth: D1..D3` + career `level: L1..L7`).
#
#   scripts/migrate-progress.sh                 # dry run on ~/.claude/mentor
#   scripts/migrate-progress.sh --apply         # back up, then migrate in place
#   scripts/migrate-progress.sh --dir <path>    # operate on another mentor dir (e.g. a copy)
#
# Only the YAML frontmatter is touched. Files that already have `depth:` are skipped,
# so running it twice is safe.
set -euo pipefail

dir="$HOME/.claude/mentor"
apply=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --apply) apply=1 ;;
    --dir) dir="$2"; shift ;;
    -h|--help) sed -n '2,11p' "$0"; exit 0 ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
  shift
done

progress="$dir/progress"
[[ -d "$progress" ]] || { echo "no progress dir at $progress — nothing to migrate"; exit 0; }

migrate() { # stdin: file, stdout: migrated file
  awk '
    NR == 1 && $0 == "---" { infm = 1; print; next }
    infm && $0 == "---" {
      infm = 0
      if (!had_career) { print "level: unassessed             # career level L1..L7 — run /mentor assess"; print "level_history: []" }
      print; next
    }
    infm && /^level:[ \t]*L[123]([ \t#]|$)/ {
      line = $0
      sub(/^level:[ \t]*L/, "depth: D", line)
      print line
      next
    }
    infm && /^level:/ { had_career = 1 }
    { print }
  '
}

todo=()
for f in "$progress"/*.md; do
  [[ -e "$f" ]] || continue
  if awk 'NR==1 && $0!="---"{exit 1} NR>1 && $0=="---"{exit} /^depth:/{found=1} END{exit !found}' "$f"; then
    echo "skip (already migrated): $(basename "$f")"
  else
    todo+=("$f")
  fi
done

if (( apply && ${#todo[@]} )); then
  backup="$dir.bak-$(date +%Y%m%d-%H%M%S)-$$"
  cp -a "$dir" "$backup"
  echo "backup: $backup"
fi

changed=0
for f in "${todo[@]}"; do
  out="$(migrate < "$f")"
  if (( apply )); then
    printf '%s\n' "$out" > "$f"
    echo "migrated: $(basename "$f")"
  else
    echo "--- would migrate: $(basename "$f")"
    diff <(cat "$f") <(printf '%s\n' "$out") || true
  fi
  changed=$((changed + 1))
done

echo "$changed file(s) $( (( apply )) && echo migrated || echo 'to migrate (dry run; pass --apply)')"
