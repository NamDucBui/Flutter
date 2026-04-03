---
title: "Workspace Orchestration Setup"
description: "Transform todo_list_2 into a multi-project workspace: orchestrator CLAUDE.md, mobile/ + backend/ sub-projects, update Notes App plan paths."
status: completed
priority: P1
effort: 2h
issue:
branch: main
tags: [feature, infra]
blockedBy: []
blocks: [260403-1454-flutter-notes-app]
created: 2026-04-03
completed: 2026-04-03
---

# Workspace Orchestration Setup

## Overview

Convert `todo_list_2` từ single-project template thành **workspace root** có thể orchestrate nhiều sub-projects.

**Reference:** [Brainstorm Report](../reports/brainstorm-260403-1522-workspace-orchestration.md)

## Workspace Structure (Target)

```
todo_list_2/                        ← Workspace root (Orchestrator Claude)
├── CLAUDE.md                       ← UPDATE: add orchestrator context
├── .claude/                        ← Shared: skills, hooks, rules (unchanged)
├── mobile/                         ← CREATE: Flutter Notes App
│   └── CLAUDE.md                   ← CREATE: Flutter-specific context
├── backend/                        ← CREATE: NodeJS API (placeholder)
│   └── CLAUDE.md                   ← CREATE: Node-specific context
├── plans/                          ← Workspace plans (unchanged)
└── docs/                           ← CREATE: workspace docs structure
```

## Phases

| Phase | Name | Status | Est. |
|-------|------|--------|------|
| 1 | [Workspace Setup](./phase-01-workspace-setup.md) | Pending | 2h |

## Cross-Plan Dependencies

| Relationship | Plan | Status |
|-------------|------|--------|
| Blocks | [Flutter Notes App](../260403-1454-flutter-notes-app/plan.md) | Pending |

Notes App Phase 1 must run AFTER this plan — `mobile/` must exist before `flutter create`.
