---
name: polish
description: Retrospect and improve a skill based on execution experience.
disable-model-invocation: true
user-invocable: true
argument-hint: "[skill-name]"
allowed-tools: Bash(${CLAUDE_SKILL_DIR}/scripts/find-skill.sh:*)
---

# Polish

## Step 1: Identify the Target Skill

Scan the conversation history for traces of skill execution. Look for:

- `<command-name>/skill-name</command-name>` tags — these mark skill invocations
- `Skill` tool calls — these show which skills were loaded

If multiple skills were executed, rank them by "how many corrections occurred during execution." Present the results to the user via AskUserQuestion:

- List each detected skill with a one-line summary of observed issues
- Ask the user to confirm which skill to retro, or specify another

If the user already passed an argument (e.g. `/polish resolve-issue`), use it directly, but still summarize observed issues and ask for confirmation.

Once the target skill is confirmed, locate its SKILL.md by running:

```bash
${CLAUDE_SKILL_DIR}/scripts/find-skill.sh <skill-name>
```

The script searches `~/.claude/skills`, the project's `.claude/skills` and `plugins/` directories. If the user is running with `--plugin-dir`, pass it as an additional argument:

```bash
${CLAUDE_SKILL_DIR}/scripts/find-skill.sh <skill-name> --plugin-dir <dir>
```

Use the results to confirm the target path via `AskUserQuestion`:

- **One result** — present the path and ask for confirmation
- **Multiple results** — list each as a numbered option and ask the user to pick one
- **No results** — ask the user to provide the absolute path to the SKILL.md directly

Once the path is confirmed, immediately read the file with the Read tool so its current content is available for Steps 3 and 4.

## Step 2: Catalog Correction Events

A skill is written with assumptions about how execution will unfold. Correction events are the gaps between those assumptions and reality — signals that the skill's instructions can be improved. The goal is to feed these signals back into SKILL.md so its instructions guide toward the ideal execution path.

Event type definitions and identification methods are in `references/event-types.md`.

### Extract Correction Events

Walk through the conversation chronologically and extract every correction event (types defined in `references/event-types.md`). For each event, record:

| Field | Description |
|-------|-------------|
| **Type** | `user-interrupt`, `self-correct`, `unnecessary-pause`, `script-candidate`, or `preload-candidate` |
| **Location** | The step/phase the skill was executing at the time |
| **What happened** | The action the agent took, or was about to take |
| **What should have happened** | The correct action (from user feedback or the successful recovery) |
| **Root cause in skill** | Which part of SKILL.md led to the wrong behavior |

For `script-candidate` and `preload-candidate` events, additionally record:
- Which Bash commands to consolidate or preload
- What the script/preload does (input → output)
- Where in the skill it would be called or inlined

### Present the Event List

Present the list to the user as a numbered list. Each item should show:
- Correction type (emoji: 🛑 user-interrupt, 🔄 self-correct, ⏸️ unnecessary-pause, 📦 script-candidate, ⚡ preload-candidate)
- A short description of what happened
- The inferred root cause in the skill (or consolidation rationale for script/preload candidates)

Use AskUserQuestion to confirm the list is correct before proceeding.

## Step 3: Design Fixes

For each event in the confirmed list, propose a concrete change to SKILL.md. Fix patterns for each event type are in `references/event-types.md`.

### Structural Improvements

Beyond individual fixes, look for overall patterns:

- **Multiple corrections in the same phase** → the phase's instructions may need restructuring
- **Corrections imply a missing step** → add that step
- **Corrections stem from outdated information** → update the stale content
- **Skill instructions conflict with CLAUDE.md or project conventions** → align to project standards

Present each proposed fix to the user, including:
1. The corresponding correction event (referencing its list number)
2. The specific SKILL.md section to change
3. A before/after preview of the change

If any fix implies splitting the skill or creating a new skill, discuss with the user before proceeding.

## Step 4: Apply Fixes

After the user approves the fixes (or a subset of them):

1. Apply each approved fix one by one using the Edit tool
2. If metadata changes are needed (description, allowed-tools), update those too
3. Show a summary of all changes made

Do not create new files or rewrite the entire SKILL.md — use targeted edits to preserve the existing structure, changing only what needs to change.

## Step 5: Verify

After applying fixes, do a quick sanity check:

- Re-read the modified SKILL.md
- Confirm the changes are consistent with the rest of the skill's instructions
- Check that no instructions contradict each other
- Verify the YAML frontmatter is still valid

Present a final summary to the user:
- How many corrections were addressed
- Which sections were modified
- Any issues that couldn't be resolved through skill changes alone (e.g. tool limitations, external API behavior)
