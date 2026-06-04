# Skill sources

All 20 skills, grouped by upstream. The 12 entries in `skills-lock.json` are tracked by the [`skills`](https://github.com/vercel-labs/skills) CLI and refreshed via `npx skills update`. The remaining 8 are maintained locally; refresh them via the manual steps in [§ Locally maintained](#locally-maintained).

## CLI-tracked (12)

| Local skill | Upstream | Refresh |
| --- | --- | --- |
| [`agents-sdk`](./skills/agents-sdk) | [`cloudflare/skills@skills/agents-sdk`](https://github.com/cloudflare/skills/tree/main/skills/agents-sdk) | `npx skills update agents-sdk` |
| [`cloudflare`](./skills/cloudflare) | [`cloudflare/skills@skills/cloudflare`](https://github.com/cloudflare/skills/tree/main/skills/cloudflare) | `npx skills update cloudflare` |
| [`cloudflare-email-service`](./skills/cloudflare-email-service) | [`cloudflare/skills@skills/cloudflare-email-service`](https://github.com/cloudflare/skills/tree/main/skills/cloudflare-email-service) | `npx skills update cloudflare-email-service` |
| [`durable-objects`](./skills/durable-objects) | [`cloudflare/skills@skills/durable-objects`](https://github.com/cloudflare/skills/tree/main/skills/durable-objects) | `npx skills update durable-objects` |
| [`sandbox-sdk`](./skills/sandbox-sdk) | [`cloudflare/skills@skills/sandbox-sdk`](https://github.com/cloudflare/skills/tree/main/skills/sandbox-sdk) | `npx skills update sandbox-sdk` |
| [`web-perf`](./skills/web-perf) | [`cloudflare/skills@skills/web-perf`](https://github.com/cloudflare/skills/tree/main/skills/web-perf) | `npx skills update web-perf` |
| [`workers-best-practices`](./skills/workers-best-practices) | [`cloudflare/skills@skills/workers-best-practices`](https://github.com/cloudflare/skills/tree/main/skills/workers-best-practices) | `npx skills update workers-best-practices` |
| [`wrangler`](./skills/wrangler) | [`cloudflare/skills@skills/wrangler`](https://github.com/cloudflare/skills/tree/main/skills/wrangler) | `npx skills update wrangler` |
| [`playwright-cli`](./skills/playwright-cli) | [`microsoft/playwright-cli@skills/playwright-cli`](https://github.com/microsoft/playwright-cli/tree/main/skills/playwright-cli) | `npx skills update playwright-cli` |
| [`no-use-effect`](./skills/no-use-effect) | [`Factory-AI/factory-plugins@plugins/typescript/skills/no-use-effect`](https://github.com/Factory-AI/factory-plugins/tree/master/plugins/typescript/skills/no-use-effect) | `npx skills update no-use-effect` |
| [`typescript-expert`](./skills/typescript-expert) | [`davila7/claude-code-templates@cli-tool/components/skills/development/typescript-expert`](https://github.com/davila7/claude-code-templates/tree/main/cli-tool/components/skills/development/typescript-expert) | `npx skills update typescript-expert` |
| [`complexity-optimizer`](./skills/complexity-optimizer) | [`Kappaemme-git/codex-complexity-optimizer@complexity-optimizer`](https://github.com/Kappaemme-git/codex-complexity-optimizer/tree/main/complexity-optimizer) | `npx skills update complexity-optimizer` |

Bulk check / update:

```bash
npx skills check    # diff every tracked skill against its upstream
npx skills update   # apply pending updates (writes to skills/<name>/ and skills-lock.json)
```

## Locally maintained (8)

### From EpicenterHQ (4) — CLI cannot discover these

`EpicenterHQ/epicenter` exposes ~95 skill directories under `.agents/skills/`, but the public skills CLI currently only enumerates ~76 of them. Until that gap closes, refresh these four by hand. The local directory names use the `better-auth-*` prefix groots adopted; the upstream `name:` field still matches the upstream directory.

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

### Groots-internal (2) — no public upstream

Originally written inside `langgenius/groots`; no public copy exists elsewhere. Treat `langgenius/groots/.agents/skills/<name>/` as the upstream.

- [`code-review-guardrails`](./skills/code-review-guardrails) — `langgenius/groots@main:.agents/skills/code-review-guardrails`
- [`typescript-style-guardrails`](./skills/typescript-style-guardrails) — `langgenius/groots@main:.agents/skills/typescript-style-guardrails`

`scripts/sync-local.sh` knows about these too; pass the local name as the argument.

## How `scripts/sync-local.sh` works

The script reads the per-skill mapping below from this file and runs `git archive | tar -x` to refresh each skill directory in-place. It writes nothing else, so a `git diff` after running shows exactly what changed upstream. Review the diff, commit if you want to adopt it.
