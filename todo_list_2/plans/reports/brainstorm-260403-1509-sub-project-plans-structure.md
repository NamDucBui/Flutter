# Brainstorm Report: Sub-project Plans Structure

**Date:** 2026-04-03
**Session:** Sub-project plans per mobile/ and backend/

---

## Problem Statement

Plans currently at workspace root `plans/` — not co-located with sub-project code. User wants plans inside each sub-project for better context isolation when working directly in `mobile/` or `backend/`.

---

## Approaches Evaluated

### A: Sub-project Plans ✅ CHOSEN
- `mobile/plans/` + `backend/plans/`
- Each sub-project has `.claude/.ck.json` with `paths.plans = "plans"`
- Hook injects correct path when CWD = sub-project

### B: Workspace Plans + Naming Prefix
- Keep all in `plans/` with `mobile-` / `backend-` prefix
- Zero config change, but plans not co-located

### C: Hybrid Symlink
- Rejected — Windows symlink issues, unnecessary complexity

---

## Final Solution

```
todo_list_2/
├── plans/                              ← Workspace-level (cross-project, infra)
├── mobile/
│   ├── .claude/.ck.json               ← paths.plans = "plans"
│   ├── plans/                         ← Flutter plans (moved here)
│   │   └── 260403-1454-flutter-notes-app/
│   └── CLAUDE.md
└── backend/
    ├── .claude/.ck.json               ← paths.plans = "plans"
    ├── plans/                         ← Node plans (placeholder)
    └── CLAUDE.md
```

### Key Decisions

| Decision | Choice |
|----------|--------|
| Plans location | Co-located with sub-project code |
| Config mechanism | `.ck.json` per sub-project with `paths.plans` |
| Workspace `plans/` | Keep for cross-project + infra plans |
| Existing Notes App plan | Move to `mobile/plans/` |

---

## Implementation Steps

1. Create `mobile/.claude/.ck.json` with paths config
2. Create `backend/.claude/.ck.json` with paths config
3. Create `mobile/plans/reports/` and `backend/plans/reports/` dirs
4. Move `plans/260403-1454-flutter-notes-app/` → `mobile/plans/`
5. Update internal relative links in moved plan files
6. Update `mobile/CLAUDE.md` plan path reference

---

## Risks

| Risk | Mitigation |
|------|-----------|
| Relative links break after move | Fix `../../plans/reports/` → `../reports/` in moved files |
| hooks inject wrong path from workspace root | Workspace root still uses `plans/` correctly |
| backend/.ck.json conflicts with workspace | Scoped to sub-project CWD — no conflict |

---

## Unresolved Questions

- None
