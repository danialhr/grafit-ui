#!/bin/bash
# sync-upstream.sh - Import and update shadcn-ui/ui subtree

set -e

echo "🔍 Grafit Upstream Sync Script"
echo "=============================="
echo ""

# Check if upstream is already added
if git remote | grep -q "upstream"; then
    echo "✓ Upstream remote already configured"
else
    echo "✗ Upstream remote not found"
    echo "Please run: git remote add upstream https://github.com/shadcn-ui/ui.git"
    exit 1
fi

# Check if subtree already exists
if [ -d "upstream/shadcn-ui" ]; then
    echo "✓ Upstream subtree exists"
    echo ""
    echo "Updating subtree..."
    git subtree pull --prefix=upstream/shadcn-ui upstream main --squash
else
    echo "✗ Upstream subtree not found"
    echo ""
    read -p "Import shadcn-ui/ui subtree? This will download ~50MB (y/n): " confirm
    if [ "$confirm" != "y" ]; then
        echo "Cancelled"
        exit 0
    fi

    echo ""
    echo "Importing shadcn-ui/ui subtree..."
    echo "This may take a few minutes..."
    git subtree add --prefix=upstream/shadcn-ui https://github.com/shadcn-ui/ui.git main --squash
fi

echo ""
echo "✓ Upstream sync complete!"
echo ""
echo "Next steps:"
echo "  1. Check upstream/shadcn-ui/apps/web/components/ui/ for source reference"
echo "  2. Run ./scripts/detect-new-components.sh to find new components"
echo "  3. Update COMPONENT_REGISTRY.yaml with tracked commit"
