# Structured Prompt-Driven Development (SPDD)

## Purpose

Describe SPDD, a method from Thoughtworks Global IT Services for making LLM-assisted changes governable, reviewable, and reusable by treating the prompt as a first-class delivery artifact kept in version control alongside the code.

This is a descriptive note, not a rule. The promoted imperative ("keep spec and code in two-way sync") lives in `AGENTS.md` house style.

## When it applies

SPDD pays off when change must be governed and carried forward across iterations:

- Scaled or standardized delivery with long-term maintainability.
- Hard-constraint or compliance systems (financial core, regulated domains).
- Multi-person delivery where every change must be traceable and reviewable.
- Cross-cutting refactors where logic must stay synchronized across services.

It does not pay off for firefighting hotfixes, exploratory spikes, one-off scripts, ill-defined domains, or taste-driven creative work.

## The REASONS Canvas

A seven-part structured prompt that moves uncertainty left — from code review to design time.

| Letter | Dimension | Captures |
|---|---|---|
| R | Requirements | The problem and the definition of done |
| E | Entities | Domain entities and their relationships |
| A | Approach | The strategy for meeting the requirements |
| S | Structure | Where the change fits; components and dependencies |
| O | Operations | Concrete, testable implementation steps |
| N | Norms | Cross-cutting norms (naming, observability, defensive coding) |
| S | Safeguards | Non-negotiable boundaries (invariants, performance, security) |

R-E-A-S are abstract (intent and design); O is execution; N-S are governance. Because the full specification lives in one artifact, reviewers reason about a single document instead of scattered chat logs and partial diffs.

## Pattern body: the closed loop

The workflow is a closed loop: business input → abstraction → execution → validation → release, with prompt and code evolving together.

Reference tooling (`openspdd`) implements the loop as discrete, versioned CLI steps — analysis, canvas generation, code generation, prompt update, and sync — so artifacts stay reviewable instead of trapped in chat. The structured prompt is never hand-edited; gaps are corrected by instructing the model to update only the affected Canvas sections.

## Spec/code two-way sync

The directional rule that distinguishes SPDD from one-shot spec-driven development:

- **Behavior change** (new requirement, bug fix, logic correction): update the spec first, then regenerate or patch the code from it. "When reality diverges, fix the prompt first — then update the code."
- **Refactor** (no observable behavior change): change the code first, then sync the spec back so it stays an accurate record of the current code.

Both directions keep intent and implementation from drifting apart. Birgitta Böckeler categorizes this as a *spec-anchored* approach: the spec is maintained, not generated once and discarded.

## Trade-offs and decision criteria

| Benefit | Nature |
|---|---|
| Determinism | A precise spec reduces hallucination and creative interpretation |
| Traceability | Every change traces back to the structured prompt; closes the audit loop |
| Faster reviews | Code arrives closer to standards; review focuses on logic, not cleanup |
| Safer evolution | Defined boundaries make targeted change lower-risk |

The upfront cost is real: a design-first mindset shift, senior abstraction skill per feature, and automation tooling to keep prompts consistent. Without automation the method hits a throughput ceiling.

## Anti-patterns

- Treating the spec as write-once scaffolding and letting it rot after first generation.
- Hand-editing the structured prompt instead of regenerating affected sections.
- Applying SPDD's governance overhead to throwaway or exploratory work.
- Skipping the sync-back step after a refactor, so the spec lies about the code.

## References

- Structured-Prompt-Driven Development — <https://martinfowler.com/articles/structured-prompt-driven/>
- Wei Zhang and Jessie Jie Xia, Thoughtworks, 28 April 2026.
- `docs/research-log.md` — dated observations this note was promoted from.

## Boundaries

This note does not cover: the repository's instruction-layering rules (`AGENTS.md`, `CLAUDE.md`), the research-handling pipeline (`docs/research-log.md`, `docs/source-repos.md`), or generic agent-integration plumbing (`docs/knowledge/agent-integration-patterns.md`).
