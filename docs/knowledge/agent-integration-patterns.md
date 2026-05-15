# Agent integration patterns

## Purpose

Capture reusable architecture patterns for connecting AI coding agents to each other and to external surfaces, extracted from `chenhg5/cc-connect` (a Go bridge daemon linking local coding agents to chat platforms).

This is a descriptive note. The patterns are language-agnostic even though the source is Go.

## When it applies

Reach for these patterns when building any layer that bridges, multiplexes, or wraps multiple agents or hosts: a connector daemon, an MCP gateway, a multi-agent provider config, or a cross-tool installer.

## Pattern body

### Bridge daemon

A single long-running process connects locally-running agents (Claude Code, Codex, Cursor, Gemini CLI, …) to external surfaces (chat platforms, webhooks) so the agent is drivable remotely with no public IP. The daemon is transport and orchestration only — it carries no instruction logic.

### Capability-interface over identity-switch

Behavior differences between integrations go through capability interfaces, never `if target.Name() == "feishu"`. Adding an integration means implementing an interface, not editing a switch. This keeps the core closed to modification.

### Plugin self-registration with a strict dependency direction

Adapters register themselves at init time (`RegisterAgent()` / `RegisterPlatform()`). The `core/` package must never import `agent/` or `platform/` — dependencies point inward only. The core is the stable nucleus; adapters are the volatile edge.

### Uniform per-host adapter layout

One folder per integration target (`agent/{claudecode,codex,cursor,gemini,…}/`) with the same internal file shape. Predictable layout makes a new adapter a copy-and-fill exercise.

### Versioned, dual-language preset manifest

Catalog-style extension manifests carry `version`, `updated_at`, and per-entry `name` / `display_name` / `description` / localized description / `tags` / `featured`. A provider abstraction nests per-agent-type config (`base_url`, `model`, `models`) so one provider serves heterogeneous agents.

### Secrets and auth posture

Secrets are injected via `${ENV_VAR}` interpolation, never inline. A redaction helper keeps tokens out of logs. Per-project authorization uses an admin allowlist, OS-user isolation for the run-as identity, and role-scoped command denylists and rate limits.

### Session and context lifecycle as config

Idle reset, auto-compression thresholds, and heartbeat intervals are explicit configuration keys, not hardcoded constants — context management is operator-tunable.

## Trade-offs and decision criteria

- Capability interfaces and self-registration add indirection; worth it once there are 3+ integrations, overkill for one.
- Selective compilation (build tags dropping unused integrations) trims binary size but is language-specific; treat as Go-flavored, not universal.
- A dual-language manifest is valuable only when the audience is genuinely multilingual.

## Anti-patterns

- Branching on integration identity instead of a capability interface.
- Letting the core import adapter packages (inverts the dependency arrow; every adapter change risks the core).
- Inlining credentials instead of env-var interpolation; logging un-redacted tokens.
- Shipping duplicated `AGENTS.md` and `CLAUDE.md` with no cross-reference — observed in cc-connect and the precise drift hazard the single-source-and-mirror discipline prevents.

## References

- `chenhg5/cc-connect` — <https://github.com/chenhg5/cc-connect>
- `docs/research-log.md` — dated observations this note was promoted from.

## Boundaries

This note does not cover: the repository's instruction-layering rules (`AGENTS.md`, `CLAUDE.md`), the structured-prompt method (`docs/knowledge/structured-prompt-driven-development.md`), or Azure-specific guidance (`docs/knowledge/azure-genai.md`).
