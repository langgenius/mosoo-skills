---
name: no-use-effect
description: Avoid unnecessary React effects in Mosoo while using React useEffect directly for real external synchronization. Use when writing or reviewing React components, refactoring effect-driven derived state or event relays, handling subscriptions and browser APIs, or validating web changes with Mosoo's focused Justfile commands.
---

# Avoid Unnecessary useEffect

Prefer render-time derivation, event handlers, the existing query layer, and
component identity over effect choreography. Use React `useEffect` directly
when a component must synchronize with a system outside React.

## Decision Table

| Need | Prefer |
| --- | --- |
| Derive a value from props or state | Compute during render |
| Perform work caused by a user action | Run it in the event handler |
| Read or mutate server data | Use the existing generated API/query layer |
| Reset a subtree for a different entity | Give the subtree a different `key` |
| Subscribe to or control an external system | Use `useEffect` with cleanup and complete dependencies |

## Workflow

1. State what external system, if any, the component must synchronize with.
2. If there is none, move the work to render, an event handler, the query
   layer, or component identity.
3. If there is one, keep the effect narrow, declare every reactive dependency,
   and return cleanup when setup creates a resource or subscription.
4. Verify the affected web package with the repository's focused commands.

## 1. Derive During Render

Do not store a value that can be calculated from current props or state.

```tsx
// Avoid: an extra render and a temporarily stale value.
const [visibleItems, setVisibleItems] = useState<Item[]>([]);
useEffect(() => {
  setVisibleItems(items.filter((item) => item.visible));
}, [items]);

// Prefer: one source of truth.
const visibleItems = items.filter((item) => item.visible);
```

Use `useMemo` only when the calculation is measurably expensive or stable
identity is required by a consumer. It is not a replacement for every effect.

## 2. Keep User Actions In Event Handlers

Do not turn state into a command queue for an effect.

```tsx
// Avoid: click -> flag -> effect -> reset flag.
const [shouldSave, setShouldSave] = useState(false);
useEffect(() => {
  if (!shouldSave) return;
  void saveDraft();
  setShouldSave(false);
}, [shouldSave]);

// Prefer: the event owns the action.
function handleSave() {
  void saveDraft();
}
```

If multiple callers need the action, extract a normal function or mutation
hook. Do not route it through render state.

## 3. Use The Existing Data Layer

Avoid ad hoc fetch effects that recreate cancellation, caching, retry, loading,
and stale-data behavior. Use Mosoo's generated GraphQL access and existing
TanStack Query patterns when they fit the boundary.

Keep request parameters in the query key or mutation input. Handle
user-triggered mutations from the event that caused them.

## 4. Synchronize External Systems Directly

Effects are appropriate for browser APIs, timers, sockets, subscriptions,
third-party widgets, DOM integration, and other resources whose lifecycle must
follow the mounted component.

```tsx
useEffect(() => {
  const unsubscribe = sessionStream.subscribe(sessionId, handleEvent);
  return unsubscribe;
}, [sessionId, handleEvent, sessionStream]);
```

Requirements for a necessary effect:

- setup and cleanup are safe under React Strict Mode's development replay;
- every reactive value used by the effect is represented in its dependency
  list;
- callbacks or objects are stabilized only when their identity is part of the
  external subscription contract;
- cleanup releases listeners, timers, observers, sockets, or pending work;
- the effect does not also mirror derived state or relay a user action.

Do not hide dependencies behind a mount-only wrapper. If synchronization is
truly mount-scoped, the direct effect and its cleanup should make that contract
visible.

## 5. Reset With Component Identity

When a component should behave as a new instance for a different entity, put
the identity in a parent `key` instead of resetting several state values in an
effect.

```tsx
function AgentEditorRoute({ agentId }: { agentId: string }) {
  return <AgentEditor key={agentId} agentId={agentId} />;
}
```

Use this only when a full local subtree reset is the intended user experience.
Preserve state explicitly when users expect drafts or selections to survive an
identity change.

## Review Questions

- What external system requires synchronization?
- Could the value be computed during render?
- Did a user event already provide the correct execution boundary?
- Does the existing query or mutation layer own this request?
- Would a `key` express the intended reset more directly?
- For a necessary effect, are dependencies, cleanup, and replay safety clear?

## Verification

Run from the Mosoo repository root:

```bash
just tc-package @mosoo/web
just test-package @mosoo/web
```

Use `just test-file <path>` when one focused test proves the behavior. Add a
browser or manual flow when the effect changes a user-visible lifecycle such as
reconnection, notifications, autosave, or navigation.
