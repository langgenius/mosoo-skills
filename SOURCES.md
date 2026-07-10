# Skill sources

All 20 skills, grouped by maintenance path. The 10 entries in `skills-lock.json` are tracked by the [`skills`](https://github.com/vercel-labs/skills) CLI and refreshed via `npx skills update`. 6 more sync from public upstreams the CLI cannot enumerate. The remaining 4 are Mosoo-maintained originals or adaptations.

Run every relative command on this page from the `mosoo-skills` repository root. From another directory, invoke `scripts/sync-local.sh` by its absolute path and review with `git -C /absolute/path/to/mosoo-skills diff -- skills/<name>/`.

## CLI-tracked (10)

| Local skill | Upstream | Refresh |
| --- | --- | --- |
| [`agents-sdk`](./skills/agents-sdk) | [`cloudflare/skills@skills/agents-sdk`](https://github.com/cloudflare/skills/tree/main/skills/agents-sdk) | `npx skills update agents-sdk` |
| [`cloudflare`](./skills/cloudflare) | [`cloudflare/skills@skills/cloudflare`](https://github.com/cloudflare/skills/tree/main/skills/cloudflare) | `npx skills update cloudflare` |
| [`cloudflare-email-service`](./skills/cloudflare-email-service) | [`cloudflare/skills@skills/cloudflare-email-service`](https://github.com/cloudflare/skills/tree/main/skills/cloudflare-email-service) | `npx skills update cloudflare-email-service` |
| [`durable-objects`](./skills/durable-objects) | [`cloudflare/skills@skills/durable-objects`](https://github.com/cloudflare/skills/tree/main/skills/durable-objects) | `npx skills update durable-objects` |
| [`web-perf`](./skills/web-perf) | [`cloudflare/skills@skills/web-perf`](https://github.com/cloudflare/skills/tree/main/skills/web-perf) | `npx skills update web-perf` |
| [`workers-best-practices`](./skills/workers-best-practices) | [`cloudflare/skills@skills/workers-best-practices`](https://github.com/cloudflare/skills/tree/main/skills/workers-best-practices) | `npx skills update workers-best-practices` |
| [`wrangler`](./skills/wrangler) | [`cloudflare/skills@skills/wrangler`](https://github.com/cloudflare/skills/tree/main/skills/wrangler) | `npx skills update wrangler` |
| [`playwright-cli`](./skills/playwright-cli) | [`microsoft/playwright-cli@skills/playwright-cli`](https://github.com/microsoft/playwright-cli/tree/main/skills/playwright-cli) | `npx skills update playwright-cli` |
| [`typescript-expert`](./skills/typescript-expert) | [`davila7/claude-code-templates@cli-tool/components/skills/development/typescript-expert`](https://github.com/davila7/claude-code-templates/tree/main/cli-tool/components/skills/development/typescript-expert) | `npx skills update typescript-expert` |
| [`complexity-optimizer`](./skills/complexity-optimizer) | [`Kappaemme-git/codex-complexity-optimizer@complexity-optimizer`](https://github.com/Kappaemme-git/codex-complexity-optimizer/tree/main/complexity-optimizer) | `npx skills update complexity-optimizer` |

Bulk update:

```bash
npx skills update   # apply pending updates (writes to skills/<name>/ and skills-lock.json)
```

## Manually synced (6)

### From EpicenterHQ (4) — CLI cannot discover these

`EpicenterHQ/epicenter` exposes ~95 skill directories under `.agents/skills/`, but the public skills CLI currently only enumerates ~76 of them. Until that gap closes, refresh these four by hand. The local directory names use a `better-auth-*` prefix for grouping; the upstream `name:` field still matches the upstream directory.

| Local skill | Upstream path | One-shot refresh |
| --- | --- | --- |
| [`better-auth-best-practices`](./skills/better-auth-best-practices) | `EpicenterHQ/epicenter@.agents/skills/better-auth-best-practices/SKILL.md` | `scripts/sync-local.sh better-auth-best-practices` |
| [`better-auth-security`](./skills/better-auth-security) | `EpicenterHQ/epicenter@.agents/skills/better-auth-security-best-practices/SKILL.md` | `scripts/sync-local.sh better-auth-security` |
| [`better-auth-create-auth`](./skills/better-auth-create-auth) | `EpicenterHQ/epicenter@.agents/skills/create-auth-skill/SKILL.md` | `scripts/sync-local.sh better-auth-create-auth` |
| [`better-auth-email-and-password`](./skills/better-auth-email-and-password) | `EpicenterHQ/epicenter@.agents/skills/email-and-password-best-practices/SKILL.md` | `scripts/sync-local.sh better-auth-email-and-password` |

### Snapshot from `cloudflare/skills@54ca4fd` (2) — removed upstream

`cloudflare/skills` commit [`e96fbc7`](https://github.com/cloudflare/skills/commit/e96fbc7) (2026-04-15) deleted these two skill directories and folded the guidance into `commands/build-agent.md` / `commands/build-mcp.md`. We pin to the parent commit so the original SKILL.md form is preserved.

| Local skill | Upstream path | One-shot refresh |
| --- | --- | --- |
| [`building-ai-agent-on-cloudflare`](./skills/building-ai-agent-on-cloudflare) | `cloudflare/skills@54ca4fd:skills/building-ai-agent-on-cloudflare/SKILL.md` | `scripts/sync-local.sh building-ai-agent-on-cloudflare` |
| [`building-mcp-server-on-cloudflare`](./skills/building-mcp-server-on-cloudflare) | `cloudflare/skills@54ca4fd:skills/building-mcp-server-on-cloudflare/SKILL.md` | `scripts/sync-local.sh building-mcp-server-on-cloudflare` |

## Mosoo-maintained (4)

This repository is the canonical home for these skills. Edit them directly and commit the result; do not add the adaptations to `skills-lock.json` unless they return to unmodified upstream behavior.

Original skills with no public upstream:

- [`code-review-guardrails`](./skills/code-review-guardrails) — review skill that catches sub-optimal coding patterns and constraint violations
- [`typescript-style-guardrails`](./skills/typescript-style-guardrails) — readability-first TypeScript/TSX style guardrails for strict codebases

Mosoo-maintained adaptations with upstream provenance:

- [`no-use-effect`](./skills/no-use-effect) — adapted from [`Factory-AI/factory-plugins`](https://github.com/Factory-AI/factory-plugins/tree/master/plugins/typescript/skills/no-use-effect) to match Mosoo's direct external-synchronization use of React effects and Justfile commands
- [`sandbox-sdk`](./skills/sandbox-sdk) — adapted from [`cloudflare/skills`](https://github.com/cloudflare/skills/tree/main/skills/sandbox-sdk) to preserve existing project configuration and require current package, Dockerfile, and official-doc evidence

## How `scripts/sync-local.sh` works

The script holds a per-skill mapping (`<local-name>|<owner/repo>|<ref>|<upstream-path>`) and refreshes one or all entries by fetching that path from the pinned ref. Pass a skill name to refresh just one; pass nothing to refresh all 6. It resolves its destination from the script location, so an absolute script invocation is safe from any CWD. It writes nothing outside `skills/<name>/`; review with `git diff -- skills/<name>/` from the repository root, or with the `git -C` command above from elsewhere.
