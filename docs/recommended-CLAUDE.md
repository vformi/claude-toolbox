# Recommended CLAUDE.md additions

This file is a copy-paste source, not an active CLAUDE.md. Copy the sections
below into the CLAUDE.md of the project you are actually coding in. They do
not apply to `claude-toolbox` itself — this repo is a plugin marketplace, not
an application codebase.

## Engineering principles

```markdown
- Do not preserve backward compatibility. Remove obsolete paths instead of
  adding compatibility layers, fallbacks, or migrations.
- Choose the simplest implementation that fully meets the current
  requirements. Avoid speculative abstractions, configuration, and indirection.
- Grow the system in layers. Start from the smallest version that works end
  to end, and add each new capability on top of a product that already works.
  Never trade a working product for unfinished complexity.
- Keep components modular and concerns clearly separated.
- Prefer established, well-maintained libraries when they reduce overall
  complexity or improve reliability. Do not reimplement common functionality
  without a clear reason.
- Lean on the dependencies already in the project before writing your own
  implementation or adding packages. Do not assume a library lacks a
  capability without checking its documentation and types.
- Make architectural decisions for the long term. Do not accept a stopgap
  that only works for now and is meant to be replaced later.
```

## CodeGraph pointer

Add this once CodeGraph is set up in the target repo (see
[Recommended companion tools](../README.md#recommended-companion-tools) for
setup):

```markdown
## CodeGraph (code intelligence)

This repo is indexed by [CodeGraph](https://github.com/colbymchenry/codegraph) (a gitignored `.codegraph/` index). When locating or understanding code, prefer it over grep/find: one query returns the relevant symbols' verbatim source, the call paths between them, and a blast-radius summary (callers + test coverage).

- **Agents (MCP):** `codegraph_explore` — name a symbol/file or ask a question.
- **Shell:** `codegraph explore "<symbols or question>"`
```

## RTK: no per-repo snippet needed

RTK ([github.com/rtk-ai/rtk](https://github.com/rtk-ai/rtk)) does not get a
pointer section here. `rtk init -g` (see
[Recommended companion tools](../README.md#recommended-companion-tools))
already writes `~/.claude/RTK.md` and references it with `@RTK.md` from the
**global** CLAUDE.md. Copying a second snippet into a per-repo CLAUDE.md would
duplicate that file instead of pointing at it.
