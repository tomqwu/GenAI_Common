# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

The cross-agent baseline lives in [`AGENTS.md`](./AGENTS.md). Read it first; the addenda below are Claude-specific and take precedence inside Claude Code sessions when they conflict.

## Repository purpose

`GenAI_Common` serves two roles:

1. **Bootstrap source** for new projects — `AGENTS.md`, `CLAUDE.md`, and `.github/copilot-instructions.md` are designed to drop into a fresh repo. See [`BOOTSTRAP.md`](./BOOTSTRAP.md).
2. **Personal knowledge base** for AI and software-engineering practice — research observations live under `docs/`, with promoted rules in instruction files and descriptive notes in `docs/knowledge/`.

This repo is not a product application. There is no build and no package manager; the doc-quality checks below are its test suite. Edits are almost always markdown.

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

## Agentic PR review gate

Use this builder/reviewer split when a coding agent opens or updates PRs.

Builder prompt:

```text
You may write code, push branches, and open PRs. Do not merge before the review
gate passes. After opening or updating a PR, push the branch, wait for CI, and
wait for independent review. Treat "Not LGTM yet" as blocking. A PR is mergeable
only when a reviewer comments LGTM with a marker matching the current head SHA.
You are authorized to merge after the review gate passes. Immediately before
merging, re-fetch PR state and merge only when CI is green, the marker matches
the current head SHA, and no newer blocking feedback exists.
```

Reviewer prompt:

```text
Review open PRs in the current repo. Fetch metadata, head SHA, diff, comments,
reviews, and CI. Never post LGTM while CI is pending or failing. If CI fails or
code review finds issues, comment "Not LGTM yet" with actionable findings. If CI
is green and no findings remain, post exactly:

LGTM
<!-- codex-pr-review: <head_sha> -->

Before posting, re-fetch the head SHA and comments to avoid duplicate or stale
reviews. Do not merge PRs from the reviewer role.
```

See `docs/knowledge/agentic-pr-review-loop.md` for scheduler, lock, and state
guardrails.

## Quality checks

Run before declaring a doc change done. Tier 1 needs no install; tiers 2–4 are opt-in but recommended for ongoing maintenance.

### Tier 1 — always run (zero install)

```bash
# Cross-references resolve (relative links only)
grep -RIn '\](\./\|](docs/\|](\.github/' . --include='*.md'

# Secrets scan in staged diff
git diff --cached | grep -iE 'api[_-]?key|secret|token|password'

# File-length cap (~200 lines per AGENTS.md house style)
find . -name '*.md' -not -path './.git/*' -exec wc -l {} + \
  | awk '$1 > 200 && $2 != "total"'

# Each prescriptive instruction file ends with a Boundaries section
for f in AGENTS.md CLAUDE.md BOOTSTRAP.md \
         .github/copilot-instructions.md \
         .github/instructions/*.instructions.md \
         docs/knowledge/*.md; do
  [ -e "$f" ] && { grep -q '^## Boundaries' "$f" || echo "MISS Boundaries: $f"; }
done
```

The file-length and Boundaries checks should print nothing. The secrets and cross-ref greps are informational — instruction files legitimately contain words like "secret" in rules, so review hits rather than treating any output as failure.

### Tier 2 — markdown lint

```bash
npx markdownlint-cli2 "**/*.md" "#node_modules"
```

Configured via `.markdownlint.json` at the repo root:

```json
{
  "MD013": false,
  "MD024": { "siblings_only": true },
  "MD033": { "allowed_elements": ["details", "summary"] }
}
```

Disables hard line-length (prose wraps freely), allows the same heading text in non-sibling sections, and allows a small HTML allowlist.

### Tier 3 — link check

```bash
# Install once: brew install lychee  (or: cargo install lychee)
lychee --offline '**/*.md'    # relative links only, fast
lychee '**/*.md'              # adds external URL probes, network-bound
```

`lychee.toml` at the repo root allowlists intentionally unreachable URLs (e.g., the `<your-username>` placeholder in `BOOTSTRAP.md`) so the weekly online run does not file false-positive issues.

### Tier 4 — spell check

```bash
# Install once: brew install typos-cli  (or: cargo install typos-cli)
typos
```

Add `_typos.toml` for project-specific terms: `GenAI`, `Foundry`, `LLMOps`, `applyTo`, `OpenHands`, etc.

### Optional — prose style

`vale` enforces house-style rules like imperative voice. Heavy to configure; only adopt when prose drift becomes a recurring problem.

### Local runner

`scripts/check.sh` bundles tiers 1–4 behind one command. Tiers 3 and 4 auto-skip if their binary isn't installed locally, so the script is safe to run even on a fresh machine.

```bash
./scripts/check.sh
```

### Run order

In order of cost: tier 1 → tier 2 → tier 3 (`--offline`) → tier 4 → tier 3 (online) → manual re-read of each changed file. `scripts/check.sh` runs tiers 1–4 in this order.

### CI

Tiers 1–4 also run as parallel jobs in `.github/workflows/doc-quality.yml` on every push to `main` and every pull request. A separate `.github/workflows/link-check-online.yml` runs lychee with network on a weekly cron to catch external link rot. The `main` branch is protected: PRs cannot merge until the four `doc-quality` jobs pass.

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
