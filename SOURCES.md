# Skill sources

All 20 skills are divided by maintenance path. Sixteen are unmodified
public-upstream copies refreshed by `scripts/sync.sh`; four are maintained in
this repository.

```bash
scripts/sync.sh                 # refresh all 16 upstream copies
scripts/sync.sh <skill-name>    # refresh one
```

## Synced upstream copies (16)

The authoritative machine manifest is the `SOURCES` array in
[`scripts/sync.sh`](./scripts/sync.sh).

### Single-repository upstreams (3)

| Local skill | Upstream |
| --- | --- |
| [`playwright-cli`](./skills/playwright-cli) | [`microsoft/playwright-cli@main:skills/playwright-cli`](https://github.com/microsoft/playwright-cli/tree/main/skills/playwright-cli) |
| [`typescript-expert`](./skills/typescript-expert) | [`davila7/claude-code-templates@main:cli-tool/components/skills/development/typescript-expert`](https://github.com/davila7/claude-code-templates/tree/main/cli-tool/components/skills/development/typescript-expert) |
| [`complexity-optimizer`](./skills/complexity-optimizer) | [`Kappaemme-git/codex-complexity-optimizer@main:complexity-optimizer`](https://github.com/Kappaemme-git/codex-complexity-optimizer/tree/main/complexity-optimizer) |

### `cloudflare/skills` tracking `main` (7)

[`agents-sdk`](./skills/agents-sdk),
[`cloudflare`](./skills/cloudflare),
[`cloudflare-email-service`](./skills/cloudflare-email-service),
[`durable-objects`](./skills/durable-objects),
[`web-perf`](./skills/web-perf),
[`workers-best-practices`](./skills/workers-best-practices), and
[`wrangler`](./skills/wrangler) track
`cloudflare/skills@main:skills/<name>`.

### `cloudflare/skills` pinned snapshot (2)

These skills were removed upstream after `54ca4fd`, so their original
`SKILL.md` form remains pinned:

- [`building-ai-agent-on-cloudflare`](./skills/building-ai-agent-on-cloudflare)
- [`building-mcp-server-on-cloudflare`](./skills/building-mcp-server-on-cloudflare)

Both use
`cloudflare/skills@54ca4fd800e69906355da5010c03499017ddc3b1`.

### `EpicenterHQ/epicenter` tracking `main` (4)

| Local skill | Upstream directory |
| --- | --- |
| [`better-auth-best-practices`](./skills/better-auth-best-practices) | `.agents/skills/better-auth-best-practices` |
| [`better-auth-security`](./skills/better-auth-security) | `.agents/skills/better-auth-security-best-practices` |
| [`better-auth-create-auth`](./skills/better-auth-create-auth) | `.agents/skills/create-auth-skill` |
| [`better-auth-email-and-password`](./skills/better-auth-email-and-password) | `.agents/skills/email-and-password-best-practices` |

## Mosoo-maintained (4)

Edit these directly and do not add them to the sync manifest.

Originals:

- [`code-review-guardrails`](./skills/code-review-guardrails)
- [`typescript-style-guardrails`](./skills/typescript-style-guardrails)

Adaptations:

- [`no-use-effect`](./skills/no-use-effect), adapted from
  [`Factory-AI/factory-plugins`](https://github.com/Factory-AI/factory-plugins/tree/master/plugins/typescript/skills/no-use-effect)
  to reflect Mosoo's real React/data-layer commands and allow direct effects for
  external synchronization.
- [`sandbox-sdk`](./skills/sandbox-sdk), adapted from
  [`cloudflare/skills`](https://github.com/cloudflare/skills/tree/main/skills/sandbox-sdk)
  to require repository evidence and current official documentation rather than
  a fixed Wrangler format, image tag, or SDK version.

## Sync behavior

Each manifest entry is
`<local-dir>|<owner/repo>|<ref>|<upstream-path>`. The script fetches that
source and replaces only `skills/<local-dir>/`. A Mosoo-specific adaptation
must remain outside the manifest so a refresh cannot overwrite its guardrails.
