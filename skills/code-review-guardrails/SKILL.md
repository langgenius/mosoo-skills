---
name: code-review-guardrails
description: Review skill that catches sub-optimal coding patterns, tech debt, and constraint violations. Use before committing changes, after completing a feature, or when reviewing another agent's work. Identifies hand-rolled code that duplicates library features, unsafe type casts, silent error handling, parallel truth sources, and violations of project ADRs.
---

# Code Review Guardrails

## Purpose

Catch the patterns that compile and pass lint but accumulate tech debt. This skill is derived from real mistakes found in this codebase — every check maps to an actual incident.

## When to Use

- Before committing: run this review on your staged changes
- After completing a feature: review the full diff against main
- When reviewing another agent's work
- When touching data-plane, schema, or infrastructure code

## Review Checklist

Work through each section. For every finding, state: the file, the line, what's wrong, and the fix.

### 1. Library Features vs Hand-Rolled Code

**Check**: For every custom utility, parser, or generator — does the library already provide this?

Red flags:

- Custom SQL string generators when the ORM has native support (e.g. Drizzle `pgPolicy`, `pgRole`, `enableRLS()`)
- Custom migration file parsers when `migrate()` exists
- Custom config loaders when the framework has built-in env support
- Custom HTTP/WebSocket wrappers when Fastify/Mercurius handle it
- Reimplemented retry logic, connection pooling, or health checks

**Action**: Read the library's docs for the specific feature before writing custom code. If the library provides it, use it. If not, document why the custom code is necessary.

### 2. Parallel Truth Sources

**Check**: Is the same fact defined in two places that can drift?

Red flags:

- A list of table names maintained separately from the schema definitions
- Event type strings duplicated between contracts and handlers
- Configuration defaults in both code and documentation
- Validation rules in both frontend and backend without a shared schema
- RLS/security policies maintained outside the schema that defines the tables

**Action**: Consolidate to one canonical source. Other consumers should derive from it, not duplicate it.

### 3. Unsafe Type Assertions

**Check**: Search for `as unknown as`, `as any`, and `as T` where T is a generic parameter.

Red flags:

- `tx as unknown as DbClient` — double cast hiding a type mismatch
- `JSON.parse(data) as T` — unsafe deserialization without validation
- `result as SomeType[]` — casting query results without checking shape
- Type assertions to bypass strict null checks instead of proper narrowing

**Action**: Fix the type system to not need the cast. If a cast is truly necessary, add a runtime validation (Zod parse, `instanceof` check, or type guard function) at the boundary.

### 4. Silent Error Handling

**Check**: Does the code silently swallow errors, return fallback values, or catch-and-ignore?

Red flags:

- `catch (e) { return []; }` — hides infrastructure failures as empty results
- `try { ... } catch { }` — empty catch block
- Default values that mask configuration errors (e.g., `port || "6379"`)
- `if (!result) return null` without logging or distinguishing error from empty

**Action**: Fail fast on business invariants. Log infrastructure errors. Only use fallbacks when the fallback behavior is explicitly documented and tested.

### 5. Test Quality

**Check**: Do tests exercise real behavior or just compile-time types?

Red flags:

- Tests that only verify `typeof x === "function"` or `expect(obj).toBeDefined()`
- Integration tests that don't touch real infrastructure (mocked DB for RLS tests)
- `describe.skip` or `it.todo` without a tracking issue
- Tests that pass with empty implementations (testing the mock, not the code)
- Data-plane code without integration tests against real PostgreSQL/Valkey

**Action**: Every data-plane package needs `*.integration.test.ts` files that run against real services. Contract packages need type-level tests. Application packages need API-level tests.

### 6. Dependency Governance

**Check**: Are new dependencies approved and properly declared?

Red flags:

- Dependencies not in root `package.json` allow-list
- GPL/LGPL/AGPL/SSPL/BSL licensed dependencies
- Pinned versions using `^` for beta/pre-release packages (should pin exact)
- Dependencies declared in the wrong package (e.g., test-utils depending on db creating a cycle)
- Circular workspace dependencies

**Action**: Check license before adding. Use exact pins for pre-release. Verify no circular deps with `turbo`.

### 7. Multi-Tenancy Violations

**Check**: Does every database operation respect tenant isolation?

Red flags:

- Queries without `withTenantContext` wrapper
- Direct SQL that bypasses RLS (outside admin/migration context)
- Tables with `tenantId` column but missing `...tenantPolicy()` in schema
- Tests that use superuser client for application-level queries
- Missing RLS integration tests for new tenant-scoped tables

**Action**: Every tenant-scoped query goes through `withTenantContext`. Every new table with `tenantId` gets `...tenantPolicy()`. New tables get RLS integration test coverage.

### 8. Commit Hygiene

**Check**: Are changes properly split by nature?

Red flags:

- Dependency upgrades mixed with feature code
- Refactoring mixed with behavior changes
- Documentation updates mixed with implementation
- Infrastructure changes mixed with business logic
- Commit messages that don't follow `type(scope): subject`

**Action**: Split into separate commits. Each commit should be one logical change that can be reviewed, reverted, or cherry-picked independently.

### 9. Architecture Boundary Violations

**Check**: Do imports respect the dependency rules from README.md?

Red flags:

- `packages/contracts/*` importing from `packages/data-plane/*` (contracts must be pure)
- `packages/platform/*` importing from `apps/*` (platform is consumed by apps, not the reverse)
- Runtime-plane code importing control-plane internals (should consume SessionResolution contract)
- Bun-specific APIs (`import { SQL } from "bun"`) in packages that should be runtime-neutral
- `docs/harness/` or `docs/demo-prototype/` files committed to the main repo (separate git repos)

**Action**: Check the dependency graph in README.md. If a cross-boundary import is needed, the shared type should move to `packages/contracts/`.

### 10. Operational Readiness

**Check**: Does new I/O code have observability?

Red flags:

- Database queries without `withSpan` tracing
- New services without health check endpoints
- Error paths without structured logging
- Missing `just check` / `just build` verification before committing
- Docker Compose changes not tested locally

**Action**: Every service has OTel spans for key operations (ADR-007). Every error path logs with context. Run `just check` after every change, or the smallest package-level `bun run --filter <pkg> ...` command when the change is explicitly scoped.

## Output Format

After reviewing, produce a structured report:

```
## Review: [brief description of what was reviewed]

### Passed
- [list of checks that passed cleanly]

### Findings
1. **[Category]** `file:line` — [description of issue]
   Fix: [concrete fix]

2. ...

### Verdict
[PASS | PASS WITH NOTES | NEEDS CHANGES]
```

If verdict is PASS, the changes are ready to commit. If NEEDS CHANGES, list the blocking issues.
