#!/usr/bin/env bash
# Validation for cc-005: The Great Refactor
# Checks: getUserData is completely gone, fetchUserProfile exists in all 5 files

WORKSPACE="$HOME/.cclab/workspace/cc-005"
PASS=true

# Check 1: No file in src/ contains getUserData (old name is completely gone)
OLD_REFS=$(grep -rl "getUserData" "$WORKSPACE/src/" 2>/dev/null)
if [ -n "$OLD_REFS" ]; then
  echo "FAIL: The old name getUserData still exists in these files:"
  for f in $OLD_REFS; do
    echo "  - ${f#$WORKSPACE/}"
  done
  echo "  Rename getUserData to fetchUserProfile in every file."
  PASS=false
fi

# Check 2: fetchUserProfile exists in user-service.ts (definition)
if [ ! -f "$WORKSPACE/src/services/user-service.ts" ]; then
  echo "FAIL: src/services/user-service.ts not found"
  PASS=false
elif ! grep -q "fetchUserProfile" "$WORKSPACE/src/services/user-service.ts"; then
  echo "FAIL: src/services/user-service.ts missing fetchUserProfile"
  echo "  Rename the function definition from getUserData to fetchUserProfile."
  PASS=false
fi

# Check 3: fetchUserProfile exists in routes/users.ts
if [ ! -f "$WORKSPACE/src/routes/users.ts" ]; then
  echo "FAIL: src/routes/users.ts not found"
  PASS=false
elif ! grep -q "fetchUserProfile" "$WORKSPACE/src/routes/users.ts"; then
  echo "FAIL: src/routes/users.ts missing fetchUserProfile"
  echo "  Update the import and call sites in this file."
  PASS=false
fi

# Check 4: fetchUserProfile exists in routes/admin.ts
if [ ! -f "$WORKSPACE/src/routes/admin.ts" ]; then
  echo "FAIL: src/routes/admin.ts not found"
  PASS=false
elif ! grep -q "fetchUserProfile" "$WORKSPACE/src/routes/admin.ts"; then
  echo "FAIL: src/routes/admin.ts missing fetchUserProfile"
  echo "  Update the import and call sites in this file."
  PASS=false
fi

# Check 5: fetchUserProfile exists in middleware/auth.ts
if [ ! -f "$WORKSPACE/src/middleware/auth.ts" ]; then
  echo "FAIL: src/middleware/auth.ts not found"
  PASS=false
elif ! grep -q "fetchUserProfile" "$WORKSPACE/src/middleware/auth.ts"; then
  echo "FAIL: src/middleware/auth.ts missing fetchUserProfile"
  echo "  Update the import and call sites in this file."
  PASS=false
fi

# Check 6: fetchUserProfile exists in tests/user.test.ts
if [ ! -f "$WORKSPACE/src/tests/user.test.ts" ]; then
  echo "FAIL: src/tests/user.test.ts not found"
  PASS=false
elif ! grep -q "fetchUserProfile" "$WORKSPACE/src/tests/user.test.ts"; then
  echo "FAIL: src/tests/user.test.ts missing fetchUserProfile"
  echo "  Update the import and test references in this file."
  PASS=false
fi

if [ "$PASS" = true ]; then
  echo "All checks passed!"
  exit 0
else
  exit 1
fi
