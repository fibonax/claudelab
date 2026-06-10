# Master the Edit Tool

Claude has two ways to change a file. The **Write** tool replaces the whole
file with new content. The **Edit** tool makes a surgical replacement — it
swaps one exact string for another and leaves every other byte untouched.

For a one-line bugfix, Edit is the right tool: the diff is tiny and easy to
review, comments and formatting survive, and there's no chance an unrelated
part of the file gets silently rewritten. Rewriting a 200-line file to
change one character is how subtle regressions sneak in.

This exercise is the first one that validates *how* you work, not just the
result. The cclab plugin records which tools Claude uses inside the exercise
workspace (and only there), so the check can tell an Edit from a rewrite.

## Your Task

Customers are being overcharged. Bug report #142 says a 10% discount on a
$50.00 cart charges $55.00 — the discount is being **added** instead of
**subtracted**.

The bug is in `src/discount.ts`, in the `applyDiscount` function. Fix it by
asking Claude to use the **Edit tool** — a one-line surgical change, not a
rewrite of the file.

## Getting Started

First, navigate to the exercise workspace:

```bash
cd ~/.cclab/workspace/cc-009/
```

Read `src/discount.ts` and find the line the bug report describes. Then ask
Claude to fix it — and be explicit about *how*:

> "Fix the discount bug in src/discount.ts using the Edit tool — change only
> the buggy line, don't rewrite the file."

## Requirements

- The discount must be subtracted from the subtotal, not added
- The rest of `src/discount.ts` must be unchanged — the comments and the
  `formatPrice` helper must survive
- The fix must be made with the **Edit** tool (the check reads the tool log)

## Tips

- If Claude rewrites the whole file with Write, run `/cclab:reset` and try
  again with a more explicit prompt
- "Change only line X" or "make a minimal edit" steers Claude toward Edit
- Small, reviewable diffs are a habit worth building — this is how you'd
  want Claude to patch a real production file

## When You're Done

Run `/cclab:check` to validate your work.
