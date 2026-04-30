# AI-agent coding strategy

## Purpose

Define the general operating strategy for using AI coding agents (Claude Code, Codex CLI, GitHub Copilot, Cursor, Aider, Jules, OpenHands, and similar) on real codebases. This document is the human-facing strategy; the agent-facing rules live in `AGENTS.md`, `CLAUDE.md`, and `.github/copilot-instructions.md`.

## When to use this strategy

- Onboarding a new repository to AI coding agents.
- Auditing an existing repository whose agent instructions have drifted.
- Deciding where a new rule should live (universal, agent-specific, or path-specific).

## Operating model

1. **Study** high-quality public repositories, practical guides, and articles.
2. **Extract** repeatable engineering practices.
3. **Convert** those practices into agent-readable instructions.
4. **Test** the instructions against real repositories.
5. **Refine** the guidance as observations accumulate.

## Layered instructions

Agents pick up different files. Place each rule at the narrowest layer that still covers its scope.

| Layer | File(s) | Loaded when | Use for |
|---|---|---|---|
| Universal baseline | `AGENTS.md` | Codex, Cursor, Aider, Jules, OpenHands sessions | Rules every agent should follow |
| Claude project memory | `CLAUDE.md` | Every Claude Code session | Claude-specific addenda + `@AGENTS.md` import |
| Claude path rules | `.claude/rules/*.md` with `paths:` frontmatter | When matching files are edited | Topic- or path-scoped Claude rules |
| Copilot repo-wide | `.github/copilot-instructions.md` | Every Copilot interaction | Build, test, and PR rules for Copilot |
| Copilot path rules | `.github/instructions/*.instructions.md` with `applyTo:` | When matching files are referenced | Tech- or path-scoped Copilot rules |
| Skills | `SKILL.md` directories | On-demand when triggered | Reusable capability packages |
| Human strategy | `docs/*.md` | Read by humans and on request by agents | Background, rationale, research |

## Minimum viable workflow

For a new repo:

1. Add `AGENTS.md` at the root.
2. Add `CLAUDE.md` with `@AGENTS.md` at the top, plus Claude-specific addenda.
3. Add `.github/copilot-instructions.md` with the same baseline restated for Copilot.
4. Add `docs/source-repos.md` and `docs/research-log.md` if the project will study external sources.
5. Validate by running each agent on a small task and reviewing whether the rules were honored.

## Implementation checklist

- [ ] One topic per file. Split rather than nest.
- [ ] Each rule is verifiable (`Use 2-space indentation`), not vague (`Format nicely`).
- [ ] Imperative voice. `Run X before committing.`
- [ ] Concrete, runnable commands where applicable.
- [ ] Each file under ~200 lines.
- [ ] Path-scoped rules use globs, not prose.
- [ ] No secrets, no customer identifiers, no copyrighted long-form content.

## Validation checklist

- [ ] Run Claude Code from the repo root and check `CLAUDE.md` is picked up (`/memory` or session-start log).
- [ ] Run Codex CLI or Aider and confirm `AGENTS.md` is loaded.
- [ ] Edit a file matched by a path-scoped rule and confirm the rule fires.
- [ ] Ask the agent to summarize the rules it loaded; correct any misreads.
- [ ] Land one small change end-to-end (read instructions → patch → validate → commit) without manual rule restatement.

## Anti-patterns

- Burying critical constraints inside long prose. Agents will skim past them.
- Duplicating the same rule into every agent file. Use `@AGENTS.md` import or restate only what differs.
- Treating exploratory research notes as mandatory rules. Keep `docs/research-log.md` separate.
- Mixing project-specific examples into general agent rules.
- Adding marketing language unless the file is explicitly a sales artifact.

## Single source, multi-host

When the same content needs to reach multiple agents, keep one canonical source and emit several delivery files rather than maintaining parallel copies.

- Pick one canonical file per topic. Examples: `AGENTS.md` for the cross-agent baseline; a `SKILL.md` body for a capability bundle.
- Emit per-host delivery files that wrap or link to the canonical: `CLAUDE.md` cross-references `AGENTS.md`; `.github/copilot-instructions.md` restates the parts Copilot needs; `.cursor/rules/*.mdc` carries the same content for Cursor; a plugin manifest packages it for installable distribution.
- Document two install paths for users: a structured install (plugin marketplace, package manager) and an append-mode file-drop (`curl -o CLAUDE.md <url>` for new repos, `curl <url> >> CLAUDE.md` for existing ones).
- When the canonical content changes, list the per-host files that must be updated alongside it. A pre-commit checklist or a CI grep for drift is the safety net.

## How rules graduate

```text
Observation in research-log.md
        │
        ▼
Tested on at least one real change
        │
        ▼
Promoted to AGENTS.md (universal) or per-agent file (specific)
        │
        ▼
Source row in source-repos.md updated to Status = promoted
```

## References

- `AGENTS.md` — universal cross-agent baseline.
- `CLAUDE.md` — Claude Code project memory.
- `.github/copilot-instructions.md` — repo-wide Copilot rules.
- `.github/instructions/azure-ai.instructions.md` — Azure-specific Copilot rules.
- `docs/source-repos.md` — tracked sources.
- `docs/research-log.md` — observations and promoted rules.
