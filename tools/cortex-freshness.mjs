#!/usr/bin/env node
// ============================================================================
// cortex-freshness — QUICK-mode knowledge-base rot tripwire (deterministic, zero-dep)
//
// The cheap, always-on tier of the freshness engine. Runs in a git pre-commit
// hook / CI / inside /ensure-tracking + /checkpoint, so KB rot gets NOTICED
// without anyone remembering to look. (Deep semantic verification is the
// agent-driven /verify-knowledge-base --deep skill.)
//
// Checks, deterministically:
//   1. DEAD REFERENCES — code file paths cited in KB topics that no longer exist.
//   2. INDEX SYNC       — INDEX.md / _SUMMARY.md topic counts vs files on disk.
//   3. METADATA         — topics missing **Last Updated:**.
//
// Auto-adapts: if <root>/active-projects/* exists → workspace mode (code roots =
// those projects); else → single-project mode (code root = repo root).
//
// Usage:  node tools/cortex-freshness.mjs [--root <dir>] [--json] [--quiet]
// Exit:   non-zero if any HIGH finding (dead refs or index drift) — hook-friendly.
// ============================================================================
import fs from "node:fs";
import path from "node:path";

const args = process.argv.slice(2);
const getFlag = (n) => args.includes(n);
const getOpt = (n, d) => { const i = args.indexOf(n); return i >= 0 && args[i + 1] ? args[i + 1] : d; };
const ROOT = path.resolve(getOpt("--root", process.cwd()));
const JSONOUT = getFlag("--json");
const QUIET = getFlag("--quiet");
const KB = path.join(ROOT, "knowledge-base");

const CODE_EXT = /\.(ts|tsx|js|jsx|mjs|cjs|dart|py|sql|sh|ps1|gs|vue|go|rb|java|kt|swift|css|scss|html|toml)$/i;
const PATH_LEAD = /^(src|lib|app|apps|packages|active-projects|supabase|components|features|pages|scripts|tools|test|tests|__tests__|android|ios|api)\//i;

function die(msg) { console.error(msg); process.exit(2); }
if (!fs.existsSync(KB)) { if (!JSONOUT && !QUIET) console.log(`cortex-freshness: no knowledge-base/ at ${ROOT} — nothing to check.`); process.exit(0); }

// ---- config (light): read freshness.ignore globs if present; mappings default ----
let ignore = [];
const cfgPath = path.join(ROOT, "context-engineering", "cortex.config.yaml");
if (fs.existsSync(cfgPath)) {
  const cfg = fs.readFileSync(cfgPath, "utf8");
  const m = cfg.match(/ignore:\s*\[([^\]]*)\]/);
  if (m) ignore = m[1].split(",").map((s) => s.trim().replace(/^["']|["']$/g, "")).filter(Boolean);
}
const isIgnored = (rel) => ignore.some((g) => rel.includes(g.replace(/\*/g, "")));

// ---- resolve code roots (workspace vs single-project) ----
const projDir = path.join(ROOT, "active-projects");
let codeRoots = [ROOT];
let mode = "single-project";
if (fs.existsSync(projDir)) {
  const subs = fs.readdirSync(projDir, { withFileTypes: true }).filter((d) => d.isDirectory()).map((d) => path.join(projDir, d.name));
  if (subs.length) { codeRoots = subs; mode = "workspace"; }
}

// ---- walk KB topic files ----
const SECTIONS = ["concepts", "flows", "gotchas", "decisions"];
function listTopics(dir) {
  const out = [];
  const walk = (d) => {
    for (const e of fs.readdirSync(d, { withFileTypes: true })) {
      const p = path.join(d, e.name);
      if (e.isDirectory()) walk(p);
      else if (e.name.endsWith(".md") && e.name !== "_SUMMARY.md" && e.name !== "INDEX.md") out.push(p);
    }
  };
  if (fs.existsSync(dir)) walk(dir);
  return out;
}
const topicFiles = [];
for (const s of SECTIONS) topicFiles.push(...listTopics(path.join(KB, s)));
topicFiles.push(...listTopics(path.join(KB, "implementations")));

// ---- 1 + 3: dead references + metadata ----
// Try each code root with common source prefixes — the KB often cites `src/`-relative
// shorthand (e.g. `lib/actions/x.ts` for `src/lib/actions/x.ts`). Bias toward resolving:
// QUICK is a precision-first tripwire; DEEP does the rigorous per-claim check.
const SRC_PREFIXES = ["", "src/", "lib/", "app/", "src/app/"];
const resolves = (cand) => {
  const tries = [path.join(ROOT, cand)];
  for (const r of codeRoots) for (const pre of SRC_PREFIXES) tries.push(path.join(r, pre + cand));
  return tries.some((p) => { try { return fs.existsSync(p); } catch { return false; } });
};
const deadRefs = [];
const metaGaps = [];
for (const f of topicFiles) {
  const rel = path.relative(ROOT, f).replace(/\\/g, "/");
  if (isIgnored(rel)) continue;
  const txt = fs.readFileSync(f, "utf8");
  // metadata (implementations/concepts/flows/gotchas carry Last Updated; decisions use Date)
  // informational only (not a HIGH finding). Accept any dated-provenance convention.
  if (!rel.includes("/decisions/") && !/\*\*(Last Updated|Discovered|Date):\*\*/.test(txt)) metaGaps.push(rel);
  // path claims = backticked spans that look like real code paths
  const seen = new Set();
  for (const m of txt.matchAll(/`([^`\n]+)`/g)) {
    let cand = m[1].trim();
    if (!cand.includes("/") || /\s/.test(cand) || /^https?:/.test(cand)) continue;
    cand = cand.replace(/^\.\//, "").replace(/[)>,.:]+$/, "");
    if (/[*{}<>?]|\.\.\./.test(cand)) continue;         // skip globs / placeholders (docs, not files)
    if (!CODE_EXT.test(cand)) continue;                 // must end in a code extension
    if (!PATH_LEAD.test(cand)) continue;                // must start with a known code dir
    if (cand.startsWith("knowledge-base/") || cand.startsWith("context-engineering/")) continue;
    if (seen.has(cand)) continue; seen.add(cand);
    if (!resolves(cand)) deadRefs.push({ file: rel, ref: cand });
  }
}

// ---- 2: index / summary count sync ----
const idxDrift = [];
const countTopics = (dir) => (fs.existsSync(dir) ? fs.readdirSync(dir).filter((f) => f.endsWith(".md") && f !== "_SUMMARY.md").length : 0);
const implCounts = {};
let implTotal = 0;
if (fs.existsSync(path.join(KB, "implementations"))) {
  for (const e of fs.readdirSync(path.join(KB, "implementations"), { withFileTypes: true })) {
    if (e.isDirectory()) { const c = countTopics(path.join(KB, "implementations", e.name)); implCounts[e.name] = c; implTotal += c; }
  }
}
const diskCounts = { concepts: countTopics(path.join(KB, "concepts")), flows: countTopics(path.join(KB, "flows")), gotchas: countTopics(path.join(KB, "gotchas")), decisions: countTopics(path.join(KB, "decisions")) };
const grand = diskCounts.concepts + diskCounts.flows + diskCounts.gotchas + diskCounts.decisions + implTotal;

const idxPath = path.join(KB, "INDEX.md");
if (fs.existsSync(idxPath)) {
  const idx = fs.readFileSync(idxPath, "utf8");
  const tot = idx.match(/\*\*Total Topics:\*\*\s*(\d+)/);
  if (tot && Number(tot[1]) !== grand) idxDrift.push(`INDEX total says ${tot[1]}, disk has ${grand}`);
  for (const [sec, n] of Object.entries(diskCounts)) {
    const h = idx.match(new RegExp(`## ${sec[0].toUpperCase() + sec.slice(1)} \\((\\d+) topics\\)`));
    if (h && Number(h[1]) !== n) idxDrift.push(`INDEX ${sec} header says ${h[1]}, disk has ${n}`);
  }
} else idxDrift.push("INDEX.md missing");
// per-section _SUMMARY counts
for (const [sec, n] of Object.entries(diskCounts)) {
  const sp = path.join(KB, sec, "_SUMMARY.md");
  if (!fs.existsSync(sp)) { idxDrift.push(`${sec}/_SUMMARY.md missing`); continue; }
  const mm = fs.readFileSync(sp, "utf8").match(/\*\*Topics:\*\*\s*(\d+)/);
  if (mm && Number(mm[1]) !== n) idxDrift.push(`${sec}/_SUMMARY says ${mm[1]}, disk has ${n}`);
}

// ---- report ----
const high = deadRefs.length + idxDrift.length;
const result = { mode, root: ROOT, topics: topicFiles.length, deadRefs, idxDrift, metaGaps, high };
if (JSONOUT) { console.log(JSON.stringify(result, null, 2)); process.exit(high ? 1 : 0); }
if (!QUIET) {
  console.log(`cortex-freshness (QUICK) — ${mode} — ${topicFiles.length} topics, ${codeRoots.length} code root(s)`);
  console.log(`  dead references: ${deadRefs.length}   index drift: ${idxDrift.length}   metadata gaps: ${metaGaps.length}`);
  if (deadRefs.length) { console.log("\n  DEAD REFERENCES (cited code files that no longer exist):"); for (const d of deadRefs.slice(0, 40)) console.log(`    ${d.file}  ->  ${d.ref}`); if (deadRefs.length > 40) console.log(`    …and ${deadRefs.length - 40} more`); }
  if (idxDrift.length) { console.log("\n  INDEX / SUMMARY DRIFT:"); for (const d of idxDrift) console.log(`    ${d}`); }
  if (metaGaps.length) { console.log("\n  METADATA GAPS (missing **Last Updated:**):"); for (const g of metaGaps.slice(0, 20)) console.log(`    ${g}`); if (metaGaps.length > 20) console.log(`    …and ${metaGaps.length - 20} more`); }
  console.log(high ? `\n  ✗ ROT DETECTED — run /verify-knowledge-base --deep --fix (or /rebuild-kb-index for count drift).` : `\n  ✓ Clean — KB references and index are consistent with the code.`);
}
process.exit(high ? 1 : 0);
