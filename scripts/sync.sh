#!/usr/bin/env bash
# scripts/sync.sh — refresh unmodified public-upstream copies in mosoo-skills.
#
# Usage:
#   scripts/sync.sh                   # refresh all 16 upstream copies
#   scripts/sync.sh <skill-name>      # refresh one
#
# The four Mosoo-maintained skills (code-review-guardrails,
# typescript-style-guardrails, no-use-effect, and sandbox-sdk) intentionally stay
# out of this manifest so a refresh cannot erase project-specific guardrails.

set -euo pipefail

# Each entry: <local-skill-dir>|<upstream-repo>|<upstream-ref>|<upstream-path>
SOURCES=(
  # cloudflare/skills — tracks main
  "agents-sdk|cloudflare/skills|main|skills/agents-sdk"
  "cloudflare|cloudflare/skills|main|skills/cloudflare"
  "cloudflare-email-service|cloudflare/skills|main|skills/cloudflare-email-service"
  "durable-objects|cloudflare/skills|main|skills/durable-objects"
  "web-perf|cloudflare/skills|main|skills/web-perf"
  "workers-best-practices|cloudflare/skills|main|skills/workers-best-practices"
  "wrangler|cloudflare/skills|main|skills/wrangler"

  # cloudflare/skills @ 54ca4fd — retained from the last upstream SKILL.md form
  "building-ai-agent-on-cloudflare|cloudflare/skills|54ca4fd800e69906355da5010c03499017ddc3b1|skills/building-ai-agent-on-cloudflare"
  "building-mcp-server-on-cloudflare|cloudflare/skills|54ca4fd800e69906355da5010c03499017ddc3b1|skills/building-mcp-server-on-cloudflare"

  # Single-skill upstreams. no-use-effect is Mosoo-maintained and excluded.
  "playwright-cli|microsoft/playwright-cli|main|skills/playwright-cli"
  "typescript-expert|davila7/claude-code-templates|main|cli-tool/components/skills/development/typescript-expert"
  "complexity-optimizer|Kappaemme-git/codex-complexity-optimizer|main|complexity-optimizer"

  # EpicenterHQ/epicenter
  "better-auth-best-practices|EpicenterHQ/epicenter|main|.agents/skills/better-auth-best-practices"
  "better-auth-security|EpicenterHQ/epicenter|main|.agents/skills/better-auth-security-best-practices"
  "better-auth-create-auth|EpicenterHQ/epicenter|main|.agents/skills/create-auth-skill"
  "better-auth-email-and-password|EpicenterHQ/epicenter|main|.agents/skills/email-and-password-best-practices"
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
