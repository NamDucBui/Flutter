# Phase 1: Workspace Setup

**Plan:** [Workspace Orchestration Setup](./plan.md)
**Status:** Completed | **Priority:** P1 | **Est:** 2h

## Overview

4 changes cụ thể:
1. Update root `CLAUDE.md` → thêm orchestrator context
2. Tạo `mobile/CLAUDE.md` — Flutter sub-project context
3. Tạo `backend/CLAUDE.md` — NodeJS placeholder
4. Update Notes App `phase-01-project-setup.md` — đổi paths sang `mobile/`
5. Tạo `docs/` placeholder files

## Related Code Files

### Modify
- `CLAUDE.md` — thêm Workspace & Sub-Projects section
- `plans/260403-1454-flutter-notes-app/plan.md` — update blockedBy
- `plans/260403-1454-flutter-notes-app/phase-01-project-setup.md` — update all paths to `mobile/`

### Create
- `mobile/CLAUDE.md`
- `backend/CLAUDE.md`
- `docs/project-overview-pdr.md` (stub)
- `docs/system-architecture.md` (stub)
- `docs/code-standards.md` (stub)

## Implementation Steps

### 1. Update root CLAUDE.md — Add Workspace Section

Add after the existing `## Role & Responsibilities` section:

```markdown
## Workspace Structure

This is a **multi-project workspace**. Sub-projects live in subdirectories:

| Directory | Type | Status |
|-----------|------|--------|
| `mobile/` | Flutter (iOS, Android, Web, Desktop) | Active |
| `backend/` | NodeJS API | Planned |

### Orchestrating Sub-Projects

When working on a sub-project, spawn a sub-agent with the project's CWD:

```
Agent(
  subagent_type: "fullstack-developer",
  prompt: "Task description.
Work context: D:\\Immortal\\Flutter\\todo_list_2\\mobile
Plans: D:\\Immortal\\Flutter\\todo_list_2\\plans"
)
```

- Sub-agent automatically inherits this workspace CLAUDE.md + project CLAUDE.md
- Always pass absolute `Work context` path in sub-agent prompts
- Plans stay at workspace level (`plans/`), not inside sub-projects
```

### 2. Create mobile/CLAUDE.md

```markdown
# mobile/CLAUDE.md

## Project Context

**Type:** Flutter mobile/desktop/web app
**Workspace root:** `D:\Immortal\Flutter\todo_list_2\`
**This project:** `D:\Immortal\Flutter\todo_list_2\mobile\`

Inherit all rules from workspace root CLAUDE.md.

## Flutter-Specific Rules

- Flutter SDK ≥ 3.19, Dart ≥ 3.3
- State management: Riverpod 2.x with code generation
- Navigation: go_router v14+
- Database: Isar v3 (local-first, offline)
- All Flutter files use `snake_case` (Dart convention)
- Run `dart run build_runner build --delete-conflicting-outputs` after model changes

## Project Plans

Plans are stored at workspace level: `../plans/`
Active plan: `../plans/260403-1454-flutter-notes-app/`

## Commands

```bash
# From mobile/ directory
flutter pub get
flutter run
dart run build_runner build --delete-conflicting-outputs
flutter test
flutter analyze
```
```

### 3. Create backend/CLAUDE.md

```markdown
# backend/CLAUDE.md

## Project Context

**Type:** NodeJS API server
**Workspace root:** `D:\Immortal\Flutter\todo_list_2\`
**This project:** `D:\Immortal\Flutter\todo_list_2\backend\`

Inherit all rules from workspace root CLAUDE.md.

## Status

🚧 **Placeholder** — not yet scaffolded. When ready:
- Runtime: Node.js ≥ 20 LTS
- Framework: TBD (Fastify / NestJS / Express)
- Language: TypeScript
- All files use kebab-case

## Commands (future)

```bash
npm install
npm run dev
npm test
```
```

### 4. Update Notes App phase-01-project-setup.md — Path Changes

Key changes in `plans/260403-1454-flutter-notes-app/phase-01-project-setup.md`:

| Old | New |
|-----|-----|
| `flutter create notes_app` | `mkdir mobile && flutter create mobile --org com.yourname` OR `flutter create . --org com.yourname` (from within `mobile/`) |
| `cd notes_app` | `cd mobile` |
| `lib/main.dart` | `mobile/lib/main.dart` |
| `ios/Runner/Info.plist` | `mobile/ios/Runner/Info.plist` |
| `android/app/src/main/AndroidManifest.xml` | `mobile/android/app/src/main/AndroidManifest.xml` |
| `analysis_options.yaml` | `mobile/analysis_options.yaml` |

Full updated Step 1 command:
```bash
# From workspace root: D:\Immortal\Flutter\todo_list_2\
mkdir mobile
cd mobile
flutter create . --org com.yourname --project-name notes_app \
  --platforms ios,android,web,macos,windows,linux
```

All subsequent file paths in phase-01 need `mobile/` prefix.

### 5. Create docs/ Stubs

3 stub files với minimal content — will be filled during implementation:

`docs/project-overview-pdr.md`:
```markdown
# Project Overview — todo_list_2 Workspace

**Type:** Multi-project workspace (Flutter + NodeJS)
**Projects:** mobile/ (Flutter Notes App), backend/ (NodeJS API — planned)
**Claude config:** Workspace-level orchestration via root CLAUDE.md

## Projects

### mobile/ — Flutter Notes App
Local-first notes app (iPhone Notes-inspired). Rich text, folders, tags, search.
Tech: Flutter + Riverpod + Isar + flutter_quill

### backend/ — NodeJS API (Planned)
REST API for future cloud sync feature.
```

`docs/system-architecture.md` and `docs/code-standards.md`: minimal stubs to be filled per project.

## Todo List

- [x] Update `CLAUDE.md` — add `## Workspace Structure` section with sub-project table + orchestration guide
- [x] Create `mobile/` directory
- [x] Create `mobile/CLAUDE.md` with Flutter-specific context
- [x] Create `backend/` directory  
- [x] Create `backend/CLAUDE.md` with NodeJS placeholder
- [x] Update `plans/260403-1454-flutter-notes-app/phase-01-project-setup.md` — all paths to `mobile/`
- [x] Update `plans/260403-1454-flutter-notes-app/plan.md` — add `blockedBy: [260403-1522-workspace-orchestration-setup]`
- [x] Create `docs/project-overview-pdr.md` stub
- [x] Create `docs/system-architecture.md` stub
- [x] Create `docs/code-standards.md` stub
- [x] Verify: open `mobile/lib/main.dart` in Claude → both CLAUDE.md files loaded

## Success Criteria

- `mobile/CLAUDE.md` exists với Flutter context
- `backend/CLAUDE.md` exists với Node placeholder
- Root `CLAUDE.md` có `## Workspace Structure` section
- Notes App Phase 1 paths đều có `mobile/` prefix
- `docs/` có 3 stub files
- Claude session mở trong `mobile/` inherit cả workspace + mobile rules

## Risk Assessment

| Risk | Impact | Mitigation |
|------|--------|------------|
| CLAUDE.md inheritance depth limit | Low | Claude Code reads all parent CLAUDE.md — no known depth limit |
| Notes App Phase 1 có paths bị sót | Medium | Check tất cả bash commands + file paths trong phase-01 |
| `flutter create .` in existing dir | Low | Chỉ tạo Flutter structure, không xóa existing files |

## Next Steps

After this plan completes → unblocks Notes App plan:
```
/ck:cook D:\Immortal\Flutter\todo_list_2\plans\260403-1454-flutter-notes-app\plan.md
```
