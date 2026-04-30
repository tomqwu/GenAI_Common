---
description: Azure, Azure OpenAI, Azure AI Foundry, RAG, agents, and LLMOps guidance for code and docs in this repo. Use this instead of generic cloud or AI rules for any file that names an Azure service, Azure OpenAI, Foundry, RAG, or LLMOps. Trigger on phrases like "deploy to Azure", "Azure OpenAI", "Foundry agent", "RAG pipeline", "managed identity".
applyTo: '**/azure*/**, **/*azure*.md, **/*foundry*.md, **/*rag*.md, **/*llmops*.md, examples/azure/**'
---

# Azure and GenAI guidance

Path-scoped rules for content that touches Azure, Azure OpenAI, Azure AI Foundry, RAG pipelines, agents, or LLMOps. Applies to GitHub Copilot via `applyTo:` above. The same content is mirrored for Claude in `.claude/rules/azure-ai.md` if and when that file is added.

## Identity and secrets

- Prefer managed identity over static credentials in every example.
- Use Azure Key Vault for any secret that cannot be eliminated.
- Never hardcode tenant IDs, subscription IDs, resource group names, storage account names, or customer-sensitive identifiers. Use placeholders like `<tenant-id>` or environment variables like `${AZURE_TENANT_ID}`.
- Use `DefaultAzureCredential` (Python: `azure.identity.DefaultAzureCredential`; .NET: `Azure.Identity.DefaultAzureCredential`) for examples that need an auth chain.

## Networking

- Default to private endpoints for AI Search, Azure OpenAI, Storage, and Cosmos in production examples.
- Show explicit firewall and VNet integration when the example crosses a trust boundary.
- Mark a sample `prototype` if it uses public endpoints; do not mark it `production`.

## Observability

- Include Application Insights or OpenTelemetry instrumentation in agent and RAG examples.
- Log prompt and completion token counts where the SDK exposes them. Do not log full prompt or response bodies if they may contain user data.

## Evaluation

- Include at least one offline evaluation step (groundedness, relevance, or task-specific) for any RAG or agent example.
- Reference Azure AI Evaluation SDK or `promptflow.evals` where appropriate.

## Cost

- Note the model SKU (`gpt-4o`, `gpt-4o-mini`, `o3-mini`, etc.) and the rough cost-per-1K-tokens reference.
- Default examples to the cheapest model that meets the quality bar; document when a higher tier is required.

## Responsible AI and content safety

- For user-facing scenarios, include Azure AI Content Safety (input + output filtering) in the example.
- Add a brief responsible-AI note: intended use, known limitations, and a human-review path.

## Financial-services examples

When the example targets financial services, explicitly address:

- Compliance frame (SR 11-7, FFIEC, EBA, MAS, etc. — pick the relevant one).
- Auditability — how the example produces an immutable record of inputs, outputs, and decisions.
- Data governance — data classification, residency, and retention.
- Human review — where a human is in the loop and what they approve.

## Prototype vs. production

Every example must declare its tier in a one-line note at the top:

```text
Tier: prototype
```

or

```text
Tier: production
```

`prototype` allows: public endpoints, static keys, default model, no observability, no evaluation.
`production` requires: managed identity, private endpoints, observability, evaluation, cost note, content safety where applicable.

## Anti-patterns

- Hardcoding region names, tenant IDs, or subscription IDs.
- Using `client.api_key = "<paste-here>"` style. Use environment variables and managed identity.
- Skipping evaluation in RAG examples.
- Skipping content safety in user-facing examples.
- Promoting a `prototype` example without re-tagging.

## References

- Azure OpenAI auth — https://learn.microsoft.com/azure/ai-services/openai/how-to/managed-identity
- Azure AI Foundry — https://learn.microsoft.com/azure/ai-foundry/
- Azure AI Content Safety — https://learn.microsoft.com/azure/ai-services/content-safety/
- Azure AI Evaluation SDK — https://learn.microsoft.com/azure/ai-foundry/how-to/develop/evaluate-sdk
- Responsible AI standard — https://learn.microsoft.com/azure/machine-learning/concept-responsible-ai
