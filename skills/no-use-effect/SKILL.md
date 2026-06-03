---
name: no-use-effect
description: Enforce the no-useEffect rule when writing or reviewing React code. Use when editing React components, refactoring existing `useEffect` calls, adding lint guardrails for effects, or reviewing PRs that introduce `useEffect` "just in case". Prefer the five replacement patterns first and use a mount-only helper such as `useMountEffect` only for explicit external synchronization.
---

# No useEffect

## Overview

Avoid direct `useEffect` usage in React UI code by default.

Prefer these replacements first:

1. Derived state
2. Query/server-state libraries
3. Event handlers
4. Conditional mounting plus `useMountEffect`
5. `key`-driven remounts

## When To Use

- Writing new React or TSX components
- Refactoring an existing `useEffect`
- Adding or tightening lint rules around React effects
- Reviewing PRs that add `useEffect`
- Catching agent-generated `useEffect` added without a clear external sync reason

## Current Guidance

- Do not introduce new direct `useEffect` usage in UI code unless external synchronization is clearly required.
- If the repository provides a dedicated mount-only helper such as `useMountEffect`, prefer it over ad-hoc effect patterns.
- Legacy allowlists are migration scaffolding, not precedent.
- If an effect truly belongs to runtime synchronization, keep it in a narrowly named runtime/controller hook instead of a render-focused UI component.

## Anchors

- Repo policy: `AGENTS.md`

## Workflow

### 1. Classify the effect

Ask what the effect is actually doing:

- deriving state
- fetching data
- reacting to user intent
- synchronizing with an external system
- resetting local state for a new entity

### 2. Replace it with the right pattern

Use the five rules below.

### 3. Verify

For frontend work, run the affected checks:

```sh
bun run lint
bun run typecheck
```

Only run the commands relevant to the app or package you changed.

## The Escape Hatch: `useMountEffect`

Use `useMountEffect` only when the behavior is naturally:

- setup on mount
- cleanup on unmount

Good fits:

- focus and scroll setup
- browser or native API subscriptions
- IPC listeners
- third-party widget lifecycle wiring
- stable singleton subscriptions

Bad fits:

- deriving one piece of state from another
- fetch-then-set-state flows that should use Query
- event relays driven by "flag state"
- state reset choreography on ID changes

## Replacement Patterns

### Rule 1: Derive state, do not sync it

Bad smell:

```tsx
useEffect(() => {
  setFilteredProducts(products.filter((product) => product.inStock));
}, [products]);
```

Preferred:

```tsx
const filteredProducts = products.filter((product) => product.inStock);
```

Use this when local state only mirrors props or other state.

### Rule 2: Use Query or an existing server-state layer

Bad smell:

```tsx
useEffect(() => {
  fetchProduct(productId).then(setProduct);
}, [productId]);
```

Preferred:

```tsx
const { data: product } = useQuery({
  queryKey: ["product", productId],
  queryFn: () => fetchProduct(productId),
});
```

Prefer an existing shared data-loading pattern or add a server-state layer deliberately instead of effect-based fetching. Do not assume a query library is present unless the target app already uses one for that surface.

### Rule 3: Run user actions in handlers

Bad smell:

```tsx
useEffect(() => {
  if (liked) {
    void postLike();
    setLiked(false);
  }
}, [liked]);
```

Preferred:

```tsx
const handleLike = () => {
  void postLike();
};
```

Use this when state is only acting as a trigger flag.

### Rule 4: Conditional mount plus `useMountEffect`

Bad smell:

```tsx
useEffect(() => {
  if (!isReady) {
    return;
  }
  startPlayer();
}, [isReady]);
```

Preferred:

```tsx
function PlayerGate({ isReady }: { isReady: boolean }) {
  if (!isReady) {
    return <Loading />;
  }
  return <Player />;
}

function Player() {
  useMountEffect(() => {
    startPlayer();
  });
}
```

Use this for mount-only synchronization with external systems.

### Rule 5: Reset with `key`, not dependency choreography

Bad smell:

```tsx
useEffect(() => {
  loadVideo(videoId);
}, [videoId]);
```

Preferred:

```tsx
function VideoPlayerWrapper({ videoId }: { videoId: string }) {
  return <VideoPlayer key={videoId} videoId={videoId} />;
}

function VideoPlayer({ videoId }: { videoId: string }) {
  useMountEffect(() => {
    loadVideo(videoId);
  });
}
```

Use this when a component should behave like a fresh instance for each entity ID.

## Review Checklist

Before accepting any new effect-like code, check:

1. Can this be computed inline?
2. Should this be a Query/server-state concern?
3. Should this happen in the event handler that already knows the user's intent?
4. Is this truly mount/unmount external synchronization?
5. Is `key` the correct reset boundary?

## Origin

- React docs: `https://react.dev/learn/you-might-not-need-an-effect`
- Skill seed: `https://gist.github.com/alvinsng/5dd68c6ece355dbdbd65340ec2927b1d`
