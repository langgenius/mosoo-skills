# mosoo-skills

Reusable skills for the Mosoo coding agents. Each skill lives under [`skills/`](./skills) as its own directory containing a `SKILL.md` (the entry point) and any supporting `references/`, scripts, or assets.

Skill provenance and refresh commands are tracked in [`SOURCES.md`](./SOURCES.md). One of the 20 skills is an unmodified public-upstream copy refreshed by `scripts/sync.sh`; the remaining 19 are Mosoo-maintained originals or adaptations and must be edited in place.

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
| [no-use-effect](./skills/no-use-effect/SKILL.md) | Avoid unnecessary React effects while using `useEffect` for real external synchronization. |
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
├── SOURCES.md            # upstream provenance and maintenance path per skill
├── scripts/
│   ├── sync.sh           # refresh the unmodified upstream copy
│   └── validate-relative-links.py # reject broken packaged Markdown links
└── skills/
    └── <skill-name>/
        ├── SKILL.md          # entry point — frontmatter `name` + `description`, then body
        └── references/       # optional supporting material
```

## Updating skills

Run the relative commands below from the `mosoo-skills` repository root. If invoking the sync script from another directory, call it by its absolute path and use `git -C /absolute/path/to/mosoo-skills diff -- skills/<name>/` to review the result.

```bash
# One unmodified upstream copy (see SOURCES.md for its ref)
scripts/sync.sh                   # refresh it
scripts/sync.sh complexity-optimizer
```

The 19 Mosoo-maintained skills are listed in `SOURCES.md`. They are intentionally absent from the sync manifest so an upstream refresh cannot overwrite Mosoo-specific project-first guidance. Review `git diff -- skills/<name>/` before committing any refresh or local edit.

Validate packaged Markdown links after a refresh or documentation edit:

```bash
python3 scripts/validate-relative-links.py
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
3. Record the maintenance path and provenance in [`SOURCES.md`](./SOURCES.md). Add only an unmodified upstream copy to the `SOURCES` array in `scripts/sync.sh`. A Mosoo-specific adaptation must instead be listed as Mosoo-maintained and remain absent from the sync manifest.
4. Keep skill names in `kebab-case` and match the directory name to the `name` frontmatter field where practical.
