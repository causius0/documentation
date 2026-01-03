# AI Agent Documentation Repository

This repository contains standardized documentation templates and guidelines that AI agents should reference when working on projects. It serves as a knowledge base to kickstart development, maintain consistency, and ensure best practices across all projects.

## Purpose

- Provide AI agents with immediate context about project structure and conventions
- Standardize development practices across all repositories
- Reduce setup time and cognitive load when starting new tasks
- Maintain a single source of truth for development guidelines

## Repository Structure

```
documentation/
├── README.md                      # This file - overview and quick start
├── QUICKSTART.md                  # ⚡ Automated setup (ONE-LINE INSTALL)
├── agents.md                      # AI agent instructions and MCP servers
├── claude.md                      # Claude Code plugins, skills, workflows
├── coding-standards.md            # Code style, comments, philosophy
├── tech-stack.md                  # Technology choices and rationale
├── git-workflow.md                # Branching, commits, PRs
├── security-testing.md            # Hacker agent and OWASP Top 10
├── documentation-standards.md     # README format, JSDoc, ASCII art
├── dependencies-guide.md          # When/how to add dependencies
├── HOW_TO_EXPORT.md              # Manual integration guide
└── setup.sh                       # Automated setup script
```

## Quick Start ⚡

**The fastest way to use this in your project:**

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/causius0/documentation/main/setup.sh)
```

This one command:
1. Creates `.claude/` with config and slash commands
2. Generates `AGENTS.md` for your project
3. Sets up `/security-audit`, `/pre-merge`, `/document-feature` commands
4. Configures recommended Claude Code plugins
5. Creates `.env.example` and `README.md` templates

**Then:** Install recommended plugins in Claude Code (Superpowers, Episodic Memory, Feature Dev, Frontend Design)

**See [QUICKSTART.md](QUICKSTART.md) for detailed instructions.**

## Core Documentation Files

### 1. agents.md
**The AI agent playbook.** Start here for every project.

Contains:
- Project-specific commands and shortcuts
- MCP servers available and when to use them
- Multi-agent coordination (Claude Code + Gemini 3 Pro)
- Error handling patterns
- Testing requirements
- Deployment checklist

**When to read:** Beginning of every work session

### 2. claude.md
**Claude Code-specific features and plugins.**

Contains:
- Essential plugins (Superpowers, Frontend Design, Episodic Memory, Feature Dev)
- When and how to use each plugin
- Custom skills and slash commands
- Enhanced workflows with plugins
- Integration with Gemini 3 Pro (handoff protocols)
- Plugin installation and troubleshooting

**When to read:** When using Claude Code (recommended primary agent)

### 3. coding-standards.md
**How to write code that's easy to learn from.**

Contains:
- Extensive commenting requirements (what, why, how)
- Code documentation examples
- Learning-focused development
- Testing approach
- Pre-deployment checklist

**When to read:** Before writing any code

### 4. tech-stack.md
**What technologies to use and why.**

Contains:
- Preferred tech stack with rationale
- Framework choices (React, Next.js, FastAPI)
- Database selection (PostgreSQL + Prisma)
- Deployment platform (render.com)
- Package manager (pnpm preferred)

**When to read:** Starting new project or adding new features

### 5. git-workflow.md
**Branch, test, merge workflow.**

Contains:
- Branching strategy (always branch, never merge directly to main)
- Pre-merge checklist
- Commit message format
- PR creation workflow
- Branch protection rules

**When to read:** Before creating branches or making commits

### 6. security-testing.md
**The hacker agent protocol.**

Contains:
- OWASP Top 10 testing checklist
- Attack vectors and mitigations
- Security audit template
- Common vulnerability patterns to avoid
- When and how to run security tests

**When to read:** Before merging any feature

### 7. documentation-standards.md
**How to document code and projects.**

Contains:
- README format with ASCII art examples
- JSDoc/TSDoc templates
- Function and variable documentation
- Inline comment guidelines
- CHANGELOG format

**When to read:** When creating documentation

### 8. dependencies-guide.md
**When to add dependencies and which ones.**

Contains:
- Decision framework for adding dependencies
- Recommended vs. avoided packages
- Security best practices
- Bundle size considerations
- Dependency hygiene

**When to read:** Before installing any package

## How to Use This Repository

### For New Projects

See [HOW_TO_EXPORT.md](HOW_TO_EXPORT.md) for detailed instructions.

**Quick version:**
```bash
# 1. Copy the AGENTS.md template to your project
cp documentation/agents.md /path/to/project/AGENTS.md

# 2. Customize it for your project's specifics

# 3. Reference this repo for standards as you develop
```

### For AI Agents (Claude Code / Gemini 3 Pro)

**On every work session:**

1. **Read AGENTS.md** - Check project-specific instructions
2. **Follow coding-standards.md** - Comment extensively, explain choices
3. **Follow git-workflow.md** - Create branch, test, security audit, merge
4. **Reference tech-stack.md** - Use recommended technologies
5. **Before merging:** Security audit (security-testing.md)
6. **Document everything** - Follow documentation-standards.md

**Workflow diagram:**
```
Start work
    ↓
Read AGENTS.md in project (or this repo if no AGENTS.md exists)
    ↓
Create feature branch (git-workflow.md)
    ↓
Develop with extensive comments (coding-standards.md)
    ↓
Add dependencies if needed (dependencies-guide.md)
    ↓
Manual testing
    ↓
Run hacker agent (security-testing.md)
    ↓
Fix vulnerabilities
    ↓
Update docs (documentation-standards.md)
    ↓
Create PR and merge
```

## Integration with Projects

### Option 1: Reference (Recommended)
- Keep this repo separate
- Link to it from project READMEs
- Copy AGENTS.md template to each project
- Always check this repo for latest standards

### Option 2: Git Submodule
```bash
# Add as submodule
cd your-project
git submodule add https://github.com/causius0/documentation.git docs

# Update submodule
git submodule update --remote docs
```

### Option 3: Direct Copy
```bash
# Copy specific files you need
cp -r documentation/* /path/to/project/docs/
```

## Maintenance

This is a **living repository**. Update it whenever you:

✅ Discover new best practices
✅ Encounter recurring issues
✅ Develop new patterns or approaches
✅ Learn from project retrospectives
✅ Find better tools or libraries
✅ Experience security incidents
✅ Get feedback from code reviews

**Update protocol:**
1. Create feature branch in this repo
2. Update relevant documentation
3. Test on active project
4. Create PR
5. Merge and propagate to other projects

## Quick Reference Card

| Task | File to Check |
|------|---------------|
| **New project setup** | **QUICKSTART.md** ⚡ |
| Starting work | agents.md |
| Using Claude Code | claude.md |
| Writing code | coding-standards.md |
| Choosing tech | tech-stack.md |
| Creating branch | git-workflow.md |
| Adding package | dependencies-guide.md |
| Security testing | security-testing.md |
| Writing docs | documentation-standards.md |
| Manual integration | HOW_TO_EXPORT.md |

## Philosophy

This documentation exists because:

1. **Consistent quality** - Every project follows the same high standards
2. **Faster onboarding** - AI agents (and humans) can start immediately
3. **Learning-focused** - Extensive comments teach while you code
4. **Security-first** - Every feature tested by hacker agent
5. **Optimal tech** - Don't limit learning, use modern best practices
6. **Multi-agent ready** - Claude Code and Gemini 3 Pro stay aligned

## Contributing

Found something that works better? Encountered an issue? Update this documentation!

1. Create branch: `git checkout -b docs/your-improvement`
2. Make changes
3. Test on a real project
4. Create PR with explanation
5. Update other projects once merged
