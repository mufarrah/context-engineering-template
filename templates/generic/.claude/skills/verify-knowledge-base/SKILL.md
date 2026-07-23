---
name: verify-knowledge-base
description: "Detect and fix knowledge-base ROT by verifying every KB claim against the ACTUAL code (paths, symbols, counts, statuses, versions) — not just Last-Updated dates. Quick mode for hooks/gates; deep adversarial mode on demand."
argument-hint: "[--quick | --deep] [--fix] [section ...]"
disable-model-invocation: true
---

# Verify Knowledge Base (Freshness Engine)

Verifies that the knowledge base still tells the **truth about the code**.

- `audit-context` checks *structure* and `Last Updated` **dates**.
- `rebuild-kb-index` fixes *counts and navigation*.
- **This skill checks whether each KB CLAIM is still TRUE** against the live source — a referenced file path, a function / RPC / component / route name, a count ("124 routes"), a status ("FIXED" / "active bug" / "pending" / "LIVE"), a version — and fixes the ones that have drifted.

**PURPOSE:** Kill knowledge-base **rot** at its root. Rot enters whenever code changes but the `/update-knowledge-base` step is skipped or incomplete (or the code changed with no PRP at all). The KB then confidently states wrong facts and every downstream agent inherits them — *confident wrongness at scale*.

**WHY DATES ARE NOT ENOUGH (the failure `audit-context` cannot see):** A topic can be *recently updated* and still assert a *stale fact*. Example: a `Communications` concept whose `Last Updated` matched its source PRP's date — so a date heuristic reads "fresh" — while its `28 source types` had silently become `29` because a later feature added one out-of-band. Date/coverage heuristics only catch "a PRP touched this area after the doc was written"; they are blind to drift from code that changed outside the PRP flow. This skill grounds every claim in the code itself.

**WHEN TO USE:**
- **QUICK** — on a git pre-commit hook / CI, or inside `/ensure-tracking` and `/checkpoint`: a cheap rot tripwire so drift gets *noticed* without anyone remembering to look.
- **DEEP** — before a release, after a burst of code changes, on a schedule, or whenever QUICK mode nags.

---

## MODES

- `--quick` *(default when invoked from a hook/gate)* — deterministic, **no agents**. Verifies: every referenced path exists · index/`_SUMMARY` counts are in sync · `**Last Updated:**` present. Reports drift and exits non-zero (nag). Seconds.
- `--deep` — full **semantic verification** with agent fan-out + adversarial confirmation. Minutes.
- `--fix` — apply confirmed, **additive** corrections, subject to the config `autofix` policy and user approval.
- Trailing `section ...` args restrict scope (e.g. `gotchas concepts`).

---

## STEP 0: LOAD CONFIG

Read `context-engineering/cortex.config.yaml` if present; otherwise use defaults. Relevant keys under `freshness:`:

- `mappings:` — KB section / implementation folder → the code path(s) it documents.
  - **Global-multi-project defaults:** `implementations/<proj>` → `active-projects/<proj>`; `concepts` / `flows` / `gotchas` / `decisions` → all of `active-projects/*`.
  - **Generic (single-project) defaults:** every section → the repo's source root (`src/`, `lib/`, `app/`, …).
- `scope:` — sections to verify (default: all five).
- `autofix:` — `off` | `nag` | `safe-auto` (default: `nag`). `safe-auto` auto-applies only mechanical corrections (counts, dead paths, status words, version strings); prose changes always ask.
- `ignore:` — globs of topic files or claim patterns to skip.
- `depth_active_only:` — if `true`, DEEP mode only verifies topics whose mapped code changed recently (via `git log`), to bound cost.

If no config exists, infer mappings from directory names and proceed with defaults.

---

## STEP 1: QUICK CHECK (always runs first)

Deterministically, across every in-scope topic file:

1. **Path claims** — extract path-like references (`path/to/file.ext`, `src/…`, `lib/…`) and confirm each exists on disk under the mapped code root. Flag dead references.
2. **Index sync** — topic counts per section vs the `_SUMMARY.md` / `INDEX.md` headers (delegate the detailed recount to `/rebuild-kb-index`). Flag mismatches.
3. **Metadata** — `**Last Updated:**` present and well-formed.

Emit QUICK findings. **In `--quick` mode, STOP here** and report (nag if anything drifted). In `--deep` mode, continue.

---

## STEP 2: EXTRACT VERIFIABLE CLAIMS (deep)

For each in-scope topic, extract claims of these kinds:
- **references** — paths, dirs; function / RPC / component / route / variable / package names
- **counts** — "124 routes", "28 source types", "$13/day", "12 RPCs"
- **statuses** — "FIXED" / "Resolved" / "active known bug" / "pending" / "planned" / "LIVE" / "in progress"
- **versions / config values** — SDK/package versions, sampling rates, base URLs
- **relationships** — ADR supersession, `[[cross-links]]`

**Triage to bound cost:** timeless bug-pattern warnings → light existence check only; count / status / path / version claims and **recently-changed code areas** → deep check.

---

## STEP 3: VERIFY AGAINST CODE (deep, parallel)

Fan out with the **Task tool + Explore agents** (one per section slice; weight effort toward recently-changed projects — static projects need only quick existence checks). Each agent, for its topics, greps/reads the **mapped** code and classifies each claim: `matches` | `dead-reference` | `count-drift` | `version-drift` | `stale-status` | `wrong-fact`. Returns structured findings with concrete evidence (`path:line`). Report only genuine mismatches — a fully-accurate topic yields nothing.

---

## STEP 4: ADVERSARIAL VERIFY (deep)

For **each** candidate stale finding, spawn a skeptic agent whose default bias is to **REFUTE it** — to prove the KB is *actually still correct* by reading the real code. Keep only `CONFIRMED_STALE` (the code clearly contradicts the KB). Discard `KB_ACTUALLY_CORRECT`. This is what stops a single misread from corrupting the KB during `--fix`.

---

## STEP 5: REPORT

Produce a scannable report: confirmed-stale findings ranked by severity (with file, claim, reality, evidence, suggested fix), coverage gaps (shipped-but-undocumented features), and the refuted count. Then, unless `autofix: safe-auto`, **ask before fixing**.

---

## STEP 6: REMEDIATE (`--fix`, after approval / per `autofix`)

Additive-only, one editor agent per file (distinct files → parallel-safe):
- **Correct the wrong fact IN PLACE. NEVER delete surrounding knowledge** (a correction is not a deletion).
- Locate stale text **by content, not by line number** (line numbers drift). If it can't be confidently placed, **skip and report** — never guess.
- Bump `**Last Updated:**`; append a `## Changes Log` row: `| {date} | {what was corrected} | freshness verification |`.
- For **status flips**, re-confirm the new status against the code before writing it.
- Finally, delegate to **`/rebuild-kb-index`** to resync counts and summaries.

---

## ANTI-ROT INTEGRATION (decouple "notice" from "remember")

The whole point is that rot must be *impossible to accumulate silently* — without forcing 100% automation. So:
- Wire **QUICK mode** into a **git pre-commit hook** and/or into **`/ensure-tracking`** + **`/checkpoint`**, so drift is surfaced automatically at gates that already run. No human has to remember.
- Optionally schedule a **DEEP scan** (cron / CI) for periodic semantic verification.
- Keep **all fixes** gated by the `autofix` policy. → **Detection is automated; remediation stays managed and configurable.**

---

## REPORT FORMAT

```
========================================
KNOWLEDGE BASE FRESHNESS — {quick|deep}
========================================
Date: {today}   Scope: {sections}   Config: {found|defaults}

QUICK:  paths checked {N} · dead {N} · index in sync {yes/no} · metadata gaps {N}
DEEP:   topics verified {N} · candidates {N} · CONFIRMED stale {N} · refuted {N} · coverage gaps {N}

CONFIRMED STALE ({N})   [most severe first]
  {sev} {category}  {file}
     claim:    {stale KB text}
     reality:  {what the code shows}
     evidence: {path:line}
     fix:      {surgical, additive}

COVERAGE GAPS ({N})  — shipped but undocumented (use /update-knowledge-base)
REFUTED ({N})        — flagged but KB was actually correct

{If clean:}  Knowledge base is TRUE against the code. No rot detected.
{If issues + not safe-auto:}  Apply the confirmed fixes? (all / by number / skip)
```

---

## SAFETY RULES

- **ADDITIVE ONLY** — correct wrong facts in place; never remove existing knowledge; append to the Changes Log.
- **NEVER modify source code** — this skill reads code, writes only to `knowledge-base/`.
- **FIXES ARE USER-GATED** unless `autofix: safe-auto` (and even then, prose changes ask).
- **`--quick` IS READ-ONLY.**
- **ADVERSARIALLY CONFIRM** before any `--fix` — only `CONFIRMED_STALE` findings are eligible.
- **RE-READ BEFORE EDIT**; locate by content, not line number.
