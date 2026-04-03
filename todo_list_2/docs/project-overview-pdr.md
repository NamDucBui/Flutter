# Project Overview — todo_list_2 Workspace

**Type:** Multi-project workspace (Flutter + NodeJS)
**Created:** 2026-04-03
**Claude config:** Workspace-level orchestration via root `CLAUDE.md`

## Projects

### `mobile/` — Flutter Notes App

Local-first notes app inspired by iPhone Notes / Evernote.

| Item | Detail |
|------|--------|
| Platform | iOS, Android, Web, macOS, Windows, Linux |
| Stack | Flutter + Riverpod + Isar + flutter_quill |
| Status | Active — MVP in progress |
| Plan | `mobile/plans/260403-1454-flutter-notes-app/` |

**MVP Features:** Rich text editor, folders, tags, full-text search, pin/color notes, dark/light theme.
**Deferred:** Cloud sync, handwriting, export, auth.

### `backend/` — NodeJS API (Planned)

REST API for cloud sync feature — scaffolded when Notes App MVP is complete.

| Item | Detail |
|------|--------|
| Platform | Server (Node.js ≥ 20 LTS) |
| Stack | TypeScript + Fastify/NestJS + Supabase |
| Status | Placeholder — not yet scaffolded |

## Workspace Conventions

- Plans → `plans/` (workspace-level) + `{subproject}/plans/` (sub-project level)
- Docs → `docs/` (this directory)
- Shared config → `.claude/` (skills, hooks, rules)
- Sub-projects have `.claude/.ck.json` for plan path configuration
- Each sub-project has its own `CLAUDE.md` with project-specific context
