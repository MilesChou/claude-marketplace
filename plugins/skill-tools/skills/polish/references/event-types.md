# Correction Event Types

Defines the correction event types used by the polish skill.

---

## Type Reference

| Type | Emoji | Description |
|------|-------|-------------|
| `user-interrupt` | 🛑 | The user interrupted — they stopped the flow and said "do it this way instead." Indicates the skill's instructions guided the agent toward the wrong action, or included an unnecessary confirmation step. |
| `self-correct` | 🔄 | The agent hit an error, recovered, and found the right approach. Indicates the skill should have guided the agent to the correct approach from the start. |
| `unnecessary-pause` | ⏸️ | The agent paused to ask or confirm, but the user's next message showed it could have continued directly. Indicates the skill is overly cautious or includes unnecessary checkpoints. |
| `script-candidate` | 📦 | A sequence of Bash commands that should be consolidated into a standalone script. Triggered when commands repeat across steps, or when a fixed-order sequence requires no LLM judgment between steps. |
| `preload-candidate` | ⚡ | Read-only commands that run at the very start of a skill (or are always executed regardless of which branch the flow takes) and whose output becomes context for all subsequent steps. These should be converted to a preload script so the results are inlined into SKILL.md at load time, eliminating upfront API calls and token overhead. |

---

## How to Identify Each Type

### 🛑 `user-interrupt`

Look for:
- Tool calls that return "The user doesn't want to proceed with this tool use"
- Messages where the user redirects the flow ("don't do that", "instead...", "just...")
- Messages where the user provides the correct approach after an agent action

### 🔄 `self-correct`

Look for:
- A failed tool call followed by a successful attempt using a different approach
- Agent messages like "let me try a different approach"
- Sequences where the agent backtracks and starts over

### ⏸️ `unnecessary-pause`

Look for:
- AskUserQuestion calls where the user's response shows the agent could have continued
- Confirmation requests where the answer was obvious from context
- The agent stopping execution and the user responding "go ahead" or "just do it"

### 📦 `script-candidate`

Look for:
- **Repeated patterns** — the same command structure appearing multiple times with different arguments
- **Multi-step sequences** — multiple Bash calls always executed together (e.g. a GraphQL query, filtered with `--jq`, then feeding results into a second query)
- **Complex inline commands** — long one-liners with pipes, jq filters, or string manipulation
- **No LLM judgment between steps** — a fixed-order sequence where the agent doesn't branch or decide based on intermediate results (e.g. `git diff` → `git log` → `git branch` → then act)

### ⚡ `preload-candidate`

Look for:
- **Opening read sequence** — the first few steps are all read-only commands that gather context before any action (e.g. a commit-push skill that starts with `git status`, `git diff`, `git log`, `git branch` to understand the working directory)
- **Universal context** — commands that run regardless of which branch the skill takes later (e.g. always fetching current branch name, always reading a config file)
- **No side effects** — all commands are purely read-only; no writes, no API mutations

---

## Fix Patterns

How to handle each event type.

### 🛑 `user-interrupt`

- If the skill instructed the wrong action → rewrite that instruction
- If the skill used the wrong command/API → fix the command and add a note explaining why
- If the skill presented a choice where there's an obvious default → remove the choice, or set a sensible default with a fallback

### 🔄 `self-correct`

- If the agent found a better approach → make that approach the primary path
- If the agent hit a known API limitation → add a note/hint in the skill (e.g. "Note: GitHub GraphQL filterBy does not support X")
- If the error was due to missing context → add the necessary context or a prerequisite check

### ⏸️ `unnecessary-pause`

- If the skill explicitly required an unnecessary confirmation → remove the AskUserQuestion step or make it conditional
- If the skill was broken into too many micro-steps → consolidate steps that flow naturally together
- If the agent was overly cautious about a safe operation → add guidance indicating the step can proceed without confirmation

### 📦 `script-candidate`

1. Write the script to `${CLAUDE_SKILL_DIR}/scripts/` (e.g. `scripts/find-release-issues.sh`). The script should:
   - Accept input via arguments or stdin
   - Output structured data (JSON preferred) to stdout
   - Include a brief usage comment at the top
   - Be made executable (`chmod +x`)
   - If consolidating a no-judgment sequence, run all steps internally and output a combined summary

2. Update SKILL.md to call the script instead of inline Bash:
   ```bash
   # Before (sequential Bash calls with no LLM judgment between them):
   git log --oneline main..HEAD
   git diff main...HEAD --stat
   git log --format="%s" main..HEAD

   # After (one script call):
   ${CLAUDE_SKILL_DIR}/scripts/branch-summary.sh
   ```

3. Optionally pre-authorize the script in the skill's `allowed-tools` frontmatter to avoid a permission prompt at runtime:
   ```yaml
   allowed-tools: Bash(${CLAUDE_SKILL_DIR}/scripts/branch-summary.sh:*)
   ```

### ⚡ `preload-candidate`

1. Add a context section near the top of SKILL.md. Use the `!` preload syntax to inline each read-only command directly — no wrapper script needed:
   ```markdown
   ## Working Directory Context

   File change status:

   !`git status --short`

   Detailed diff:

   !`git diff`

   Recent commits:

   !`git log --oneline -5`

   Current branch: !`git branch --show-current`
   ```
   Each `!` command runs at skill load time and its output is inlined before the agent sees the skill content.

2. Remove the corresponding manual steps from the skill's flow — the context is already available from the start.

3. If the preload commands are complex (pipes, filters, multi-line), or if a `script-candidate` event also applies (the sequence has no LLM judgment between steps), extract them into a script and preload the script instead:
   ```markdown
   !`${CLAUDE_SKILL_DIR}/scripts/collect-context.sh`
   ```
   When both `script-candidate` and `preload-candidate` apply to the same sequence, the fix is to consolidate into a script first, then preload that script.

4. **Required:** pre-authorize all preloaded commands and scripts in the skill's `allowed-tools` frontmatter. Without this, the permission prompt interrupts skill load and the preload output is never inlined:
   ```yaml
   allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git branch:*)
   ```
   For preloaded scripts, authorize the script path directly:
   ```yaml
   allowed-tools: Bash(${CLAUDE_SKILL_DIR}/scripts/collect-context.sh:*)
   ```

