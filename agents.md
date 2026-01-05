# AI Agents Guide

This file contains essential context and workflow instructions for AI agents working on projects.

## 🤖 AUTO-SETUP TRIGGER (Claude Code & Gemini)

**When the user says:**
- "Access the documentation repo"
- "Access the /documentation repo"
- "Import the documentation"
- "Set up with documentation standards"
- "Use the documentation repo"
- "Apply documentation standards"

**→ Immediately run:**
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/causius0/documentation/main/setup.sh)
```

**Then:**
- Run `/permissions` (if Claude Code)
- Inform user setup is complete
- List slash commands created
- Explain essential agents available

**No confirmation needed - this is the user's trigger to set up everything automatically.**

---

## 📖 CRITICAL: Always Read README.md First

**When starting work on ANY repository:**

1. **Immediately read README.md**
   - Understand what the project does
   - Learn how to run it
   - Get important context

2. **Then read AGENTS.md** (if it exists)
   - Project-specific commands
   - Custom workflows

**DO NOT start coding without reading README.md first.**

---

## ⚠️ Token Limit Management (Claude Code)

**When you reach 80% of token limit (~160,000 tokens):**
- Stop and warn the user
- Provide status update
- Offer handoff options

**At 90% token limit (~180,000 tokens):**
- Immediately alert user
- Create handoff notes
- Prepare for session end

**Never let tokens run out mid-task without warning.**

See [claude.md](claude.md) for detailed token management protocol.

---

## 🌿 CRITICAL: Always Create Feature Branches

**NEVER work directly on main.**

**For EVERY feature:**
1. Create branch first: `git checkout -b feature/descriptive-name`
2. Do all work on the branch
3. Test thoroughly
4. Merge to main only when complete

**Branch naming:**
- `feature/` - New features
- `fix/` - Bug fixes
- `refactor/` - Code refactoring
- `docs/` - Documentation
- `security/` - Security fixes

---

## 🧪 CRITICAL: Always Test with Sample Material

**When given sample data:**
1. Use EXACT sample material provided
2. Test with it as-is first
3. Test edge cases (empty, large, invalid)
4. Document test results
5. If fails, fix and re-test

**Never skip testing with provided samples.**

---

## Purpose

Provide AI agents with:
- Environment-specific commands and shortcuts
- Testing procedures and requirements
- PR/commit conventions
- Project-specific gotchas and tips

**For Claude Code users:** See [claude.md](claude.md) for Claude Code-specific plugins, skills, and enhanced workflows.

**For Gemini users:** See [gemini.md](gemini.md) for Gemini-specific instructions and workflows.

**Important:** Claude Code and Gemini work on **separate features** independently. Each agent owns complete features from start to finish - no handoffs between agents.

## Sample AGENTS.md Template

Below is an example for a pnpm monorepo with Turbo:

---

# Sample AGENTS.md file

## Dev environment tips
- Use `pnpm dlx turbo run where <project_name>` to jump to a package instead of scanning with `ls`.
- Run `pnpm install --filter <project_name>` to add the package to your workspace so Vite, ESLint, and TypeScript can see it.
- Use `pnpm create vite@latest <project_name> -- --template react-ts` to spin up a new React + Vite package with TypeScript checks ready.
- Check the name field inside each package's package.json to confirm the right name—skip the top-level one.

## Testing instructions
- Find the CI plan in the .github/workflows folder.
- Run `pnpm turbo run test --filter <project_name>` to run every check defined for that package.
- From the package root you can just call `pnpm test`. The commit should pass all tests before you merge.
- To focus on one step, add the Vitest pattern: `pnpm vitest run -t "<test name>"`.
- Fix any test or type errors until the whole suite is green.
- After moving files or changing imports, run `pnpm lint --filter <project_name>` to be sure ESLint and TypeScript rules still pass.
- Add or update tests for the code you change, even if nobody asked.

## PR instructions
- Title format: [<project_name>] <Title>
- Always run `pnpm lint` and `pnpm test` before committing.

---

## Templates for Different Project Types

### Next.js Project
```markdown
## Dev environment tips
- Run `npm run dev` to start the development server
- Use `npm run build` to verify production builds locally
- Check `.env.local` for environment variables

## Testing instructions
- Run `npm test` for unit tests
- Run `npm run test:e2e` for end-to-end tests
- Run `npm run typecheck` for TypeScript validation

## PR instructions
- Title format: feat|fix|docs|refactor: description
- Always run build and tests before committing
```

### Python Project
```markdown
## Dev environment tips
- Activate virtual environment: `source venv/bin/activate`
- Install dependencies: `pip install -r requirements.txt`
- Run with: `python main.py`

## Testing instructions
- Run `pytest` for all tests
- Run `pytest -k test_name` for specific tests
- Run `mypy .` for type checking
- Run `ruff check .` for linting

## PR instructions
- Follow conventional commits format
- Ensure all tests pass and coverage is maintained
```

## Best Practices for AGENTS.md

1. **Keep it concise** - Only essential commands and workflows
2. **Project-specific** - Tailor to your actual tech stack
3. **Command-focused** - Provide exact commands agents should run
4. **Testing-centric** - Make it clear how to verify changes
5. **Updated regularly** - Reflect current project state

## When to Create AGENTS.md

Create this file when:
- Starting a new project
- Onboarding becomes repetitive
- You notice AI agents making the same mistakes
- Project conventions solidify

## MCP (Model Context Protocol) Servers

AI agents should have access to all available MCP servers. List them in AGENTS.md so agents can choose the appropriate tools for the task.

### Common MCP Servers

**File System & Search:**
- `@modelcontextprotocol/server-filesystem` - File operations
- `@modelcontextprotocol/server-everything` - Universal search across files

**Development:**
- `@modelcontextprotocol/server-github` - GitHub API access
- `@modelcontextprotocol/server-gitlab` - GitLab API access
- `@modelcontextprotocol/server-git` - Git operations

**Databases:**
- `@modelcontextprotocol/server-postgres` - PostgreSQL queries
- `@modelcontextprotocol/server-sqlite` - SQLite operations
- `@modelcontextprotocol/server-mongodb` - MongoDB operations

**Web & APIs:**
- `@modelcontextprotocol/server-brave-search` - Web search
- `@modelcontextprotocol/server-fetch` - HTTP requests
- `@modelcontextprotocol/server-puppeteer` - Browser automation

**AI & Processing:**
- `@modelcontextprotocol/server-memory` - Persistent memory across sessions
- `@modelcontextprotocol/server-sequential-thinking` - Complex reasoning

### Including MCPs in AGENTS.md

Add this section to your project's AGENTS.md:

```markdown
## Available MCP Servers

This project has the following MCP servers configured:

### Active Servers
- **filesystem** - For file operations beyond code editor
- **github** - GitHub API for issues, PRs, releases
- **postgres** - Direct database queries (use with caution)
- **brave-search** - Web search for documentation and solutions

### When to Use Each MCP

**filesystem MCP:**
- Bulk file operations (rename, move many files)
- Complex file tree analysis
- Binary file operations

**github MCP:**
- Creating issues from errors
- Fetching PR details
- Managing releases
- Checking CI status

**postgres MCP:**
- Data analysis queries
- Database migrations
- Schema inspection
- Performance analysis (EXPLAIN queries)

**brave-search MCP:**
- Finding documentation for unfamiliar libraries
- Researching error messages
- Looking up best practices
- Checking for known issues/bugs

### Security Note
- Only use database MCPs in development
- Never expose MCP credentials in code
- Document which MCPs are required in README
```

## Multi-Agent Coordination

### Separate Feature Ownership

**Important principle:** Claude Code and Gemini work on **separate features independently**. There are NO handoffs between agents.

**How it works:**
- Each agent owns a complete feature from start to finish
- Claude Code works on Feature A
- Gemini works on Feature B
- Both follow the same documentation standards
- Both create separate branches
- Both merge independently to main

### Common Standards (Both Agents)

Both Claude Code and Gemini must:
1. **Use the same terminology** - Consistent naming across the codebase
2. **Follow the same patterns** - Same file structure, code style
3. **Document extensively** - Comprehensive comments (coding-standards.md)
4. **Reference AGENTS.md** - Always check project-specific instructions
5. **Follow git-workflow.md** - Same branching and PR process
6. **Run security audits** - OWASP Top 10 for every feature
7. **Update AGENTS.md** - Document new patterns as they emerge

### Agent-Specific Capabilities

**Claude Code has:**
- Plugins (Superpowers, Frontend Design, etc.)
- Custom skills and slash commands
- MCP servers
- See [claude.md](claude.md) for details

**Gemini has:**
- Manual testing and validation workflows
- Direct documentation reference
- See [gemini.md](gemini.md) for details

### File Access Rules

**CRITICAL:**
- Claude Code agents: Read [claude.md](claude.md), do NOT read gemini.md
- Gemini agents: Read [gemini.md](gemini.md), do NOT read claude.md
- Both agents: Read all other documentation files (coding-standards.md, etc.)

## Error Handling Requirements

AI agents must implement both **user-friendly** and **developer-friendly** error handling:

```typescript
/**
 * Error handling pattern: Dual-mode errors
 *
 * User mode: Simple, actionable message
 * Developer mode: Full details, stack trace, context
 */
class AppError extends Error {
  constructor(
    public userMessage: string,      // User-friendly
    public developerMessage: string,  // Technical details
    public code: string,              // Error code for lookup
    public statusCode: number = 500,
    public context?: Record<string, any> // Debug context
  ) {
    super(developerMessage);
    this.name = this.constructor.name;
  }
}

// Usage
throw new AppError(
  'Unable to process payment. Please try again.',
  'Stripe API returned 402: Insufficient funds in test mode',
  'PAYMENT_FAILED',
  402,
  { userId: '123', amount: 50, stripeError: 'insufficient_funds' }
);
```

### Error Response Format

```typescript
// API error response structure
interface ErrorResponse {
  error: {
    message: string;           // User-friendly message
    code: string;              // Error code (PAYMENT_FAILED, etc.)
    statusCode: number;        // HTTP status code
    timestamp: string;         // When error occurred
    requestId: string;         // For tracing
    details?: {                // Only in development
      developerMessage: string;
      stack?: string;
      context?: Record<string, any>;
    };
  };
}
```

### Error Handling Checklist

AI agents must:
- [ ] Catch all errors (no unhandled rejections)
- [ ] Provide user-friendly messages
- [ ] Log detailed errors for debugging
- [ ] Include context (user ID, request ID, etc.)
- [ ] Hide stack traces in production
- [ ] Return appropriate HTTP status codes
- [ ] Add error tracking (Sentry, LogRocket, etc.)

## Testing Requirements

### Before Every Merge

1. **Manual Testing**
   - Test happy path
   - Test error cases
   - Test edge cases (empty inputs, large inputs, special characters)
   - Test on actual deployment environment (render.com preview)

2. **Automated Testing** (if tests exist)
   ```bash
   npm run lint          # Linting must pass
   npm run typecheck     # No TypeScript errors
   npm test              # All tests pass
   npm run build         # Build succeeds
   ```

3. **Security Testing**
   - Run hacker agent (see security-testing.md)
   - Fix all critical/high vulnerabilities
   - Document security measures taken

### Test Documentation

Every feature needs testing instructions:

```markdown
## Testing: User Authentication

### Manual Test Steps

1. **Registration Flow**
   - Navigate to /register
   - Enter email: test@example.com
   - Enter password: SecurePass123!
   - Click Register
   - ✅ Expected: Redirected to dashboard
   - ✅ Expected: JWT token stored in localStorage

2. **Login Flow**
   - Navigate to /login
   - Enter registered credentials
   - Click Login
   - ✅ Expected: Redirected to dashboard

3. **Protected Route**
   - Clear localStorage (simulate logged out)
   - Try to access /dashboard
   - ✅ Expected: Redirected to /login

4. **Error Cases**
   - Try weak password: "123"
   - ✅ Expected: "Password must be at least 12 characters"
   - Try existing email
   - ✅ Expected: "Email already registered"
   - Try invalid email format
   - ✅ Expected: "Invalid email format"

### Security Tests (Hacker Agent)

- [x] SQL injection in email field - BLOCKED
- [x] XSS in name field - SANITIZED
- [x] Brute force login - RATE LIMITED (5 attempts/15min)
- [x] JWT token manipulation - REJECTED (signature invalid)
- [x] Password complexity bypass - ENFORCED

See SECURITY_AUDIT.md for details.
```

## Deployment Checklist

Before deploying to render.com:

```markdown
- [ ] All tests pass locally
- [ ] Build succeeds: `npm run build`
- [ ] Environment variables documented in .env.example
- [ ] Environment variables set in render.com dashboard
- [ ] Database migrations applied
- [ ] Security audit completed and vulnerabilities fixed
- [ ] README updated with new features
- [ ] CHANGELOG updated
- [ ] No console.logs or debug code
- [ ] No secrets in code (check with `git grep -i 'api.*key'`)
- [ ] Dependencies locked (package-lock.json or pnpm-lock.yaml committed)
- [ ] No high/critical npm vulnerabilities: `npm audit`
```

## AI Agent Daily Workflow

```
1. Check AGENTS.md for project-specific instructions
2. Read relevant documentation files (coding-standards.md, tech-stack.md)
3. Create feature branch
4. Develop with extensive comments
5. Test manually
6. Run hacker agent (security audit)
7. Fix vulnerabilities
8. Update documentation
9. Create PR
10. Merge to main
11. Deploy (if ready)
```

## Quick Reference

| Task | Tool/Command |
|------|--------------|
| Find project commands | Check package.json scripts |
| Environment setup | Copy .env.example to .env |
| Install dependencies | npm install / pnpm install |
| Run development | npm run dev |
| Run tests | npm test |
| Check types | npm run typecheck / tsc --noEmit |
| Lint code | npm run lint |
| Build | npm run build |
| Security audit | npm audit |
| Create branch | git checkout -b feature/name |
| Create PR | gh pr create |
| Deploy | render.com auto-deploys from main |
