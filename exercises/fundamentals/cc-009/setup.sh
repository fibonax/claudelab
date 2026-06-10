#!/usr/bin/env bash
# Setup for cc-009: Master the Edit Tool
# Scaffolds a pricing module with a one-character bug. Idempotent.

WORKSPACE="$HOME/.cclab/workspace/cc-009"

mkdir -p "$WORKSPACE/src"

# Fresh start: clear any previous tool-usage log so old Edit calls
# can't satisfy this exercise's process validation.
rm -f "$WORKSPACE/.tool_log.jsonl"

# package.json
cat > "$WORKSPACE/package.json" << 'EOF'
{
  "name": "storefront-pricing",
  "version": "1.0.0",
  "description": "Pricing engine for the storefront checkout",
  "type": "module",
  "scripts": {
    "build": "tsc"
  },
  "devDependencies": {
    "typescript": "^5.4.0"
  }
}
EOF

# src/discount.ts — contains the bug: discount is ADDED instead of SUBTRACTED
cat > "$WORKSPACE/src/discount.ts" << 'EOF'
// Pricing engine for the storefront checkout.
// Discounts are expressed as percentages (0-100) and applied to the
// subtotal before tax. All amounts are in cents to avoid float drift.

export interface CartSummary {
  subtotal: number;
  discountPercent: number;
}

export function applyDiscount(cart: CartSummary): number {
  if (cart.discountPercent < 0 || cart.discountPercent > 100) {
    throw new RangeError("discountPercent must be between 0 and 100");
  }
  const discountAmount = Math.round(
    (cart.subtotal * cart.discountPercent) / 100,
  );
  // BUG REPORT #142: customers with a discount code are being charged
  // MORE than the subtotal. A 10% discount on $50.00 charges $55.00.
  const total = cart.subtotal + discountAmount;
  return total;
}

export function formatPrice(cents: number): string {
  const dollars = Math.floor(cents / 100);
  const remainder = Math.abs(cents % 100);
  return `$${dollars}.${String(remainder).padStart(2, "0")}`;
}
EOF

# CLAUDE.md — project description
cat > "$WORKSPACE/CLAUDE.md" << 'EOF'
# Storefront Pricing

## Project Description

The pricing engine for the storefront checkout. Calculates discounted
totals from cart subtotals. All amounts are integers (cents).

## Tech Stack

- TypeScript
- Node.js

## Commands

- `npm run build` — compile TypeScript
EOF
