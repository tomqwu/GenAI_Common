# Research log

Observations and extracted practices from sources tracked in `source-repos.md`.

This log separates **observations** (what a source actually does) from **promoted rules** (what we adopt). Do not promote a practice without first recording the observation here.

## Observations

### 2026-04-28 — google/skills

- Skills are folders: `skills/<area>/<skill-name>/SKILL.md` plus a sibling `references/` directory loaded only when needed.
- `SKILL.md` opens with YAML frontmatter (`name`, `description`); the `description` describes both *what it does* and *when to use it*.
- Body is imperative, runnable shell snippets (`gcloud services enable …`, `bq mk …`).
- Reference files are linked from `SKILL.md` with one-line summaries — readers fan out only when needed (progressive disclosure).
- Closed contribution model — skill authority is centralized to keep accuracy high.

### 2026-04-28 — alchaincyf/huashu-design

- Same skill bundle works on Claude Code, Cursor, Codex, OpenClaw, Hermes via the `skills.sh` install convention.
- "Brand asset protocol" hard-codes a 5-step workflow (ask → search official site → download assets → grep hex codes → write `brand-spec.md`) and explicitly forbids guessing brand colors from memory. Strong example of an anti-hallucination rule encoded directly in the skill.
- "Junior Designer workflow": output assumptions + placeholders + reasoning *first*, show user early, iterate.
- "Fallback mode": when the request is too vague, present 3 differentiated options from a taxonomy rather than guessing.
- Reproducible 5-dimension review rubric (philosophy, hierarchy, detail, function, novelty).
- Treats output stability as a quality metric (lower variance across runs = better skill).

### 2026-04-28 — garrytan/gstack

- 23 slash-command skills modeled as a software org (CEO, eng manager, designer, QA, SRE, CSO, release engineer) following Think → Plan → Build → Review → Test → Ship → Reflect.
- Skills chain — outputs of one become inputs of the next (`/office-hours` → design doc → `/plan-eng-review` reads it).
- Each skill carries "Iron Laws" (e.g., `/investigate`: no fixes without investigation; stop after 3 failed hypotheses).
- Safety guardrails as opt-in skills: `/careful` (warn before `rm -rf`, `DROP TABLE`, force-push), `/freeze` (lock edits to one directory), `/guard` (both).
- Multi-host installer auto-detects 10 agent hosts and writes to each one's conventional skills directory.
- Continuous WIP checkpoint commits with `[gstack-context]` body for crash recovery; squashed before PR.

### 2026-04-28 — AGENTS.md spec and openai/codex example

- AGENTS.md is plain markdown at the repo root; no required frontmatter.
- Conventional sections: **Dev environment tips**, **Testing instructions**, **PR instructions**.
- Production usage favors hierarchical bullets, do/never/avoid rules, file-path-scoped guidance ("In the `codex-rs` folder…"), and explicit lint commands.
- Consumed by OpenAI Codex CLI, Cursor, Aider, Jules, Sourcegraph Amp, OpenHands, Factory.
- Claude Code does *not* read AGENTS.md natively; the recommended pattern is `@AGENTS.md` at the top of `CLAUDE.md`.

### 2026-04-28 — Anthropic CLAUDE.md and Skills

- `CLAUDE.md` stacks across scopes (managed → user `~/.claude/CLAUDE.md` → project `./CLAUDE.md` → `CLAUDE.local.md`) and walks up the directory tree.
- Target under ~200 lines per file; longer files reduce adherence.
- Topic-specific rules live in `.claude/rules/*.md` with optional YAML frontmatter `paths: ["src/api/**/*.ts"]` so they only load when matching files are touched.
- `@path/to/file` import syntax; max recursion depth 5.
- HTML block comments are stripped before context injection — useful for human-only notes.
- Agent Skills are filesystem-based, on-demand capability packages with `name` (≤64 chars, lowercase + digits + hyphens; reserved words "anthropic"/"claude" forbidden) and `description` (≤1024 chars; must say *what* and *when*) frontmatter.
- Skills body should stay under ~5K tokens; bundled references and scripts can be unlimited because they don't enter context until read.

### 2026-04-28 — GitHub Copilot custom instructions

- Repo-wide instructions: `.github/copilot-instructions.md` (single file, no frontmatter).
- Path-scoped instructions: `.github/instructions/*.instructions.md` with YAML frontmatter `description:` and `applyTo:` (glob, comma-separated).
- Instructions auto-apply when matching files are referenced — no manual invocation.
- Real-world examples favor imperative bullets, explicit "do not" rules, and runnable commands.

## Promoted rules

These observations have been promoted into agent-readable rule files. Each row links the observation to where it now lives.

| Practice | Source(s) | Promoted to |
|---|---|---|
| Read repo conventions before editing | CLAUDE.md, gstack, huashu | `AGENTS.md` §Operating loop |
| Imperative voice + verifiable rules | CLAUDE.md, AGENTS.md spec, Copilot | `AGENTS.md` §House style |
| Concrete runnable commands over prose | google/skills, codex AGENTS.md, gstack | `AGENTS.md` §House style |
| Small reviewable diffs; show assumptions early | huashu, gstack, CLAUDE.md | `AGENTS.md` §Operating loop |
| Don't invent facts or identifiers | huashu, codex AGENTS.md, CLAUDE.md | `AGENTS.md` §Anti-patterns |
| Never commit secrets | CLAUDE.md, AGENTS.md ecosystem norm | `AGENTS.md` §Safety |
| Progressive disclosure / layered instructions | Anthropic skills, google/skills, Claude `.claude/rules/`, Copilot `.github/instructions/` | `docs/ai-agent-coding-strategy.md` §Layered instructions |
| Path-scoped rules via globs | Claude `.claude/rules/`, Copilot `applyTo:` | `.github/instructions/azure-ai.instructions.md` |
| Stop / safety rules | huashu fallback, gstack `/careful`, codex never-kill rules | `AGENTS.md` §Safety |
| Codify the validation step | AGENTS.md spec, codex, gstack `/ship` | `AGENTS.md` §Validation |
| Document PR/commit format | AGENTS.md spec, codex, CLAUDE.md | `AGENTS.md` §PR and commit format |
| Separate research notes from rules | CLAUDE.md, huashu `references/`, google/skills `references/` | This file |

## Pending observations (not yet promoted)

- Skill-chaining as outputs-become-inputs — interesting but our repo has no skill runtime yet.
- "Iron Laws" per skill — adopt only if we add slash-command skills.
- Stability variance as a quality metric — useful when we start running evals.
- Continuous WIP checkpoint commits — defer until we have multi-session work.

## Anti-patterns observed (and rejected)

- Hard-coding brand colors, IDs, or commands from memory (huashu).
- Letting agents fix code without first investigating root cause (gstack `/investigate` Iron Law).
- Mixing project-specific examples into general agent rules (CLAUDE.md guideline; observed in mixed instruction files).
