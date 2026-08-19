#!/usr/bin/env bash
# Pushes the Flutter app ONLY to a PRIVATE repo under the sk8er22 account
# (never touches levin-riegner or any other upstream).
#
# Requires a GitHub Personal Access Token (repo scope) for the sk8er22 account.
#
#   GITHUB_TOKEN=ghp_xxx ./scripts/push_private_sk8er22.sh [repo-name]
#
# Defaults repo name to the current directory's basename.
set -euo pipefail

TOKEN="${GITHUB_TOKEN:-}"
if [[ -z "$TOKEN" ]]; then
  echo "ERROR: GITHUB_TOKEN not set. Create a PAT at https://github.com/settings/tokens (repo scope)." >&2
  exit 1
fi

REPO_NAME="${1:-$(basename "$PWD")}"
ORG="sk8er22"
BRANCH="$(git branch --show-current)"

echo "➜ Ensuring private repo exists: $ORG/$REPO_NAME"

# Create the private repo if it does not already exist (idempotent).
HTTP_CODE="$(curl -s -o /tmp/sk8er22_repo.json -w '%{http_code}' \
  -X POST "https://api.github.com/user/repos" \
  -H "Authorization: token $TOKEN" \
  -H "Accept: application/vnd.github+json" \
  -d "{\"name\":\"$REPO_NAME\",\"private\":true,\"description\":\"On-device AI Flutter app\",\"auto_init\":false}")"

if [[ "$HTTP_CODE" == "201" ]]; then
  echo "✅ Created private repo $ORG/$REPO_NAME"
elif [[ "$HTTP_CODE" == "422" ]]; then
  # 422 means it already exists (name taken) — continue to push.
  echo "• Repo already exists ($ORG/$REPO_NAME), continuing."
else
  echo "⚠ Repo creation returned HTTP $HTTP_CODE — continuing to push anyway." >&2
  cat /tmp/sk8er22_repo.json >&2 || true
fi

URL="https://x-access-token:${TOKEN}@github.com/${ORG}/${REPO_NAME}.git"

echo "➜ Setting remote 'private' (only for this push; origin untouched)"
git remote set-url private "$URL" 2>/dev/null || git remote add private "$URL"

echo "➜ Pushing branch '$BRANCH' to $ORG/$REPO_NAME"
git push private "$BRANCH"

echo "✅ Done. Private repo: https://github.com/$ORG/$REPO_NAME"
echo "   origin (levin-riegner) was NOT touched."
