# mosoo-skills

Reusable skills for Mosoo coding agents. Each skill lives under
[`skills/`](./skills) with a `SKILL.md` entry point and optional supporting
references, scripts, or assets.

Provenance and refresh ownership are tracked in [`SOURCES.md`](./SOURCES.md).
Of the 20 skills, 16 are unmodified public-upstream copies refreshed by
`scripts/sync.sh`. Four are Mosoo-maintained: two originals plus the
`no-use-effect` and `sandbox-sdk` adaptations.

## Skills

| Skill | Description |
| --- | --- |
| [agents-sdk](./skills/agents-sdk/SKILL.md) | Build AI agents on Cloudflare Workers using the Agents SDK. |
| [better-auth-best-practices](./skills/better-auth-best-practices/SKILL.md) | Integrating Better Auth — the comprehensive TypeScript authentication framework. |
| [better-auth-create-auth](./skills/better-auth-create-auth/SKILL.md) | Create auth layers in TypeScript/JavaScript apps using Better Auth. |
| [better-auth-email-and-password](./skills/better-auth-email-and-password/SKILL.md) | Guidance and enforcement rules for secure email + password auth with Better Auth. |
| [better-auth-security](./skills/better-auth-security/SKILL.md) | Cross-cutting Better Auth security: rate limiting, CSRF, session, trusted origins, secrets, OAuth, IP tracking, auditing. |
| [building-ai-agent-on-cloudflare](./skills/building-ai-agent-on-cloudflare/SKILL.md) | Build AI agents on Cloudflare with state, real-time WebSockets, scheduled tasks, tools, and chat. |
| [building-mcp-server-on-cloudflare](./skills/building-mcp-server-on-cloudflare/SKILL.md) | Build remote MCP servers on Cloudflare Workers with tools and OAuth. |
| [cloudflare](./skills/cloudflare/SKILL.md) | Cloudflare platform guidance for Workers, Pages, storage, AI, networking, security, and IaC. |
| [cloudflare-email-service](./skills/cloudflare-email-service/SKILL.md) | Send and receive transactional emails with Cloudflare Email Service. |
| [code-review-guardrails](./skills/code-review-guardrails/SKILL.md) | Review Mosoo changes against current project rules and architecture. |
| [complexity-optimizer](./skills/complexity-optimizer/SKILL.md) | Audit and improve complexity and performance without changing behavior. |
| [durable-objects](./skills/durable-objects/SKILL.md) | Create and review Cloudflare Durable Objects. |
| [no-use-effect](./skills/no-use-effect/SKILL.md) | Avoid unnecessary React effects while keeping real external synchronization explicit. |
| [playwright-cli](./skills/playwright-cli/SKILL.md) | Automate browser interactions and work with Playwright tests. |
| [sandbox-sdk](./skills/sandbox-sdk/SKILL.md) | Build and review version-sensitive Cloudflare Sandbox SDK integrations. |
| [typescript-expert](./skills/typescript-expert/SKILL.md) | TypeScript strictness, boundary contracts, parser design, and monorepo diagnostics. |
| [typescript-style-guardrails](./skills/typescript-style-guardrails/SKILL.md) | Readability-first TypeScript/TSX style guardrails. |
| [web-perf](./skills/web-perf/SKILL.md) | Analyze Web performance with Chrome DevTools. |
| [workers-best-practices](./skills/workers-best-practices/SKILL.md) | Review and author Cloudflare Workers code. |
| [wrangler](./skills/wrangler/SKILL.md) | Use Wrangler to develop and manage Cloudflare resources. |

## Layout

```text
mosoo-skills/
├── README.md
├── SOURCES.md
├── scripts/
│   └── sync.sh
└── skills/
    └── <skill-name>/
        ├── SKILL.md
        └── references/
```

## Updating skills

Run these commands from the repository root:

```bash
scripts/sync.sh                 # refresh all 16 upstream copies
scripts/sync.sh <skill-name>    # refresh one upstream copy
```

Review `git diff -- skills/<name>/` before adopting a refresh. The four
Mosoo-maintained skills are intentionally absent from the sync manifest so an
upstream refresh cannot erase project-specific guardrails.

## Adding a skill

1. Create `skills/<skill-name>/SKILL.md` with only `name` and `description`
   in YAML frontmatter.
2. Add the skill to the table above.
3. Record provenance and maintenance ownership in `SOURCES.md`.
4. Add only an unmodified upstream copy to the `SOURCES` array in
   `scripts/sync.sh`; keep adaptations out of that manifest.
5. Use kebab-case and keep the directory name aligned with `name`.
