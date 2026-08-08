# claude-toolbox

vformi's personal Claude Code stack. One marketplace, nine plugins: eight community plugins referenced upstream + one own plugin (`vformi-toolkit`) with personal skills.

## Quick install (recommended)

Add the snippet below to `~/.claude/settings.json` (merge with existing fields if present), then restart Claude Code.

```json
{
  "extraKnownMarketplaces": {
    "claude-toolbox": {
      "source": { "source": "github", "repo": "vformi/claude-toolbox" }
    }
  },
  "enabledPlugins": {
    "vformi-toolkit@claude-toolbox": true,
    "superpowers@claude-toolbox": true,
    "feature-dev@claude-toolbox": true,
    "github@claude-toolbox": true,
    "claude-md-management@claude-toolbox": true,
    "security-guidance@claude-toolbox": true,
    "frontend-design@claude-toolbox": true,
    "caveman@claude-toolbox": true,
    "typescript-lsp@claude-toolbox": true
  }
}
```

Omit any plugin you don't want.

### Prerequisite for `typescript-lsp`

`typescript-lsp` registers a language server. Install it once on your machine:

```bash
npm install -g typescript-language-server typescript
```

Without this, the `typescript-lsp` plugin will fail to start.

## One-shot install (CLI)

If you prefer a shell script that installs the marketplace and all 9 plugins via the `claude` CLI:

```bash
curl -fsSL https://raw.githubusercontent.com/vformi/claude-toolbox/main/install.sh -o install.sh
less install.sh   # review before running
bash install.sh
```

The script installs `typescript-language-server` globally via npm if not already present (required by the `typescript-lsp` plugin), registers the marketplace, then installs each of the 9 plugins. Restart Claude Code (or `/reload-plugins`) afterwards.

Direct pipe form (skips the review step — only do this if you trust the source):

```bash
curl -fsSL https://raw.githubusercontent.com/vformi/claude-toolbox/main/install.sh | bash
```

## Interactive install (alternative)

If you prefer to install one at a time, run these in a Claude Code session:

```
/plugin marketplace add vformi/claude-toolbox
/plugin install vformi-toolkit@claude-toolbox
/plugin install superpowers@claude-toolbox
/plugin install feature-dev@claude-toolbox
/plugin install github@claude-toolbox
/plugin install claude-md-management@claude-toolbox
/plugin install security-guidance@claude-toolbox
/plugin install frontend-design@claude-toolbox
/plugin install caveman@claude-toolbox
/plugin install typescript-lsp@claude-toolbox
```

After install, run `/reload-plugins` (or restart).

## Updating

```
/plugin marketplace update claude-toolbox
/reload-plugins
```

This is necessary after I bump any upstream `ref` in `marketplace.json`. Skipping the `update` will leave you on the cached version.

## Plugins included

| Plugin | Purpose | Upstream |
|--------|---------|----------|
| `vformi-toolkit` | Own skills: `implement-pr`, `toolkit-router` | this repo |
| `superpowers` | Brainstorming, TDD, subagent-driven development | [obra/superpowers](https://github.com/obra/superpowers) |
| `feature-dev` | Small-feature workflow with code-explorer, code-architect, code-reviewer agents | [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/feature-dev) |
| `github` | GitHub MCP server (issues, PRs, code search) | [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official/tree/main/external_plugins/github) |
| `claude-md-management` | Maintain and improve CLAUDE.md files | [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/claude-md-management) |
| `security-guidance` | Security review hooks + agentic commit reviewer | [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/security-guidance) |
| `frontend-design` | Production-grade frontend generation | [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/frontend-design) |
| `caveman` | Ultra-compressed communication mode (~75% token reduction) | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) |
| `typescript-lsp` | TypeScript/JavaScript LSP for go-to-definition, find references, type info | [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/typescript-lsp) |

## Routing: feature-dev vs superpowers

Both auto-trigger on feature work. The `toolkit-router` skill in `vformi-toolkit` provides advisory routing:

| User intent | Route to |
|-------------|----------|
| Single-file edit, no new abstraction | `feature-dev` (`/feature-dev`) |
| New subsystem, more than 2 files, design needed | `superpowers:brainstorming` → `writing-plans` |
| Create or edit a skill | `superpowers:writing-skills` |
| Ambiguous | router asks user |

`toolkit-router` is advisory only — the downstream skills can still auto-fire from their own descriptions. Force a path explicitly with `/<plugin>:<skill>` (e.g. `/superpowers:brainstorming`).

## Complementary overlaps (intentional, not bugs)

- **Code review:** `superpowers:requesting-code-review` (you ask for review), `caveman-review` (compresses the review output), `security-guidance` Stop hook (auto-fires after edits). Different scopes — all three can stack on a single PR.
- **Commit messages under caveman mode:** `caveman-commit` auto-triggers on commit requests when caveman mode is active. Type `stop caveman` first if you want a plain commit message.

## Updating community plugin pins

All upstream refs are pinned to `main` in `.claude-plugin/marketplace.json`. To pin to a specific tag or sha for reproducibility, edit the `ref` field of the entry and `git push`. Users then run `/plugin marketplace update claude-toolbox` to fetch the new pin.

## Recommended companion tools

These are not Claude Code plugins, so they are not in the marketplace or `enabledPlugins` list above. They are separate CLI tools, installed once per machine (or once per repo, for CodeGraph), that cut token usage during coding sessions.

| Tool | Scope | What it does | Install | Usage |
|------|-------|---------------|---------|-------|
| [CodeGraph](https://github.com/colbymchenry/codegraph) | Per-repo | Local SQLite knowledge graph of a repo's symbols, edges, and files. One query returns a symbol's verbatim source plus its call paths, including dynamic-dispatch hops grep can't follow. | `curl -fsSL https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.sh \| sh`, then `codegraph install` (one-time, configures Claude Code/Cursor/Codex), then `codegraph init` inside each repo you want indexed. | Agents: MCP tool `codegraph_explore`, or `codegraph explore "<question>"`. Humans: same command from the repo root. The index auto-syncs via a file watcher after `init` — no manual rebuilds. |
| [RTK](https://github.com/rtk-ai/rtk) | Global (machine-wide) | Rust CLI proxy that filters, groups, truncates, and deduplicates the output of 100+ common commands (`git`, `npm`, `aws`, `cat`, `grep`, `ls`, ...) before an agent reads it — cuts up to 90% of bash output tokens. | `brew install rtk`, then `rtk init -g`. Answer `y` when it asks to patch `~/.claude/settings.json` (or run `rtk init -g --auto-patch` for a non-interactive shell). It also writes `~/.claude/RTK.md` and adds an `@RTK.md` reference to the global CLAUDE.md — no per-repo setup. | Restart Claude Code, then verify with `rtk init --show`. After that it's transparent — `git status` is automatically rewritten to `rtk git status`. Run `rtk gain` to see savings. Only rewrites Bash tool calls; `Read`/`Grep`/`Glob` bypass it. |

**Overlap with `typescript-lsp` and CodeGraph (intentional, not a conflict):** `typescript-lsp` and CodeGraph answer semantic/structural code questions directly, so the Bash tool — and RTK's hook — never fires for those. RTK only compresses the remaining raw shell commands (git, package managers, cloud CLIs, log tailing) that the other two don't touch.

**CLAUDE.md additions:** see [`docs/recommended-CLAUDE.md`](docs/recommended-CLAUDE.md) for a copy-paste template — engineering principles and a CodeGraph pointer snippet — to add to the CLAUDE.md of the project you're actually coding in. It does not apply to `claude-toolbox` itself.

## License

MIT — see [LICENSE](./LICENSE).
