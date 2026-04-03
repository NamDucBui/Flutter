# System Architecture — todo_list_2 Workspace

**Last updated:** 2026-04-03

## Workspace Overview

```
todo_list_2/                    ← Workspace root
├── .claude/                    ← Shared: skills, hooks, rules, settings
├── mobile/                     ← Flutter Notes App
├── backend/                    ← NodeJS API (planned)
├── plans/                      ← All implementation plans
└── docs/                       ← This directory
```

## mobile/ — Flutter Architecture

**Pattern:** Clean Architecture (domain → data → presentation)

```
mobile/lib/
├── core/
│   ├── database/               # Isar singleton service
│   ├── router/                 # go_router ShellRoute
│   └── theme/                  # Material 3 light/dark
├── features/
│   ├── notes/
│   │   ├── domain/             # entities, repository interfaces, usecases
│   │   ├── data/               # Isar impl, datasources, mappers
│   │   └── presentation/       # Riverpod providers, screens, widgets
│   ├── folders/
│   ├── tags/
│   └── search/
├── shared/
│   ├── widgets/                # reusable UI components
│   └── utils/
└── main.dart
```

**Data Flow:**
```
UI (Widget) → Provider (Riverpod) → UseCase → Repository Interface
                                                      ↓
                                            Repository Impl (Isar)
                                                      ↓
                                              Local Storage
```

**State Management:** Riverpod 2.x + code generation
**Navigation:** go_router v14 with ShellRoute (bottom nav)
**Storage:** Isar v3 — embedded NoSQL with full-text search
**Rich Text:** flutter_quill — Delta JSON format

## backend/ — Planned Architecture

> Not yet scaffolded. Will be documented when implemented.

**Planned pattern:** REST API with JWT auth + Supabase PostgreSQL

## Cross-Project Communication (Future)

```
mobile/ ←──── REST API ────→ backend/
         JWT Bearer Token
         HTTPS only
```
