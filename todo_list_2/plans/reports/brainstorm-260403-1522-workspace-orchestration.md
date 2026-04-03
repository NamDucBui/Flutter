# Brainstorm Report: Workspace Orchestration với Claude Code

**Date:** 2026-04-03  
**Session:** todo_list_2 workspace architecture  

---

## Problem Statement

User muốn `todo_list_2` trở thành **workspace root** chứa nhiều project con (Flutter mobile + NodeJS backend), với Claude cha có khả năng orchestrate các project con. Mỗi project con có CLAUDE.md riêng nhưng share config/skills từ workspace.

---

## Evaluated Approaches

### A. Flat Monorepo + CLAUDE.md Inheritance
- Chỉ config inheritance, không orchestrate được
- Không phù hợp yêu cầu "điều khiển"

### B. Orchestrator Claude + Sub-Agent Delegation ✅ CHOSEN
- Parent spawn Agent tool với CWD = project subdir
- Sub-agent đọc CLAUDE.md của project đó
- Phù hợp cả 4 control types: task delegation, config sharing, scaffold, reporting

### C. Git Submodules + Shared Config Package
- Git submodule = pain on Windows
- Không orchestrate được → rejected

---

## Final Solution

### Structure

```
D:\Immortal\Flutter\todo_list_2\     ← Workspace root (Orchestrator Claude)
├── CLAUDE.md                        ← Orchestrator rules
├── .claude/                         ← Shared: skills, hooks, rules, settings
├── mobile/                          ← Flutter Notes App (Phase 1-6 plan)
│   ├── CLAUDE.md                    ← Minimal Flutter-specific override
│   ├── pubspec.yaml
│   └── lib/
├── backend/                         ← NodeJS API (future)
│   ├── CLAUDE.md
│   └── src/
├── plans/                           ← Workspace-level plans
└── docs/                            ← Workspace-level docs
```

### Key Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Project structure | `mobile/`, `backend/` subfolders | Clear separation, generic names |
| Config sharing | Workspace `.claude/` shared, child CLAUDE.md minimal | DRY - không duplicate |
| Flutter Notes App location | `mobile/` subdir | Confirmed by user |
| Plans location | Workspace `plans/` | Centralized, easier to manage |
| Backend | `backend/` placeholder | Future-ready, YAGNI for now |

### How Orchestration Works

```
User → Parent Claude (todo_list_2/)
  ↓ "Fix bug in mobile"
  └── spawn Agent → CWD: mobile/ → reads mobile/CLAUDE.md + workspace CLAUDE.md
  
User → Parent Claude
  ↓ "Deploy both mobile build + backend"  
  ├── spawn Agent → mobile/ → build Flutter web
  └── spawn Agent → backend/ → deploy Node API
  ↓ collect results → report
```

### Impact on Existing Notes App Plan (Phase 1-6)

Plan `260403-1454-flutter-notes-app` cần update:
- Phase 1: `flutter create` command → output vào `mobile/`
- All phases: paths `lib/` → `mobile/lib/`, `pubspec.yaml` → `mobile/pubspec.yaml`
- Logic, architecture, packages: **không thay đổi**

---

## Implementation Steps

### Step 1: Workspace Setup
1. Update root `CLAUDE.md` → orchestrator context
2. Create `mobile/CLAUDE.md` (minimal Flutter override)
3. Create `backend/` placeholder với `CLAUDE.md`
4. Update Phase 1 plan: `flutter create` vào `mobile/`

### Step 2: Execute Notes App Plan
- Run `/ck:cook` cho plan `260403-1454-flutter-notes-app`
- Flutter code goes into `mobile/`

### Step 3: Backend (Future)
- When ready: scaffold NodeJS project vào `backend/`

---

## Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| Plan paths outdated (root vs mobile/) | Medium | Update Phase 1 trước khi cook |
| Claude Code CLAUDE.md inheritance depth | Low | Test với mở file trong mobile/ |
| Windows symlinks cho shared skills | Low | Không dùng symlink — share qua workspace .claude/ |

---

## Next Steps

1. Create workspace setup plan (update CLAUDE.md + mobile/ structure)
2. Update Notes App Phase 1 paths
3. Execute Notes App plan (`/ck:cook`)
