# run-artifacts/

Generated QA output (screenshots, UI dumps, audit reports) produced by `tool/*.dart`
scripts and manual QA passes. This whole directory is gitignored (see root
`.gitignore`) except this file.

## Retention

- Prefix new files with a date (`YYYY-MM-DD`) or route/module name, matching the
  existing `ponytail-audit-<module>-<date>.md` convention already in use here.
- This directory is not pruned automatically. Delete files/subfolders you no
  longer need locally — nothing here is required for the app to build, test, or
  run `flutter analyze`.
- If a report needs to be kept long-term (e.g. referenced from a doc), move it
  into `docs/` instead, since anything left here is not shared with the team.
