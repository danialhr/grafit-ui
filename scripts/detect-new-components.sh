#!/bin/bash
# detect-new-components.sh - Find new components in shadcn-ui/ui not yet tracked

set -e

echo "🔍 Detecting New Components from shadcn-ui/ui"
echo "==============================================="
echo ""

# Check if upstream subtree exists
if [ ! -d "upstream/shadcn-ui" ]; then
    echo "✗ Upstream subtree not found"
    echo "Run ./scripts/sync-upstream.sh first"
    exit 1
fi

# Count components in upstream
UPSTREAM_COUNT=$(find upstream/shadcn-ui/apps/v4/registry/new-york-v4/ui -name "*.tsx" | wc -l | tr -d ' ')
echo "📦 shadcn-ui/ui components: $UPSTREAM_COUNT"
echo ""

# Find all components in upstream
echo "Scanning upstream components..."
echo ""

# List all TSX files in upstream
for file in upstream/shadcn-ui/apps/v4/registry/new-york-v4/ui/*.tsx; do
    if [ -f "$file" ]; then
        COMPONENT=$(basename "$file" .tsx)
        # Check if tracked in registry
        if grep -q "  $COMPONENT:" COMPONENT_REGISTRY.yaml 2>/dev/null; then
            echo "  ✓ $COMPONENT - tracked"
        else
            echo "  🆕 $COMPONENT - NOT YET TRACKED"
        fi
    fi
done

echo ""
echo "==============================================="
echo ""
echo "To add a new component to tracking:"
echo "  1. Create .component.yaml file in packages/grafit_ui/lib/src/components/"
echo "  2. Add entry to COMPONENT_REGISTRY.yaml under flutter_components"
echo "  3. Implement the Flutter component"
