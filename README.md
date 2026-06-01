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

## License

MIT — see [LICENSE](./LICENSE).
