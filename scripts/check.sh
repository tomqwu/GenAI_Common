#!/usr/bin/env bash
# Doc-quality checks. Mirrors .github/workflows/doc-quality.yml for local runs.
# Tiers 3 and 4 auto-skip if their binary is not installed.

cd "$(dirname "$0")/.."

fail=0

printf '\n** Tier 1 — structural\n'

violators=$(find . -name '*.md' -not -path './.git/*' -exec wc -l {} + \
            | awk '$1 > 200 && $2 != "total"')
if [ -n "$violators" ]; then
  printf '!! Files over 200 lines:\n%s\n' "$violators" >&2
  fail=1
fi

missing=""
for f in AGENTS.md CLAUDE.md BOOTSTRAP.md \
         .github/copilot-instructions.md \
         .github/instructions/*.instructions.md \
         docs/knowledge/*.md; do
  [ -e "$f" ] || continue
  grep -q '^## Boundaries' "$f" || missing="$missing $f"
done
if [ -n "$missing" ]; then
  printf '!! Missing Boundaries section in:%s\n' "$missing" >&2
  fail=1
fi

# Secrets scan over the staged diff. Informational, not a hard fail: rule files
# legitimately contain words like "secret" — review hits, don't auto-block.
# Cross-reference resolution is tier 3's job (lychee --offline).
hits=$(git diff --cached | grep -iE 'api[_-]?key|secret|token|password' || true)
if [ -n "$hits" ]; then
  printf 'i  Secret-pattern matches in staged diff (review, not necessarily a failure):\n%s\n' "$hits"
fi

printf '\n** Tier 2 — markdownlint\n'
if command -v npx >/dev/null 2>&1; then
  npx --yes markdownlint-cli2 "**/*.md" "#node_modules" || fail=1
else
  printf '   (npx not installed — install Node to enable)\n'
fi

printf '\n** Tier 3 — lychee --offline (optional)\n'
if command -v lychee >/dev/null 2>&1; then
  lychee --offline --no-progress '**/*.md' || fail=1
else
  printf '   (lychee not installed — brew install lychee)\n'
fi

printf '\n** Tier 4 — typos (optional)\n'
if command -v typos >/dev/null 2>&1; then
  typos || fail=1
else
  printf '   (typos not installed — brew install typos-cli)\n'
fi

if [ "$fail" -ne 0 ]; then
  printf '\nFAILED — see messages above.\n' >&2
  exit 1
fi
printf '\nAll checks clean.\n'
