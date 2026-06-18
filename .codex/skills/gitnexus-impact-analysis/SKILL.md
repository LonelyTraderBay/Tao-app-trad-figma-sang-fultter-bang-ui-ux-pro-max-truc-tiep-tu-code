---
name: gitnexus-impact-analysis
description: "Run GitNexus blast-radius and safety analysis before code changes. Use when the user asks what depends on something, what will break, whether a change is safe, or what current git changes affect."
---

# Impact Analysis With GitNexus

Use impact analysis before non-trivial edits, public API changes, router changes,
shared utility changes, and pre-commit reviews.

## Workflow

1. Use `impact({target: "<symbol>", direction: "upstream"})` to find dependents.
2. Review depth 1 first; direct callers/importers are most likely to break.
3. Read affected source files for high-risk or ambiguous results.
4. Use `detect_changes({scope: "all"})` before committing or summarizing changed scope.
5. Report risk with concrete files, flows, and test recommendations.

If the index is stale, run:

```bash
node .gitnexus/run.cjs analyze --skip-agents-md --skip-skills
```

## Direction

| Direction | Meaning |
| --- | --- |
| `upstream` | What depends on this symbol. |
| `downstream` | What this symbol depends on. |

## Depth Meaning

| Depth | Meaning |
| --- | --- |
| `d=1` | Direct callers/importers; treat as will-break review scope. |
| `d=2` | Indirect dependents; likely affected. |
| `d=3` | Transitive dependents; test selectively. |

## Example Calls

```text
impact({
  target: "createAppRouter",
  direction: "upstream",
  minConfidence: 0.8,
  maxDepth: 3
})

detect_changes({scope: "all"})
```

For very broad shared symbols, start with `summaryOnly: true`, then page into
depths with `limit` and `offset`.
