# Bootstrap

How to drop the agent-instruction files from this repo into a new or existing project.

## Quick start: fresh repo

```bash
GENAI_REPO=https://raw.githubusercontent.com/<your-username>/GenAI_Common/main

curl -fsSL "$GENAI_REPO/AGENTS.md" -o AGENTS.md
curl -fsSL "$GENAI_REPO/CLAUDE.md" -o CLAUDE.md
mkdir -p .github/instructions
curl -fsSL "$GENAI_REPO/.github/copilot-instructions.md" -o .github/copilot-instructions.md

# Only if the project touches Azure / Azure OpenAI / Foundry / RAG / LLMOps:
curl -fsSL "$GENAI_REPO/.github/instructions/azure-ai.instructions.md" \
    -o .github/instructions/azure-ai.instructions.md
```

Replace `<your-username>` with the GitHub account that hosts your fork of `GenAI_Common`.

## Quick start: existing repo with prior rules

Append-mode keeps your existing rules and adds the baseline below them:

```bash
GENAI_REPO=https://raw.githubusercontent.com/<your-username>/GenAI_Common/main

printf "\n" >> AGENTS.md && curl -fsSL "$GENAI_REPO/AGENTS.md" >> AGENTS.md
printf "\n" >> CLAUDE.md && curl -fsSL "$GENAI_REPO/CLAUDE.md" >> CLAUDE.md
printf "\n" >> .github/copilot-instructions.md \
    && curl -fsSL "$GENAI_REPO/.github/copilot-instructions.md" >> .github/copilot-instructions.md
```

After the append, scan each file end-to-end and de-duplicate any sections that now appear twice.

## Replace before use

After installing, edit these sections so the files describe *your* project, not `GenAI_Common`:

| File | Section to replace | Why |
|---|---|---|
| `AGENTS.md` | "Repository purpose" (top of file) | Names this repo by default |
| `CLAUDE.md` | "Repository purpose" (top of file) | Names this repo by default |
| `.github/copilot-instructions.md` | "Repository purpose" (top of file) | Names this repo by default |

Also consider trimming, in any file, references to assets that don't exist in your project:

- `docs/research-log.md`, `docs/source-repos.md`, `docs/knowledge/` — drop the references if you won't track research or knowledge notes.
- `BOOTSTRAP.md` — your downstream repo doesn't need this file.

The remaining content (house style, safety, anti-hallucination, validation, PR format, instruction-layering architecture) is generic and applies to any repo.

## Validate the install

```bash
# All cross-references resolve to files that exist
grep -RIn '\](\./\|](docs/\|](\.github/' .

# No secrets snuck in
git diff --cached | grep -iE 'api[_-]?key|secret|token|password'
```

The first command's output should only list links whose targets exist in your repo (delete or update any that don't). The second should return nothing.

Then run your agent and ask it to summarize the rules it loaded:

- Claude Code: open a session at the repo root and ask "summarize the rules you loaded from CLAUDE.md".
- Codex CLI / Aider / Cursor: prompt for a summary of `AGENTS.md` after session start.
- GitHub Copilot: open a tracked file and ask Copilot Chat to repeat the active instructions.

Correct any misreads by tightening the affected file.

## What you get

- `AGENTS.md` — universal baseline for Codex, Cursor, Aider, Jules, OpenHands, Sourcegraph Amp, Factory, etc.
- `CLAUDE.md` — Claude-specific addenda; cross-references `AGENTS.md`.
- `.github/copilot-instructions.md` — repo-wide Copilot rules.
- `.github/instructions/azure-ai.instructions.md` — path-scoped Copilot rules for Azure/GenAI files (Azure-only projects).

## Boundaries

This file does not cover: writing new rules (see `AGENTS.md` and `docs/ai-agent-coding-strategy.md`), the source-repo research pipeline (see `docs/source-repos.md`), or knowledge notes (see `docs/knowledge/`).
