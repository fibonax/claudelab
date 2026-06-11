#!/usr/bin/env bash
# Setup for adv-005: Forked Context
# Scaffolds a docs-heavy project for building a forked summarization skill
# with named arguments. Idempotent.

WORKSPACE="$HOME/.cclab/workspace/adv-005"

# Reset learner-created artifacts so /cclab:reset restores the initial state
rm -rf "$WORKSPACE/.claude/skills/summarize"

mkdir -p "$WORKSPACE/docs"
mkdir -p "$WORKSPACE/.claude/skills"

# docs/changelog.md -- a release changelog (summarization target #1)
cat > "$WORKSPACE/docs/changelog.md" << 'EOF'
# Changelog

## v2.3.0 (2026-05-28)

### Added
- Streaming export pipeline: large reports now stream to disk in 4 MB
  chunks instead of buffering the whole payload in memory.
- New `--profile` flag on the CLI for switching between staging and
  production credentials without editing config files.
- Webhook retry queue with exponential backoff (max 5 attempts).

### Changed
- Default request timeout raised from 10s to 30s to accommodate the new
  bulk endpoints.
- The `/api/reports` endpoint now paginates at 100 items per page
  (previously unbounded -- this caused several OOM incidents).

### Fixed
- Race condition in the session cache that could serve another user's
  preferences during concurrent logins.
- Timezone drift in scheduled jobs: cron expressions are now evaluated
  in UTC everywhere instead of server-local time.

## v2.2.1 (2026-04-12)

### Fixed
- Hotfix: rollback of the connection pooler upgrade that leaked file
  descriptors under sustained load.
- CSV export no longer truncates cells containing embedded newlines.
EOF

# docs/design-note.md -- an architecture design note (summarization target #2)
cat > "$WORKSPACE/docs/design-note.md" << 'EOF'
# Design Note: Event-Driven Sync Service

## Problem

The nightly batch sync between the orders database and the analytics
warehouse takes four hours and regularly misses its window. Analysts
start their day with stale data, and a single failed row aborts the
whole run.

## Proposal

Replace the batch job with an event-driven sync service. Every write to
the orders database emits a change event onto a durable queue; a small
consumer applies each event to the warehouse within seconds.

## Key Decisions

1. Change capture happens at the database level (logical replication),
   not in application code, so no service can forget to emit an event.
2. Events are idempotent upserts keyed by order ID and version number.
   Replaying the queue is always safe.
3. Failures are isolated: a bad event goes to a dead-letter queue with
   full context instead of aborting the stream.

## Trade-offs

- Operational surface grows: we now run a queue and a consumer instead
  of one cron job.
- Eventual consistency: dashboards may lag writes by a few seconds,
  which the analytics team has confirmed is acceptable.
EOF

# CLAUDE.md -- project description
cat > "$WORKSPACE/CLAUDE.md" << 'EOF'
# Forked Context

## Project Description

A documentation-heavy project used as a playground for building a
summarization skill in Claude Code. The docs/ folder contains long
documents that nobody wants pasted into the main conversation -- ideal
material for a skill that runs in a forked context.

## Structure

- `docs/changelog.md` -- release changelog across two versions
- `docs/design-note.md` -- architecture design note for a sync service
- `.claude/skills/` -- where your summarize skill goes

## Conventions

- Summaries should be short, plain-language, and pitched at a specific
  audience (engineers, managers, new hires, ...).
EOF
