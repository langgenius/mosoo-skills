---
name: sandbox-sdk
description: Build or review Cloudflare Sandbox SDK integrations using repository evidence and current official documentation. Use for secure code execution, agent runtimes, container-backed tools, Wrangler bindings, Dockerfiles, preview services, or Sandbox lifecycle work, especially in an existing project whose package manager, Wrangler format, and image versions must be preserved.
---

# Cloudflare Sandbox SDK

Treat Sandbox SDK configuration and APIs as version-sensitive. Inspect the
repository first, then retrieve the current Cloudflare documentation for the
specific operation. Existing project conventions take precedence over generic
examples.

## Current Sources

- [Sandbox documentation](https://developers.cloudflare.com/sandbox/)
- [Getting started](https://developers.cloudflare.com/sandbox/get-started/)
- [Dockerfile reference](https://developers.cloudflare.com/sandbox/configuration/dockerfile/)
- [API reference](https://developers.cloudflare.com/sandbox/api/)
- [Official examples](https://github.com/cloudflare/sandbox-sdk/tree/main/examples)
- [Wrangler configuration](https://developers.cloudflare.com/workers/wrangler/configuration/)

Fetch the relevant page or example before changing code. Do not assume a
remembered method signature, image tag, configuration format, or preview URL
requirement is still current.

## 1. Inspect Before Editing

Read the active repository's `AGENTS.md` and contribution rules, then locate:

- the package manager and lockfile;
- every manifest that declares `@cloudflare/sandbox`;
- every Dockerfile based on `cloudflare/sandbox`;
- existing `wrangler.toml`, `wrangler.json`, or `wrangler.jsonc` files;
- the Worker entry point, Sandbox binding, Durable Object migration, and
  container configuration;
- repository-specific build, typecheck, test, and local runtime commands.

Useful evidence searches:

```bash
rg --files -g 'package.json' -g 'bun.lock' -g 'package-lock.json' \
  -g 'pnpm-lock.yaml' -g 'yarn.lock' -g 'Dockerfile*' \
  -g 'wrangler.toml' -g 'wrangler.json' -g 'wrangler.jsonc'
rg -n '"@cloudflare/sandbox"|FROM .*cloudflare/sandbox' .
```

If package and image versions disagree, report the mismatch and stop before
choosing a version. Do not silently treat either file as newer or correct.

## 2. Preserve The Existing Project

- Keep an existing Wrangler file in its current TOML, JSON, or JSONC format.
- Merge the required container, Durable Object binding, and migration into the
  existing configuration; do not replace unrelated routes, bindings,
  environments, observability, or compatibility settings.
- Reuse the repository's package manager. Add `@cloudflare/sandbox` only when
  it is absent and the requested feature needs it.
- Reuse existing class and binding names unless a product requirement calls for
  a new Sandbox boundary.
- Follow current repository commands instead of substituting generic npm or
  Wrangler commands.

For a new project with no established format, follow the current Cloudflare
getting-started guide. A new-project recommendation is not a migration mandate
for an existing project.

## 3. Required Configuration Shape

A Sandbox integration normally needs these three concepts. Merge their
equivalents into the existing Wrangler format and environment structure:

```toml
# Illustrative TOML only. Preserve the active project's format and names.
[[containers]]
class_name = "Sandbox"
image = "./Dockerfile"
instance_type = "lite"
max_instances = 1

[[durable_objects.bindings]]
name = "Sandbox"
class_name = "Sandbox"

[[migrations]]
tag = "v1"
new_sqlite_classes = ["Sandbox"]
```

Do not duplicate an existing binding or migration. Production environments may
need their own container settings because Wrangler named environments do not
inherit every top-level field.

The Worker must expose the Sandbox class required by the installed SDK version.
Confirm the current export and binding pattern in official docs and the
repository before editing:

```ts
import { getSandbox } from "@cloudflare/sandbox";
export { Sandbox } from "@cloudflare/sandbox";
```

## 4. Keep Package And Image Versions Aligned

Cloudflare requires the Docker base image version to match the installed
`@cloudflare/sandbox` package version. Derive the version from repository
evidence and confirm the rule in the current Dockerfile documentation.

Do not copy a numeric image tag from this skill. Check the available image
variants before choosing one:

- the default image is lean and intended for JavaScript or TypeScript;
- use the `-python` variant when Python and its data tooling are required;
- use another documented variant only when the requested runtime needs it.

Keep the image lean and make any base-image change explicit in the diff. If the
repository intentionally pins package and image versions, update both in the
same coherent change and validate the resulting lockfile.

## 5. Use Version-Verified APIs

Common capabilities include obtaining a Sandbox by stable ID, executing
commands, managing files, running code contexts, exposing services, and
destroying temporary Sandboxes. Retrieve current signatures before use.

General lifecycle rules:

- derive Sandbox IDs from the real user, session, or workload boundary;
- do not share a hardcoded ID across tenants or concurrent workloads;
- distinguish command failure from transport or container-start failure;
- destroy temporary Sandboxes, but do not destroy persistent session state as
  generic cleanup;
- make retries idempotent and observable.

Preview and port APIs change over time. Verify the current `exposePort` and
request-proxy pattern in official docs and examples. For local Wrangler
development, declare each port the container actually exposes; do not add a
fixed port merely because an example used it.

## 6. Verification

Use the repository's own commands and progress from static to runtime evidence:

1. Validate Wrangler syntax and generated binding types.
2. Run the affected package typecheck and focused tests.
3. Confirm the package version and Docker base image version match.
4. When local container behavior is in scope, prove the supported Docker daemon
   is healthy before starting Wrangler.
5. Start a Sandbox operation that exercises the changed path; a Worker health
   response alone does not prove the container starts.
6. Inspect Worker and container logs for startup, proxy, and cleanup failures.
7. For exposed services, verify both the process inside the Sandbox and the
   external request path.

Do not claim Sandbox health from configuration review alone.

## Anti-patterns

- creating a new Wrangler file when the project already has one;
- replacing the complete Wrangler configuration with a minimal example;
- hardcoding an image version without checking the package and Dockerfile;
- assuming the default image includes Python;
- installing with a different package manager than the repository uses;
- using internal clients when the public Sandbox surface covers the operation;
- skipping cleanup for truly temporary Sandboxes;
- debugging application code before proving the local container backend works.

## Supplemental Local References

The bundled [API quick reference](references/api-quick-ref.md) and
[example index](references/examples.md) are navigation aids. Treat their
signatures as snapshots and confirm them against the current official sources
before implementation.
