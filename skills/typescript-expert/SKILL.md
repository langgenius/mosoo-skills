---
name: typescript-expert
description: Groots-focused TypeScript expert for strict type safety, boundary contracts, parser/admission design, monorepo diagnostics, and validation commands. Use when fixing TypeScript errors, reviewing type-heavy code, adding shared contracts, changing GraphQL/runtime payloads, or untangling assert-style guard functions.
---

# TypeScript Expert

## Purpose

Apply senior TypeScript judgment inside the Groots monorepo. This skill is adapted from the community `typescript-expert` skill, but the project rules in `AGENTS.md`, `docs/architecture.md`, and existing `.agents/skills/typescript-style-guardrails` take precedence.

Use this skill to make TypeScript code easier to prove correct, not more clever. Prefer explicit contracts, runtime validation at boundaries, and repository scripts over generic TypeScript recipes.

## Working Mode

1. Read the local context first: the touched files, nearest package `package.json`, relevant `tsconfig.json`, and any `docs/` architecture or PRD document that defines the boundary.
2. Identify the problem class before editing:
   - boundary contract, DTO, GraphQL schema, runtime payload, or external input
   - application service and authorization policy
   - package/module layering or import surface
   - React/TSX view model and generated GraphQL types
   - compiler, monorepo, or tooling diagnostics
3. Prefer the repo's commands and existing tools:
   - `bun run tc` for workspace typecheck
   - `bun run lint` for workspace lint rules
   - `bun run graphql:codegen` after GraphQL schema, scalar, query, mutation, or fragment changes
   - `just build` after code changes in this repo unless the user explicitly narrows verification
4. Explain any unverified claim. TypeScript, lint, build, package version, and generated-file facts must come from commands or file references.

## Groots Type Safety Rules

- Do not introduce `any`. Use `unknown`, named contracts, type predicates, schema validation, or narrower generics.
- Avoid `as unknown as`. A double cast at a boundary usually means the parser is missing or the contract belongs in `packages/contracts`.
- Keep exported function parameters and return values readable. Extract dense utility types into named semantic types.
- Shared contracts, runtime payloads, cross-package schemas, and public DTOs belong in a shared package only when they cross a real boundary. Keep module-local view models local.
- Use `null` only when a DB column, JSON/RPC payload, GraphQL schema, or domain state intentionally distinguishes present-empty from omitted.
- Prefer `satisfies` for literal object conformance when it preserves useful inference without widening the value.
- Use discriminated unions for typed outcomes when callers need to branch; use typed errors for exceptional control-flow that must map to API responses.
- Runtime-neutral packages must not import Node-only, browser-only, Worker-only, or app-local implementation details.

## Assert Function Review

Treat `assert*` as a high-risk naming signal. Review these functions especially carefully.

Acceptable `assert*` functions are narrow:

- validate a local invariant or untrusted input shape
- do not perform DB reads, writes, network calls, or cross-module authorization
- either return a fully validated value or throw a typed, intentionally mapped error
- avoid partial checks followed by broad casts

Rename or split `assert*` functions when they actually do more:

- DB lookup plus policy decision -> `ensure*Access`, `authorize*`, `admit*`, or a dedicated policy/admission service
- JSON parsing or protocol decoding -> `parse*` / `decode*` returning a validated contract
- business state transition rule -> domain policy function with a typed domain error
- GraphQL or HTTP error mapping -> adapter-layer error translation, not hidden inside a guard

When reviewing an assert-style function, check:

1. What boundary is being protected?
2. Is the validation complete for the returned type?
3. Is the thrown error mapped consistently by GraphQL, HTTP, public API, and audit paths?
4. Could a direct service caller bypass the intended policy order?
5. Is there a focused regression at the service entrypoint, not just a UI or workflow test?

## Boundary Patterns

### Untrusted JSON or Protocol Payload

Use a real parser or schema at the edge. A good parser should consume `unknown`, validate the complete shape needed by downstream code, and return a named contract.

```ts
interface RuntimeEventEnvelope {
  readonly runId: string;
  readonly type: "started" | "finished";
}

function parseRuntimeEventEnvelope(value: unknown): RuntimeEventEnvelope {
  if (!value || typeof value !== "object" || Array.isArray(value)) {
    throw new Error("Runtime event envelope must be an object.");
  }

  const record = value as Record<string, unknown>;
  if (typeof record.runId !== "string") {
    throw new Error("Runtime event envelope runId is required.");
  }
  if (record.type !== "started" && record.type !== "finished") {
    throw new Error("Runtime event envelope type is unsupported.");
  }

  return {
    runId: record.runId,
    type: record.type,
  };
}
```

### Authorization or Admission

Authorization should name the resource, actor, required permission, and returned access context. Do not hide it behind a generic `assert`.

```ts
interface AgentAdmission {
  readonly agentId: string;
  readonly organizationId: string;
  readonly viewerRole: "owner" | "admin" | "editor";
}

async function admitAgentEditor(input: {
  readonly agentId: string;
  readonly database: D1Database;
  readonly viewerId: string;
}): Promise<AgentAdmission> {
  // Load the canonical row and enforce the policy here.
  // Return the access context that downstream code needs.
  throw new Error("Example only.");
}
```

### Generated GraphQL Types

- Do not hand-edit `apps/api/src/adapters/graphql/schema.generated.graphql` or `apps/web/src/gql/**`.
- Change the source schema/resolver/document first, then run `bun run graphql:codegen`.
- If generated types expose drift, fix the source contract rather than patching generated output.

## Diagnostics

Use the smallest command that proves the change:

- Type error only: `bun run tc` or the package's `tc` script if available.
- No-new-any concern: `bun run lint`.
- Script or architecture rule changes: run the owning package check or the nearest root validation command.
- GraphQL schema/query changes: `bun run graphql:codegen`, then typecheck.
- Code changes in Groots: `just build` as the default final gate.

Avoid generic `npx tsc --noEmit` unless the repo has no better script. Do not start watch or dev-server processes for validation unless the task is specifically about runtime behavior.

## Review Checklist

- Are public types named by domain meaning rather than by TypeScript mechanics?
- Did the change avoid new `any`, double casts, and unsupported fallbacks?
- Is every boundary parser complete for the type it returns?
- Are permission failures represented as explicit denied/forbidden outcomes where the adapter can map them?
- Is package ownership respected, especially `packages/contracts`, app-local modules, and runtime-neutral packages?
- Did GraphQL or DB schema changes run their required generation/migration checks?
- Did the final response report verification run, skipped checks, and the next minimum check?
