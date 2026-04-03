---
title: "Flutter Notes App (MVP)"
description: "Local-first notes app với rich text editor, folders/tags, full-text search — Material 3, all platforms, offline-first."
status: pending
priority: P1
effort: 80h
issue:
branch: main
tags: [flutter, feature, frontend, database]
blockedBy: [260403-1522-workspace-orchestration-setup]
blocks: []
created: 2026-04-03
---

# Flutter Notes App — MVP Plan

## Overview

Build a local-first notes app inspired by iPhone Notes. All platforms (iOS, Android, Web, Desktop).
**Scope (MVP):** Rich text editing, folders, tags, search, pin/color notes, dark/light theme. No sync, no handwriting.

**Research:** [Research Report](../../plans/reports/research-260403-1446-flutter-notes-app.md)

## Tech Stack

| Layer | Package |
|-------|---------|
| State | `flutter_riverpod 2.x` + `riverpod_generator` |
| Navigation | `go_router ^14` |
| Rich Text | `flutter_quill ^10` + `flutter_quill_extensions` |
| Database | `isar ^3` (full-text search built-in) |
| Image | `image_picker` + `path_provider` |
| Theme | Material 3 |

## Phases

| Phase | Name | Status | Est. |
|-------|------|--------|------|
| 1 | [Project Setup & Architecture](./phase-01-project-setup.md) | Pending | 8h |
| 2 | [Data Models & Isar Database](./phase-02-data-models-database.md) | Pending | 10h |
| 3 | [Notes CRUD + Rich Text Editor](./phase-03-notes-crud-rich-text.md) | Pending | 20h |
| 4 | [Folders, Tags & Organization](./phase-04-folders-tags-organization.md) | Pending | 16h |
| 5 | [Search & Filtering](./phase-05-search-filtering.md) | Pending | 10h |
| 6 | [UI Polish, Theme & Testing](./phase-06-ui-polish-testing.md) | Pending | 16h |

## Architecture

```
mobile/lib/
├── core/
│   ├── database/          # Isar service + models
│   ├── router/            # go_router
│   └── theme/             # Material 3 light/dark
├── features/
│   ├── notes/             # CRUD, rich text
│   ├── folders/           # Folder management
│   ├── tags/              # Tag management
│   └── search/            # Full-text search
└── main.dart
```

## Deferred (Not in MVP Scope)

- Cloud sync (Supabase)
- Authentication
- Handwriting canvas
- Export (PDF/Markdown)
- Biometric note lock
- Web Clips / PDF attachments

## Dependencies

- Flutter SDK ≥3.19
- Dart ≥3.3
- `isar_flutter_libs` (platform-specific native libs)
- `build_runner` for code generation
