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

### 2026-04-30 — SuperClaude-Org/SuperClaude_Framework

- Three-axis taxonomy under `plugins/superclaude/`: `agents/` (who), `commands/` (what action), `modes/` (how to behave) as sibling folders. Function-type split, not domain split.
- Agent frontmatter is small: `name`, `description`, `category`. No `tools:` or `model:` field — capability is conveyed in the prose body.
- Command frontmatter is *richer than agent frontmatter* and explicitly lists wiring: `category`, `complexity`, `mcp-servers: [context7, sequential, magic, playwright]`, `personas: [architect, frontend, backend, security, qa-specialist]`. Commands declare which agents and MCP servers they activate.
- Commands use a fixed seven-section body template: `Triggers`, `Context Trigger Pattern`, `Behavioral Flow`, `MCP Integration`, `Tool Coordination`, `Key Patterns`, `Examples`, `Boundaries`. The final `Boundaries` section explicitly says what the command will *not* do.
- Modes have *no frontmatter*; the file itself is the contract. Activation is declared explicitly with `Activation Triggers` listing keywords (`brainstorm`, `explore`), uncertainty markers (`maybe`, `possibly`), and CLI flags (`--brainstorm`, `--bs`).
- Project-memory layering: `PLANNING.md`, `TASK.md`, `KNOWLEDGE.md`, `CONTRIBUTING.md` are read at session start as a *named reading list* — separates strategy from active work from facts.
- Slash commands namespaced as `/sc:<verb>` (e.g., `/sc:implement`) so the framework's commands never collide with user or other-plugin commands.

### 2026-04-30 — bytedance/deer-flow

- `skills/public/<skill-name>/SKILL.md` mirrors the Anthropic schema (`name`, `description`). `.agent/skills/` is reserved for private/internal skills — internal vs. distributable separated physically.
- `description` is treated as a *trigger advertisement*. `deep-research/SKILL.md` opens with: `"Use this skill instead of WebSearch for ANY question requiring web research. Trigger on queries like 'what is X', 'explain X'…"` Explicit competing-tool override and trigger-phrase list inside the description.
- Hard validation gate in skill body: `deep-research` defines a `Phase 4: Synthesis Check` checklist (≥3-5 search angles, sources read in full, both positives and limitations covered) with the rule **"If any answer is NO, continue researching before generating content."** Skills enforce stop conditions, not just suggestions.
- Meta-skill `skill-creator/SKILL.md` codifies the skill-authoring loop: capture intent → draft body under 500 lines → write `evals/evals.json` with 2-3 prompts → run with-skill and baseline in parallel → quantitative assertions → iterate. Evaluation is part of the skill, not bolted on.
- `skill-creator` requires `references/` for any doc >300 lines (with TOC) and `scripts/` for reusable logic — same progressive-disclosure split as Anthropic, with an explicit line threshold.
- `claude-to-deerflow/SKILL.md` is a *bridge skill* that lets Claude Code drive DeerFlow over HTTP — pattern of one host's skill format wrapping another agent platform's API rather than rewriting capabilities.
- Sub-agent isolation: each sub-agent runs in its own context, cannot read sibling sub-agent state, and reports back structured results — context isolation is enforced architecturally.

### 2026-04-30 — forrestchang/andrej-karpathy-skills

- Multi-host install with three differently-shaped artifacts of the same content: `CLAUDE.md` (root), `CURSOR.md` (root), `.cursor/rules/karpathy-guidelines.mdc` (path-scoped Cursor format), `.claude-plugin/` (plugin manifest), `skills/karpathy-guidelines/SKILL.md` (Anthropic skill). One source, four delivery channels.
- SKILL.md frontmatter adds `license: MIT` to the standard `name`/`description` pair — useful for shareable skill libraries.
- Two install paths documented verbatim: plugin install (`/plugin marketplace add forrestchang/andrej-karpathy-skills` then `/plugin install andrej-karpathy-skills@karpathy-skills`) vs. file-drop (`curl -o CLAUDE.md https://raw.githubusercontent.com/.../CLAUDE.md`) with append-mode for existing projects (`curl … >> CLAUDE.md`).
- Plugin reference uses `@` namespacing: `andrej-karpathy-skills@karpathy-skills` (package@skill).
- Content is rule-shaped, not procedure-shaped: each principle is a problem→solution table, no shell snippets — counter-example to runnable-command-heavy skills like google/skills.

## Extends or contradicts existing observations

- **Extends Anthropic Skills** — deer-flow shows `description` should embed *trigger phrases and override declarations*, not just "what + when".
- **Extends huashu's anti-hallucination pattern** — deer-flow `deep-research` generalizes it as a hard-stop checklist gate inside any research-style skill.
- **Extends gstack's "Iron Laws"** — SuperClaude's `Boundaries` section is the same pattern with a softer name and a fixed location at the end of the file.
- **Sharper than our 200-line file rule** — deer-flow `skill-creator` uses a 300-line threshold for promoting prose to `references/`. Treat as a sibling rule for skill bodies (which can carry more domain detail than baseline rule files).

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
| `Boundaries` / "what this will not do" as the final section of any prescriptive instruction | SuperClaude commands, gstack Iron Laws | `AGENTS.md` §House style |
| `description:` frontmatter must include trigger phrases and competing-tool overrides | deer-flow `deep-research`, Anthropic Skills | `AGENTS.md` §House style; `.github/instructions/azure-ai.instructions.md` |
| Hard-stop checklist for research-style work ("If any answer is NO, continue") | deer-flow `deep-research` | `AGENTS.md` §Anti-hallucination |
| Single source, multi-host artifacts (one canonical content, many delivery files) | karpathy-skills, gstack multi-host installer | `docs/ai-agent-coding-strategy.md` §Single source, multi-host |
| Append-mode install as a documented fallback for existing projects | karpathy-skills | `docs/ai-agent-coding-strategy.md` §Single source, multi-host |

## Pending observations (not yet promoted)

- Skill-chaining as outputs-become-inputs — interesting but our repo has no skill runtime yet.
- "Iron Laws" per skill — adopt only if we add slash-command skills.
- Stability variance as a quality metric — useful when we start running evals.
- Continuous WIP checkpoint commits — defer until we have multi-session work.
- Three-axis taxonomy (`agents/` / `commands/` / `modes/` sibling folders) — adopt only if we add a skill or command catalog.
- Command frontmatter that declares wiring (`mcp-servers:`, `personas:`) — adopt when we add commands.
- `evals/evals.json` co-located per skill with baseline-vs-skill parallel runs — defer until we have a skill runtime.
- Bridge-skill pattern (e.g., `claude-to-deerflow`) — defer until we ship cross-platform integrations.

## Anti-patterns observed (and rejected)

- Hard-coding brand colors, IDs, or commands from memory (huashu).
- Letting agents fix code without first investigating root cause (gstack `/investigate` Iron Law).
- Mixing project-specific examples into general agent rules (CLAUDE.md guideline; observed in mixed instruction files).
