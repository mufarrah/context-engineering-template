# CONFIG.md - Cortex Single-Project Workspace

## Available Commands & Workflows

### PRP Workflow Commands

```bash
/generate-requirements [file.md]     # Transform feature ideas into structured requirements
/generate-prp [requirements.md]      # Generate Project Requirement Plan from requirements
/check-prp [prp-path]                # Validate PRP structure and requirements alignment
/execute-prp [prp-path]              # Execute PRP implementation (Phase 0 for phased)
/continue-prp [prp-path]             # Continue phased PRP (Phase 1+)
/check-progress [prp-path]           # Mid-development progress audit
/ensure-tracking [prp-path]          # Verify documentation completeness before closing
```

### Knowledge Base Commands

```bash
/update-knowledge-base [prp-path]    # Extract knowledge from PRP into KB + update project docs
/populate-knowledge-base             # Full KB discovery and population from project
/rebuild-kb-index                    # Regenerate INDEX.md and all _SUMMARY.md files
```

### Project Management Commands

```bash
/audit-context                       # Comprehensive project health check
/setup-project                       # Initial project setup (run after copying template)
/update-template                     # Pull latest Cortex template updates safely
```

---

## PRP Workflow Diagram

```
Feature Idea
    │
    ▼
/generate-requirements ──→ Requirements Doc (feature-inputs/pending/)
    │
    ▼
/generate-prp ──→ PRP Created (PRPs/) + move to in-progress/
    │
    ▼
/check-prp ──→ Validate structure
    │
    ▼
/execute-prp ──→ Implement Phase 0
    │
    ▼ (for phased PRPs)
/continue-prp ──→ Each subsequent phase
    │               │
    │               ▼
    │         /update-knowledge-base (EVERY phase)
    │
    ▼
/ensure-tracking ──→ Verify docs complete
    │
    ▼
Feature Complete ──→ Archive requirements, update docs
```

---

## Skills Reference

### Available Skills

| Skill | Purpose | When to Use |
|-------|---------|-------------|
| **skill-creator** | Framework for creating custom domain skills | When you want to add specialized expertise for your project |
| **frontend-design** | Production-grade UI design | When building distinctive, intentional frontend interfaces |

### Creating New Skills

Use the `skill-creator` skill to create new domain-specific skills for your project. See `.claude/skills/skill-creator/SKILL.md` for the framework.

---

## File Locations Quick Reference

| Resource | Location |
|----------|----------|
| Navigation + coding standards | `CLAUDE.md` |
| Architecture + philosophy | `PLANNING.md` |
| Commands reference | `CONFIG.md` (this file) |
| Project status | `context-engineering/_STATUS.md` |
| Pending features | `context-engineering/feature-inputs/pending/` |
| Active features | `context-engineering/feature-inputs/in-progress/` |
| PRPs (permanent) | `context-engineering/PRPs/` |
| Knowledge base TOC | `knowledge-base/INDEX.md` |
| Commands & skills guide | `docs/commands-and-skills.md` |
| KB guide | `docs/knowledge-base.md` |
| PRP workflow guide | `docs/prp-workflow.md` |
