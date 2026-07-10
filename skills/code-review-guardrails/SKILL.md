---
name: code-review-guardrails
description: Review Mosoo changes for project-rule, architecture, type-safety, data-scope, generated-source, observability, dependency, and verification violations. Use before committing, after completing a feature, or when reviewing another agent's diff, especially for API, GraphQL, D1, runtime, auth, UI, or infrastructure changes.
---

# Code Review Guardrails

Review the actual diff against the active checkout's rules. Read `AGENTS.md`,
`CONTRIBUTING.md`, the relevant PRD, and `docs/architecture.md` before treating
any checklist item as a repository requirement. Current project documents and
code are authoritative when this skill and the repository disagree.

For every finding, report the file and line, the evidence, the user or runtime
impact, and a concrete fix. Do not report a generic best practice as a blocker.

## 1. Existing Platform Capabilities

Check whether a change reimplements a capability already provided by the
current stack:

- Cloudflare D1 and Drizzle for database access and schema management
- Hono for HTTP routing and middleware
- GraphQL Yoga and the repository GraphQL module specs for GraphQL behavior
- Cloudflare bindings and primitives for Durable Objects, Containers, R2,
  Queues, email, and scheduled work
- existing Mosoo services, contracts, parsers, and generated clients

Custom code is acceptable when the existing surface does not meet the need.
Require evidence for the gap and keep the custom boundary small.

## 2. Canonical And Generated Sources

Look for parallel truth sources or manual edits to generated output.

- GraphQL fields and types originate in
  `apps/api/src/adapters/graphql/graphql-module-specs.ts`; runtime resolvers live
  in module GraphQL adapters.
- Web GraphQL operations use the generated typed client. Do not introduce a
  parallel handwritten request layer.
- `apps/api/src/adapters/graphql/schema.generated.graphql` and
  `apps/web/src/gql/**` are generated.
- D1 schema source lives in `pkgs/db/src/schema/**`; `pkgs/db/drizzle/**` is the
  generated baseline or migration output.
- Cross-boundary payloads belong in an existing `pkgs/contracts` surface only
  when they truly cross application or package boundaries.

Fix the source and regenerate. Do not patch generated files to hide drift.

## 3. Type And Boundary Safety

Search for `any`, `as unknown as`, unsafe generic assertions, unchecked
deserialization, and exported complex inline types.

- Parse untrusted input at the boundary with the repository's existing parser
  or schema approach.
- Narrow nullable and union values instead of asserting them away.
- Keep runtime-specific APIs inside their platform boundary.
- Keep shared packages runtime-neutral and use their public exports.

Allow a type assertion only when the runtime invariant is demonstrated and the
assertion is narrower than the alternatives.

## 4. Errors And Invariants

Flag broad catch-and-ignore behavior, empty catches, silent fallback values,
and placeholder defaults that turn configuration or infrastructure failure into
valid-looking data.

- Required business values and secrets fail fast.
- Infrastructure errors retain useful context in structured logs.
- Empty results remain distinguishable from failed reads.
- Recovery behavior is explicit and tested when it changes user-visible state.

## 5. Verification Quality

Match verification to risk instead of requiring one test shape everywhere.

- Pure logic: focused unit tests.
- Package or adapter behavior: `just test-package <package>` or
  `just test-file <path>`.
- API behavior: focused API integration tests.
- User-visible or cross-runtime behavior: the relevant E2E or manual flow.

Flag assertions that only prove a symbol exists, skipped coverage without a
tracked reason, and tests that exercise a mock instead of the changed behavior.

## 6. Dependencies

For each new dependency, ask whether an existing workspace package or a small
local implementation already covers the need.

- Declare dependencies in the package that imports them.
- Commit intentional `bun.lock` changes and exclude install-only churn.
- Avoid circular workspace dependencies and platform leakage.
- Prefer lightweight typed clients over large vendor SDKs when the integration
  surface is small.

Treat licensing, security, and version policy as evidence-based checks against
the dependency and current repository rules, not a fixed blacklist in this
skill.

## 7. App Ownership And Data Scope

Check every App-owned or user-owned read and write at the ingress and service
boundary.

- Prove the caller may access the App, Organization shell, Agent, Session,
  Credential, File, or other scoped resource.
- Carry the real scope identifier into explicit D1 queries.
- Do not bypass domain services for control-plane operations.
- Fail closed when ownership cannot be established.
- Add focused cross-scope denial coverage for new sensitive access paths.

Do not invent a universal database wrapper or policy mechanism that the current
Mosoo architecture does not use.

## 8. Commit Hygiene

- Keep the commit a coherent, reviewable change.
- Use `type(scope): subject` Conventional Commit syntax.
- Use a real human author and committer identity; reject agent or bot identity
  names and trailers.
- Do not mix unrelated dependency upgrades, generated churn, or cleanup into
  the feature.

Use `just commit-check` when reviewing commit metadata against the repository
base.

## 9. Architecture Boundaries

Use current documents and directory ownership, not memorized paths.

- `apps/api`: Cloudflare Worker API, domain services, GraphQL, auth, and runtime
  control plane
- `apps/web`: React console and generated API consumers
- `apps/driver`: runtime driver and Sandbox container boundary
- `pkgs/contracts`: true cross-boundary contracts
- `pkgs/*`: focused shared packages that remain runtime-neutral unless their
  package boundary explicitly says otherwise

Flag imports that reverse these ownership directions or leak application
internals across boundaries. When a core noun or ownership boundary changes,
update the active documentation anchor rather than creating an adapter that
preserves two meanings.

## 10. Operational Readiness

New I/O and failure paths need evidence that operators can understand them.

- Use `@mosoo/observability` and its Vestig structured logger, wide events, and
  W3C trace context instead of creating a parallel logging stack.
- Preserve Cloudflare native `[observability.logs]` and
  `[observability.traces]` configuration where applicable.
- Keep API health checks on `/api/health`.
- Include contextual structured logs for actionable failure paths.
- Verify the smallest affected scope first:
  - docs: `just fmt-check-path <path>`
  - TypeScript: `just tc-package <package>`
  - tests: `just test-package <package>` or `just test-file <path>`
  - GraphQL changes: `just graphql-codegen`
  - D1 schema changes: `just db-regen`, then `just db-migrate` when applying the
    local baseline
  - broad or cross-boundary changes: `just check`

Do not claim performance, availability, or runtime health without measurements,
logs, traces, or a reproducible smoke.

## Output

```markdown
## Review: <scope>

### Passed
- <material checks that passed>

### Findings
1. **<category>** `path:line` — <evidence and impact>
   Fix: <concrete change>

### Verification gaps
- <required evidence that was not run or observed>

### Verdict
PASS | PASS WITH NOTES | NEEDS CHANGES
```

Use `NEEDS CHANGES` only for findings that violate current project rules,
correctness, security, data integrity, or an explicit acceptance criterion.
