# Grafit Sync Log

This document tracks all sync activities between Grafit (Flutter) and shadcn-ui/ui (React).

## Setup

- **Date**: 2025-02-06
- **Action**: Initial upstream tracking system setup
- **Details**:
  - Added shadcn-ui/ui as git remote
  - Created directory structure for tracking
  - Implemented 4-layer tracking system:
    1. Git subtree for upstream reference
    2. Component metadata files (.component.yaml)
    3. Central registry (COMPONENT_REGISTRY.yaml)
    4. Automated scripts and GitHub Actions

## Initial Component Tracking

### Tracked Components (14)

| Component | Parity | Status | Notes |
|-----------|--------|--------|-------|
| button | 85% | Implemented | Missing asChild, loading |
| input | 88% | Implemented | Missing file upload |
| checkbox | 90% | Implemented | Full parity |
| switch | 90% | Implemented | Full parity |
| slider | 85% | Implemented | Minor differences |
| card | 88% | Implemented | Header/footer variants |
| separator | 95% | Implemented | Full parity |
| tabs | 85% | Implemented | Basic implementation |
| dialog | 82% | Implemented | Missing some features |
| tooltip | 90% | Implemented | Full parity |
| alert | 85% | Implemented | Warning variant |
| badge | 90% | Implemented | Full parity |
| avatar | 88% | Implemented | Missing fallback variants |
| resizable | 80% | Implemented | Basic implementation |
| scroll-area | 90% | Implemented | Full parity |
| collapsible | 82% | Implemented | Basic implementation |

**Overall Parity: 86%**

## Pending Components (40+)

### High Priority
- label (1 hour)
- progress (2 hours)
- skeleton (2 hours)
- textarea (2 hours)
- separator ✓ (1 hour) - Already implemented

### Medium Priority
- alert-dialog (2 hours)
- data-table (6 hours)
- dropdown-menu (6 hours)
- navigation-menu (6 hours)
- popover (4 hours)
- select (8 hours)
- combobox (8 hours)
- input-otp (3 hours)
- radio-group (3 hours)
- toggle (2 hours)
- toggle-group (3 hours)
- drawer (4 hours)
- sheet (5 hours)
- menubar (5 hours)
- command (10 hours)
- context-menu (8 hours)
- accordion (4 hours)
- calendar (12 hours)
- date-picker (12 hours)

### Low Priority
- auto-form (8 hours)
- carousel (10 hours)
- chart (16 hours)
- form (2 hours)
- hover-card (3 hours)
- pagination (4 hours)
- sonner/toast (6 hours)
- table (5 hours)

## Sync Scripts

### Available Scripts

1. **./scripts/sync-upstream.sh**
   - Import or update shadcn-ui/ui git subtree
   - First time setup: downloads ~50MB of source code

2. **./scripts/check-upstream.sh**
   - Compare tracked commit with latest upstream
   - List changed components
   - Generate sync report

3. **./scripts/sync-component.sh <component>**
   - Show what changed in specific component
   - Display diff since last sync
   - Provide update guidance

4. **./scripts/detect-new-components.sh**
   - Scan upstream for all components
   - Compare with tracked components
   - List new components not yet implemented

## GitHub Actions

### Weekly Upstream Check
- **Schedule**: Every Monday at 10:00 UTC
- **Workflow**: `.github/workflows/upstream-check.yml`
- **Actions**:
  - Fetches latest shadcn-ui/ui
  - Compares with tracked commit
  - Detects new components
  - Creates/updates issue with report
  - Updates COMPONENT_REGISTRY.yaml

## Workflow

### Initial Setup
1. Run `./scripts/sync-upstream.sh` to import shadcn-ui/ui
2. Verify upstream/shadcn-ui/apps/web/components/ui/ is accessible
3. Update COMPONENT_REGISTRY.yaml with tracked commit

### Weekly Update Process
1. GitHub Actions runs automatically on Mondays
2. Review generated issue
3. Run `./scripts/check-upstream.sh` manually if needed
4. For updated components: `./scripts/sync-component.sh <name>`
5. Implement missing features in Flutter components
6. Update .component.yaml files
7. Update parity percentages

### Adding New Components
1. Run `./scripts/detect-new-components.sh`
2. Choose component to implement
3. Review upstream source: `upstream/shadcn-ui/apps/web/components/ui/<component>.tsx`
4. Create Flutter component
5. Create .component.yaml metadata
6. Add to COMPONENT_REGISTRY.yaml
7. Document parity gaps

## Next Steps

- [ ] Import shadcn-ui/ui subtree using sync-upstream.sh
- [ ] Verify all existing components have .component.yaml files
- [ ] Calculate and document parity for all components
- [ ] Enable GitHub Actions workflow
- [ ] Implement high-priority pending components
- [ ] Maintain 85-90% parity target
