# Phase 1: Sub-project Plans Migration

**Plan:** [Sub-project Plans Structure](./plan.md)
**Status:** Completed | **Priority:** P1 | **Est:** 30m

## Overview

3 tasks:
1. Create `.claude/.ck.json` cho `mobile/` và `backend/` với đúng `paths` config
2. Tạo `mobile/plans/`, `backend/plans/` directory structure
3. Move `plans/260403-1454-flutter-notes-app/` → `mobile/plans/` + fix broken links

## Related Files

### Create
- `mobile/.claude/.ck.json`
- `backend/.claude/.ck.json`
- `mobile/plans/reports/.gitkeep`
- `backend/plans/reports/.gitkeep`

### Move
- `plans/260403-1454-flutter-notes-app/` → `mobile/plans/260403-1454-flutter-notes-app/`

### Update
- `mobile/CLAUDE.md` — fix plan path reference (`../plans/` → `plans/`)
- `mobile/plans/260403-1454-flutter-notes-app/plan.md` — fix research report link
- `plans/260403-1509-sub-project-plans-structure/plan.md` — fix blocks link after move

## Implementation Steps

### 1. Create mobile/.claude/.ck.json

Copy từ workspace `.ck.json` và override chỉ `paths` section. Giữ nguyên tất cả settings còn lại (gemini, skills, hooks, etc.) — inherit từ workspace.

```json
{
  "paths": {
    "plans": "plans",
    "docs": "../docs"
  }
}
```

> **Note:** `.ck.json` trong sub-project chỉ cần override `paths`. Các settings khác (gemini, privacyBlock, skills, v.v.) sẽ được đọc từ workspace `.claude/.ck.json`.

### 2. Create backend/.claude/.ck.json

```json
{
  "paths": {
    "plans": "plans",
    "docs": "../docs"
  }
}
```

### 3. Create directory structure

```bash
# mobile/plans/reports/
mkdir -p mobile/plans/reports

# backend/plans/reports/
mkdir -p backend/plans/reports
```

Add `.gitkeep` to empty dirs để git track them.

### 4. Move Notes App plan

```bash
# From workspace root
mv plans/260403-1454-flutter-notes-app mobile/plans/260403-1454-flutter-notes-app
```

### 5. Fix broken link in moved plan.md

`mobile/plans/260403-1454-flutter-notes-app/plan.md` line:
```markdown
# Old (broken after move):
**Research:** [Research Report](../../plans/reports/research-260403-1446-flutter-notes-app.md)

# New (correct relative path from mobile/plans/260403-.../):
**Research:** [Research Report](../../plans/reports/research-260403-1446-flutter-notes-app.md)
```

> **Note:** Research report vẫn ở `plans/reports/` (workspace level) — relative path từ `mobile/plans/260403-1454-flutter-notes-app/` = `../../../plans/reports/research-260403-1446-flutter-notes-app.md`

### 6. Update mobile/CLAUDE.md — Plan Path Reference

```markdown
# Old:
Plans are stored at workspace level: `../plans/`
Active plan: `../plans/260403-1454-flutter-notes-app/`

# New:
Plans are stored at: `plans/` (sub-project level)
Active plan: `plans/260403-1454-flutter-notes-app/`
```

### 7. Update blocks link in workspace plan

`plans/260403-1509-sub-project-plans-structure/plan.md` — update Cross-Plan link to new location after move.

## Todo List

- [x] Create `mobile/.claude/.ck.json` với paths config
- [x] Create `backend/.claude/.ck.json` với paths config
- [x] Create `mobile/plans/reports/` với `.gitkeep`
- [x] Create `backend/plans/reports/` với `.gitkeep`
- [x] `git mv plans/260403-1454-flutter-notes-app mobile/plans/260403-1454-flutter-notes-app`
- [x] Fix research report link trong `mobile/plans/260403-1454-flutter-notes-app/plan.md`
- [x] Update `mobile/CLAUDE.md` plan path references
- [x] Verify: `node .claude/scripts/set-active-plan.cjs` from `mobile/` resolves correctly

## Success Criteria

- `mobile/.claude/.ck.json` exists với `paths.plans = "plans"`
- `backend/.claude/.ck.json` exists với `paths.plans = "plans"`
- `mobile/plans/260403-1454-flutter-notes-app/plan.md` accessible
- `mobile/plans/reports/` directory exists
- `backend/plans/reports/` directory exists
- All relative links trong moved plan files resolve correctly
- `mobile/CLAUDE.md` plan references updated

## Risk Assessment

| Risk | Impact | Mitigation |
|------|--------|------------|
| Relative links break after `git mv` | Medium | Audit all `../` paths in moved plan files |
| `.ck.json` không được đọc từ sub-project | Low | ClaudeKit reads `.ck.json` from CWD and parents — sub-project `.ck.json` overrides workspace |
| workspace plan `blocks` link outdated | Low | Update cross-plan link sau khi move |

## Next Steps

After completion → Notes App plan unblocked:
```
/ck:cook D:\Immortal\Flutter\todo_list_2\mobile\plans\260403-1454-flutter-notes-app\plan.md
```
