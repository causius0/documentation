# How to Export Documentation to Projects

This guide explains how to integrate this documentation repository into your projects.

## Quick Start (Automated) ⚡

**The fastest way to set up a new project:**

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/causius0/documentation/main/setup.sh)
```

This automatically:
- ✅ Creates `.claude/` directory with config and commands
- ✅ Generates project-specific `AGENTS.md`
- ✅ Sets up slash commands (`/security-audit`, `/pre-merge`, etc.)
- ✅ Configures Claude Code plugins
- ✅ Creates `.env.example` and `README.md`

**See [QUICKSTART.md](QUICKSTART.md) for full automated setup documentation.**

---

## Manual Integration Methods

If you prefer manual control, choose one of these three methods:

## Three Integration Methods

```
┌────────────────────────────────────────────────────────────┐
│                    INTEGRATION OPTIONS                     │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  1. REFERENCE (Recommended)                                │
│     ┌────────────────┐         ┌─────────────────┐        │
│     │  Your Project  │ ───────►│ documentation   │        │
│     │  (AGENTS.md)   │  link   │    repository   │        │
│     └────────────────┘         └─────────────────┘        │
│     Pros: Always up to date, single source of truth        │
│     Cons: Requires network access to GitHub               │
│                                                            │
│  2. GIT SUBMODULE                                          │
│     ┌────────────────────────────────────┐                │
│     │  Your Project                      │                │
│     │  ├── src/                          │                │
│     │  ├── docs/ ← (submodule)           │                │
│     │  │   └── documentation/            │                │
│     │  └── AGENTS.md                     │                │
│     └────────────────────────────────────┘                │
│     Pros: Stays in sync, version controlled               │
│     Cons: Git submodules can be confusing                 │
│                                                            │
│  3. DIRECT COPY                                            │
│     ┌────────────────────────────────────┐                │
│     │  Your Project                      │                │
│     │  ├── src/                          │                │
│     │  ├── docs/                         │                │
│     │  │   ├── agents.md                 │                │
│     │  │   ├── coding-standards.md       │                │
│     │  │   └── ...                       │                │
│     │  └── AGENTS.md                     │                │
│     └────────────────────────────────────┘                │
│     Pros: Simple, works offline                           │
│     Cons: Can get out of sync                             │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

## Method 1: Reference (Recommended)

### Setup

1. **Create project-specific AGENTS.md**

```bash
cd /path/to/your/project

# Copy the AGENTS.md sample
cat > AGENTS.md << 'EOF'
# Project: [Your Project Name]

> For general coding standards and guidelines, see the [documentation repository](https://github.com/causius0/documentation)

## Quick Links
- [Coding Standards](https://github.com/causius0/documentation/blob/main/coding-standards.md)
- [Tech Stack](https://github.com/causius0/documentation/blob/main/tech-stack.md)
- [Git Workflow](https://github.com/causius0/documentation/blob/main/git-workflow.md)
- [Security Testing](https://github.com/causius0/documentation/blob/main/security-testing.md)

## Project-Specific Instructions

### Tech Stack
- Frontend: [React / Next.js / etc.]
- Backend: [Express / FastAPI / etc.]
- Database: [PostgreSQL / MongoDB / etc.]
- Deployment: render.com

### Dev Environment Commands

```bash
# Install dependencies
npm install  # or pnpm install

# Development
npm run dev

# Testing
npm test

# Build
npm run build

# Lint
npm run lint
```

### Environment Variables

See `.env.example` for required variables.

### Available MCP Servers

- **filesystem** - File operations
- **github** - GitHub API
- **postgres** - Database queries (dev only)
- **brave-search** - Web search

### Testing Checklist

- [ ] Manual testing completed
- [ ] `npm run lint` passes
- [ ] `npm run build` succeeds
- [ ] Security audit completed (see security-testing.md)
- [ ] All comments comprehensive
- [ ] CHANGELOG updated

### Deployment

Deploys automatically to render.com when merged to main.

**Pre-deploy checklist:**
- [ ] Environment variables set in render.com
- [ ] Database migrations applied
- [ ] No secrets in code

### Common Commands

```bash
# Run specific test
npm test -- -t "test name"

# Check types
npm run typecheck

# Security audit
npm audit --audit-level=high
```

EOF
```

2. **Reference in README**

Add this section to your project's README:

```markdown
## For AI Agents

This project follows the standards documented in the [documentation repository](https://github.com/causius0/documentation).

**Start here:** Read [AGENTS.md](./AGENTS.md) for project-specific instructions.

**Key references:**
- [Coding Standards](https://github.com/causius0/documentation/blob/main/coding-standards.md) - How to write and comment code
- [Git Workflow](https://github.com/causius0/documentation/blob/main/git-workflow.md) - Branching and merging strategy
- [Security Testing](https://github.com/causius0/documentation/blob/main/security-testing.md) - How to run security audits
```

### Usage

AI agents should:
1. Read project's `AGENTS.md` first
2. Click through links to documentation repo for detailed standards
3. Follow both project-specific and general guidelines

### Maintenance

```bash
# When documentation repo updates, just use the new links
# No local updates needed!
```

## Method 2: Git Submodule

### Setup

```bash
cd /path/to/your/project

# Add documentation as a submodule
git submodule add https://github.com/causius0/documentation.git docs/standards

# Commit the submodule
git add .gitmodules docs/standards
git commit -m "docs: add documentation standards as submodule"
```

### Create AGENTS.md

```bash
cat > AGENTS.md << 'EOF'
# Project: [Your Project Name]

> General standards are in `docs/standards/`. See [README](docs/standards/README.md) for overview.

## Project-Specific Instructions

[Your project-specific content here]

## Reference Documents

- [Coding Standards](docs/standards/coding-standards.md)
- [Tech Stack](docs/standards/tech-stack.md)
- [Git Workflow](docs/standards/git-workflow.md)
- [Security Testing](docs/standards/security-testing.md)
- [Documentation Standards](docs/standards/documentation-standards.md)
- [Dependencies Guide](docs/standards/dependencies-guide.md)

EOF
```

### Cloning Projects with Submodules

When others clone your project:

```bash
# Clone with submodules
git clone --recurse-submodules https://github.com/you/your-project.git

# Or if already cloned:
git submodule init
git submodule update
```

### Updating Submodule

```bash
# Update to latest documentation standards
cd docs/standards
git pull origin main
cd ../..

# Commit the update
git add docs/standards
git commit -m "docs: update standards to latest"
```

### Usage

AI agents can:
- Read files directly from `docs/standards/`
- No network access needed
- Version locked to specific commit

## Method 3: Direct Copy

### Setup

```bash
cd /path/to/your/project

# Create docs directory
mkdir -p docs

# Copy documentation files
# Option A: Copy from local clone
cp /path/to/documentation/*.md docs/

# Option B: Download directly
wget https://raw.githubusercontent.com/causius0/documentation/main/agents.md -O docs/agents-template.md
wget https://raw.githubusercontent.com/causius0/documentation/main/coding-standards.md -O docs/coding-standards.md
wget https://raw.githubusercontent.com/causius0/documentation/main/tech-stack.md -O docs/tech-stack.md
wget https://raw.githubusercontent.com/causius0/documentation/main/git-workflow.md -O docs/git-workflow.md
wget https://raw.githubusercontent.com/causius0/documentation/main/security-testing.md -O docs/security-testing.md
wget https://raw.githubusercontent.com/causius0/documentation/main/documentation-standards.md -O docs/documentation-standards.md
wget https://raw.githubusercontent.com/causius0/documentation/main/dependencies-guide.md -O docs/dependencies-guide.md

# Customize agents-template.md for your project
mv docs/agents-template.md AGENTS.md
# Edit AGENTS.md with project specifics

# Commit
git add docs/ AGENTS.md
git commit -m "docs: add project documentation standards"
```

### Maintenance

```bash
# Manually check for updates periodically
# Compare with documentation repo:
# https://github.com/causius0/documentation

# Update specific files when needed
cd docs
wget https://raw.githubusercontent.com/causius0/documentation/main/security-testing.md -O security-testing.md
cd ..
git add docs/security-testing.md
git commit -m "docs: update security testing guidelines"
```

## Comparison Table

| Feature | Reference | Submodule | Direct Copy |
|---------|-----------|-----------|-------------|
| **Setup Complexity** | Easy | Medium | Easy |
| **Always Up to Date** | ✅ Yes | Manual update | Manual update |
| **Works Offline** | ❌ No | ✅ Yes | ✅ Yes |
| **Single Source of Truth** | ✅ Yes | ✅ Yes | ❌ No |
| **Can Customize** | Via project AGENTS.md | No (but can extend) | ✅ Yes |
| **Git Complexity** | Low | High | Low |
| **Best For** | Active projects | Team projects | Archived projects |

## Recommended Approach by Project Type

```
┌─────────────────────────────────────────────────────────────┐
│ PROJECT TYPE              │ RECOMMENDED METHOD              │
├───────────────────────────┼─────────────────────────────────┤
│ New active project        │ Reference (Method 1)            │
│ Team collaboration        │ Submodule (Method 2)            │
│ Archived/maintenance      │ Direct Copy (Method 3)          │
│ Learning/experiments      │ Reference (Method 1)            │
│ Production apps           │ Submodule (Method 2)            │
│ Quick prototypes          │ Reference (Method 1)            │
└─────────────────────────────────────────────────────────────┘
```

## AI Agent Instructions

### When Starting New Project

```bash
# 1. Choose integration method based on project type
# 2. Set up according to method above
# 3. Create project-specific AGENTS.md
# 4. Reference documentation standards in project README
# 5. Follow the standards throughout development
```

### During Development

**Always:**
1. Check project's `AGENTS.md` first
2. Reference documentation standards for:
   - How to write code (coding-standards.md)
   - What tech to use (tech-stack.md)
   - How to manage git (git-workflow.md)
   - How to test security (security-testing.md)
   - How to document (documentation-standards.md)
   - When to add dependencies (dependencies-guide.md)

**Update project's AGENTS.md** when:
- New project-specific patterns emerge
- Commands change
- Environment variables added
- Deployment process changes

**Update documentation repo** when:
- Discover general best practices
- Find better approaches
- Encounter recurring issues across projects

## Template: Project AGENTS.md

```markdown
# Project: [Project Name]

> General coding standards: [Link to documentation repo or local docs/]

## Project Overview
[One-sentence description]

## Tech Stack
- Frontend: [Framework]
- Backend: [Framework]
- Database: [Database + ORM]
- Deployment: [Platform]
- Package Manager: [npm/pnpm/yarn]

## Quick Start

\`\`\`bash
# Setup
npm install
cp .env.example .env
# Edit .env with your values

# Development
npm run dev

# Testing
npm test

# Build & Deploy
npm run build
# Deploys automatically on merge to main
\`\`\`

## Environment Variables

See \`.env.example\`. Required variables:
- \`DATABASE_URL\` - PostgreSQL connection string
- \`JWT_SECRET\` - Secret for JWT signing
- [Add others as needed]

## Development Workflow

1. Create feature branch: \`git checkout -b feature/name\`
2. Develop with extensive comments
3. Test manually
4. Run hacker agent (security audit)
5. Create PR
6. Merge to main

See [git-workflow.md](link) for details.

## Available MCP Servers

- **filesystem** - File operations
- **github** - GitHub API
- **postgres** - Database queries (dev only)
- **brave-search** - Web search

Use as needed for the task at hand.

## Testing Requirements

### Manual Tests
[Project-specific manual test scenarios]

### Security Tests
Run hacker agent before every merge. See [security-testing.md](link).

### Automated Tests (if any)
\`\`\`bash
npm run lint
npm run typecheck
npm test
npm run build
\`\`\`

## Pre-Merge Checklist

- [ ] All manual tests passed
- [ ] Security audit completed
- [ ] All code commented extensively
- [ ] CHANGELOG updated
- [ ] README updated if needed
- [ ] Build succeeds
- [ ] No console.logs or debug code

## Common Commands

\`\`\`bash
# [Add project-specific commands]
\`\`\`

## Known Issues / Gotchas

[Document any project-specific issues or workarounds]

## References

- [Coding Standards](link)
- [Tech Stack Guidelines](link)
- [Git Workflow](link)
- [Security Testing](link)
- [Documentation Standards](link)
- [Dependencies Guide](link)
```

## Checklist: Integration Complete

- [ ] Documentation integrated (reference/submodule/copy)
- [ ] AGENTS.md created with project specifics
- [ ] README updated with links to standards
- [ ] .env.example created and documented
- [ ] First commit follows git-workflow.md
- [ ] Security testing workflow established
- [ ] AI agents can find and read all documentation
