---
name: toolkit-router
description: Use when the user asks to build a feature, add functionality, design a subsystem, brainstorm an idea, create a skill, or edit a skill — picks between feature-dev, superpowers:brainstorming, and superpowers:writing-skills before any of them auto-trigger
---

# Toolkit Router

## Why this exists

Two pairs of installed plugins compete for the same user intents:

1. **`feature-dev`** (Anthropic) and **`superpowers:brainstorming` → `writing-plans`** both fire on "build X" / "add Y" / "implement Z".
2. **`superpowers:writing-skills`** and (if installed) **`skill-creator`** both fire on "create a skill" / "edit a skill".

This skill is an advisory router. It does not replace the downstream skills — it picks one and hands off.

## Decision table

| User intent | Route to |
|-------------|----------|
| Single-file edit, no new abstraction, no design questions | `feature-dev` — invoke `/feature-dev` |
| New subsystem, more than 2 files, design needed | `superpowers:brainstorming` → then `writing-plans` |
| Bug fix with clear cause | `superpowers:systematic-debugging`, no router needed |
| Create new skill from scratch | `superpowers:writing-skills` (kept) — `skill-creator` only if eval/benchmarks needed |
| Edit or tighten existing skill | `superpowers:writing-skills` |
| Ambiguous between the above | Ask user one clarifying question before dispatching |

## How to use

When this skill fires:

1. Read the user's request and pick the matching row.
2. Announce the choice in one sentence: *"Routing to feature-dev because this is a single-file change."*
3. Invoke the chosen skill via the `Skill` tool.

## Limitations

- This skill is **advisory**, not a hard gate. `feature-dev` and `brainstorming` still auto-trigger from their own descriptions, and the chosen skill may differ from what the router would have picked.
- User can force a path explicitly by typing `/<plugin>:<skill>` (e.g. `/superpowers:brainstorming`).
- If the user has clearly stated which workflow they want, follow them — do not re-route.
