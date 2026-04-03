---
title: "Sub-project Plans Structure"
description: "Move plans into sub-project directories (mobile/plans/, backend/plans/) with per-sub-project .ck.json config."
status: completed
priority: P1
effort: 30m
issue:
branch: main
tags: [infra, config]
blockedBy: []
blocks: [260403-1454-flutter-notes-app]
created: 2026-04-03
completed: 2026-04-03
---

# Sub-project Plans Structure

## Overview

Co-locate plans with code: Flutter plans → `mobile/plans/`, Node plans → `backend/plans/`. Each sub-project gets `.claude/.ck.json` so hooks inject correct paths when CWD = sub-project.

**Reference:** [Brainstorm Report](../reports/brainstorm-260403-1509-sub-project-plans-structure.md)

## Target Structure

```
todo_list_2/
├── plans/                          ← workspace-level only (infra, cross-project)
│   └── reports/
├── mobile/
│   ├── .claude/
│   │   └── .ck.json               ← paths.plans = "plans", paths.docs = "../docs"
│   ├── plans/                     ← Flutter plans live here
│   │   ├── 260403-1454-flutter-notes-app/  ← MOVED from workspace plans/
│   │   └── reports/
│   └── CLAUDE.md
└── backend/
    ├── .claude/
    │   └── .ck.json               ← paths.plans = "plans", paths.docs = "../docs"
    ├── plans/
    │   └── reports/
    └── CLAUDE.md
```

## Phases

| Phase | Name | Status | Est. |
|-------|------|--------|------|
| 1 | [Sub-project Plans Migration](./phase-01-sub-project-plans-migration.md) | Pending | 30m |

## Cross-Plan Dependencies

| Relationship | Plan | Note |
|-------------|------|------|
| Blocks | [Flutter Notes App](../../mobile/plans/260403-1454-flutter-notes-app/plan.md) | Plan path changes — must complete before cooking |
