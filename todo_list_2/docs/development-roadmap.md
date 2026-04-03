# Development Roadmap — todo_list_2 Workspace

**Last updated:** 2026-04-03 | **Roadmap version:** v1.0

---

## Project Phases & Timeline

### Phase 1: Foundation ✅ COMPLETE (2026-04-03)

**Flutter Notes App MVP**

| Item | Status | Date |
|------|--------|------|
| Flutter project setup (ObjectBox v5, Riverpod v3, go_router v14, flutter_quill v11) | ✅ | 2026-04-03 |
| Data models + repositories (Note, Folder, Tag with ObjectBox) | ✅ | 2026-04-03 |
| Notes CRUD + QuillEditor (auto-save, list/grid, color picker) | ✅ | 2026-04-03 |
| Folders drawer + Tags system (create/assign/filter) | ✅ | 2026-04-03 |
| Full-text search (debounce, highlights, filter chips, recent searches) | ✅ | 2026-04-03 |
| Settings screen (theme+sort persistence), responsive layout, 10 tests | ✅ | 2026-04-03 |

**Deliverables:**
- ✅ Functional app across iOS, Android, Web, macOS, Windows, Linux
- ✅ Local-first, offline-first architecture with ObjectBox
- ✅ 10+ unit/widget tests
- ✅ Code standards documented
- ✅ Architecture documented

**Success Criteria Met:**
- All CRUD operations working
- Full-text search functional
- Settings persist correctly
- Responsive on all platforms
- Tests passing

---

### Phase 2: Cloud Sync 🔄 PLANNED (TBD)

**Backend API + Authentication**

| Item | Status | Target |
|------|--------|--------|
| NodeJS/TypeScript API scaffold (Fastify/NestJS) | 📋 | TBD |
| Supabase PostgreSQL schema (users, notes, sync metadata) | 📋 | TBD |
| JWT authentication (Supabase Auth) | 📋 | TBD |
| Note sync endpoints (GET, POST, PATCH, DELETE) | 📋 | TBD |
| Conflict resolution (operational transform or CRDT) | 📋 | TBD |
| Multi-device sync integration | 📋 | TBD |
| Sync status UI in mobile app | 📋 | TBD |
| End-to-end sync tests | 📋 | TBD |

**Deliverables:**
- NodeJS API running on VPS or cloud platform
- Mobile app authenticated with JWT
- Two-way sync functional
- Offline queue + retry logic

---

### Phase 3: Enhanced Features 📅 FUTURE

| Feature | Status | Priority | Rationale |
|---------|--------|----------|-----------|
| Handwriting input | 📋 | Low | Requires iOS-specific ink plugin, not MVP priority |
| Export to PDF/Markdown | 📋 | Medium | Important for data portability |
| Collaboration (real-time editing) | 📋 | Low | Requires CRDT, out of scope for single-user MVP |
| Image embedding | 📋 | Medium | Enhance rich text capabilities |
| Voice notes | 📋 | Low | Requires audio recording API |
| Desktop app optimization | 📋 | Medium | Keyboard shortcuts, drag-drop, menu bar |
| i18n (multi-language) | 📋 | Low | intl package ready, defer until user base expands |

---

## Milestones & Success Metrics

| Milestone | Status | Metric | Target | Actual |
|-----------|--------|--------|--------|--------|
| **MVP Release (v0.1.0)** | ✅ | App store readiness | Notes, Folders, Tags, Search, Settings | ✅ Complete |
| **API Foundation** | 📋 | Backend ready | Auth, sync endpoints, conflict resolution | TBD |
| **Multi-Device Sync** | 📋 | Sync coverage | All features synced across devices | TBD |
| **Enhanced UX** | 📋 | Feature completeness | Export, images, voice, collaboration | TBD |

---

## Risk Assessment & Mitigation

| Risk | Severity | Mitigation |
|------|----------|-----------|
| ObjectBox versioning issues on new Flutter SDK | Medium | Pin to ObjectBox v5.3.0, track compatibility in CI |
| Sync conflicts between offline edits | Medium | Implement OT/CRDT in Phase 2, extensive testing |
| App size bloat (flutter_quill adds 15MB+) | Low | Monitor build size, defer heavy plugins to Phase 3 |
| Performance on 1000+ notes | Low | Add pagination, test with synthetic data sets |

---

## Current Velocity & Next Steps

**MVP Phase Velocity:**
- 6 implementation phases completed in one sprint
- All core features working
- Tests passing, code reviewed

**Immediate Next Steps:**
1. ✅ Update docs (codebase summary, roadmap, changelog)
2. 📋 Plan Phase 2 (backend API)
3. 📋 Scaffold NodeJS project
4. 📋 Implement authentication
5. 📋 Implement sync logic

---

## Dependencies & Blockers

| Task | Blocked By | Status | Note |
|------|-----------|--------|------|
| Phase 2 API | None | Ready | Can start anytime |
| Handwriting | Mobile platform support research | Not started | iOS Ink API investigation needed |
| Collaboration | CRDT implementation | Not started | Significant R&D required |

---

## Version History

| Version | Date | Highlights |
|---------|------|-----------|
| v0.1.0 | 2026-04-03 | **MVP Release** — Core notes app with search, folders, tags |
| v0.2.0 | TBD | Cloud sync, authentication |
| v0.3.0 | TBD | Enhanced features (export, images, voice) |
| v1.0.0 | TBD | Production-ready, polished UX |
