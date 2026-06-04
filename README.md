# mosoo-skills

Reusable skills for the Mosoo coding agents. Each skill lives under [`skills/`](./skills) as its own directory containing a `SKILL.md` (the entry point) and any supporting `references/`, scripts, or assets.

Skill provenance and refresh commands are tracked in [`SOURCES.md`](./SOURCES.md). 12 of the 20 skills are managed by the [`skills`](https://github.com/vercel-labs/skills) CLI (run `npx skills check` / `npx skills update`); the other 8 are refreshed by `scripts/sync-local.sh`.

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
| [complexity-optimizer](./skills/complexity-optimizer/SKILL.md) | Audit and improve code complexity, N+1 queries, repeated scans, and render-heavy paths without changing behavior. |
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
├── SOURCES.md            # upstream provenance per skill
├── package.json          # consumed by the skills CLI
├── skills-lock.json      # CLI-tracked skill versions + content hashes
├── scripts/
│   └── sync-local.sh     # refresh the 8 non-CLI-managed skills
└── skills/
    └── <skill-name>/
        ├── SKILL.md          # entry point — frontmatter `name` + `description`, then body
        └── references/       # optional supporting material
```

## Updating skills

```bash
# 12 CLI-tracked skills
npx skills check          # show drift from upstream
npx skills update         # apply pending updates, rewrites skills/<name>/ + skills-lock.json

# 8 locally-maintained skills (EpicenterHQ, removed-upstream snapshots, groots-internal)
scripts/sync-local.sh                   # refresh all
scripts/sync-local.sh <skill-name>      # refresh one
```

Review the resulting `git diff` before committing — upstream changes are not auto-accepted.

## Adding a new skill

1. Create `skills/<skill-name>/SKILL.md` with YAML frontmatter:
   ```markdown
   ---
   name: <skill-name>
   description: One-line summary that helps an agent decide whether to load this skill.
   ---
   ```
2. Add an entry to the **Skills** table above — link the skill name to its `SKILL.md`.
3. Record the upstream in [`SOURCES.md`](./SOURCES.md). If it ships in a repo the [`skills` CLI](https://github.com/vercel-labs/skills) can read, also run `npx skills add <owner/repo> --skill <skill-name> --copy -y` from the repo root so it lands in `skills-lock.json`.
4. Keep skill names in `kebab-case` and match the directory name to the `name` frontmatter field where practical.
