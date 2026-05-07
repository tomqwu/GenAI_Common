# Azure and GenAI reference

Descriptive notes on building with Azure OpenAI, Azure AI Foundry, RAG pipelines, agents, and LLMOps. The imperative rules for code/doc edits live in [`.github/instructions/azure-ai.instructions.md`](../../.github/instructions/azure-ai.instructions.md); this file captures the *why* and the trade-offs.

## When this guidance applies

Any code or design touching: Azure OpenAI, Azure AI Search, Azure AI Foundry, Azure AI Content Safety, Azure AI Evaluation SDK, RAG pipelines on Azure, or LLMOps on Azure.

## Identity and secrets

Managed identity is the default. `DefaultAzureCredential` (Python: `azure.identity.DefaultAzureCredential`; .NET: `Azure.Identity.DefaultAzureCredential`) lets the same code work in dev (CLI / VS Code), CI (federated identity), and prod (managed identity) without code changes. Static keys are a debug-only fallback.

When secrets cannot be eliminated (third-party API keys, signing material), Key Vault is the store. Identifiers (tenant, subscription, resource group, account names) are placeholders or environment variables, never literal in committed code.

## Networking

Production AI workloads default to private endpoints for AI Search, Azure OpenAI, Storage, and Cosmos. Public endpoints belong to prototypes and must be explicitly tagged `Tier: prototype`.

Trade-off: private endpoints add DNS, peering, and firewall complexity. For early prototypes, the speed of iteration on public endpoints often outweighs the security premium — but only with `prototype` tagging and no real customer data.

## Observability

App Insights or OpenTelemetry on every agent and RAG path. Log token counts (prompt + completion), latency, model SKU, and error class. Do not log raw prompt or completion bodies if they may contain user data; redact or hash before emitting.

## Evaluation

Offline evals before any production rollout.

- For RAG: groundedness + relevance + retrieval recall.
- For agents: task-specific success rate + tool-use correctness + step count.

Azure AI Evaluation SDK or `promptflow.evals` are the convenient options; rolling your own is fine if the metric is repo-specific. Whatever the choice, keep the eval set in version control alongside the prompt.

## Cost

Note the model SKU and rough cost-per-1K-tokens reference in any sample. Default to the cheapest model that meets the quality bar; document explicitly when a higher tier is required. Common cheap defaults at the time of writing: `gpt-4o-mini`, `o3-mini`. Re-check pricing before relying on a number.

## Responsible AI and content safety

User-facing scenarios add Azure AI Content Safety on both input and output. Every user-facing sample includes a brief "intended use, known limitations, human-review path" note.

## Financial services

Compliance, auditability, data governance, and human review are first-class concerns:

- **Compliance** — name the relevant frame (SR 11-7, FFIEC, EBA, MAS, etc.).
- **Auditability** — immutable record of inputs, outputs, decisions.
- **Data governance** — classification, residency, retention.
- **Human review** — where the human is in the loop and what they approve.

## Prototype vs. production tier

Tag every example. `prototype` is allowed to use public endpoints, static keys, default models, and skip observability/evaluation. `production` requires managed identity, private endpoints, observability, evaluation, cost note, and content safety where applicable. A `prototype` cannot be promoted to `production` without re-tagging and adding the missing pieces.

## References

- Azure OpenAI auth — https://learn.microsoft.com/azure/ai-services/openai/how-to/managed-identity
- Azure AI Foundry — https://learn.microsoft.com/azure/ai-foundry/
- Azure AI Content Safety — https://learn.microsoft.com/azure/ai-services/content-safety/
- Azure AI Evaluation SDK — https://learn.microsoft.com/azure/ai-foundry/how-to/develop/evaluate-sdk
- Responsible AI standard — https://learn.microsoft.com/azure/machine-learning/concept-responsible-ai
- Imperative rules: [`.github/instructions/azure-ai.instructions.md`](../../.github/instructions/azure-ai.instructions.md)

## Boundaries

This file does not contain imperative agent rules (see `.github/instructions/azure-ai.instructions.md`), Azure-specific runnable code samples (a future `examples/azure/` if added), or general AI patterns not Azure-specific (sibling notes in `docs/knowledge/`).
