#!/usr/bin/env node
// ============================================================================
// cortex — the Cortex CLI. Install & update the context-engineering framework
// in any repo with one command; run the anti-rot freshness check on demand.
//
//   npx @mufarrah/cortex init [dir] [--kind generic|workspace] [--hook]
//   npx @mufarrah/cortex update [dir] [--repo <url>]
//   npx @mufarrah/cortex check [dir] [--json]
//   npx @mufarrah/cortex hook [dir]
//   npx @mufarrah/cortex version | help
//
// Zero runtime dependencies (Node builtins only). Templates ship INSIDE the
// package, so there is no "clone the repo manually" step anymore.
// ============================================================================
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { spawnSync } from "node:child_process";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const PKG_ROOT = path.resolve(__dirname, "..");
const TEMPLATES = path.join(PKG_ROOT, "templates");
const DEFAULT_REPO = "https://github.com/mufarrah/context-engineering-template";

const [, , cmd, ...rest] = process.argv;
const flags = {};
const positional = [];
for (let i = 0; i < rest.length; i++) {
  const a = rest[i];
  if (a.startsWith("--")) {
    const k = a.slice(2);
    if (rest[i + 1] && !rest[i + 1].startsWith("--")) flags[k] = rest[++i];
    else flags[k] = true;
  } else positional.push(a);
}

const die = (m) => { console.error("cortex: " + m); process.exit(1); };
const pkgVersion = () => JSON.parse(fs.readFileSync(path.join(PKG_ROOT, "package.json"), "utf8")).version;
const target = () => path.resolve(positional[0] || process.cwd());

function resolveKind(dir, explicit) {
  const e = (explicit || "").toLowerCase();
  if (["workspace", "global", "global-multi-project"].includes(e)) return "global-multi-project";
  if (["generic", "single", "single-project"].includes(e)) return "generic";
  if (fs.existsSync(path.join(dir, "active-projects")) || fs.existsSync(path.join(dir, "shared"))) return "global-multi-project";
  return "generic";
}

function safeCopyDir(src, dest, { overwrite = false } = {}) {
  const copied = [], skipped = [];
  const walk = (s, d) => {
    for (const ent of fs.readdirSync(s, { withFileTypes: true })) {
      if (ent.name === ".git") continue;
      const sp = path.join(s, ent.name), dp = path.join(d, ent.name);
      if (ent.isDirectory()) { fs.mkdirSync(dp, { recursive: true }); walk(sp, dp); }
      else if (fs.existsSync(dp) && !overwrite) skipped.push(path.relative(dest, dp).replace(/\\/g, "/"));
      else { fs.mkdirSync(path.dirname(dp), { recursive: true }); fs.copyFileSync(sp, dp); copied.push(path.relative(dest, dp).replace(/\\/g, "/")); }
    }
  };
  fs.mkdirSync(dest, { recursive: true });
  walk(src, dest);
  return { copied, skipped };
}

function writeLedger(dir, kind, repo) {
  const cdir = path.join(dir, ".cortex");
  fs.mkdirSync(cdir, { recursive: true });
  const ledger = {
    templateVersion: pkgVersion(),
    templateRepo: repo,
    templateKind: kind,
    appliedMigrations: [],
    syncedToCommit: null,
    lastRun: new Date().toISOString(),
    note: "Reconciliation ledger — /update-template refines this. 'The filesystem is the version.'",
  };
  fs.writeFileSync(path.join(cdir, "state.json"), JSON.stringify(ledger, null, 2) + "\n");
  fs.writeFileSync(path.join(dir, ".template-version"), pkgVersion() + "\n");
}

function installHook(dir) {
  const gitDir = path.join(dir, ".git");
  if (!fs.existsSync(gitDir)) { console.log("  (no .git yet — run `cortex hook` after `git init` to add the freshness tripwire)"); return false; }
  // vendor the tripwire into the repo so the hook is self-contained (no global install needed)
  const toolDest = path.join(dir, ".cortex", "tools");
  fs.mkdirSync(toolDest, { recursive: true });
  fs.copyFileSync(path.join(PKG_ROOT, "tools", "cortex-freshness.mjs"), path.join(toolDest, "cortex-freshness.mjs"));
  const hookDir = path.join(gitDir, "hooks");
  fs.mkdirSync(hookDir, { recursive: true });
  const hookPath = path.join(hookDir, "pre-commit");
  const script = [
    "#!/bin/sh",
    "# Cortex freshness tripwire (added by `cortex hook`). Non-blocking: warns on KB rot,",
    "# never blocks the commit. Make it blocking by removing the final `exit 0`.",
    'node ".cortex/tools/cortex-freshness.mjs" --root . || echo "cortex: ^ knowledge-base rot detected (run \\`cortex check\\`). Commit NOT blocked."',
    "exit 0",
    "",
  ].join("\n");
  fs.writeFileSync(hookPath, script);
  try { fs.chmodSync(hookPath, 0o755); } catch { /* windows */ }
  console.log("  installed pre-commit freshness hook → .git/hooks/pre-commit (non-blocking warn)");
  return true;
}

function cmdInit() {
  const dir = target();
  const kind = resolveKind(dir, flags.kind);
  const repo = flags.repo || DEFAULT_REPO;
  const src = path.join(TEMPLATES, kind);
  if (!fs.existsSync(src)) die(`bundled template not found: ${kind}`);
  fs.mkdirSync(dir, { recursive: true });
  const { copied, skipped } = safeCopyDir(src, dir, { overwrite: !!flags.force });
  writeLedger(dir, kind, repo);
  console.log(`\nCortex (${kind}) v${pkgVersion()} → ${dir}`);
  console.log(`  copied ${copied.length} files · skipped ${skipped.length} (already existed; use --force to overwrite)`);
  if (flags.hook) installHook(dir);
  console.log("\nNext:");
  console.log(`  1. cd ${dir}`);
  console.log(`  2. open in Claude Code and run  ${kind === "global-multi-project" ? "/setup-workspace" : "/setup-project"}`);
  console.log(`  3. keep it fresh:  cortex check   (or add the git hook: cortex hook)\n`);
}

function cmdUpdate() {
  const dir = target();
  if (!fs.existsSync(path.join(dir, "context-engineering"))) die(`${dir} is not a Cortex repo (no context-engineering/).`);
  const kind = resolveKind(dir, flags.kind);
  let repo = flags.repo;
  if (!repo) { try { repo = JSON.parse(fs.readFileSync(path.join(dir, ".cortex", "state.json"), "utf8")).templateRepo; } catch { /* */ } }
  repo = repo || DEFAULT_REPO;
  const runnerSrc = path.join(TEMPLATES, kind, ".claude", "skills", "update-template", "SKILL.md");
  if (!fs.existsSync(runnerSrc)) die(`bundled runner missing: ${runnerSrc}`);
  const body = fs.readFileSync(runnerSrc, "utf8").split("{TEMPLATE_REPO_URL}").join(repo);
  const runnerDest = path.join(dir, ".claude", "skills", "update-template");
  fs.mkdirSync(runnerDest, { recursive: true });
  fs.writeFileSync(path.join(runnerDest, "SKILL.md"), body);
  console.log(`\nRefreshed the Cortex migration runner (v${pkgVersion()}, kind: ${kind}) in ${dir}`);
  console.log(`  source: ${repo}`);
  console.log("\nNext: open the repo in Claude Code and run  /update-template");
  console.log("  It dry-runs a plan, backs up to .cortex-backup/, and reconciles your files with your consent.\n");
}

function cmdCheck() {
  const dir = target();
  const args = [path.join(PKG_ROOT, "tools", "cortex-freshness.mjs"), "--root", dir];
  if (flags.json) args.push("--json");
  if (flags.quiet) args.push("--quiet");
  const r = spawnSync(process.execPath, args, { stdio: "inherit" });
  process.exit(r.status ?? 0);
}

function cmdHook() { installHook(target()); }

function help() {
  console.log(`cortex v${pkgVersion()} — the thinking layer around your codebase

Usage:
  cortex init   [dir] [--kind generic|workspace] [--hook] [--force]   Add Cortex to a repo (bundled templates)
  cortex update [dir] [--repo <url>]                                   Refresh the migration runner, then run /update-template
  cortex check  [dir] [--json] [--quiet]                              Anti-rot freshness scan (KB vs code + index)
  cortex hook   [dir]                                                 Install the pre-commit freshness tripwire
  cortex version | help

Everything ships inside the package — no manual cloning. Deep reconciliation and
knowledge extraction run as Claude Code skills (/update-template, /update-knowledge-base).`);
}

switch (cmd) {
  case "init": cmdInit(); break;
  case "update": cmdUpdate(); break;
  case "check": case "freshness": cmdCheck(); break;
  case "hook": case "install-hook": cmdHook(); break;
  case "version": case "--version": case "-v": console.log(pkgVersion()); break;
  case undefined: case "help": case "--help": case "-h": help(); break;
  default: die(`unknown command: ${cmd}\nRun \`cortex help\`.`);
}
