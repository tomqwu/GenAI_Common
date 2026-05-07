# Knowledge notes

Descriptive notes on AI and software-engineering topics. Distinct from agent rules: these capture *facts and trade-offs* rather than *imperatives an agent must follow*.

## When to add a note here vs. an instruction file

| Content | Goes in |
|---|---|
| Imperative rule an agent should follow ("Use managed identity") | `AGENTS.md`, `CLAUDE.md`, or `.github/instructions/*.md` |
| Path- or tech-specific imperative rule | `.github/instructions/<topic>.instructions.md` |
| Descriptive fact, pattern, or trade-off ("RAG retrieval modes and when each fits") | `docs/knowledge/<topic>.md` |
| Observation extracted from a source, not yet promoted | `docs/research-log.md` |

A topic can have both an instruction file and a knowledge note when the rule is short but the rationale is long. Cross-link them.

## Note structure

Use the documentation style from `CLAUDE.md`:

1. Purpose.
2. When to use this pattern / when it applies.
3. Workflow or pattern body.
4. Trade-offs and decision criteria.
5. Anti-patterns or known limitations.
6. References.

End each note with a `Boundaries` section listing what the note does *not* cover and which sibling file does.

## Existing notes

- [`azure-genai.md`](./azure-genai.md) — Azure / Azure OpenAI / Foundry / RAG / agents / LLMOps reference notes.

## Planned topics (add when you have material)

- `llm-app-patterns.md` — RAG, agent loops, tool use, function calling.
- `prompt-engineering.md` — prompt patterns, system-prompt structure, few-shot strategies.
- `eval-and-observability.md` — offline evals, online metrics, tracing.
- `model-selection.md` — Claude / GPT / Gemini / local model trade-offs (cost, latency, quality, context).
- `coding-agent-comparison.md` — Claude Code, Codex, Cursor, Aider, OpenHands feature matrix.

Add a topic by creating the file, populating the structure above, and listing it under "Existing notes".

## Boundaries

This folder does not contain agent rules (see `AGENTS.md` / `CLAUDE.md` / `.github/instructions/`), source tracking (see `docs/source-repos.md`), or research observations (see `docs/research-log.md`).
