# CLAUDE.md — backend/

## Project Context

**Type:** NodeJS API server
**Workspace root:** `D:\Immortal\Flutter\todo_list_2\`
**This project:** `D:\Immortal\Flutter\todo_list_2\backend\`

Inherits all rules from workspace root `CLAUDE.md`. Rules below are Node-specific overrides.

## Status

🚧 **Placeholder — not yet scaffolded.**

Will be scaffolded when cloud sync feature is needed (deferred from Notes App MVP).

## Planned Stack (when ready)

- Runtime: Node.js ≥ 20 LTS
- Language: TypeScript (strict mode)
- Framework: TBD — Fastify (performance) or NestJS (structure)
- Database: Supabase (PostgreSQL) for notes sync
- Auth: Supabase Auth
- All files use kebab-case naming

## Commands (future)

```bash
# Run from backend/ directory
npm install
npm run dev
npm test
npm run build
```

## Architecture (planned)

```
backend/
├── src/
│   ├── modules/       # notes, auth, users
│   ├── common/        # middleware, guards, utils
│   └── main.ts
├── test/
├── package.json
└── tsconfig.json
```
