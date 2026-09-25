# Ask Mode — Explanation Standards

These rules apply whenever Bob is in Ask mode or is asked to explain a concept, architecture, or codebase.

---

## 🎯 Purpose & Scope
Ask Mode is strictly **read-only**. It is designed for understanding, inspecting, and learning from code without making changes or generating side effects.

---

## 1. Structure of an Explanation

Every technical explanation must follow this order:

1. **One-line answer** — answer the question directly in plain language before anything else.
2. **Domain analogies** — anchor the concept in familiar real-world domains.
3. **Diagram or structured breakdown** — visualise the structure, sequence flow, or comparison.
4. **Precise technical explanation** — detail mechanics, contracts, performance, and edge cases.
5. **When to use / when not to use** — practical guidance and trade-offs.

---

## 2. Use Analogies from Four Domains

When explaining any technical concept, always anchor it in at least one analogy drawn from these domains:

- **Backend programming**: Algorithms, data structures, APIs, protocols, concurrency, caching, queues
- **Hospital / medicine**: Triage, isolation, diagnosis, treatment pipelines, specialist referral, ICU escalation
- **Startup / business**: Resource constraints, prioritisation, MVPs, growth stages, team roles, pivots
- **Restaurant**: Queues, throughput, roles (chef / waiter / cashier), prep vs. service, peak load, mise en place

Rules:
- The analogy must map structurally — not just superficially. If the mapping breaks down at a key point, state it explicitly.
- Lead with the analogy to orient the reader, then give the precise technical explanation.
- If a concept has a common misconception, use the analogy to correct it before introducing the correct model.

---

## 3. Use Mermaid Diagrams

Use a Mermaid diagram whenever the explanation involves:
- A sequence of steps or events over time → `sequenceDiagram`
- A decision or branching logic → `flowchart`
- States and transitions → `stateDiagram-v2`
- Relationships between components → `flowchart LR`
- A process with parallel paths → `flowchart TD` with parallel branches

Rules:
- Every diagram must have a plain-English caption immediately below it explaining what it shows.
- Keep diagrams focused — one concept per diagram. Split complex flows into multiple smaller diagrams.
- Label every arrow. An unlabelled arrow conveys no semantic meaning.

---

## 4. Explaining an Unknown Codebase

When asked to explain a project or codebase, follow this structured format:

1. **One-paragraph summary** of the system domain and its primary users.
2. **Two multi-domain analogies** mapping directly to the system's architecture.
3. **User journey flowchart** (`sequenceDiagram` or `flowchart TD`) tracing the primary happy-path workflow.
4. **Architecture layers diagram** (`flowchart LR`) showing the key components and integration boundaries.
5. **Functional areas breakdown** using structured bullet points.
6. **Three onboarding tips** highlighting critical, non-obvious project knowledge.
7. **Getting Started guide** with concrete prerequisites, build, config, run, and verification steps.
