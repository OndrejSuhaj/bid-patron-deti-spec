#!/usr/bin/env bash
# check-template-parity.sh
#
# Detect structural drift of AR's shared layer templates/rules against arg-emitee's
# authoring templates/rules. Compares the `## ` section headings of each shared layer,
# ignoring AR's intentional deltas. See docs/template-parity.md.
#
# Scope: TEMPLATES are checked for all 16 layers (the artifact structure). RULES are checked
# for the 12 BA layers; the 4 UX rules follow AR's uniform house structure (an intentional
# delta — see docs/template-parity.md) and are reported informationally, not as drift.
#
# Usage: scripts/check-template-parity.sh [path-to-arg-emitee-docs]
# Exit:  0 = in parity (or arg-emitee not present); 1 = drift detected.

set -uo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
EMITEE_DOCS="${1:-$REPO_ROOT/../arg-emitee-secondvibe/docs}"

if [ ! -d "$EMITEE_DOCS/authoring" ]; then
  echo "arg-emitee docs not found at: $EMITEE_DOCS — skipped"
  exit 0
fi

BA_LAYERS="EN UC BR FN ARCH ES MSG CS API JOB ACL QUERY"
UX_LAYERS="IA WIRE COMP COPY"

# Intentional AR-vs-arg deltas to ignore on BOTH sides (see docs/template-parity.md):
# - Cross-references (AR rules section, task C)
# - Evidence / Evidence level / Evidence Convention (AR evidence discipline; organized
#   differently between AR and arg-emitee — AR embeds CS evidence in Purpose)
EXCL='^## Cross-references|^## Evidence$|^## Evidence level$|^## Evidence level labels$|^## Evidence Convention$'

drift=0

headings() { grep -E '^## ' "$1" 2>/dev/null | sed -E 's/[[:space:]]+$//' | sort -u | grep -vE "$EXCL"; }

compare() { # label ar_file em_file
  local label="$1" ar="$2" em="$3"
  if [ ! -f "$ar" ] || [ ! -f "$em" ]; then
    printf '  %-7s skipped (missing file)\n' "$label"
    return
  fi
  local ar_only em_only
  ar_only="$(comm -23 <(headings "$ar") <(headings "$em"))"
  em_only="$(comm -13 <(headings "$ar") <(headings "$em"))"
  if [ -z "$ar_only" ] && [ -z "$em_only" ]; then
    printf '  %-7s in parity\n' "$label"
  else
    printf '  %-7s DRIFT\n' "$label"
    [ -n "$ar_only" ] && echo "$ar_only" | sed 's/^/    AR-only:  /'
    [ -n "$em_only" ] && echo "$em_only" | sed 's/^/    arg-only: /'
    drift=1
  fi
}

echo "Template parity check (AR vs $EMITEE_DOCS)"
echo
echo "Templates (all 16 layers — artifact structure):"
for L in $BA_LAYERS $UX_LAYERS; do
  compare "$L" "$REPO_ROOT/templates/template-$L.md" "$EMITEE_DOCS/authoring/templates/$L.md"
done
echo
echo "Rules (12 BA layers — strict):"
for L in $BA_LAYERS; do
  compare "$L" "$REPO_ROOT/docs/rules-$L.md" "$EMITEE_DOCS/authoring/rules/$L.md"
done
echo
echo "Rules (4 UX layers — AR house structure, informational; see docs/template-parity.md):"
for L in $UX_LAYERS; do
  printf '  %-7s AR house structure\n' "$L"
done

echo
if [ "$drift" -eq 0 ]; then
  echo "RESULT: in parity"
else
  echo "RESULT: DRIFT detected — reconcile, or record a new intentional delta in docs/template-parity.md"
fi
exit $drift
