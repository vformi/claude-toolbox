---
name: implement-pr
description: Use when asked to read a GitHub PR and implement its requested changes - handles repo detection, fetches PR content via gh CLI, and drives implementation
---

# Implement PR

## Overview

Read a GitHub pull request and implement the changes it describes. Detects the current repo automatically; asks the user when context is ambiguous.

## Steps

### 1. Resolve the repo

```bash
# Are we inside a git repo with a GitHub remote?
git rev-parse --show-toplevel 2>/dev/null && git remote get-url origin 2>/dev/null
```

- **If both succeed** → use the current repo. Extract `owner/repo` from the remote URL.
- **If either fails** → ask the user: *"Which GitHub repository should I read the PR from? (e.g. owner/repo)"*

### 2. Resolve the PR number

- If the user supplied a PR number, use it.
- Otherwise list open PRs and ask which one:

```bash
gh pr list --repo owner/repo --limit 20 --json number,title,author,state \
  --template '{{range .}}#{{.number}} {{.title}} ({{.author.login}})\n{{end}}'
```

### 3. Fetch PR content

```bash
gh pr view <NUMBER> --repo owner/repo \
  --json title,body,comments,reviews,files \
  --jq '{title,body,comments:.comments[].body,reviewComments:.reviews[].body}'
```

Also fetch the diff to understand what code is already changed vs. what still needs doing:

```bash
gh pr diff <NUMBER> --repo owner/repo
```

### 4. Understand the request

Read the PR description (`body`) and any review/comment threads. Identify:

- **What** changes are being requested (new feature, bugfix, refactor, etc.)
- **Which files** are affected (from the diff or the description)
- **Acceptance criteria** — look for checklists, "should", "must", "expected behaviour" language

If the intent is ambiguous, ask before touching any code.

### 5. Implement

Follow the project's conventions (CLAUDE.md if present). Apply changes surgically — only modify what the PR actually requests.

After implementing, run whatever verification is appropriate (lint, type-check, tests):

```bash
npm run lint && npm run build && npm test
```

### 6. Report back

Summarise:
- What you changed and why (tied back to the PR description)
- Any decisions or trade-offs made
- Any parts of the PR that were unclear or not implemented, and why

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Implementing more than the PR requests | Read the PR again; do only what it asks |
| Ignoring existing diff — re-implementing already-merged changes | Always fetch the diff first |
| Asking for the repo when already inside one | Run the `git` detection commands first |
| Not checking project conventions | Always read CLAUDE.md before touching code |
