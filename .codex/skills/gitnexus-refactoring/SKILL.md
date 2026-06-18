---
name: gitnexus-refactoring
description: "Refactor with GitNexus support. Use when the user asks to rename a symbol, extract a module, split a service or function, move code, or restructure code while preserving callers and execution flows."
---

# Refactoring With GitNexus

Use GitNexus to map dependencies before editing and to verify the changed scope
after editing.

## General Workflow

1. Use `context({name: "<target>"})` to understand the symbol.
2. Use `impact({target: "<target>", direction: "upstream"})` to find callers/importers.
3. Use `query({query: "<target or feature>"})` to find related flows and dynamic references.
4. Edit in dependency order: contracts, implementations, callers, tests.
5. Use `detect_changes({scope: "all"})` to confirm affected scope.
6. Run focused tests for affected modules.

If the index is stale, run:

```bash
node .gitnexus/run.cjs analyze --skip-agents-md --skip-skills
```

## Rename Checklist

1. Preview:

```text
rename({symbol_name: "oldName", new_name: "newName", dry_run: true})
```

2. Review graph-backed edits first and text-search edits carefully.
3. Apply only after the preview is acceptable:

```text
rename({symbol_name: "oldName", new_name: "newName", dry_run: false})
```

4. Run `detect_changes({scope: "all"})`.
5. Run focused tests.

## Extract Or Split Checklist

1. Use `context` to list incoming and outgoing dependencies.
2. Use `impact` to identify external callers.
3. Define the new boundary before moving code.
4. Update imports and call sites.
5. Use `detect_changes` to catch unexpected blast radius.

## Custom Reference Query

```cypher
MATCH (caller)-[:CodeRelation {type: 'CALLS'}]->(f:Function {name: "validateUser"})
RETURN caller.name, caller.filePath
ORDER BY caller.filePath
```
