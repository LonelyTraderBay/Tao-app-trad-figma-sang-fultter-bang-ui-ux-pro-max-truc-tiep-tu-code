# CLAUDE.md — flutter_app/

Lazy-loaded when Claude Code works under `flutter_app/`. Root
`CLAUDE.md` + `@AGENTS.md` remain the project contract.

## Working directory

Run Flutter/Dart commands from **this directory** (`flutter_app/`):

```bash
flutter pub get
dart format --output=none --set-exit-if-changed .
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
flutter analyze
flutter test --reporter=compact
```

Prefer `/vt-verify` from repo root (it `cd`s here). Prefer `/vt-audit` /
`/vt-batch` for design-domain and batch orchestration.

## Layout hotspots

```text
lib/app/          bootstrap, theme, router facade, providers
lib/core/         non-UI cross-cutting (exception: back_navigation.dart)
lib/features/<f>/{domain,data,presentation/{pages,widgets,controllers}}
lib/shared/       Vit* primitives
test/             mirror features + test/quality/ guardrails
```

## Claude Code MCP

Use **tokensave** for blast radius (`tokensave_impact`, `tokensave_context`,
`tokensave_search`, `tokensave_diff_context`). GitNexus is Cursor-only.

## Do not

- Edit `lib/features/home/.../home_page.dart` unless the task explicitly
  names it (screen-designer agents already refuse casual home edits).
- Add English user-facing product copy; vi-VN đủ dấu inline.
- Commit to `main`; use a feature branch + PR.
