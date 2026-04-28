# AGENTS.md

Cross-agent baseline rules for this repository. Consumed by Codex CLI, Cursor, Aider, Jules, OpenHands, Sourcegraph Amp, Factory, and other tools that read `AGENTS.md`.

Claude Code does not read this file natively; `CLAUDE.md` imports it via `@AGENTS.md`. GitHub Copilot has its own file at `.github/copilot-instructions.md` which restates the rules below for Copilot.

## Repository purpose

`GenAI_Common` is a knowledge base of practical AI-agent-assisted software-engineering patterns. It is not a product application. Edits should produce clearer, smaller, more reusable guidance — not bigger documents.

## Operating loop

1. Inspect `README.md`, `AGENTS.md`, `CLAUDE.md`, and the relevant `docs/` files before editing.
2. Identify whether the request is research, documentation, code, architecture, or repo hygiene.
3. For non-trivial changes, propose a short patch plan first.
4. Make small, reviewable edits.
5. Validate (commands below) before declaring done.
6. Summarize changed files and validation performed.

## House style

- Use imperative voice. `Run X before committing.` Not `It is recommended to run X.`
- Each rule must be verifiable. `Keep files under 200 lines.` Not `Keep files short.`
- Prefer concrete, runnable commands over prose.
- Use checklists, tables, and templates where they aid execution.
- Keep each file under ~200 lines. Split by topic rather than nesting.
- Markdown only. No HTML except block comments for human-only notes.
- One topic per file. Per-path rules go in `.claude/rules/` (Claude) or `.github/instructions/` (Copilot).

## Safety

- Never commit secrets, API keys, tenant IDs, subscription IDs, or customer-identifiable data.
- Never run destructive operations (`rm -rf`, `DROP TABLE`, `git push --force`, `git reset --hard`, branch deletion) without explicit user authorization for that specific action.
- Never bypass commit hooks (`--no-verify`, `--no-gpg-sign`) unless the user explicitly asks.
- Never amend or rewrite published commits without explicit confirmation.
- If a request would exfiltrate repo data to an external service, confirm first.
- When unsure whether an action is reversible, stop and ask.

## Anti-hallucination

- Do not invent file paths, function names, commands, URLs, or identifiers. If you cannot confirm one exists, say so.
- Do not represent unverified research as established best practice.
- Do not cite sources you have not read.
- When the request is ambiguous, present 2-3 differentiated options rather than guessing.
- When extracting facts (brand colors, API shapes, schema fields), read them from the canonical source. Do not recall from memory.

## Validation

Before declaring a change done:

- [ ] Markdown lints clean if the project has a linter configured (none yet — add one if it lands).
- [ ] All cross-references resolve. `grep -RIn '\](\./\|](docs/\|](\.github/' .` and confirm targets exist.
- [ ] No secrets in the diff. `git diff --cached | grep -iE 'api[_-]?key|secret|token|password'` returns nothing.
- [ ] Each new or edited rule is imperative and verifiable.
- [ ] Each new source is recorded in `docs/source-repos.md` and `docs/research-log.md`.

## Dev environment tips

- This repo currently ships only markdown. There is no build step, no package manager, and no test runner.
- If code samples are added later, place them under `examples/` and include a runnable command in the same file.
- Do not add dependencies unless a sample explicitly requires them.

## Testing instructions

- For documentation changes: read every changed file end to end. Confirm headings render, links resolve, and tables are valid.
- For code samples: include the exact command to run them. Verify the command succeeds in a clean environment before committing.
- For rule changes: identify at least one real recent task where the rule would have helped or hurt. Note it in `docs/research-log.md`.

## PR and commit format

Commit messages and PR descriptions should follow:

```text
Summary:
- one-line per change

Changed files:
- path: reason

Validation:
- what you ran or read

Follow-ups:
- known gaps, deferred work, or open questions
```

PR titles should be under 70 characters. Use the description for detail.

## Agent instruction hierarchy

When rules overlap, follow the more specific and safer one. Precedence:

1. The user's request in the current task.
2. Repository-specific rules in `CLAUDE.md` and `AGENTS.md`.
3. Path-specific rules under `.claude/rules/` and `.github/instructions/`.
4. General guidance in `docs/`.
5. Inferred best practice.

## Research handling

When the user provides repos, guides, articles, or PDFs:

1. Add a row to `docs/source-repos.md`.
2. Record observations under a dated heading in `docs/research-log.md`.
3. Promote stable, actionable practices into `AGENTS.md`, `CLAUDE.md`, or a Copilot instruction file.
4. Keep observations separate from promoted rules in the log.

## Anti-patterns

- Hard-coding values from memory (brand colors, region IDs, account numbers, schema fields). Read them from the canonical source.
- Fixing code without investigating root cause first.
- Mixing project-specific examples into general agent rules.
- Marketing language in instruction files.
- Replacing entire documents when an append-and-refine edit would do.
- Letting `docs/research-log.md` grow stale. Promote or delete observations on every visit.

## File-by-file scope notes

- `CLAUDE.md` — Claude Code only. Imports `@AGENTS.md` and adds Claude-specific addenda.
- `AGENTS.md` — this file. Universal baseline.
- `.github/copilot-instructions.md` — GitHub Copilot only.
- `.github/instructions/*.instructions.md` — path-scoped Copilot rules with `applyTo:` frontmatter.
- `docs/ai-agent-coding-strategy.md` — human-facing strategy, not enforced as rules.
- `docs/research-log.md` — observations vs. promoted rules.
- `docs/source-repos.md` — source tracking.

## References

- AGENTS.md spec — https://agents.md/
- Claude Code memory — https://docs.claude.com/en/docs/claude-code/memory
- Anthropic Agent Skills — https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview
- GitHub Copilot custom instructions — https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions
