# Technology Stack Guidelines

## Philosophy

**Optimal over beginner-friendly**: Choose modern, industry-standard tools that represent best practices. The goal is to learn the right way from the start, not to be limited by experience level.

## Deployment

### Primary Platform: render.com
- Free tier for experiments
- Easy PostgreSQL, Redis, and static site hosting
- Auto-deploy from GitHub
- Environment variable management

**When to use:**
- Web applications (Node.js, Python, etc.)
- Databases (PostgreSQL preferred)
- Background workers
- Static sites

**Configuration:**
Always include `render.yaml` in project root for infrastructure-as-code:
```yaml
# Example render.yaml
services:
  - type: web
    name: my-app
    env: node
    buildCommand: npm install && npm run build
    startCommand: npm start
```

## Testing Strategy

### Manual Testing Priority
1. Developer runs manual tests first
2. Automated tests supplement, not replace manual testing
3. Provide clear testing instructions for every feature

### Testing Tools (when automated tests are added)
- **Vitest**: Modern, fast, TypeScript-native
- **Playwright**: E2E testing (better than Cypress for modern apps)
- **React Testing Library**: Component testing

## Frontend Stack

### Preferred: React + TypeScript
**Why:**
- React: Industry standard, massive ecosystem, transferable skills
- TypeScript: Catches errors before runtime, great for learning proper patterns

### Build Tool: Vite
**Why over Create React App:**
- Faster development server (instant HMR)
- Better build times
- Modern, actively maintained
- Native TypeScript support

### Styling: Tailwind CSS
**Why:**
- Utility-first = easier to reason about than custom CSS
- No naming conflicts (no BEM, no CSS modules confusion)
- Consistent design system built-in
- Great documentation for learning

### Framework Option: Next.js
**When to use:**
- Need server-side rendering (SEO, performance)
- Want built-in routing
- API routes + frontend in one project

## Backend Stack

### Node.js + TypeScript
**Framework: Express or Fastify**
- Express: More resources, simpler for learning
- Fastify: Better performance, modern TypeScript support

### Alternative: Python + FastAPI
**When to use:**
- Data processing or ML features
- Team prefers Python
- Async operations are key

**Why FastAPI:**
- Automatic API docs (Swagger)
- Modern async support
- Great TypeScript-like type hints
- Fast (comparable to Node.js)

## Database

### Primary: PostgreSQL
**Why:**
- Industry standard for production apps
- Free on render.com
- Powerful querying, JSON support
- Easy to learn, scales well

### ORM: Prisma (Node.js) or SQLAlchemy (Python)
**Prisma benefits:**
- Type-safe database queries
- Automatic migrations
- Great TypeScript integration
- Visual database browser

## Package Management

### Preferred: pnpm
**Why over npm/yarn:**
- Faster installs
- Better disk space usage (shared dependencies)
- Stricter (prevents phantom dependencies)
- Drop-in replacement for npm

**Fallback: npm**
Use npm if:
- Project already uses it
- Team is unfamiliar with pnpm
- Deployment platform doesn't support pnpm well

## Monorepo (when needed)

### Tool: Turborepo
**Why:**
- Simple configuration
- Fast parallel builds
- Great with pnpm workspaces
- Caching reduces rebuild times

## Environment Management

### Required Files

**`.env.example`** - Template for required variables:
```bash
# Database
DATABASE_URL=postgresql://user:pass@localhost:5432/db

# API Keys
API_KEY=your_key_here
```

**`.env`** - Actual secrets (never commit):
```bash
# This file is gitignored
DATABASE_URL=postgresql://real_connection_string
API_KEY=real_api_key
```

## Code Quality Tools

### Linting: ESLint
- Catch errors before runtime
- Enforce consistent style
- Learn best practices through warnings

### Formatting: Prettier
- No debates about formatting
- Consistent code style
- Auto-fix on save

### Type Checking: TypeScript
- Run `tsc --noEmit` before commits
- Catch type errors early

## Git Workflow

### Commit Messages
Use conventional commits:
```
feat: add user authentication
fix: resolve database connection timeout
docs: update README with deployment steps
refactor: simplify user validation logic
```

### Branch Strategy
- `main`: Production-ready code
- `dev`: Development branch (optional)
- `feature/*`: Feature branches
- `fix/*`: Bug fix branches

## Documentation

### Required Files
Every project must have:
- **README.md**: What it does, how to run it, how to deploy
- **AGENTS.md**: AI agent instructions (commands, testing, conventions)
- **.env.example**: Required environment variables
- **CHANGELOG.md**: Track major changes (optional but recommended)

## When to Deviate

It's okay to use different tools when:
1. Project already has established stack
2. Specific requirement demands it (e.g., Svelte for specific use case)
3. Learning opportunity (trying new framework)

**But:** Document *why* you deviated in the project README.

## AI Agent Instructions

When starting a new project:
1. Ask about specific requirements that might change tech choices
2. Default to this stack unless there's a good reason to deviate
3. Explain *why* each technology was chosen
4. Provide learning resources for unfamiliar tools
5. Always include render.com deployment configuration
