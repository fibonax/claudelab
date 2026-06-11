# Hints for cc-009: Master the Edit Tool

## Hint 1

Read `src/discount.ts` first — the bug report comment (#142) sits right
above the buggy line. The symptom tells you the math: a discount should
make the total smaller, but this one makes it bigger. When you ask Claude
to fix it, think about *how small* the change really needs to be.

## Hint 2

The bug is one character: `applyDiscount` computes
`cart.subtotal + discountAmount` instead of subtracting. Ask Claude to fix
exactly that line **with the Edit tool** — say "use Edit, don't rewrite the
file". The validator reads cclab's tool log, so a full-file rewrite with
Write won't pass even if the math ends up right.

## Hint 3

Tell Claude: "In ~/.cclab/workspace/cc-009/src/discount.ts, use the Edit
tool to change `const total = cart.subtotal + discountAmount;` to
`const total = cart.subtotal - discountAmount;`. Change nothing else."
If a previous attempt rewrote the file, run `/cclab:reset` first so the
tool log starts clean, then make the single edit.
