# TASK-013: Clarify Offline Install — Exercise Workspace Location

**Priority:** P2
**Estimated Effort:** 0.25h
**Status:** DONE
**Dependencies:** None
**Blocked By:** None

---

### Objective

Add a clarifying note to the offline install section in README.md so users understand that exercise files are created in `~/.cclab/workspace/`, not inside the cloned plugin directory. This prevents confusion about where their work lives.

### Scope

#### Files to Modify
- `README.md` — Add a note to the "Offline Install" section

#### Files NOT Touched
- Plugin code, skills, exercises

### Design

Keep the current offline install steps as-is. Add a short note after the steps:

```markdown
> **Note:** Your exercise files are created in `~/.cclab/workspace/`, not in the
> cloned repository. The plugin source directory stays clean.
```

### Acceptance Criteria

- [x] AC-1: README offline install section includes a note about `~/.cclab/workspace/` being the exercise workspace
- [x] AC-2: The note clarifies that the cloned repo is not modified by exercises
- [x] AC-3: Existing install steps are unchanged
