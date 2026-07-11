#!/usr/bin/env bash
# scripts/sync-local.sh — refresh the unmodified skill that the public `skills` CLI cannot manage.
#
# Usage from the mosoo-skills repository root:
#   scripts/sync-local.sh                 # refresh the unmodified upstream skill
#   scripts/sync-local.sh <skill-name>    # refresh one skill
#
# From any other CWD, invoke this script by its absolute path. Review with:
#   git -C /absolute/path/to/mosoo-skills diff -- skills/<name>/

set -euo pipefail

# Each entry: <local-skill-dir>|<upstream-repo>|<upstream-ref>|<upstream-path>
SOURCES=(
  "better-auth-security|EpicenterHQ/epicenter|main|.agents/skills/better-auth-security-best-practices"
)

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
target_skill="${1:-}"

sync_one() {
  local local_name=$1 repo=$2 ref=$3 upstream_path=$4
  local local_dir="$repo_root/skills/$local_name"
  echo "→ $local_name  ←  $repo@$ref:$upstream_path"

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
for entry in "${SOURCES[@]}"; do
  IFS='|' read -r name repo ref path <<<"$entry"
  if [[ -z "$target_skill" || "$target_skill" == "$name" ]]; then
    sync_one "$name" "$repo" "$ref" "$path"
    matched=$((matched + 1))
  fi
done

if [[ $matched -eq 0 ]]; then
  echo "No skill named '$target_skill' in the local-sync manifest." >&2
  echo "Known: $(printf '%s\n' "${SOURCES[@]}" | cut -d'|' -f1 | tr '\n' ' ')" >&2
  exit 1
fi
