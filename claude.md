# Claude Code Specific Guide

This file contains Claude Code-specific features, plugins, and skills that enhance the development workflow.

## Why Claude Code?

Claude Code is the **primary AI agent** for this workflow because:
- Native integration with development tools
- Built-in skills for common workflows
- Plugin ecosystem for extensibility
- Better context retention across sessions
- Optimized for coding tasks

**Gemini 3 Pro** is used as a fallback when Claude Code is unavailable.

## Built-in Features

### 1. Tool Integration

Claude Code has native access to:
- **File operations** (Read, Write, Edit, Glob, Grep)
- **Git operations** (via Bash tool with gh CLI)
- **Terminal** (Bash tool for commands)
- **Web access** (WebFetch, WebSearch)
- **Task management** (TodoWrite for tracking)
- **Jupyter notebooks** (NotebookEdit, NotebookRead)

### 2. Slash Commands

Custom slash commands can be created in `.claude/commands/`:

```bash
# Example: Create a security audit command
mkdir -p .claude/commands
cat > .claude/commands/security-audit.md << 'EOF'
Run a complete security audit following security-testing.md:

1. Test all OWASP Top 10 vulnerabilities
2. Document findings in SECURITY_AUDIT.md
3. Fix all critical and high severity issues
4. Re-test to verify fixes
5. Update README with security status
EOF
```

**Usage:**
```
/security-audit
```

## Essential Plugins

### Installation

```bash
# Plugins are installed via Claude Code settings or CLI
# See https://docs.claude.ai/claude-code for installation guide
```

### Recommended Plugins

#### 1. **Superpowers** (Highly Recommended)
**Plugin ID:** `superpowers@superpowers-marketplace`

**What it does:**
- Advanced development workflow automation
- Planning and execution skills
- Code review and debugging workflows
- Test-driven development support
- Git worktree management

**Available Skills:**
```
┌─────────────────────────────────────────────────────────────┐
│ SUPERPOWERS SKILLS                                          │
├─────────────────────────────────────────────────────────────┤
│ brainstorming              - Explore requirements before    │
│                              implementation                 │
│ writing-plans              - Create detailed implementation │
│                              plans                          │
│ executing-plans            - Execute plans with checkpoints │
│ test-driven-development    - TDD workflow (test first)      │
│ systematic-debugging       - Debug issues methodically      │
│ requesting-code-review     - Request comprehensive reviews  │
│ receiving-code-review      - Handle review feedback         │
│ verification-before-       - Verify work before completion  │
│   completion                                                │
│ finishing-a-development-   - Guided merge/PR/cleanup        │
│   branch                                                    │
│ using-git-worktrees        - Isolated feature development   │
│ subagent-driven-          - Execute plans with subagents   │
│   development                                               │
│ dispatching-parallel-      - Run independent tasks in       │
│   agents                     parallel                       │
│ writing-skills             - Create custom skills           │
└─────────────────────────────────────────────────────────────┘
```

**When to use:**

```typescript
/**
 * USE SUPERPOWERS WHEN:
 *
 * 1. Starting new features
 *    Skill: brainstorming -> writing-plans -> executing-plans
 *
 * 2. Implementing with tests
 *    Skill: test-driven-development
 *
 * 3. Debugging issues
 *    Skill: systematic-debugging
 *
 * 4. Before completing work
 *    Skill: verification-before-completion
 *
 * 5. Ready to merge
 *    Skill: finishing-a-development-branch
 *
 * 6. Need isolation
 *    Skill: using-git-worktrees
 *
 * 7. Multiple independent tasks
 *    Skill: dispatching-parallel-agents
 */
```

**Integration with our workflow:**

```markdown
## Feature Development Workflow with Superpowers

1. **/brainstorming**
   - Explore requirements and design
   - Clarify user intent
   - Plan architecture

2. **/writing-plans**
   - Create detailed implementation plan
   - Break into subtasks
   - Identify dependencies

3. **/test-driven-development** (if applicable)
   - Write tests first
   - Implement to pass tests
   - Refactor

4. **/executing-plans** OR **/subagent-driven-development**
   - Execute the plan step by step
   - Use subagents for parallel work

5. **/systematic-debugging** (if issues arise)
   - Methodical bug investigation
   - Root cause analysis
   - Fix verification

6. Run hacker agent (security-testing.md)
   - OWASP Top 10 audit
   - Fix vulnerabilities

7. **/verification-before-completion**
   - Run all tests
   - Verify build succeeds
   - Check comments are comprehensive

8. **/requesting-code-review**
   - Self-review before merge
   - Check adherence to standards

9. **/finishing-a-development-branch**
   - Guided merge process
   - PR creation
   - Cleanup
```

#### 2. **Frontend Design** (Recommended for UI work)
**Plugin ID:** `frontend-design@claude-code-plugins`

**What it does:**
- Creates production-grade frontend interfaces
- Avoids generic AI aesthetics
- Generates polished, distinctive designs

**When to use:**
- Building web components
- Creating new pages
- Designing user interfaces
- Need creative, non-generic UI

**Integration:**
```markdown
## UI Development Workflow

1. **/brainstorming** (Superpowers)
   - Understand UI requirements
   - Explore design options

2. **/frontend-design**
   - Generate distinctive, polished UI
   - Modern design patterns
   - Production-ready code

3. Add extensive comments (coding-standards.md)
   - Explain component structure
   - Document props and state
   - Note design decisions

4. Test manually
   - Visual regression testing
   - Responsive design check
   - Accessibility check

5. Security audit
   - XSS protection in user inputs
   - Proper sanitization
```

#### 3. **Episodic Memory** (Useful for ongoing projects)
**Plugin ID:** `episodic-memory@superpowers-marketplace`

**What it does:**
- Searches conversation history
- Recalls past decisions and solutions
- Helps with "how should I..." questions

**When to use:**
- "How did we solve X before?"
- "What's the best approach for Y?"
- Stuck on a problem solved previously
- Unfamiliar workflows

**Example:**
```
User: "How should I handle authentication in this project?"

Assistant uses episodic-memory to search past conversations:
- Finds previous discussion about JWT vs sessions
- Recalls we chose bcrypt for password hashing
- References 12 salt rounds decision
- Applies consistent pattern
```

#### 4. **Feature Dev** (For complex features)
**Plugin ID:** `feature-dev@claude-code-plugins`

**What it does:**
- Guided feature development
- Codebase exploration and understanding
- Architecture-focused implementation
- Code review with confidence filtering

**Available Skills:**
```
/feature-dev:feature-dev     - Guided feature development
```

**Available Agents:**
```
code-explorer     - Deep codebase analysis
code-architect    - Architecture design
code-reviewer     - Bug and security review
```

**When to use:**
- Large, complex features
- Need to understand existing codebase first
- Want architecture guidance
- Need comprehensive code review

**Workflow:**
```markdown
1. **/feature-dev** or use code-explorer agent
   - Analyze existing codebase
   - Understand patterns and conventions
   - Map dependencies

2. Use code-architect agent
   - Design feature architecture
   - Plan implementation
   - Identify files to modify

3. Implement feature
   - Follow discovered patterns
   - Maintain consistency
   - Comment extensively

4. Use code-reviewer agent
   - Review for bugs
   - Check security issues
   - Verify quality

5. Run hacker agent (our security-testing.md)
   - Additional security layer
   - OWASP Top 10 specific tests
```

#### 5. **Agent SDK Dev** (For building AI agents)
**Plugin ID:** `agent-sdk-dev@claude-code-plugins`

**What it does:**
- Create Claude Agent SDK applications
- Verify SDK apps are properly configured
- Follow SDK best practices

**When to use:**
- Building custom AI agents
- Creating agent-powered tools
- Need SDK verification

**Available:**
```
/agent-sdk-dev:new-sdk-app <name>   - Create new SDK app
agent-sdk-verifier-py               - Verify Python SDK apps
agent-sdk-verifier-ts               - Verify TypeScript SDK apps
```

## Plugin Installation Guide

### Via Claude Code UI

1. Open Claude Code
2. Go to Settings > Plugins
3. Search for plugin (e.g., "superpowers")
4. Click Install
5. Restart Claude Code if prompted

### Via Configuration File

Edit `.claude/config.json`:

```json
{
  "plugins": [
    {
      "name": "superpowers",
      "source": "superpowers-marketplace",
      "enabled": true
    },
    {
      "name": "frontend-design",
      "source": "claude-code-plugins",
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
  ]
}
```

## Recommended Plugin Setup

### For General Development
```json
{
  "plugins": [
    "superpowers",           // Essential workflows
    "episodic-memory",       // Remember past decisions
    "feature-dev"            // Complex features
  ]
}
```

### For Frontend Projects
```json
{
  "plugins": [
    "superpowers",           // Essential workflows
    "frontend-design",       // UI generation
    "episodic-memory",       // Past decisions
    "feature-dev"            // Complex features
  ]
}
```

### For AI Agent Development
```json
{
  "plugins": [
    "superpowers",           // Essential workflows
    "agent-sdk-dev",         // SDK support
    "episodic-memory"        // Past decisions
  ]
}
```

## Custom Skills

You can create project-specific skills in `.claude/skills/`:

### Example: Security Audit Skill

```markdown
<!-- .claude/skills/security-audit.md -->
# Security Audit Skill

Run comprehensive security testing following OWASP Top 10.

## Instructions

1. Read security-testing.md from documentation repo
2. Test all 10 OWASP vulnerabilities:
   - Broken Access Control
   - Cryptographic Failures
   - Injection Attacks
   - Insecure Design
   - Security Misconfiguration
   - Vulnerable Components
   - Authentication Failures
   - Data Integrity Failures
   - Logging Failures
   - SSRF

3. For each vulnerability:
   - Attempt exploit
   - Document if successful
   - Provide mitigation
   - Verify fix

4. Create SECURITY_AUDIT.md with findings

5. Fix all critical and high severity issues

6. Re-test to verify fixes

## Output

- SECURITY_AUDIT.md report
- All critical vulnerabilities fixed
- Clear status (PASS/FAIL)
```

### Example: Comprehensive Documentation Skill

```markdown
<!-- .claude/skills/document-feature.md -->
# Document Feature Skill

Add comprehensive documentation for a feature.

## Instructions

1. Read the feature code thoroughly

2. Add JSDoc/TSDoc to every function:
   - What it does (one-line summary)
   - Why this approach (rationale)
   - How it works (algorithm/steps)
   - Parameters with constraints
   - Return value structure
   - Errors thrown
   - Usage examples

3. Add inline comments:
   - Explain complex logic
   - Note security measures
   - Document business rules
   - Explain non-obvious code

4. Update README:
   - Add feature to feature list
   - Include usage example
   - Document new env variables
   - Update ASCII architecture diagram if needed

5. Update CHANGELOG:
   - Add to [Unreleased] section
   - Follow format: Added/Changed/Fixed/Security

6. Create/update testing documentation:
   - Manual test steps
   - Expected results
   - Edge cases to test

## Checklist

- [ ] All functions have JSDoc/TSDoc
- [ ] All variables documented
- [ ] Complex logic has inline comments
- [ ] README updated
- [ ] CHANGELOG updated
- [ ] Testing docs created/updated
- [ ] ASCII diagrams added where helpful
```

## Integration with Gemini 3 Pro

When using Gemini 3 Pro as fallback:

### What Gemini 3 Pro CAN do:
✅ Follow coding-standards.md (extensive comments)
✅ Use tech-stack.md (technology choices)
✅ Follow git-workflow.md (branching strategy)
✅ Perform security testing (OWASP checklist)
✅ Write comprehensive documentation
✅ Add dependencies following dependencies-guide.md

### What Gemini 3 Pro CANNOT do:
❌ Use Claude Code plugins (Superpowers, etc.)
❌ Execute custom slash commands
❌ Access Claude Code skills
❌ Use MCP servers (Claude Code specific)

### Handoff Protocol

**Claude Code → Gemini 3 Pro:**
```typescript
/**
 * AGENT HANDOFF: Claude Code → Gemini 3 Pro
 *
 * Date: [date]
 * Branch: [branch name]
 *
 * Completed by Claude Code:
 * - [List completed work]
 * - Used plugins: [list plugins used]
 *
 * Next steps for Gemini 3 Pro:
 * - [ ] [Task 1] - Follow coding-standards.md
 * - [ ] [Task 2] - Follow git-workflow.md
 * - [ ] [Task 3] - Run security audit (security-testing.md)
 *
 * Important context:
 * - Cannot use Claude Code plugins
 * - Must follow all documentation standards
 * - Comment extensively (see coding-standards.md)
 * - Run hacker agent manually (OWASP Top 10 checklist)
 *
 * References:
 * - Coding standards: [link to coding-standards.md]
 * - Security testing: [link to security-testing.md]
 * - Git workflow: [link to git-workflow.md]
 */
```

**Gemini 3 Pro → Claude Code:**
```typescript
/**
 * AGENT HANDOFF: Gemini 3 Pro → Claude Code
 *
 * Date: [date]
 * Branch: [branch name]
 *
 * Completed by Gemini 3 Pro:
 * - [List completed work]
 * - Followed: coding-standards.md, git-workflow.md
 * - Security audit: [PASS/FAIL with details]
 *
 * Next steps for Claude Code:
 * - [ ] [Task 1] - Can use Superpowers skills
 * - [ ] [Task 2] - Can leverage MCP servers
 * - [ ] [Task 3] - Use custom slash commands
 *
 * Recommendations:
 * - Consider using /verification-before-completion
 * - Use /finishing-a-development-branch for merge
 * - Leverage episodic-memory for context
 *
 * All code is fully commented as per coding-standards.md
 */
```

## Best Practices

### 1. Plugin Usage

```markdown
✅ DO:
- Use Superpowers for every significant feature
- Start with /brainstorming before implementation
- Use /verification-before-completion before merging
- Leverage /systematic-debugging for bugs
- Use frontend-design for UI work

❌ DON'T:
- Skip planning skills (brainstorming, writing-plans)
- Merge without /verification-before-completion
- Ignore episodic-memory when stuck
- Reinvent solutions to previously solved problems
```

### 2. Skill Invocation

```markdown
When to invoke skills:

ALWAYS:
- /brainstorming - Before ANY new feature
- /verification-before-completion - Before EVERY merge
- /requesting-code-review - Before EVERY PR

OFTEN:
- /writing-plans - For multi-step features
- /test-driven-development - For testable logic
- /systematic-debugging - For non-trivial bugs

AS NEEDED:
- /frontend-design - When building UI
- /using-git-worktrees - For isolated work
- /dispatching-parallel-agents - For independent tasks
- episodic-memory - When unsure of past decisions
```

### 3. Custom Slash Commands

Create project-specific commands for repetitive tasks:

```bash
.claude/commands/
├── audit.md              # Security audit
├── document.md           # Add comprehensive docs
├── pre-merge.md          # Complete pre-merge checklist
├── deploy-check.md       # Verify ready for deployment
└── update-changelog.md   # Update CHANGELOG.md
```

## Workflow Comparison

### Basic Workflow (No Plugins)
```
1. Read requirements
2. Write code
3. Test manually
4. Security audit (manual checklist)
5. Create PR
6. Merge
```

### Enhanced Workflow (With Plugins)
```
1. /brainstorming - Understand requirements deeply
2. /writing-plans - Create detailed plan
3. /test-driven-development - Write tests first (if applicable)
4. /executing-plans - Execute with checkpoints
5. Test manually
6. Security audit with hacker agent
7. /verification-before-completion - Verify everything
8. /requesting-code-review - Self-review
9. /finishing-a-development-branch - Guided merge
```

**Time investment:** +20%
**Quality improvement:** +300%
**Bugs found before merge:** +500%

## Troubleshooting

### Plugin Not Working

```bash
# 1. Check plugin is installed
# Settings > Plugins > Verify "superpowers" is enabled

# 2. Restart Claude Code

# 3. Check for updates
# Settings > Plugins > Check for updates

# 4. Verify configuration
cat .claude/config.json

# 5. Check logs
# Help > Show Logs
```

### Skill Not Invoking

```bash
# Correct syntax:
/brainstorming

# NOT:
brainstorming
/superpowers:brainstorming (use this for full name)
```

### MCP Server Issues

```bash
# MCP servers are Claude Code specific
# If using Gemini 3 Pro, use standard tools instead

# Filesystem operations → Use standard file tools
# GitHub operations → Use gh CLI via terminal
# Database queries → Use database client or ORM
```

## Resources

- [Claude Code Documentation](https://docs.claude.ai/claude-code)
- [Superpowers Plugin](https://github.com/superpowers-marketplace/superpowers)
- [Plugin Marketplace](https://plugins.claude.ai)
- [Creating Custom Skills](https://docs.claude.ai/claude-code/skills)
- [MCP Documentation](https://modelcontextprotocol.io)

## Summary for AI Agents

### Claude Code Agent Checklist

- [ ] Superpowers plugin installed
- [ ] Frontend-design plugin installed (for UI work)
- [ ] Episodic-memory plugin installed
- [ ] Feature-dev plugin installed
- [ ] Always use /brainstorming before new features
- [ ] Always use /verification-before-completion before merge
- [ ] Create custom skills for repetitive tasks
- [ ] Document plugin usage in handoffs to Gemini 3 Pro
- [ ] Follow all documentation standards (coding-standards.md, etc.)
- [ ] Run security audits (security-testing.md + Superpowers verification)

### Gemini 3 Pro Agent Checklist

- [ ] Read all documentation files (cannot use plugins)
- [ ] Follow coding-standards.md rigorously
- [ ] Follow git-workflow.md (branch, test, merge)
- [ ] Run security audit manually (OWASP Top 10 checklist)
- [ ] Document extensively (cannot rely on Claude Code context)
- [ ] Leave detailed handoff notes for Claude Code
- [ ] Reference documentation repo for all standards
- [ ] Test thoroughly before merging
