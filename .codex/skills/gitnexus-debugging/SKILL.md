---
name: gitnexus-debugging
description: "Debug bugs with GitNexus. Use when the user asks why code fails, where an error comes from, who calls a failing function, why an endpoint or flow returns the wrong result, or how to trace a regression through execution flows."
---

# Debugging With GitNexus

Use GitNexus to move from symptom to code path, then confirm the root cause in
source files.

## Workflow

1. Use `query({query: "<error or symptom>"})` to find related flows and symbols.
2. Use `context({name: "<suspect>"})` to inspect callers, callees, and process participation.
3. Read `gitnexus://repo/{name}/process/{processName}` when a returned process is relevant.
4. Use `cypher` for custom graph traces only when the standard tools are not enough.
5. Read the source files before claiming a root cause.

If the index is stale, run:

```bash
node .gitnexus/run.cjs analyze --skip-agents-md --skip-skills
```

## Patterns

| Symptom | Approach |
| --- | --- |
| Error message | `query` for the error text, then inspect throw sites with `context`. |
| Wrong return value | Use `context` on the function and trace callees/data sources. |
| Intermittent failure | Look for async boundaries, external calls, and shared mutable state. |
| Recent regression | Use `detect_changes({scope: "all"})` or a focused diff scope. |
| Performance issue | Use `context` to find hot paths and high fan-in symbols, then profile if needed. |

## Example Calls

```text
query({query: "payment validation error"})
context({name: "validatePayment"})
detect_changes({scope: "all"})
```

For custom call chains:

```cypher
MATCH path = (a)-[:CodeRelation {type: 'CALLS'}*1..2]->(b:Function {name: "validatePayment"})
RETURN [n IN nodes(path) | n.name] AS chain
```
