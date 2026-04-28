# Source repositories

Tracking sources studied to extract reusable AI-coding-agent practices.

## How to use this file

- Add a row when a new source is introduced.
- Set `Status = extracted` only after observations are recorded in `research-log.md`.
- Set `Status = promoted` once at least one practice was promoted into `AGENTS.md`, `CLAUDE.md`, or a Copilot instruction file.
- Do not delete rows. If a source is rejected, mark `Status = rejected` and keep the row.

## Sources

| Source | Type | Status | Used for | URL |
|---|---|---|---|---|
| google/skills | Repo | promoted | Skill-folder layout, progressive disclosure via `references/`, imperative runnable snippets | https://github.com/google/skills |
| alchaincyf/huashu-design | Repo | promoted | Anti-hallucination rules, "Junior Designer" early-feedback workflow, fallback-mode taxonomy | https://github.com/alchaincyf/huashu-design |
| garrytan/gstack | Repo | promoted | Skill chaining, Iron Laws, safety guardrails (`/careful`, `/freeze`), multi-host installer | https://github.com/garrytan/gstack |
| AGENTS.md spec | Spec | promoted | Cross-agent baseline file format and section conventions | https://agents.md/ |
| openai/agents.md | Repo | promoted | Canonical AGENTS.md reference and examples | https://github.com/openai/agents.md |
| openai/codex AGENTS.md | Live example | promoted | Production AGENTS.md with file-path-scoped rules and explicit lint commands | https://raw.githubusercontent.com/openai/codex/main/AGENTS.md |
| Claude Code memory docs | Docs | promoted | `CLAUDE.md` scope stacking, `.claude/rules/` with `paths:` frontmatter, `@import` syntax | https://docs.claude.com/en/docs/claude-code/memory |
| Anthropic Agent Skills overview | Docs | promoted | `SKILL.md` frontmatter (`name`, `description`), progressive disclosure model | https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview |
| Anthropic Skills announcement | Article | extracted | Skills as filesystem-based on-demand capability packages | https://www.anthropic.com/news/skills |
| anthropics/skills | Repo | extracted | Reference SKILL.md examples | https://github.com/anthropics/skills |
| GitHub Copilot custom instructions | Docs | promoted | `.github/copilot-instructions.md` and `.github/instructions/*.instructions.md` with `applyTo:` glob frontmatter | https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions |
| github/awesome-copilot | Repo | extracted | Real-world `applyTo:` and `description:` frontmatter examples | https://github.com/github/awesome-copilot/tree/main/instructions |

## Adding a new source

1. Append a row above with `Status = pending`.
2. Open `docs/research-log.md` and add a section under **Observations** with date, source name, and 3-6 bullet observations.
3. Decide which observations are stable enough to promote.
4. Promote into `AGENTS.md`, `CLAUDE.md`, or a Copilot instruction file as appropriate.
5. Update `Status` here to `extracted` then `promoted`.

## Caveats

- `docs.github.com` and `code.visualstudio.com` pages may be blocked from sandboxed agents. When that happens, prefer canonical examples in `github/awesome-copilot` and the `openai/codex` AGENTS.md to verify conventions.
- The Copilot docs path has changed over time (`customizing-copilot/adding-repository-custom-instructions-for-github-copilot` → `how-tos/configure-custom-instructions/add-repository-instructions`). Prefer linking the current path and re-verify when editing.
