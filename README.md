# Cortex — The Thinking Layer Around Your Codebase

**Cortex** gives AI coding agents deep, persistent, **self-verifying** knowledge about your projects. It combines a **PRP workflow** (Project Requirement Plans) for feature development, a **concept-centric knowledge base** for institutional memory, an **anti-rot freshness engine** that keeps that knowledge true to the code, and **AI commands** (Claude Code skills) that automate the whole lifecycle.

> Built for [Claude Code](https://claude.com/claude-code). Requires **Node ≥ 18**.

---

## Install

No cloning required — the templates ship inside the package.

```bash
# Add Cortex to a single project (run inside the repo)
npx @mufarrah/cortex init . --kind generic

# ...or scaffold a multi-project workspace
npx @mufarrah/cortex init ./my-workspace --kind workspace

# ...and install the anti-rot git hook at the same time
npx @mufarrah/cortex init . --kind generic --hook
```

Prefer a global command?

```bash
npm i -g @mufarrah/cortex
cortex init . --kind generic
```

`init` copies template files **without clobbering** anything you already have (use `--force` to overwrite). Then open the repo in **Claude Code** and run `/setup-project` (single) or `/setup-workspace` (workspace) — it analyzes your codebase, populates the docs, and initializes the knowledge base.

---

## Keep knowledge fresh (anti-rot)

A knowledge base rots the moment code changes but the docs don't — and every agent then inherits the stale "fact." Cortex fights that on two levels:

```bash
cortex check      # fast, deterministic scan: KB references vs real code + index sync
cortex hook       # install a pre-commit tripwire so rot is caught automatically
```

`cortex check` is CI- and hook-friendly (meaningful exit code, `--json` output). For a **deep, code-grounded pass** that verifies every claim — file paths, symbols, counts, statuses, versions — and additively fixes what drifted, run **`/verify-knowledge-base`** in Claude Code.

Tune behavior per repo in `context-engineering/cortex.config.yaml`:
`freshness.autofix: off | nag | safe-auto`, KB→code mappings, and ignore globs. Detection is automated; **remediation stays under your control**.

---

## Update Cortex

```bash
npx @mufarrah/cortex update .
```

This refreshes the migration runner; then open the repo in Claude Code and run **`/update-template`**. The runner follows one principle — **the filesystem is the version**: it observes what's actually on disk and reconciles it to the latest template. New skills are offered, untouched files update silently, **files you edited get a 3-way merge** (conflicts always surfaced as explicit choices), your own additions are never touched, and breaking changes run as idempotent migrations with backups (`.cortex-backup/`) and per-step consent. Safe to re-run anytime.

---

## CLI reference

| Command | Purpose |
|---------|---------|
| `cortex init [dir] --kind generic\|workspace [--hook] [--force]` | Add Cortex to a repo (templates bundled) |
| `cortex update [dir] [--repo <url>]` | Refresh the migration runner, then run `/update-template` |
| `cortex check [dir] [--json] [--quiet]` | Anti-rot freshness scan (KB vs code + index) |
| `cortex hook [dir]` | Install the pre-commit freshness tripwire |
| `cortex version` · `cortex help` | Version / usage |

Deep reconciliation and knowledge extraction run as **Claude Code skills** (`/update-template`, `/update-knowledge-base`, `/verify-knowledge-base`) because they need judgment an interactive agent provides.

---

## What you get

### 15 AI commands (Claude Code skills)

Each is a skill under `.claude/skills/<command>/SKILL.md`, invoked with `/command`:

| Command | Purpose |
|---------|---------|
| `/generate-requirements` | Transform feature ideas into structured requirements |
| `/generate-prp` | Generate an implementation-ready PRP from requirements |
| `/check-prp` | Validate PRP structure and requirements alignment |
| `/execute-prp` | Execute a PRP (Phase 0 for phased PRPs) |
| `/continue-prp` | Continue a phased PRP (Phase 1+) |
| `/checkpoint` | Capture a durable resume checkpoint of the current PRP |
| `/check-progress` | Mid-development progress audit |
| `/ensure-tracking` | Verify documentation completeness before closing context |
| `/update-knowledge-base` | Extract knowledge from a PRP into the KB |
| `/populate-knowledge-base` | Full KB discovery and population |
| `/rebuild-kb-index` | Regenerate `INDEX.md` and `_SUMMARY.md` files |
| `/verify-knowledge-base` | **Anti-rot** — verify KB claims against the actual code |
| `/audit-context` | Comprehensive project/workspace health check |
| `/setup-project` · `/setup-workspace` | Initial setup after `cortex init` |
| `/update-template` | Reconcile the repo with the latest Cortex template |

### 2 built-in skills

| Skill | Purpose |
|-------|---------|
| **skill-creator** | Framework for creating custom domain-specific skills |
| **frontend-design** | Production-grade UI design (anti-AI-slop aesthetics) |

### PRP workflow

```
Feature Idea → /generate-requirements → /generate-prp → /check-prp
    → /execute-prp → /continue-prp → /ensure-tracking → Complete
```

- **Simple features**: a single PRP file.
- **Complex features**: a phased folder with `PLAN.md`, `TEST-CASES.md`, `COMPLETED.md`, `FIXES.md`, `HANDOFF.md` per phase.
- **Agent-guided testing**: after implementation, the agent walks through the test cases with you.

### Concept-centric knowledge base

| Category | Question | Example |
|----------|----------|---------|
| **Concepts** | "What IS this?" | Entity definitions, schemas, rules |
| **Flows** | "HOW does it work?" | Processes, sequences, data flows |
| **Implementations** | "WHERE is the code?" | Project-specific patterns |
| **Gotchas** | "What to WATCH OUT for?" | Pitfalls, edge cases |
| **Decisions** | "WHY was this chosen?" | Architecture Decision Records |

Three reading levels: `INDEX.md` (overview) → `_SUMMARY.md` (section) → topic files (detail).

---

## Two templates

**`generic`** (single project) — adds Cortex directly to one repo:

```
my-project/
├── AGENTS.md              # Agent instructions: navigation, architecture, standards
├── CLAUDE.md              # Thin Claude Code entry point (imports AGENTS.md)
├── CONFIG.md              # Commands reference
├── context-engineering/   # Feature management (PRPs, feature inputs) + cortex.config.yaml
├── knowledge-base/        # Concept-centric knowledge base
├── docs/                  # Reference docs
└── .claude/skills/        # command-skills + built-in skills
```

**`global-multi-project`** (`--kind workspace`) — for workspaces managing several repos, with shared resources, an `active-projects/` area, and a cross-project knowledge base.

---

## From source (contributors)

```bash
git clone https://github.com/mufarrah/context-engineering-template.git
cd context-engineering-template
./setup-context-engineering.sh /path/to/your/project   # interactive copy (equivalent to `cortex init`)
```

The published CLI is the recommended path for everyone else — it bundles these templates so there's nothing to clone.

---

## License

MIT
