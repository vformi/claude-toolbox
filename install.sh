#!/usr/bin/env bash
# claude-toolbox installer
# One-shot install of the claude-toolbox marketplace and all 9 plugins.
set -euo pipefail

MARKETPLACE_REPO="vformi/claude-toolbox"
MARKETPLACE_NAME="claude-toolbox"
PLUGINS=(
  vformi-toolkit
  superpowers
  feature-dev
  github
  claude-md-management
  security-guidance
  frontend-design
  caveman
  typescript-lsp
)

if ! command -v claude >/dev/null 2>&1; then
  echo "ERROR: 'claude' CLI not found. Install Claude Code first: https://claude.ai/code" >&2
  exit 1
fi

if ! command -v typescript-language-server >/dev/null 2>&1; then
  if command -v npm >/dev/null 2>&1; then
    echo "==> Installing typescript-language-server (prereq for typescript-lsp plugin)..."
    npm install -g typescript-language-server typescript
  else
    echo "WARN: npm not found. Skipping typescript-language-server install." >&2
    echo "      The typescript-lsp plugin will fail until you install it manually:" >&2
    echo "      npm install -g typescript-language-server typescript" >&2
  fi
fi

echo "==> Registering marketplace ${MARKETPLACE_NAME} from ${MARKETPLACE_REPO}..."
claude plugin marketplace add "${MARKETPLACE_REPO}" || true

failed=()
for p in "${PLUGINS[@]}"; do
  echo "==> Installing ${p}@${MARKETPLACE_NAME}..."
  if ! claude plugin install "${p}@${MARKETPLACE_NAME}"; then
    failed+=("${p}")
  fi
done

echo
if [ "${#failed[@]}" -eq 0 ]; then
  echo "All 9 plugins installed."
else
  echo "WARN: the following plugins failed to install: ${failed[*]}" >&2
fi

echo "Run claude /plugins to see all installed plugins. Happy coding!"
