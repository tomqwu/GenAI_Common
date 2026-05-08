# GitHub Copilot repository instructions

Repo-wide instructions for GitHub Copilot. Path- or topic-scoped rules live in `.github/instructions/*.instructions.md` with `applyTo:` glob frontmatter.

The universal baseline is in `AGENTS.md`. This file restates the parts that matter for Copilot and adds Copilot-specific guidance.

## Repository purpose

`GenAI_Common` is a personal knowledge base for AI and software-engineering practice, and a source of drop-in instruction files for new projects. It is not a product application. Most edits are markdown. The instruction files double as templates; keep them generic enough to bootstrap another repo. See `BOOTSTRAP.md`.

## House style

- Use imperative voice. `Run X.` Not `You should run X.`
- Each rule must be verifiable.
- Prefer concrete, runnable commands over prose.
- Use checklists, tables, and templates.
- Keep each file under ~200 lines.
- Markdown only. No HTML except block comments for human-only notes.
- When a tracked spec, prompt, or design doc governs code, update both in the same change: behavior changes update the spec first then the code; pure refactors change the code first then sync the spec back.

## Editing rules

- Inspect existing files before proposing edits.
- For non-trivial changes, propose a short patch plan in the chat first.
- Prefer append-and-refine over replacing whole documents.
- Do not delete `docs/research-log.md` notes unless the user asks.
- Do not invent file paths, function names, commands, URLs, or identifiers.
- Treat "verified" as checked by a deterministic sensor (tests, types, lint, CI gate), not merely read. Prefer adding a sensor over re-reading at scale.

## Safety

- Never suggest committing secrets, API keys, tenant IDs, subscription IDs, or customer-identifiable data.
- Never suggest destructive git or shell operations (`rm -rf`, `git push --force`, `git reset --hard`) without an explicit user request for that specific action.
- Never bypass commit hooks (`--no-verify`).

## Build, test, and dependencies

- This repo has no build step and no package manager. Doc-quality checks run via `./scripts/check.sh` locally and the `doc-quality` workflow in CI.
- Do not suggest installing or updating packages.
- If code samples are added later, place them under `examples/` and include a runnable command in the same file.

## PR and commit format

Use this template for commit messages and PR descriptions:

```text
Summary:
- one-line per change

Changed files:
- path: reason

Validation:
- what you ran or read

Follow-ups:
- known gaps or open questions
```

PR titles under 70 characters. Detail goes in the body.

## Agentic PR review gate

- If an AI agent opens or updates a PR, do not merge unless the user explicitly asks.
- Wait for CI and an independent review signal tied to the current head SHA.
- Treat a reviewer comment of `Not LGTM yet` as blocking.
- Treat any new commit as invalidating older approval.
- A valid approval must include:

```text
LGTM
<!-- codex-pr-review: <head_sha> -->
```

## When to defer

- If the request is ambiguous, ask a clarifying question or offer 2-3 differentiated options.
- If the change touches Azure, AI, or Foundry guidance, follow `.github/instructions/azure-ai.instructions.md`.
- If the change would promote a research observation to a binding rule, edit `docs/research-log.md` first and link the row in `docs/source-repos.md`.

## Anti-patterns

- Hard-coding values from memory (brand colors, region IDs, account numbers, schema fields).
- Mixing project-specific examples into general agent rules.
- Marketing language in instruction files.
- Suggesting tool installs the user did not ask for.

## Boundaries

This file does not cover: cross-agent baseline rules (`AGENTS.md`), Claude-specific addenda (`CLAUDE.md`), Azure path-scoped rules (`.github/instructions/azure-ai.instructions.md`), drop-in install for new repos (`BOOTSTRAP.md`), or descriptive knowledge notes (`docs/knowledge/`).

## References

- `AGENTS.md` for the cross-agent baseline.
- `CLAUDE.md` for Claude-specific addenda.
- `docs/ai-agent-coding-strategy.md` for the human-facing strategy.
