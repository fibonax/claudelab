# TASK-014: Multi-Track Infrastructure Refactoring

**Priority:** P0
**Estimated Effort:** 3h
**Status:** TODO
**Dependencies:** None
**Blocked By:** None

---

### Objective

Refactor the 5 learner-facing skills (`/start`, `/check`, `/hint`, `/reset`, `/status`) to support multiple exercise tracks. Currently all skills hardcode "fundamentals" in their path resolution. After this task, skills dynamically resolve the track from exercise metadata, enabling the Workflows track to work alongside Fundamentals.

### Scope

#### Files to Create
- `exercises/workflows/.gitkeep` — Create the workflows track directory

#### Files to Modify
- `.claude/skills/start/SKILL.md` — Replace ~6 hardcoded "fundamentals" paths with dynamic track lookup; add track transition logic (fundamentals complete → offer workflows); add "recommend but don't block" for users skipping fundamentals
- `.claude/skills/check/SKILL.md` — Replace ~4 hardcoded "fundamentals" paths with dynamic track resolution via exercise metadata
- `.claude/skills/hint/SKILL.md` — Replace ~2 hardcoded "fundamentals" paths
- `.claude/skills/reset/SKILL.md` — Replace ~2 hardcoded "fundamentals" paths
- `.claude/skills/status/SKILL.md` — Replace ~2 hardcoded "fundamentals" paths; update dashboard to show multiple tracks with per-track completion stats

#### Files NOT Touched
- Exercise content in `exercises/fundamentals/` — no changes to existing exercises
- Dev-only skills (create-exercise, validate-exercise, etc.) — already support multiple tracks
- `plugin.json` — no manifest changes needed
- `.claude/settings.json` — no permission changes needed

### Acceptance Criteria

- [ ] AC-1: All 5 skills resolve exercise paths dynamically: read `track` field from exercise `metadata.json`, construct path as `exercises/<track>/<exercise-id>/`
- [ ] AC-2: Exercise discovery scans all track directories under `exercises/` (not just `exercises/fundamentals/`)
- [ ] AC-3: All 8 existing Fundamentals exercises (cc-001 through cc-008) continue to work identically after refactoring
- [ ] AC-4: `/cclab:start` handles track transitions: when all Fundamentals exercises are complete, it offers the Workflows track
- [ ] AC-5: `/cclab:start` allows starting Workflows without completing Fundamentals (shows recommendation message but proceeds)
- [ ] AC-6: `/cclab:status` shows per-track progress (each track with its own completion percentage and exercise list)
- [ ] AC-7: `exercises/workflows/` directory exists
- [ ] AC-8: progress.json remains backward compatible — existing MVP1 progress files work without migration
- [ ] AC-9: The `wf-NNN` exercise ID pattern is recognized alongside `cc-NNN`

### Technical Notes

- The key refactoring pattern: instead of hardcoding `exercises/fundamentals/$exercise_id/`, read the exercise's `metadata.json` to get its `track` field, then use `exercises/$track/$exercise_id/`.
- For exercise discovery, glob `exercises/*/metadata.json` instead of `exercises/fundamentals/*/metadata.json`.
- Track ordering: fundamentals first, workflows second. Determine by directory convention or a track-level metadata file.
- progress.json schema should continue to work as-is — exercise IDs are globally unique (`cc-NNN` vs `wf-NNN`), so the `completed` array and `current_exercise` field naturally support multi-track.

### Requirement Traceability

| PRD Requirement | Curriculum Exercise |
|---|---|
| FR-001 (Multi-Track Support) | — |
| FR-002 (Track Selection & Transitions) | — |
| FR-009 (Updated Progress Dashboard) | — |
