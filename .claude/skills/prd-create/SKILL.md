---
name: prd-create
description: Create a Product Requirements Document (PRD) for a feature or MVP. Use when the user says "create PRD", "write PRD", "product requirements", "define MVP", "MVP requirements", or wants to define what to build before designing or implementing. Also trigger on "what should we build" or "scope the feature".
disable-model-invocation: true
---

# Create PRD

Write a Product Requirements Document following the cclab template.

## Process

### Step 1: Interview
Interview the user to understand the product scope. Use AskUserQuestion for each.
Do NOT skip the interview — the PRD quality depends on understanding the user's intent.

Questions to cover:
1. What problem does this solve? Who has this problem?
2. What is the MVP scope? What is explicitly OUT of scope?
3. Who are the target users? What are their skill levels?
4. What does success look like? How will we measure it?
5. Are there any hard constraints? (tech, timeline, dependencies)
6. What existing solutions or prior art should we study?

### Step 2: Research (use subagents)
If the project already has code, use a subagent to explore:
- Existing architecture and patterns
- Related features already implemented
- Dependencies and constraints from the codebase

If there's prior art to study, use a subagent with WebSearch to research:
- Competing products or similar tools
- Best practices in the domain

### Step 3: Write the PRD
Save to: `docs/prd/PRD-{feature-name}.md`
Use the template structure below exactly.

### Step 4: Present and STOP
Present the PRD to the user. Say:
"Here is the PRD. Please review it. When you approve, I'll proceed to Curriculum Design.
If you want changes, tell me what to modify."

DO NOT proceed to any next phase until the user explicitly approves.

## PRD Template

# PRD: {Feature/MVP Name}

**Version:** 1.0
**Date:** {YYYY-MM-DD}
**Author:** {name}
**Status:** DRAFT | IN REVIEW | APPROVED

---

### 1. Problem Statement

What problem are we solving? Why does it matter?
Write 2-3 paragraphs describing the pain point from the user's perspective.

### 2. Target Users

| User Persona | Description | Primary Need |
|---|---|---|
| Persona 1 | ... | ... |
| Persona 2 | ... | ... |

### 3. Goals & Success Metrics

#### Goals
- Goal 1: ...
- Goal 2: ...

#### Success Metrics
| Metric | Target | How to Measure |
|---|---|---|
| ... | ... | ... |

### 4. MVP Scope

#### In Scope (MVP1)
- Feature/capability 1
- Feature/capability 2
- ...

#### Out of Scope (Future)
- Feature that's tempting but not MVP
- ...

#### Non-Goals
- Things we explicitly will NOT do and why

### 5. User Stories

#### Story 1: {Title}
**As a** {persona}, **I want to** {action}, **so that** {outcome}.
**Acceptance Criteria:**
- [ ] Criterion 1
- [ ] Criterion 2

#### Story 2: {Title}
...

(Include 5-10 user stories for MVP)

### 6. Functional Requirements

#### FR-001: {Requirement Name}
**Priority:** P0 (must have) | P1 (should have) | P2 (nice to have)
**Description:** ...
**Acceptance Criteria:**
- [ ] ...

(List all functional requirements with IDs for traceability)

### 7. Non-Functional Requirements

- **Performance:** ...
- **Security:** ...
- **Accessibility:** ...
- **Compatibility:** ...
- **Reliability:** ...

### 8. Constraints & Dependencies

- Constraint 1: ...
- Dependency 1: ...

### 9. Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| ... | High/Med/Low | High/Med/Low | ... |

### 10. Open Questions

- [ ] Question 1
- [ ] Question 2

### 11. References & Prior Art

- Reference 1: [link]
- ...