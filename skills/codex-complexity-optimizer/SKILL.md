---
name: codex-complexity-optimizer
description: Use when Codex needs to audit or improve code complexity, algorithmic cost, repeated scans/lookups, N+1 queries, render-heavy React paths, or other safe performance optimizations without changing behavior. Also use for Groots timer-agent complexity-optimizer lane runs that need before/after complexity estimates, risk ratings, and required verification.
---

# Codex Complexity Optimizer

## Purpose

Find bounded complexity problems and turn only the safe, evidence-backed ones
into small fixes. Prefer one proven hot path over a broad repo sweep.

## Required Context

Before scanning, read the local ownership and boundary docs for the touched
area. In Groots, start with:

- `AGENTS.md`
- `docs/architecture.md`
- `docs/quality/entropy-ledger.md` when running from a timer lane
- the nearest package `package.json`, tests, and existing module docs

## Scan Rules

1. Choose one scope: a changed feature area, one timer lane target, one large
   file, one route, one service, or one render path.
2. Produce at most five findings, ranked by risk and expected impact.
3. For each finding, write the current complexity, proposed complexity,
   behavior invariant, risk rating, and verification command before editing.
4. Optimize only when behavior can be preserved and verified with a focused
   test, existing regression, contract check, or unchanged snapshot.
5. Do not micro-optimize cold paths, style-only code, setup scripts, or small
   collections unless there is evidence the path is hot or repeated.

## Signals To Inspect

Use targeted searches, then inspect the surrounding code before judging.

```bash
rg -n "for \\(|for .* of|while \\(|\\.map\\(|\\.filter\\(|\\.find\\(|\\.some\\(|\\.reduce\\(" apps packages --glob "*.{ts,tsx}"
rg -n "await .*\\.(select|execute|all|run|get)|\\.prepare\\(" apps packages --glob "*.{ts,tsx}"
rg -n "useMemo|useCallback|memo\\(|\\.map\\(" apps/web/src --glob "*.tsx"
```

Treat these commands as leads, not findings. A loop or `map` is normal until
the surrounding data flow shows repeated scans, nested work, unbounded input, or
avoidable rendering.

## First-Pass Scanner

Use the bundled scanner for a broad first pass, then manually inspect a small
bounded scope before treating output as evidence:

```bash
python3 .agents/skills/codex-complexity-optimizer/scripts/analyze_complexity.py . --format markdown --exclude .agents
python3 .agents/skills/codex-complexity-optimizer/scripts/analyze_complexity.py . --format json --exclude .agents
```

The scanner intentionally favors recall over precision. Do not patch every
warning; use it to choose one testable hotspot.

## Optimization Patterns

- Replace repeated `array.find` / `array.some` inside a loop with a `Map` or
  `Set` only when key equality, duplicate handling, and ordering are explicit.
- Replace O(n*m) joins across two in-memory collections with an indexed lookup
  when the collections can grow with tenant or user data.
- Batch DB reads only when authorization, tenant scope, pagination, ordering,
  and empty-result behavior stay identical.
- Memoize React derivations only when inputs are stable and stale closures are
  impossible; do not hide state modeling problems behind memoization.
- Split render-heavy components when it reduces repeated expensive derivations
  or isolates high-frequency state updates.
- Prefer parser or query-shape fixes over caches that can mask stale data or
  permission bugs.

## N+1 Review Checklist

Before changing a DB path, answer:

- Which loop or resolver issues the repeated query?
- What is the input cardinality and tenant boundary?
- Does batching preserve access checks for every resource?
- Does the new query preserve ordering, pagination, limits, and null handling?
- Which test fails if one resource is unauthorized, missing, or duplicated?

## Output Format

```markdown
## Complexity Findings

| Risk | Path | Current cost | Proposed cost | Evidence | Verification |
|---|---|---|---|---|---|
| high/medium/low | file:line | O(...) | O(...) | command or code fact | test/check |

## Proposed Fix

- Behavior invariant:
- Safety risk:
- Required verification:
- Rollback / no-op plan:
```

If no safe optimization exists, report `no PR` with the best next focused scan.

## References

- Read `references/optimization-playbook.md` for common O(n*m) to O(n+m)
  transformations and framework-specific review checks.
- Read `references/report-template.md` when preparing a standalone complexity
  audit report.
