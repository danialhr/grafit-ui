#!/bin/bash
# check-upstream.sh - Check for changes in shadcn-ui/ui since last sync

set -e

echo "🔍 Checking shadcn-ui/ui for Updates"
echo "================================="
echo ""

# Check if upstream subtree exists
if [ ! -d "upstream/shadcn-ui" ]; then
    echo "✗ Upstream subtree not found"
    echo "Run ./scripts/sync-upstream.sh first"
    exit 1
fi

# Get current tracked commit from registry
TRACKED_COMMIT=$(grep "trackedCommit:" COMPONENT_REGISTRY.yaml | awk '{print $2}')
CURRENT_COMMIT=$(cd upstream/shadcn-ui && git log -1 --format=%h)

echo "📊 Upstream Status:"
echo "  Tracked commit: ${TRACKED_COMMIT:-None yet}"
echo "  Current commit: $CURRENT_COMMIT"
echo ""

if [ "$TRACKED_COMMIT" == "$CURRENT_COMMIT" ]; then
    echo "✓ Already up to date"
    exit 0
fi

echo "⚠️  New commits available!"
echo ""
echo "Fetching changes..."
git fetch upstream main > /dev/null 2>&1

# Get commit count difference
if [ -n "$TRACKED_COMMIT" ]; then
    COMMITS_BEHIND=$(git rev-list --count $TRACKED_COMMIT..upstream/main 2>/dev/null || echo "?")
    echo "  Behind by: $COMMITS_BEHIND commits"
fi

echo ""
echo "Changed components since last sync:"
echo ""

# Show changed files in components/ui directory
git diff $TRACKED_COMMIT..upstream/main -- upstream/shadcn-ui/apps/v4/registry/new-york-v4/ui/ \
    --name-only 2>/dev/null | while read file; do
        COMPONENT=$(basename "$file" .tsx)
        STATUS=$(git diff $TRACKED_COMMIT..upstream/main -- "$file" | head -1)
        if [ -n "$STATUS" ]; then
            echo "  📝 $COMPONENT"
        fi
    done || echo "  (Unable to show specific file changes)"

echo ""
echo "==================================="
echo ""
echo "To update:"
echo "  1. Review changes in upstream/shadcn-ui/"
echo "  2. Run: git subtree pull --prefix=upstream/shadcn-ui upstream main --squash"
echo "  3. Update COMPONENT_REGISTRY.yaml trackedCommit"
echo "  4. Run: ./scripts/sync-component.sh <component-name>"
