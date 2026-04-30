# GenAI Common

A living knowledge base for AI-agent-assisted software engineering.

This repository is designed to be ready for Claude Code, Codex-style agents, GitHub Copilot, and future coding agents. It captures reusable coding-agent guidance, repository instruction patterns, implementation playbooks, and research notes.

## Purpose

The goal is to maintain a practical, continuously updated set of instructions that can be reused across projects.

Operating model:

1. Study high-quality public repositories, practical guides, and articles.
2. Extract repeatable engineering practices.
3. Convert those practices into agent-readable instructions.
4. Test the instructions against real repositories.
5. Refine the guidance over time.

## Agent-ready files

| File | Primary consumer | Purpose |
|---|---|---|
| `CLAUDE.md` | Claude Code | Project memory and working rules. |
| `AGENTS.md` | Codex-style agents, GitHub Copilot coding agent, terminal agents | Cross-agent repository instructions. |
| `.github/copilot-instructions.md` | GitHub Copilot | Repository-wide Copilot instructions. |
| `.github/instructions/azure-ai.instructions.md` | GitHub Copilot path/context instructions | Azure and AI-specific implementation guidance. |
| `docs/ai-agent-coding-strategy.md` | Humans and agents | General operating strategy. |
| `docs/research-log.md` | Humans and agents | Research notes and extracted practices. |
| `docs/source-repos.md` | Humans and agents | Source repository tracking. |

## Current research sources

The live, authoritative list lives in [`docs/source-repos.md`](./docs/source-repos.md) — 12 sources tracked at last count, each with status (`pending` / `extracted` / `promoted` / `rejected`), the practices we use them for, and a URL.

Highlights so far:

- **Skill conventions** — Anthropic Agent Skills, `google/skills`, `bytedance/deer-flow`, `forrestchang/andrej-karpathy-skills`.
- **Cross-agent baselines** — the `AGENTS.md` spec, `openai/codex` AGENTS.md, `alchaincyf/huashu-design`, `garrytan/gstack`, `SuperClaude-Org/SuperClaude_Framework`.
- **Per-host instruction formats** — Anthropic Claude Code memory docs, GitHub Copilot custom instructions, `github/awesome-copilot`.

Add new sources by following the [research handling workflow](./AGENTS.md#research-handling): row in `source-repos.md`, observation in `docs/research-log.md`, then promote stable practices.

## Working principles

- Prefer small, reviewable changes over large opaque rewrites.
- Treat AI agents as implementation accelerators, not final authorities.
- Keep architecture decisions explicit and traceable.
- Require tests or validation steps for non-trivial changes.
- Keep instructions short enough for agents to follow consistently.
- Separate project-specific rules from general coding-agent rules.
- Preserve security, privacy, and compliance assumptions in implementation notes.

## How to use this repo with agents

### Claude Code

Run Claude Code from the repository root so it loads `CLAUDE.md` as project memory.

Recommended first prompt:

```text
Read README.md, CLAUDE.md, AGENTS.md, and docs/ai-agent-coding-strategy.md. Summarize the repo purpose, then propose the smallest next improvement as a patch plan.
```

### Codex-style agent

Run the agent from the repository root and ask it to inspect `AGENTS.md` before editing.

Recommended first prompt:

```text
Follow AGENTS.md. Inspect the repo, identify the current instruction architecture, and propose a minimal change plan before editing files.
```

### GitHub Copilot

GitHub Copilot should pick up `.github/copilot-instructions.md` as repository-wide guidance. Path-specific instructions can be added under `.github/instructions/*.instructions.md`.

## Maintenance model

When adding a new source repository or guide:

1. Add it to `docs/source-repos.md`.
2. Summarize key practices in `docs/research-log.md`.
3. Promote mature practices into `CLAUDE.md`, `AGENTS.md`, or Copilot instructions.
4. Keep speculative notes separate from instructions agents must follow.
