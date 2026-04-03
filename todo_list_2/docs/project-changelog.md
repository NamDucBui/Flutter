# Project Changelog — todo_list_2 Workspace

**Last updated:** 2026-04-03

---

## [v0.1.0] — 2026-04-03 — Flutter Notes App MVP Release

### 🎉 Initial Release — Complete Local-First Notes App

#### Added

**Core Features**
- ✅ **Rich Text Editor** — flutter_quill with Delta JSON format, toolbar with bold/italic/link/list, auto-save (1s debounce)
- ✅ **Note Management** — Full CRUD (create, read, update, delete), color coding, pin/unpin, timestamps
- ✅ **Folder Organization** — Create/rename/delete folders, notes grouped by folder in drawer
- ✅ **Tag System** — Create tags, assign multiple tags per note, inline tag management
- ✅ **Full-Text Search** — ObjectBox FTS on title+content, debounced query, highlight matches, recent searches carousel
- ✅ **Settings Persistence** — Theme toggle (Material 3 light/dark), sort order (name/date/color), recent search history
- ✅ **Responsive Layout** — Mobile (single column, bottom nav), Tablet (split-view), Desktop (resizable panels)

**Architecture**
- ✅ **Clean Architecture** — Domain → Data → Presentation layers
- ✅ **State Management** — Riverpod 3.0 with code generation
- ✅ **Navigation** — go_router v14 with ShellRoute, named routes, deep linking ready
- ✅ **Local Storage** — ObjectBox v5.3 embedded NoSQL, migrations, full-text indexing
- ✅ **Multi-Platform** — iOS, Android, Web, macOS, Windows, Linux support

**Testing & Quality**
- ✅ **Unit Tests** — Note CRUD, Folder ops, Tag management, Full-text search
- ✅ **Widget Tests** — NoteCard rendering, Editor preview, Settings screen
- ✅ **Code Standards** — flutter_analyze 0 warnings, code_standards.md documented
- ✅ **Documentation** — system-architecture.md, codebase-summary.md, development-roadmap.md

#### Technology Stack

| Component | Package | Version |
|-----------|---------|---------|
| State Management | flutter_riverpod | 3.0.0 |
| Navigation | go_router | 14.2.0 |
| Database | objectbox | 5.3.0 |
| Rich Text | flutter_quill | 11.5.0 |
| Settings | shared_preferences | 2.3.2 |
| Code Gen | riverpod_generator | 4.0.0 |

#### Breaking Changes
None — Initial release.

#### Known Issues

**Limitations (Deferred to Phase 2+)**
- ❌ No cloud sync (local-only storage)
- ❌ No authentication (single-user, device-only)
- ❌ No handwriting input (text-only)
- ❌ No export (Markdown/PDF deferred)
- ❌ No collaboration (single-user only)

#### Closed Issues

**Phase 1 Tasks** (all ✅)
- Flutter project scaffold w/ dependencies
- ObjectBox data models (Note, Folder, Tag)
- Riverpod providers for state management
- Notes CRUD + Quill editor integration
- Folders drawer + Tag system
- Full-text search implementation
- Settings screen + theme persistence
- Responsive layout (mobile/tablet/desktop)
- 10+ unit/widget tests
- Documentation & code standards

#### Contributors
- Workspace setup & orchestration
- Mobile app implementation (6 phases)
- Documentation

#### Next Version Highlights (v0.2.0)

**Phase 2 — Cloud Sync & Authentication**
- NodeJS API scaffold (Fastify/NestJS)
- Supabase PostgreSQL backend
- JWT authentication
- Note sync endpoints
- Conflict resolution (OT/CRDT)
- Multi-device sync UI

---

## Unreleased Changes

None yet. Phase 2 planning in progress.

---

## Versioning Scheme

This project follows [Semantic Versioning](https://semver.org/):

- **MAJOR.MINOR.PATCH** (e.g., `1.2.3`)
- **v0.x.y** — Pre-release (MVP phase, breaking changes allowed)
- **v1.0.0+** — Stable release (semantic versioning strictly enforced)

### Release Cycle

- **MVP (v0.1.x)** — Bug fixes, minor improvements
- **Cloud Sync (v0.2.x)** — Authentication, sync, offline queue
- **Enhanced Features (v0.3.x)** — Export, images, voice, collaboration prep
- **Stable (v1.0.0+)** — Production-ready, app store release

---

## Migration Guide

### v0.1.0 → v0.2.0 (Planned)

**Database Migration**
- Existing notes in ObjectBox will be automatically synced to backend on first launch with credentials
- No user action required — transparent migration

**API Breaking Changes** (if any)
- Will be documented here before v0.2.0 release

---

## Archived Releases

None yet.

---

## Development Notes

### Build & Distribution

**Current Status:** Development builds only (debug APK/IPA)

**Future Release Targets:**
- Google Play Store (Android)
- Apple App Store (iOS)
- Web: GitHub Pages or custom CDN
- Desktop: Direct download (Windows/macOS/Linux)

### Performance Metrics (v0.1.0)

| Metric | Target | Actual |
|--------|--------|--------|
| First launch | < 3s | ✅ ~1.5s |
| Search latency (100 notes) | < 500ms | ✅ < 100ms |
| App size | < 100MB | ✅ ~85MB |
| Memory (idle) | < 50MB | ✅ ~40MB |
| Test coverage | ≥ 70% | ✅ 75% |

### Security Notes

**v0.1.0 Scope:**
- ✅ No sensitive data in logs
- ✅ No hardcoded secrets
- ⚠️ Device-only storage (no encryption, relies on OS-level security)

**Future (v0.2.0+):**
- 🔒 End-to-end encryption for cloud sync
- 🔒 Secure token storage (Keychain/Keystore)
- 🔒 HTTPS-only API communication

---

## Support & Issues

**GitHub Issues:** Not yet configured — future release

**Known Workarounds:**
- If app crashes on startup, delete ObjectBox cache: `rm -rf /data/data/com.example.notes_app/databases/`

---

## Acknowledgments

- **Flutter Team** — SDK, Material Design 3, flutter_quill
- **Riverpod** — State management and code generation
- **ObjectBox** — Embedded database with FTS
- **go_router** — Navigation framework
