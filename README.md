# mosoo-skills

Reusable skills for the Mosoo coding agents. Each skill lives under [`skills/`](./skills) as its own directory containing a `SKILL.md` (the entry point) and any supporting `references/`, scripts, or assets.

Skills are sourced from [`langgenius/groots@2b5315b`](https://github.com/langgenius/groots/tree/2b5315bf8925bc946c06ba30874322a84db1f187/.agents/skills).

## Skills

| Skill | Description |
| --- | --- |
| [agents-sdk](./skills/agents-sdk/SKILL.md) | Build AI agents on Cloudflare Workers using the Agents SDK. |
| [better-auth-best-practices](./skills/better-auth-best-practices/SKILL.md) | Integrating Better Auth — the comprehensive TypeScript authentication framework. |
| [better-auth-create-auth](./skills/better-auth-create-auth/SKILL.md) | Create auth layers in TypeScript/JavaScript apps using Better Auth. |
| [better-auth-email-and-password](./skills/better-auth-email-and-password/SKILL.md) | Guidance and enforcement rules for secure email + password auth with Better Auth. |
| [better-auth-security](./skills/better-auth-security/SKILL.md) | Cross-cutting Better Auth security: rate limiting, CSRF, session, trusted origins, secrets, OAuth, IP tracking, auditing. |
| [building-ai-agent-on-cloudflare](./skills/building-ai-agent-on-cloudflare/SKILL.md) | Build AI agents on Cloudflare with state, real-time WebSockets, scheduled tasks, tools, and chat. |
| [building-mcp-server-on-cloudflare](./skills/building-mcp-server-on-cloudflare/SKILL.md) | Build remote MCP (Model Context Protocol) servers on Cloudflare Workers with tools and OAuth. |
| [cloudflare](./skills/cloudflare/SKILL.md) | Comprehensive Cloudflare platform skill: Workers, Pages, KV/D1/R2, Workers AI, Vectorize, Agents SDK, networking, security, IaC. |
| [cloudflare-email-service](./skills/cloudflare-email-service/SKILL.md) | Send and receive transactional emails with Cloudflare Email Service (Email Sending + Email Routing). |
| [code-review-guardrails](./skills/code-review-guardrails/SKILL.md) | Catch sub-optimal coding patterns, tech debt, and constraint violations before commit/merge. |
| [codex-complexity-optimizer](./skills/codex-complexity-optimizer/SKILL.md) | Audit and improve code complexity, N+1 queries, repeated scans, and render-heavy React paths without changing behavior. |
| [durable-objects](./skills/durable-objects/SKILL.md) | Create and review Cloudflare Durable Objects (stateful coordination, RPC, SQLite, alarms, WebSockets). |
| [no-use-effect](./skills/no-use-effect/SKILL.md) | Enforce the no-`useEffect` rule when writing or reviewing React code. |
| [playwright-cli](./skills/playwright-cli/SKILL.md) | Automate browser interactions, test web pages, and work with Playwright tests. |
| [sandbox-sdk](./skills/sandbox-sdk/SKILL.md) | Build sandboxed applications for secure code execution (code interpreters, CI/CD, dev environments). |
| [typescript-expert](./skills/typescript-expert/SKILL.md) | TypeScript expert: strict type safety, boundary contracts, parser/admission design, monorepo diagnostics. |
| [typescript-style-guardrails](./skills/typescript-style-guardrails/SKILL.md) | Readability-first TypeScript/TSX style guardrails for strict codebases. |
| [web-perf](./skills/web-perf/SKILL.md) | Analyze web performance with Chrome DevTools MCP — Core Web Vitals, render-blocking, network chains, CLS. |
| [workers-best-practices](./skills/workers-best-practices/SKILL.md) | Review and author Cloudflare Workers code against production best practices. |
| [wrangler](./skills/wrangler/SKILL.md) | Cloudflare Workers CLI for deploying and managing Workers, KV, R2, D1, Vectorize, Hyperdrive, Workers AI, Containers, Queues, Workflows, Pipelines, and Secrets Store. |

## Layout

```
mosoo-skills/
├── README.md
└── skills/
    └── <skill-name>/
        ├── SKILL.md          # entry point — frontmatter `name` + `description`, then body
        └── references/       # optional supporting material
```

## Adding a new skill

1. Create `skills/<skill-name>/SKILL.md` with YAML frontmatter:
   ```markdown
   ---
   name: <skill-name>
   description: One-line summary that helps an agent decide whether to load this skill.
   ---
   ```
2. Add an entry to the **Skills** table above — link the skill name to its `SKILL.md`.
3. Keep skill names in `kebab-case` and match the directory name to the `name` frontmatter field.
