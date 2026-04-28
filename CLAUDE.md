# CLAUDE.md

This file provides project memory and working rules for Claude Code when working in this repository.

The cross-agent baseline lives in [`AGENTS.md`](./AGENTS.md). Read it first when rules in the two files appear to overlap; Claude-specific addenda below take precedence inside Claude Code sessions.

## Repository purpose

`GenAI_Common` is a living knowledge base for practical AI-agent-assisted software engineering. It collects reusable instructions, coding-agent patterns, implementation playbooks, research notes, and Azure/GenAI architecture guidance.

This repository is not a product application. It is an enablement and reference repository.

## Primary operating mode

When working in this repository, Claude Code should act as a senior AI engineering assistant and technical editor.

The default workflow is:

1. Inspect existing files before proposing changes.
2. Identify whether the request is research, documentation, code, architecture, or repo hygiene.
3. Propose a short patch plan for non-trivial changes.
4. Make small, reviewable edits.
5. Preserve repo structure and naming conventions.
6. Summarize changed files and validation performed.

## Editing principles

- Prefer concise, practical guidance over abstract AI commentary.
- Write instructions that another coding agent can follow without extra explanation.
- Use imperative language for agent rules.
- Keep reusable guidance separate from project-specific examples.
- Do not bury critical constraints inside long prose.
- Prefer checklists, templates, and examples where they help execution.
- Avoid marketing language unless the file is explicitly a sales or executive artifact.

## Repository structure

Expected structure:

```text
.
├── README.md
├── CLAUDE.md
├── AGENTS.md
├── .github/
│   ├── copilot-instructions.md
│   └── instructions/
│       └── azure-ai.instructions.md
└── docs/
    ├── ai-agent-coding-strategy.md
    ├── research-log.md
    └── source-repos.md
```

## Agent instruction hierarchy

Use this precedence order when instructions overlap:

1. User request in the current task.
2. Repository-specific instructions in `CLAUDE.md` or `AGENTS.md`.
3. Path-specific instructions under `.github/instructions/`.
4. General guidance in `docs/`.
5. Inferred best practices.

When a conflict exists, follow the more specific and safer instruction.

## Research handling

When the user provides repositories, guides, articles, or PDFs:

1. Record the source in `docs/source-repos.md` or the appropriate source tracker.
2. Extract practices into `docs/research-log.md`.
3. Promote only stable, actionable practices into `CLAUDE.md`, `AGENTS.md`, or Copilot instruction files.
4. Separate observations from rules.
5. Do not represent unverified research as an established best practice.

## Coding guidance

This repo may later contain code samples. When editing or adding code:

- Read the local project conventions first.
- Keep examples minimal and runnable.
- Include commands to validate examples.
- Avoid adding dependencies unless there is a clear reason.
- Prefer secure defaults for Azure, identity, secrets, networking, and data access.
- Never hardcode secrets, API keys, tenant IDs, subscription IDs, or customer-sensitive identifiers.

## Azure and GenAI defaults

For Azure AI, Azure OpenAI, Azure AI Foundry, RAG, agents, and LLMOps content:

- Prefer managed identity over static credentials.
- Prefer Key Vault for secrets when secrets are unavoidable.
- Include network, identity, observability, evaluation, and cost considerations.
- Include responsible AI and content safety considerations for user-facing scenarios.
- Distinguish prototype guidance from production guidance.
- For financial services examples, explicitly address compliance, auditability, data governance, and human review.

## Documentation style

Use this style for docs:

- Start with the purpose.
- Explain when to use the pattern.
- Provide the minimum viable workflow.
- Add implementation checklist.
- Add validation checklist.
- Add anti-patterns.
- Add references or source notes when applicable.

## Change safety

Before large edits:

- Check whether the file is canonical guidance used by agents.
- Preserve headings that tools may rely on.
- Prefer append-and-refine over replacing entire documents.
- Do not delete research notes unless explicitly requested.

## Pull request / commit summary format

When summarizing work, use:

```text
Summary:
- ...

Changed files:
- path: reason

Validation:
- ...

Follow-ups:
- ...
```

## Do not do

- Do not invent external facts or claim research was completed when it was not.
- Do not add private customer information.
- Do not add copyrighted long-form source content.
- Do not turn exploratory notes into mandatory rules without review.
- Do not create large, tool-specific silos that contradict each other.
