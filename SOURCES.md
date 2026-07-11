# Skill sources

All 20 skills, grouped by maintenance path. One is an unmodified public-upstream
copy refreshed by `scripts/sync.sh`. The remaining 19 are Mosoo-maintained
originals or adaptations.

Run every relative command on this page from the `mosoo-skills` repository
root. From another directory, invoke `scripts/sync.sh` by its absolute
path and review with
`git -C /absolute/path/to/mosoo-skills diff -- skills/<name>/`.

## Synced upstream copy (1)

| Local skill | Upstream | Refresh |
| --- | --- | --- |
| [`complexity-optimizer`](./skills/complexity-optimizer) | [`Kappaemme-git/codex-complexity-optimizer@main:complexity-optimizer`](https://github.com/Kappaemme-git/codex-complexity-optimizer/tree/main/complexity-optimizer) | `scripts/sync.sh complexity-optimizer` |

## Mosoo-maintained (19)

This repository is the canonical home for these skills. Edit them directly and
commit the result. Do not add adaptations to `scripts/sync.sh` unless they
return to unmodified upstream behavior.

Original skills with no public upstream:

- [`code-review-guardrails`](./skills/code-review-guardrails) — Mosoo architecture, data, review, and verification guardrails
- [`typescript-style-guardrails`](./skills/typescript-style-guardrails) — readability-first TypeScript/TSX guardrails

Mosoo-maintained adaptations with upstream provenance:

- [`agents-sdk`](./skills/agents-sdk) — adapted from [`cloudflare/skills`](https://github.com/cloudflare/skills/tree/main/skills/agents-sdk)
- [`better-auth-best-practices`](./skills/better-auth-best-practices) — adapted from [`EpicenterHQ/epicenter`](https://github.com/EpicenterHQ/epicenter/tree/main/.agents/skills/better-auth-best-practices)
- [`better-auth-create-auth`](./skills/better-auth-create-auth) — adapted from the former [`EpicenterHQ/epicenter@.agents/skills/create-auth-skill`](https://github.com/EpicenterHQ/epicenter/tree/450f4888546e7eb2b4cecf29975b918c9f4ab31a/.agents/skills/create-auth-skill) path after its upstream removal
- [`better-auth-email-and-password`](./skills/better-auth-email-and-password) — retained from the former [`EpicenterHQ/epicenter@.agents/skills/email-and-password-best-practices`](https://github.com/EpicenterHQ/epicenter/tree/450f4888546e7eb2b4cecf29975b918c9f4ab31a/.agents/skills/email-and-password-best-practices) path after its upstream removal
- [`better-auth-security`](./skills/better-auth-security) — adapted from [`EpicenterHQ/epicenter`](https://github.com/EpicenterHQ/epicenter/tree/main/.agents/skills/better-auth-security-best-practices) with project-first tooling and dependency guardrails
- [`building-ai-agent-on-cloudflare`](./skills/building-ai-agent-on-cloudflare) — adapted from `cloudflare/skills@54ca4fd:skills/building-ai-agent-on-cloudflare`
- [`building-mcp-server-on-cloudflare`](./skills/building-mcp-server-on-cloudflare) — adapted from `cloudflare/skills@54ca4fd:skills/building-mcp-server-on-cloudflare`
- [`cloudflare`](./skills/cloudflare) — adapted from [`cloudflare/skills`](https://github.com/cloudflare/skills/tree/main/skills/cloudflare)
- [`cloudflare-email-service`](./skills/cloudflare-email-service) — adapted from [`cloudflare/skills`](https://github.com/cloudflare/skills/tree/main/skills/cloudflare-email-service)
- [`durable-objects`](./skills/durable-objects) — adapted from [`cloudflare/skills`](https://github.com/cloudflare/skills/tree/main/skills/durable-objects)
- [`no-use-effect`](./skills/no-use-effect) — adapted from [`Factory-AI/factory-plugins`](https://github.com/Factory-AI/factory-plugins/tree/master/plugins/typescript/skills/no-use-effect)
- [`playwright-cli`](./skills/playwright-cli) — adapted from [`microsoft/playwright-cli`](https://github.com/microsoft/playwright-cli/tree/main/skills/playwright-cli) with project-first test and installation guardrails
- [`sandbox-sdk`](./skills/sandbox-sdk) — adapted from [`cloudflare/skills`](https://github.com/cloudflare/skills/tree/main/skills/sandbox-sdk)
- [`typescript-expert`](./skills/typescript-expert) — adapted from [`davila7/claude-code-templates`](https://github.com/davila7/claude-code-templates/tree/main/cli-tool/components/skills/development/typescript-expert)
- [`web-perf`](./skills/web-perf) — adapted from [`cloudflare/skills`](https://github.com/cloudflare/skills/tree/main/skills/web-perf) with project-first tooling and installation guardrails
- [`workers-best-practices`](./skills/workers-best-practices) — adapted from [`cloudflare/skills`](https://github.com/cloudflare/skills/tree/main/skills/workers-best-practices)
- [`wrangler`](./skills/wrangler) — adapted from [`cloudflare/skills`](https://github.com/cloudflare/skills/tree/main/skills/wrangler)

All adaptations preserve active repository rules, existing configuration
formats, pinned dependencies, and wrapper commands before applying generic
upstream examples. Skill-specific provenance details remain in Git history.

## How `scripts/sync.sh` works

The script holds a one-entry mapping
(`<local-name>|<owner/repo>|<ref>|<upstream-path>`) and fetches the unmodified
copy. It resolves the destination from the script location, so an absolute
invocation is safe from any CWD. It writes nothing outside the listed skill
directory.
