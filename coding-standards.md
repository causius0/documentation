# Coding Standards & Philosophy

## Developer Context
- **Experience level**: Relatively new to coding, eager to learn
- **Learning approach**: Willing to use optimal tech stack and learn as we go
- **Review style**: Quick code reviews - relies on extensive comments for understanding

## Code Documentation Requirements

### Comment Every Block
Every code block must include comments explaining:
- **What** the code does
- **Why** this approach was chosen
- **How** it works (especially for complex logic)
- **Alternatives** considered (if relevant)

### Example: Good vs Bad

**Bad - No context:**
```typescript
const result = items.filter(i => i.status === 'active')
  .map(i => ({ ...i, processed: true }))
  .reduce((acc, i) => acc + i.value, 0);
```

**Good - Clear explanations:**
```typescript
// Filter for active items, mark them as processed, and sum their values
// Why: We only want to calculate totals for active items
// How: Chain filter → map → reduce for clean, functional approach
const result = items
  .filter(i => i.status === 'active')        // Keep only active items
  .map(i => ({ ...i, processed: true }))     // Mark each item as processed
  .reduce((acc, i) => acc + i.value, 0);     // Sum all values, starting from 0
```

**Better - Even more context for complex logic:**
```typescript
/**
 * Calculate total value of active items
 *
 * Business logic: Only active items contribute to totals. We mark them as
 * processed to prevent double-counting in subsequent operations.
 *
 * Alternative considered: Could use a for loop, but functional approach
 * is more readable and prevents mutation bugs.
 */
const result = items
  .filter(i => i.status === 'active')        // Keep only active items
  .map(i => ({ ...i, processed: true }))     // Mark each item as processed
  .reduce((acc, i) => acc + i.value, 0);     // Sum all values, starting from 0
```

## AI Agent Alignment

### Multi-Agent Environment
Code is written by both Claude Code and Gemini 3 Pro. Requirements:

1. **Language consistency**: Use the same terminology and patterns across agents
2. **Comment format**: Both agents must follow the same commenting style
3. **No tool-specific features**: Don't rely on tools unique to one agent
4. **Explicit over implicit**: Always explain choices, never assume context

### Handoff Protocol
When switching between agents:
- Leave clear comments about what was just done
- Note any pending decisions or questions
- Document assumptions made
- List next steps explicitly

## Technology Philosophy

### Optimal Over Familiar
- Don't dumb down the tech stack for beginners
- Use modern, best-practice tools and frameworks
- Provide learning resources when introducing new concepts
- Explain *why* a technology is chosen, not just *what* it is

### Examples of Good Tech Choices
- **TypeScript over JavaScript**: Type safety helps catch errors early (great for learning)
- **React + Vite**: Modern, fast, industry-standard
- **Tailwind CSS**: Utility-first CSS (easier to reason about than custom CSS)
- **pnpm**: Fast, efficient package manager with better dependency management
- **Vitest**: Modern testing framework with great TypeScript support

## Testing Approach

### Manual Testing First
- Developer runs manual tests before deployment
- AI agents should provide clear testing instructions
- Include sample inputs/outputs for manual verification

### Test Documentation Required
Every feature should include:
```markdown
## How to Test This Feature

1. **Setup**: [Any data or config needed]
2. **Steps**:
   - Step 1: Do X
   - Step 2: Verify Y appears
   - Step 3: Check Z behavior
3. **Expected Results**: [What success looks like]
4. **Common Issues**: [Known gotchas]
```

## Deployment

### Platform
- Primary: render.com
- AI agents should include render.com configuration when relevant
- Provide deployment checklists

### Pre-Deployment Checklist
```markdown
- [ ] All manual tests passed
- [ ] Environment variables documented
- [ ] Build succeeds locally
- [ ] Dependencies are pinned (no ^ or ~ in package.json)
- [ ] README updated with new features
- [ ] Comments explain all non-obvious code
```

## Code Organization

### File Structure
- Keep related code together
- Use clear, descriptive file names
- Include README in each major directory

### Naming Conventions
- **Files**: kebab-case (`user-profile.ts`)
- **Components**: PascalCase (`UserProfile.tsx`)
- **Functions**: camelCase (`getUserProfile`)
- **Constants**: UPPER_SNAKE_CASE (`MAX_RETRY_ATTEMPTS`)

## Learning-Focused Development

### Include Learning Resources
When using unfamiliar patterns, add comments like:
```typescript
// Using React's useReducer hook for complex state management
// Learn more: https://react.dev/reference/react/useReducer
// Why here: We have multiple related state updates that depend on each other
const [state, dispatch] = useReducer(reducer, initialState);
```

### Explain Design Patterns
```typescript
/**
 * Repository Pattern: Separates data access logic from business logic
 *
 * Benefits:
 * - Easy to swap databases later
 * - Testable without hitting real database
 * - Clear separation of concerns
 *
 * Learn more: [link to pattern explanation]
 */
class UserRepository {
  // ...
}
```

## Summary for AI Agents

When working with this developer:
1. ✅ Comment extensively - explain what, why, and how
2. ✅ Use optimal tech stack - don't oversimplify
3. ✅ Provide learning resources for new concepts
4. ✅ Include manual testing instructions
5. ✅ Keep render.com deployment in mind
6. ✅ Ensure consistency between Claude Code and Gemini 3 Pro
7. ✅ Explain all choices and alternatives considered
