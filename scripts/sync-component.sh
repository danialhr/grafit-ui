#!/bin/bash
# sync-component.sh - Show what changed in a specific upstream component

set -e

if [ $# -eq 0 ]; then
    echo "Usage: ./scripts/sync-component.sh <component-name>"
    echo "Example: ./scripts/sync-component.sh button"
    exit 1
fi

COMPONENT=$1
echo "🔍 Syncing Component: $COMPONENT"
echo "=================================="
echo ""

# Check if upstream subtree exists
if [ ! -d "upstream/shadcn-ui" ]; then
    echo "✗ Upstream subtree not found"
    echo "Run ./scripts/sync-upstream.sh first"
    exit 1
fi

# Find component in upstream
UPSTREAM_FILE="upstream/shadcn-ui/apps/web/components/ui/$COMPONENT.tsx"

if [ ! -f "$UPSTREAM_FILE" ]; then
    echo "✗ Component '$COMPONENT' not found in shadcn-ui/ui"
    echo ""
    echo "Available components:"
    ls upstream/shadcn-ui/apps/web/components/ui/*.tsx | xargs -n1 basename -s .tsx
    exit 1
fi

# Check if component exists in Grafit
METADATA_FILE="packages/grafit_ui/lib/src/components/**/$COMPONENT.component.yaml"

if [ ! -f "$METADATA_FILE" ]; then
    # Try finding in different directories
    METADATA_FILE=$(find packages/grafit_ui/lib/src/components -name "$COMPONENT.component.yaml" 2>/dev/null | head -1)
fi

if [ -z "$METADATA_FILE" ]; then
    echo "⚠️  Component '$COMPONENT' not yet tracked in Grafit"
    echo ""
    echo "To start tracking:"
    echo "  1. Review: $UPSTREAM_FILE"
    echo "  2. Create: packages/grafit_ui/lib/src/components/form/$COMPONENT.component.yaml"
    echo "  3. Implement Flutter component"
    echo "  4. Add to COMPONENT_REGISTRY.yaml"
    echo ""
    echo "Opening upstream file for review..."
    if command -v less >/dev/null 2>&1; then
        less "$UPSTREAM_FILE"
    else
        cat "$UPSTREAM_FILE"
    fi
    exit 0
fi

echo "📋 Component Metadata:"
echo "  Location: $METADATA_FILE"
echo "  Upstream: $UPSTREAM_FILE"
echo ""

# Get tracked commit from metadata
TRACKED_COMMIT=$(grep "commit:" "$METADATA_FILE" | awk '{print $2}')
CURRENT_COMMIT=$(cd upstream/shadcn-ui && git log -1 --format=%h)

echo "📊 Sync Status:"
echo "  Tracked: ${TRACKED_COMMIT:-None yet}"
echo "  Current: $CURRENT_COMMIT"
echo ""

# Show diff if there's a tracked commit
if [ "$TRACKED_COMMIT" != "null" ] && [ -n "$TRACKED_COMMIT" ]; then
    echo "📝 Changes since last sync:"
    echo ""
    git diff $TRACKED_COMMIT..upstream/main -- "$UPSTREAM_FILE" || echo "  No changes detected"
else
    echo "📝 Full component source:"
    echo ""
    cat "$UPSTREAM_FILE"
fi

echo ""
echo "==================================="
echo ""
echo "To update this component:"
echo "  1. Review changes above"
echo "  2. Update Flutter implementation in packages/grafit_ui/lib/src/components/"
echo "  3. Update $METADATA_FILE"
echo "  4. Update commit: $CURRENT_COMMIT"
