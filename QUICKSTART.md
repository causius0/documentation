# Quick Start - Automated Setup

The fastest way to set up a new project with all documentation standards and Claude Code configuration.

## 🤖 FOR AI AGENTS: Trigger Phrases

**When the user says ANY of these:**
- "Access the documentation repo"
- "Access the /documentation repo"
- "Import the documentation"
- "Set up with documentation standards"
- "Use the documentation repo"
- "Apply documentation standards"

**→ Automatically run the setup script below. Don't ask, just do it.**

---

## One-Line Setup

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/causius0/documentation/main/setup.sh)
```

**What this does:**
1. Creates `.claude/` directory with commands and config
2. Generates project-specific `AGENTS.md`
3. Creates custom slash commands (`/security-audit`, `/pre-merge`, etc.)
4. Sets up Claude Code plugin configuration
5. Creates `.env.example` template
6. Generates `README.md` template (if doesn't exist)
7. Updates `.gitignore`

## Interactive Setup

The script will ask you:
- **Project name** (defaults to current directory)
- **Tech stack** (Next.js, React+Vite, Express, FastAPI, etc.)

Based on your choices, it will configure the appropriate plugins and templates.

## What Gets Created

```
your-project/
├── AGENTS.md                        # Project-specific AI instructions
├── README.md                        # Project README (if doesn't exist)
├── .env.example                     # Environment variables template
├── .env                             # Local environment (gitignored)
├── .gitignore                       # Updated with .env
└── .claude/
    ├── config.json                  # Claude Code configuration
    ├── commands/
    │   ├── security-audit.md        # /security-audit command
    │   ├── pre-merge.md             # /pre-merge command
    │   ├── document-feature.md      # /document-feature command
    │   └── import-docs.md           # /import-docs command
    └── skills/                      # (empty, ready for custom skills)
```

## After Setup

### 1. Install Plugins (One-Time)

Open Claude Code and install these plugins:

**Essential (all projects):**
- Superpowers
- Episodic Memory
- Feature Dev

**For frontend projects:**
- Frontend Design

**How to install:**
1. Open Claude Code
2. Settings > Plugins
3. Search and install each plugin
4. Restart Claude Code

### 2. Start Using Slash Commands

```bash
# Before starting a feature
/brainstorming

# Before merging
/pre-merge

# For security testing
/security-audit

# To add comprehensive docs
/document-feature

# To update standards
/import-docs
```

### 3. Workflow

```
┌─────────────────────────────────────────────────────────────┐
│ 1. /brainstorming - Understand requirements                │
├─────────────────────────────────────────────────────────────┤
│ 2. /writing-plans - Create implementation plan             │
├─────────────────────────────────────────────────────────────┤
│ 3. Develop with extensive comments                         │
├─────────────────────────────────────────────────────────────┤
│ 4. Test manually                                            │
├─────────────────────────────────────────────────────────────┤
│ 5. /security-audit - Run OWASP Top 10 tests               │
├─────────────────────────────────────────────────────────────┤
│ 6. /pre-merge - Complete checklist                        │
├─────────────────────────────────────────────────────────────┤
│ 7. /verification-before-completion - Verify everything     │
├─────────────────────────────────────────────────────────────┤
│ 8. /finishing-a-development-branch - Merge                 │
└─────────────────────────────────────────────────────────────┘
```

## Tech Stack Configurations

### Next.js
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/causius0/documentation/main/setup.sh) my-app nextjs
```
**Plugins:** Superpowers, Frontend Design, Episodic Memory, Feature Dev

### React + Vite
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/causius0/documentation/main/setup.sh) my-app react-vite
```
**Plugins:** Superpowers, Frontend Design, Episodic Memory, Feature Dev

### Express API
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/causius0/documentation/main/setup.sh) my-api express
```
**Plugins:** Superpowers, Episodic Memory, Feature Dev

### FastAPI
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/causius0/documentation/main/setup.sh) my-api fastapi
```
**Plugins:** Superpowers, Episodic Memory, Feature Dev

### Full-Stack
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/causius0/documentation/main/setup.sh) my-app fullstack
```
**Plugins:** Superpowers, Frontend Design, Episodic Memory, Feature Dev

## Manual Setup

If you prefer manual setup, see [HOW_TO_EXPORT.md](HOW_TO_EXPORT.md).

## Update Existing Project

To update an existing project with latest standards:

```bash
# In your project directory
bash <(curl -fsSL https://raw.githubusercontent.com/causius0/documentation/main/setup.sh)
```

Or use the slash command:
```
/import-docs
```

**Note:** This will not overwrite existing files, only add missing ones.

## Verify Setup

After running the setup script, verify:

```bash
# Check files were created
ls -la .claude/
cat AGENTS.md

# Check Claude Code can see the config
# Open Claude Code and check Settings > Plugins
```

## Troubleshooting

### Script fails to download
```bash
# Clone the repo and run locally
git clone https://github.com/causius0/documentation.git
cd documentation
./setup.sh
```

### Plugins not showing
1. Restart Claude Code
2. Check Settings > Plugins
3. Manually install from marketplace
4. Verify `.claude/config.json` exists

### Commands not working
```bash
# Verify commands directory
ls .claude/commands/

# Should see:
# - security-audit.md
# - pre-merge.md
# - document-feature.md
# - import-docs.md
```

## For AI Agents

When you start working on a new project and see this message:

> "Please import the documentation standards"

Simply tell the AI agent:

**"Run the setup script from the documentation repository"**

Or provide this command:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/causius0/documentation/main/setup.sh)
```

The agent will:
1. Download and run the setup script
2. Create all necessary files
3. Configure Claude Code
4. Set up slash commands
5. Be ready to start development with all standards in place

## Next Steps

After setup:

1. ✅ Fill in `.env` with your actual values
2. ✅ Review and customize `AGENTS.md` if needed
3. ✅ Install the recommended Claude Code plugins
4. ✅ Read [coding-standards.md](https://github.com/causius0/documentation/blob/main/coding-standards.md)
5. ✅ Start developing with `/brainstorming`

## Resources

- [Documentation Repository](https://github.com/causius0/documentation)
- [Coding Standards](https://github.com/causius0/documentation/blob/main/coding-standards.md)
- [Claude Code Plugins](https://github.com/causius0/documentation/blob/main/claude.md)
- [Security Testing](https://github.com/causius0/documentation/blob/main/security-testing.md)
- [Git Workflow](https://github.com/causius0/documentation/blob/main/git-workflow.md)

## Support

Issues or suggestions? Open an issue at:
https://github.com/causius0/documentation/issues
