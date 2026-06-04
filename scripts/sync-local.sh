#!/usr/bin/env bash
# scripts/sync-local.sh — refresh the 6 skills that the public `skills` CLI cannot manage.
#
# Usage:
#   scripts/sync-local.sh                 # refresh all locally-maintained skills
#   scripts/sync-local.sh <skill-name>    # refresh one skill
#
# After the run, review `git diff skills/<name>/` and commit if you want to adopt the upstream.

set -euo pipefail

# Each entry: <local-skill-dir>|<upstream-repo>|<upstream-ref>|<upstream-path>
SOURCES=(
  "better-auth-best-practices|EpicenterHQ/epicenter|main|.agents/skills/better-auth-best-practices"
  "better-auth-security|EpicenterHQ/epicenter|main|.agents/skills/better-auth-security-best-practices"
  "better-auth-create-auth|EpicenterHQ/epicenter|main|.agents/skills/create-auth-skill"
  "better-auth-email-and-password|EpicenterHQ/epicenter|main|.agents/skills/email-and-password-best-practices"
  "building-ai-agent-on-cloudflare|cloudflare/skills|54ca4fd800e69906355da5010c03499017ddc3b1|skills/building-ai-agent-on-cloudflare"
  "building-mcp-server-on-cloudflare|cloudflare/skills|54ca4fd800e69906355da5010c03499017ddc3b1|skills/building-mcp-server-on-cloudflare"
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
