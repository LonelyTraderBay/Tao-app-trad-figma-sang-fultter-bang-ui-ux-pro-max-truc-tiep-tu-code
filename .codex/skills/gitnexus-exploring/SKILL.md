---
name: gitnexus-exploring
description: "Explore codebases with GitNexus. Use when the user asks how a feature works, where logic lives, what calls a symbol, what the architecture looks like, or wants to understand unfamiliar code before changing it."
---

# Exploring With GitNexus

Start with the graph for orientation, then read source files for implementation
details.

## Workflow

1. Use `list_repos` to confirm the indexed repository when needed.
2. Read `gitnexus://repo/{name}/context` to check freshness and repo stats.
3. Use `query({query: "<concept>"})` to find related execution flows.
4. Use `context({name: "<symbol>"})` for callers, callees, imports, and processes.
5. Read `gitnexus://repo/{name}/process/{processName}` for full flow traces.
6. Read the actual files before giving final conclusions.

If the index is stale, run:

```bash
node .gitnexus/run.cjs analyze
```

## Useful Resources

| Resource | Purpose |
| --- | --- |
| `gitnexus://repo/{name}/context` | Repo overview and staleness check. |
| `gitnexus://repo/{name}/clusters` | Functional areas and cohesion scores. |
| `gitnexus://repo/{name}/cluster/{clusterName}` | Members of one functional area. |
| `gitnexus://repo/{name}/processes` | Available execution flows. |
| `gitnexus://repo/{name}/process/{processName}` | Step-by-step execution trace. |

## Example Calls

```text
query({query: "wallet withdrawal flow"})
context({name: "createAppRouter"})
```

Use `repo` explicitly if multiple indexed repositories are available.
