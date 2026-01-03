#!/bin/bash

###############################################################################
# Documentation Setup Script
#
# Automatically sets up a project with the documentation standards from
# https://github.com/causius0/documentation
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/causius0/documentation/main/setup.sh | bash
#   or
#   bash setup.sh [project-name] [tech-stack]
#
# Examples:
#   bash setup.sh my-app nextjs
#   bash setup.sh my-api express
#   bash setup.sh                    # Interactive mode
###############################################################################

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configuration
DOCS_REPO="https://github.com/causius0/documentation"
DOCS_RAW="https://raw.githubusercontent.com/causius0/documentation/main"

###############################################################################
# Helper Functions
###############################################################################

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_header() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

###############################################################################
# Main Setup Functions
###############################################################################

setup_project_info() {
    print_header "Project Setup"

    # Get project name
    if [ -z "$PROJECT_NAME" ]; then
        read -p "Project name (default: $(basename $(pwd))): " input
        PROJECT_NAME=${input:-$(basename $(pwd))}
    fi

    # Get tech stack
    if [ -z "$TECH_STACK" ]; then
        echo ""
        echo "Select tech stack:"
        echo "  1) Next.js (React + TypeScript + Tailwind)"
        echo "  2) React + Vite (TypeScript + Tailwind)"
        echo "  3) Express (Node.js + TypeScript)"
        echo "  4) FastAPI (Python)"
        echo "  5) Full-stack (Next.js + API)"
        echo "  6) Other/Custom"
        echo ""
        read -p "Choice [1-6]: " choice

        case $choice in
            1) TECH_STACK="nextjs" ;;
            2) TECH_STACK="react-vite" ;;
            3) TECH_STACK="express" ;;
            4) TECH_STACK="fastapi" ;;
            5) TECH_STACK="fullstack" ;;
            6) TECH_STACK="custom" ;;
            *) TECH_STACK="nextjs" ;;
        esac
    fi

    print_success "Project: $PROJECT_NAME"
    print_success "Tech stack: $TECH_STACK"
}

create_claude_directory() {
    print_header "Setting up .claude/ directory"

    # Create .claude directory structure
    mkdir -p .claude/commands
    mkdir -p .claude/skills

    print_success "Created .claude/commands/"
    print_success "Created .claude/skills/"
}

download_file() {
    local url=$1
    local output=$2

    if command -v curl &> /dev/null; then
        curl -fsSL "$url" -o "$output"
    elif command -v wget &> /dev/null; then
        wget -q "$url" -O "$output"
    else
        print_error "Neither curl nor wget found. Please install one."
        exit 1
    fi
}

create_agents_md() {
    print_header "Creating AGENTS.md"

    cat > AGENTS.md << EOF
# Project: $PROJECT_NAME

> For general coding standards and guidelines, see the [documentation repository]($DOCS_REPO)

## Quick Links
- [Coding Standards]($DOCS_REPO/blob/main/coding-standards.md)
- [Claude Code Plugins]($DOCS_REPO/blob/main/claude.md)
- [Tech Stack]($DOCS_REPO/blob/main/tech-stack.md)
- [Git Workflow]($DOCS_REPO/blob/main/git-workflow.md)
- [Security Testing]($DOCS_REPO/blob/main/security-testing.md)

## Tech Stack
- **Framework:** $TECH_STACK
- **Database:** PostgreSQL (with Prisma)
- **Deployment:** render.com
- **Package Manager:** pnpm

## Dev Environment Commands

\`\`\`bash
# Install dependencies
pnpm install

# Development
pnpm run dev

# Testing
pnpm test

# Build
pnpm run build

# Lint
pnpm run lint

# Type check
pnpm run typecheck
\`\`\`

## Environment Variables

See \`.env.example\` for required variables.

## Available Claude Code Plugins

**Essential plugins to install:**
- **Superpowers** - Use /brainstorming, /verification-before-completion, /finishing-a-development-branch
- **Frontend Design** - Use for UI components (if frontend project)
- **Episodic Memory** - Recall past decisions
- **Feature Dev** - Complex feature development

See [claude.md]($DOCS_REPO/blob/main/claude.md) for detailed plugin documentation.

## Recommended Workflow

1. **/permissions** - Grant safe operation permissions (start of session)
2. **/brainstorming** - Understand requirements
3. Use **code-architect** agent - Design feature architecture
4. **/writing-plans** - Create implementation plan
5. Develop with extensive comments (see coding-standards.md)
6. Test manually
7. Run security audit (see security-testing.md)
8. Use **build-validator** agent - Validate build before commit
9. Use **code-simplifier** agent - Simplify if over-engineered
10. **/verification-before-completion** - Verify everything
11. **/requesting-code-review** - Self-review
12. **/finishing-a-development-branch** - Merge to main

## Essential Agents

- **build-validator**: Validates builds and catches errors before deployment
- **code-architect**: Designs feature architecture before implementation
- **code-simplifier**: Refactors code to be simpler and more maintainable

## Testing Checklist

- [ ] Manual testing completed
- [ ] \`pnpm run lint\` passes
- [ ] \`pnpm run typecheck\` passes
- [ ] \`pnpm run build\` succeeds
- [ ] Security audit completed (OWASP Top 10)
- [ ] All code extensively commented
- [ ] CHANGELOG updated

## Deployment

Deploys automatically to render.com when merged to main.

**Pre-deploy checklist:**
- [ ] Environment variables set in render.com
- [ ] Database migrations applied
- [ ] No secrets in code (\`git grep -i 'api.*key'\`)
- [ ] \`npm audit\` shows no high/critical vulnerabilities

## Common Commands

\`\`\`bash
# Run security audit
pnpm audit --audit-level=high

# Update dependencies
pnpm update

# Check for outdated packages
pnpm outdated
\`\`\`

## References

- [Documentation Repository]($DOCS_REPO)
- [Setup Guide]($DOCS_REPO/blob/main/HOW_TO_EXPORT.md)
EOF

    print_success "Created AGENTS.md"
}

create_slash_commands() {
    print_header "Creating custom slash commands"

    # Security audit command
    cat > .claude/commands/security-audit.md << 'EOF'
Run a complete security audit following the OWASP Top 10 checklist.

**Steps:**

1. Read the security testing guide:
   https://github.com/causius0/documentation/blob/main/security-testing.md

2. Test all OWASP Top 10 vulnerabilities:
   - Broken Access Control
   - Cryptographic Failures
   - Injection Attacks (SQL, NoSQL, Command)
   - Insecure Design
   - Security Misconfiguration
   - Vulnerable and Outdated Components
   - Identification and Authentication Failures
   - Software and Data Integrity Failures
   - Security Logging and Monitoring Failures
   - Server-Side Request Forgery (SSRF)

3. Create SECURITY_AUDIT.md documenting:
   - Vulnerabilities found
   - Severity (Critical/High/Medium/Low)
   - Attack examples that worked
   - Mitigations implemented
   - Verification of fixes

4. Fix all critical and high severity issues

5. Re-test to verify fixes work

**Output:** SECURITY_AUDIT.md with PASS/FAIL status
EOF

    # Pre-merge checklist command
    cat > .claude/commands/pre-merge.md << 'EOF'
Run the complete pre-merge checklist before creating a PR.

**Checklist:**

## Testing
- [ ] All manual tests performed and passed
- [ ] Run: pnpm run lint (must pass)
- [ ] Run: pnpm run typecheck (must pass)
- [ ] Run: pnpm run build (must succeed)
- [ ] Run: pnpm test (if tests exist, must pass)

## Security
- [ ] Security audit completed (/security-audit)
- [ ] All critical/high vulnerabilities fixed
- [ ] No secrets in code: git grep -i "api.*key"
- [ ] Run: pnpm audit --audit-level=high (no issues)

## Code Quality
- [ ] Every function has JSDoc/TSDoc comments
- [ ] Complex logic has inline comments
- [ ] All code follows coding-standards.md
- [ ] No console.logs or debug code

## Documentation
- [ ] README updated if needed
- [ ] CHANGELOG updated
- [ ] AGENTS.md updated if workflow changed
- [ ] .env.example updated if new variables

**If all pass:** Ready to create PR and merge!
EOF

    # Documentation command
    cat > .claude/commands/document-feature.md << 'EOF'
Add comprehensive documentation for the current feature.

**Steps:**

1. Add JSDoc/TSDoc to every function:
   - What it does (one-line summary)
   - Why this approach (rationale)
   - How it works (algorithm)
   - Parameters with constraints
   - Return value structure
   - Errors thrown
   - Usage examples

2. Add inline comments:
   - Explain complex logic
   - Note security measures
   - Document business rules

3. Update README:
   - Add feature to feature list
   - Include usage example
   - Document new env variables
   - Update ASCII architecture diagram

4. Update CHANGELOG:
   - Add to [Unreleased] section
   - Format: Added/Changed/Fixed/Security

5. Create testing documentation:
   - Manual test steps
   - Expected results
   - Edge cases

See: https://github.com/causius0/documentation/blob/main/documentation-standards.md
EOF

    # Import docs command
    cat > .claude/commands/import-docs.md << 'EOF'
Import or update documentation standards from the main repository.

**This command:**
1. Downloads latest documentation standards
2. Updates AGENTS.md template
3. Refreshes slash commands
4. Updates .claude/config.json

**Usage:** Run this command periodically to get latest standards.

**Manual alternative:**
bash <(curl -fsSL https://raw.githubusercontent.com/causius0/documentation/main/setup.sh)
EOF

    # Permissions command
    cat > .claude/commands/permissions.md << 'EOF'
# Permissions Configuration

Grant Claude Code permission to perform safe operations without asking for approval each time.

## Auto-Approved Operations

The following operations are pre-authorized and will not require manual approval:

### File Operations
- Read any file in the project
- Write/edit files in src/, components/, pages/, api/, lib/, utils/, styles/
- Create new files in project directories
- Delete files ONLY when explicitly requested

### Git Operations
- git status, diff, log, branch (listing/creation)
- git add (all files)
- git commit with proper messages
- git push to feature/* branches (NOT main/master)

### Build & Test
- Package installation (npm/pnpm install)
- Development server (npm run dev, pnpm run dev)
- Build (npm run build, pnpm run build)
- Linting (npm run lint, pnpm run lint)
- Type checking (npm run typecheck, pnpm run typecheck)
- Testing (npm test, pnpm test)

### Safe Commands
- File viewing (cat, less, head, tail, grep)
- File finding (ls, find, fd)
- Directory operations (cd, pwd, mkdir in project)
- Node/Python execution (project scripts only)

## NEVER Auto-Approved

These operations ALWAYS require explicit permission:

❌ git push to main/master
❌ git push --force (any branch)
❌ Destructive git operations (reset --hard, rebase -i)
❌ npm publish or deployment commands
❌ Database operations on production
❌ Deleting directories (rm -rf)
❌ Operations outside project directory
❌ System configuration changes
❌ Installing global packages

## Usage

Invoke this command at the start of each session:
```
/permissions
```

Claude Code will acknowledge these permissions and follow them for the session.

**Security:** Safe operations are pre-approved. Dangerous operations always require confirmation.
EOF

    print_success "Created /security-audit command"
    print_success "Created /pre-merge command"
    print_success "Created /document-feature command"
    print_success "Created /import-docs command"
    print_success "Created /permissions command"
}

create_claude_config() {
    print_header "Creating Claude Code configuration"

    # Determine plugins based on tech stack
    PLUGINS='"superpowers", "episodic-memory", "feature-dev"'

    if [[ "$TECH_STACK" == "nextjs" ]] || [[ "$TECH_STACK" == "react-vite" ]] || [[ "$TECH_STACK" == "fullstack" ]]; then
        PLUGINS='"superpowers", "frontend-design", "episodic-memory", "feature-dev"'
    fi

    cat > .claude/config.json << EOF
{
  "plugins": [
    {
      "name": "superpowers",
      "source": "superpowers-marketplace",
      "enabled": true
    },
    {
      "name": "episodic-memory",
      "source": "superpowers-marketplace",
      "enabled": true
    },
    {
      "name": "feature-dev",
      "source": "claude-code-plugins",
      "enabled": true
    }
EOF

    if [[ "$TECH_STACK" == "nextjs" ]] || [[ "$TECH_STACK" == "react-vite" ]] || [[ "$TECH_STACK" == "fullstack" ]]; then
        cat >> .claude/config.json << EOF
,
    {
      "name": "frontend-design",
      "source": "claude-code-plugins",
      "enabled": true
    }
EOF
    fi

    cat >> .claude/config.json << EOF

  ],
  "mcpServers": {
    "filesystem": {
      "enabled": true
    },
    "github": {
      "enabled": true
    }
  },
  "documentation": {
    "repository": "$DOCS_REPO",
    "autoImport": true
  }
}
EOF

    print_success "Created .claude/config.json"
    print_info "Recommended plugins: $PLUGINS"
}

create_gitignore() {
    print_header "Updating .gitignore"

    if [ ! -f .gitignore ]; then
        touch .gitignore
    fi

    # Add .env to gitignore if not already there
    if ! grep -q "^\.env$" .gitignore; then
        echo ".env" >> .gitignore
        print_success "Added .env to .gitignore"
    fi

    # Don't ignore .claude/ directory (we want it versioned)
    if grep -q "^\.claude" .gitignore; then
        sed -i.bak '/^\.claude/d' .gitignore
        rm .gitignore.bak 2>/dev/null || true
        print_info "Removed .claude from .gitignore (we want it versioned)"
    fi
}

create_env_example() {
    print_header "Creating .env.example"

    cat > .env.example << EOF
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# Authentication
JWT_SECRET=your-secret-key-here
JWT_EXPIRATION=1h

# API Keys (add your specific keys)
# API_KEY=your-api-key

# Environment
NODE_ENV=development
PORT=3000

# Deployment (render.com)
# Add any render.com specific variables here
EOF

    print_success "Created .env.example"

    if [ ! -f .env ]; then
        cp .env.example .env
        print_success "Created .env from template"
        print_warning "Remember to fill in your actual values in .env"
    fi
}

create_readme_template() {
    print_header "Creating README.md template"

    if [ -f README.md ]; then
        print_warning "README.md already exists, skipping"
        return
    fi

    cat > README.md << EOF
# $PROJECT_NAME

[One-sentence description of what this project does]

## Architecture

\`\`\`
[Add ASCII diagram here - see documentation-standards.md for examples]
\`\`\`

## Tech Stack

- **Framework:** $TECH_STACK
- **Database:** PostgreSQL + Prisma
- **Deployment:** render.com
- **Package Manager:** pnpm

## Quick Start

\`\`\`bash
# Install dependencies
pnpm install

# Setup environment
cp .env.example .env
# Edit .env with your values

# Development
pnpm run dev

# Build
pnpm run build
\`\`\`

## Environment Variables

See \`.env.example\` for all required variables.

## Testing

\`\`\`bash
pnpm run lint
pnpm run typecheck
pnpm test
\`\`\`

## Deployment

Automatically deploys to render.com when merged to main.

## For AI Agents

This project follows the standards from [documentation repository]($DOCS_REPO).

**Start here:** Read [AGENTS.md](./AGENTS.md)

**Key references:**
- [Coding Standards]($DOCS_REPO/blob/main/coding-standards.md)
- [Claude Code Plugins]($DOCS_REPO/blob/main/claude.md)
- [Git Workflow]($DOCS_REPO/blob/main/git-workflow.md)
- [Security Testing]($DOCS_REPO/blob/main/security-testing.md)

## License

[Your license]
EOF

    print_success "Created README.md"
}

setup_git() {
    print_header "Git Setup"

    if [ ! -d .git ]; then
        read -p "Initialize git repository? [Y/n]: " init_git
        if [[ "$init_git" != "n" ]] && [[ "$init_git" != "N" ]]; then
            git init
            print_success "Initialized git repository"
        fi
    else
        print_info "Git repository already initialized"
    fi
}

print_next_steps() {
    print_header "Setup Complete! 🎉"

    echo ""
    echo "Next steps:"
    echo ""
    echo "1. Install Claude Code plugins:"
    echo "   • Open Claude Code"
    echo "   • Settings > Plugins"
    echo "   • Install: Superpowers, Episodic Memory, Feature Dev"
    if [[ "$TECH_STACK" == "nextjs" ]] || [[ "$TECH_STACK" == "react-vite" ]] || [[ "$TECH_STACK" == "fullstack" ]]; then
        echo "   • Install: Frontend Design (for UI work)"
    fi
    echo ""
    echo "2. Review generated files:"
    echo "   • AGENTS.md - Project-specific AI agent instructions"
    echo "   • .claude/commands/ - Custom slash commands"
    echo "   • .claude/config.json - Claude Code configuration"
    echo "   • .env.example - Environment variables template"
    echo ""
    echo "3. Available slash commands:"
    echo "   • /permissions - Auto-approve safe operations (use at session start)"
    echo "   • /security-audit - Run OWASP Top 10 security tests"
    echo "   • /pre-merge - Complete pre-merge checklist"
    echo "   • /document-feature - Add comprehensive docs"
    echo "   • /import-docs - Update documentation standards"
    echo ""
    echo "4. Essential agents to use:"
    echo "   • build-validator - Validate builds before commit"
    echo "   • code-architect - Design architecture before implementing"
    echo "   • code-simplifier - Simplify over-engineered code"
    echo ""
    echo "5. Start developing:"
    echo "   • Run /permissions at start of each session"
    echo "   • Use /brainstorming before new features"
    echo "   • Use code-architect agent for complex features"
    echo "   • Follow coding-standards.md (extensive comments)"
    echo "   • Use build-validator agent before commits"
    echo "   • Run /pre-merge before creating PRs"
    echo "   • Use /verification-before-completion before merging"
    echo ""
    echo "Documentation: $DOCS_REPO"
    echo ""
}

###############################################################################
# Main
###############################################################################

main() {
    print_header "Documentation Setup Script"
    echo "Setting up project with coding standards from:"
    echo "$DOCS_REPO"
    echo ""

    # Get project info
    PROJECT_NAME="$1"
    TECH_STACK="$2"
    setup_project_info

    # Run setup steps
    create_claude_directory
    create_agents_md
    create_slash_commands
    create_claude_config
    create_gitignore
    create_env_example
    create_readme_template
    setup_git

    # Print next steps
    print_next_steps
}

# Run main function
main "$@"
