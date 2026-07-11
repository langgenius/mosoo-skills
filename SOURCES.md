# Skill sources

20 skills total. 18 sync from public upstreams via `scripts/sync.sh`; the remaining 2 are mosoo originals — this repo is their canonical home.

```bash
scripts/sync.sh                   # refresh all 18 upstream-sourced skills
scripts/sync.sh <skill-name>      # refresh one
```

A GitHub Action runs the same script every Monday and opens a PR for any drift — see [§ Weekly auto-sync](./README.md#weekly-auto-sync) in the README.

## Upstream manifest

The authoritative manifest lives in [`scripts/sync.sh`](./scripts/sync.sh) (`SOURCES` array). This table is for human reference.

### Single-repo upstreams

| Local skill | Upstream |
| --- | --- |
| [`playwright-cli`](./skills/playwright-cli) | [`microsoft/playwright-cli@main:skills/playwright-cli`](https://github.com/microsoft/playwright-cli/tree/main/skills/playwright-cli) |
| [`no-use-effect`](./skills/no-use-effect) | [`Factory-AI/factory-plugins@master:plugins/typescript/skills/no-use-effect`](https://github.com/Factory-AI/factory-plugins/tree/master/plugins/typescript/skills/no-use-effect) |
| [`typescript-expert`](./skills/typescript-expert) | [`davila7/claude-code-templates@main:cli-tool/components/skills/development/typescript-expert`](https://github.com/davila7/claude-code-templates/tree/main/cli-tool/components/skills/development/typescript-expert) |
| [`complexity-optimizer`](./skills/complexity-optimizer) | [`Kappaemme-git/codex-complexity-optimizer@main:complexity-optimizer`](https://github.com/Kappaemme-git/codex-complexity-optimizer/tree/main/complexity-optimizer) |

### `cloudflare/skills` — tracks `main` (8)

[`agents-sdk`](./skills/agents-sdk), [`cloudflare`](./skills/cloudflare), [`cloudflare-email-service`](./skills/cloudflare-email-service), [`durable-objects`](./skills/durable-objects), [`sandbox-sdk`](./skills/sandbox-sdk), [`web-perf`](./skills/web-perf), [`workers-best-practices`](./skills/workers-best-practices), [`wrangler`](./skills/wrangler) — all at `cloudflare/skills@main:skills/<name>`.

### `cloudflare/skills` — pinned snapshot at `54ca4fd` (2)

Removed in commit [`e96fbc7`](https://github.com/cloudflare/skills/commit/e96fbc7) (2026-04-15) when the guidance was folded into `commands/build-agent.md` / `commands/build-mcp.md`. Pinned to the parent commit so the original SKILL.md form is preserved.

- [`building-ai-agent-on-cloudflare`](./skills/building-ai-agent-on-cloudflare) — `cloudflare/skills@54ca4fd:skills/building-ai-agent-on-cloudflare`
- [`building-mcp-server-on-cloudflare`](./skills/building-mcp-server-on-cloudflare) — `cloudflare/skills@54ca4fd:skills/building-mcp-server-on-cloudflare`

### `EpicenterHQ/epicenter` — tracks `main` (4)

Local directory names use a `better-auth-` prefix for grouping; the upstream directory name (and the `name:` frontmatter field) sticks with EpicenterHQ's naming.

| Local skill | Upstream directory |
| --- | --- |
| [`better-auth-best-practices`](./skills/better-auth-best-practices) | `.agents/skills/better-auth-best-practices` |
| [`better-auth-security`](./skills/better-auth-security) | `.agents/skills/better-auth-security-best-practices` |
| [`better-auth-create-auth`](./skills/better-auth-create-auth) | `.agents/skills/create-auth-skill` |
| [`better-auth-email-and-password`](./skills/better-auth-email-and-password) | `.agents/skills/email-and-password-best-practices` |

## mosoo originals (2)

No public upstream. Edit `skills/<name>/SKILL.md` directly and commit.

- [`code-review-guardrails`](./skills/code-review-guardrails) — review skill that catches sub-optimal coding patterns and constraint violations
- [`typescript-style-guardrails`](./skills/typescript-style-guardrails) — readability-first TypeScript/TSX style guardrails for strict codebases

## How `scripts/sync.sh` works

Each manifest entry is `<local-dir>|<owner/repo>|<ref>|<upstream-path>`. For each entry, the script does `git fetch --depth 1` against the pinned ref, checks out `upstream-path`, then replaces `skills/<local-dir>/` with the fetched contents. It writes nothing outside `skills/`, so `git diff` after the run shows exactly what changed upstream.

Adding a new upstream-sourced skill = adding one line to the `SOURCES` array. The weekly workflow will start syncing it on the next Monday run.
