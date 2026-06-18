---
name: gitnexus-guide
description: "Reference GitNexus MCP tools, resources, and graph workflow from Codex. Use when the user asks how GitNexus works, which GitNexus tools are available, how to query the graph, or how to choose the right GitNexus skill."
---

# GitNexus Guide For Codex

GitNexus provides a code knowledge graph for indexed repositories. In Codex,
use the MCP tools directly by their Codex names.

## Start Here

1. Use `list_repos` to discover indexed repos.
2. Read `gitnexus://repo/{name}/context` to check index freshness.
3. Pick the task-specific skill:

| Task | Skill |
| --- | --- |
| Understand code or architecture | `gitnexus-exploring` |
| Debug errors or unexpected behavior | `gitnexus-debugging` |
| Check blast radius before changes | `gitnexus-impact-analysis` |
| Rename, extract, split, or move code | `gitnexus-refactoring` |
| Run index/status/clean/wiki commands | `gitnexus-cli` |

If the index is stale, run:

```bash
node .gitnexus/run.cjs analyze --skip-agents-md --skip-skills
```

## MCP Tools

| Tool | Use |
| --- | --- |
| `list_repos` | List indexed repositories. |
| `query` | Search execution flows and relevant symbols. |
| `context` | Inspect a symbol's callers, callees, imports, properties, and process links. |
| `impact` | Find what depends on a symbol or what a symbol depends on. |
| `detect_changes` | Map current git changes to affected symbols and flows. |
| `rename` | Preview or apply graph-assisted symbol renames. |
| `cypher` | Run custom graph queries. |
| `api_impact` | Inspect API route consumers and response shape risks before route edits. |

## Resources

| Resource | Content |
| --- | --- |
| `gitnexus://repo/{name}/context` | Stats and stale-index status. |
| `gitnexus://repo/{name}/clusters` | Functional areas. |
| `gitnexus://repo/{name}/cluster/{clusterName}` | Symbols in one area. |
| `gitnexus://repo/{name}/processes` | Execution flow list. |
| `gitnexus://repo/{name}/process/{processName}` | Full flow trace. |
| `gitnexus://repo/{name}/schema` | Graph schema for Cypher. |

## Cypher Note

Relationships use `CodeRelation` with a `type` property:

```cypher
MATCH (caller)-[:CodeRelation {type: 'CALLS'}]->(f:Function {name: "validateUser"})
RETURN caller.name, caller.filePath
```
