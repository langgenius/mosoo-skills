#!/usr/bin/env bash
# scripts/sync.sh — refresh the unmodified public-upstream copy in mosoo-skills.
#
# Usage:
#   scripts/sync.sh                   # refresh the upstream copy
#   scripts/sync.sh <skill-name>      # refresh one
#
# After the run, review `git diff -- skills/<name>/` from the repository root,
# or use `git -C /absolute/path/to/mosoo-skills diff -- skills/<name>/` from any
# other directory. Mosoo-maintained adaptations intentionally stay out of this
# manifest so a refresh cannot erase their project-first guardrails.

set -euo pipefail

# Each entry: <local-skill-dir>|<upstream-repo>|<upstream-ref>|<upstream-path>
SOURCES=(
  "complexity-optimizer|Kappaemme-git/codex-complexity-optimizer|main|complexity-optimizer"
)

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
target_skill="${1:-}"

sync_one() {
  local local_name=$1 repo=$2 ref=$3 upstream_path=$4
  local local_dir="$repo_root/skills/$local_name"
  echo "→ $local_name  ←  $repo@${ref:0:7}:$upstream_path"

  local tmp
  tmp=$(mktemp -d)
  trap 'rm -rf "$tmp"' RETURN

  git -C "$tmp" init -q
  git -C "$tmp" remote add origin "https://github.com/$repo.git"
  git -C "$tmp" fetch --depth 1 origin "$ref" -q
  git -C "$tmp" checkout -q FETCH_HEAD -- "$upstream_path" 2>/dev/null || {
    echo "  ! could not check out $upstream_path from $repo@$ref" >&2
    return 1
  }

  rm -rf "$local_dir"
  mkdir -p "$local_dir"
  cp -R "$tmp/$upstream_path/." "$local_dir/"
  echo "  ✓ wrote $(find "$local_dir" -type f | wc -l | tr -d ' ') files"
}

matched=0
failed=0
for entry in "${SOURCES[@]}"; do
  IFS='|' read -r name repo ref path <<<"$entry"
  if [[ -z "$target_skill" || "$target_skill" == "$name" ]]; then
    if sync_one "$name" "$repo" "$ref" "$path"; then
      matched=$((matched + 1))
    else
      failed=$((failed + 1))
    fi
  fi
done

if [[ $matched -eq 0 && $failed -eq 0 ]]; then
  echo "No skill named '$target_skill' in the sync manifest." >&2
  echo "Known: $(printf '%s\n' "${SOURCES[@]}" | cut -d'|' -f1 | tr '\n' ' ')" >&2
  exit 1
fi

echo ""
echo "Synced $matched skill(s)$([ $failed -gt 0 ] && echo " ($failed failed)")."
[[ $failed -gt 0 ]] && exit 2 || exit 0
