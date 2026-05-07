# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

The cross-agent baseline lives in [`AGENTS.md`](./AGENTS.md). Read it first; the addenda below are Claude-specific and take precedence inside Claude Code sessions when they conflict.

## Repository purpose

`GenAI_Common` serves two roles:

1. **Bootstrap source** for new projects — `AGENTS.md`, `CLAUDE.md`, and `.github/copilot-instructions.md` are designed to drop into a fresh repo. See [`BOOTSTRAP.md`](./BOOTSTRAP.md).
2. **Personal knowledge base** for AI and software-engineering practice — research observations live under `docs/`, with promoted rules in instruction files and descriptive notes in `docs/knowledge/`.

This repo is not a product application. There is no build, no package manager, and no test runner. Edits are almost always markdown.

## Architecture: layered instruction files

The repo's product *is* the instruction stack. Understand the layering before editing any rule:

| Layer | File | Loaded by | Edit when |
|---|---|---|---|
| Universal baseline | `AGENTS.md` | Codex, Cursor, Aider, Jules, OpenHands, etc. | A rule should apply to every agent |
| Claude addenda | `CLAUDE.md` (this file) | Claude Code | Rule is Claude-specific or restates baseline for Claude |
| Copilot mirror | `.github/copilot-instructions.md` | GitHub Copilot | Same rule needs to reach Copilot |
| Path-scoped (Copilot) | `.github/instructions/*.instructions.md` with `applyTo:` | Copilot, on matching files | Rule is tech- or path-specific |
| Path-scoped (Claude) | `.claude/rules/*.md` with `paths:` frontmatter | Claude Code, on matching files | Same as above, for Claude |
| Strategy / pipeline | `docs/ai-agent-coding-strategy.md`, `docs/source-repos.md`, `docs/research-log.md` | Humans, agents on request | Rationale, source tracking, observation log |
| Knowledge notes | `docs/knowledge/*.md` | Humans, agents on request | Descriptive AI/coding facts and patterns (not rules) |

The research pipeline is observation → tested → promoted. See `AGENTS.md#research-handling`.

## Single source, multi-host: keep mirrors in sync

When a rule lives in more than one file (the baseline-and-mirror pattern), edits to one must update the other in the same change. Pairs to watch:

- `AGENTS.md` ↔ `.github/copilot-instructions.md` — Copilot mirror of the baseline.
- This file's "Azure and GenAI defaults" ↔ `.github/instructions/azure-ai.instructions.md` ↔ `docs/knowledge/azure-genai.md`.
- Any rule stated here that also belongs in `AGENTS.md` — promote up rather than fork.

If you change one side, grep the other (`grep -RIn '<phrase>' .`) and reconcile, or call out the drift in the PR.

## Bootstrap-template discipline

The instruction files double as drop-in templates for new projects. When editing them:

- Keep examples generic enough to apply outside this repo.
- Confine `GenAI_Common`-specific framing to the "Repository purpose" section, which `BOOTSTRAP.md` flags for replacement.
- Don't reference paths or files that won't exist in a fresh project.

## Validation commands

Before declaring a doc change done:

```bash
# All relative cross-references resolve
grep -RIn '\](\./\|](docs/\|](\.github/' .

# No secrets in the staged diff
git diff --cached | grep -iE 'api[_-]?key|secret|token|password'
```

The first command's output should only list links whose targets exist; the second should return nothing.

## Documentation style

Sections in a rule or playbook doc, in this order:

1. Purpose.
2. When to use the pattern.
3. Minimum viable workflow.
4. Implementation checklist.
5. Validation checklist.
6. Anti-patterns.
7. References / source notes.

End any prescriptive instruction file with a `Boundaries` section listing what it does *not* cover and which sibling file does (per `AGENTS.md` house style).

## Azure and GenAI defaults

Mirrors `.github/instructions/azure-ai.instructions.md` (Copilot path rules) and `docs/knowledge/azure-genai.md` (descriptive notes). Update all three when changing.

- Prefer managed identity over static credentials. Use `DefaultAzureCredential` in code samples.
- Use Key Vault for any secret that cannot be eliminated.
- Default to private endpoints for AI Search, Azure OpenAI, Storage, and Cosmos in `production`-tier examples; `prototype` may use public endpoints.
- Include observability (App Insights or OpenTelemetry), at least one offline eval step, and a cost-per-1K-token note for the chosen model SKU.
- Include Azure AI Content Safety in user-facing examples.
- For financial-services examples, explicitly address compliance frame, auditability, data governance, and human review.
- Every example declares `Tier: prototype` or `Tier: production` at the top.

## Boundaries

This file does not cover: cross-agent baseline rules (`AGENTS.md`), Copilot-specific rules (`.github/copilot-instructions.md`), Azure path-scoped rules (`.github/instructions/azure-ai.instructions.md`), the human-facing strategy (`docs/ai-agent-coding-strategy.md`), or descriptive knowledge notes (`docs/knowledge/`). For drop-in install instructions, see `BOOTSTRAP.md`.
