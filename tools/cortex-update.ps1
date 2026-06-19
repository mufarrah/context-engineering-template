#requires -version 5
<#
  Cortex first-run bootstrap (Windows/PowerShell).

  Installs the latest migration runner (the `/update-template` skill) into an existing,
  older Cortex repo so you can then run it from Claude Code. Solves the chicken-and-egg of
  the very first upgrade.

  Usage:
    ./tools/cortex-update.ps1 -Target ..\my-project -Repo https://github.com/<you>/context-engineering-template
    $env:CORTEX_TEMPLATE_REPO = '...'; ./tools/cortex-update.ps1 -Target ..\my-project

  After it runs: open the target repo in Claude Code and run  /update-template
#>
param(
  [string]$Target = ".",
  [string]$Repo = $env:CORTEX_TEMPLATE_REPO
)
$ErrorActionPreference = "Stop"

if (-not $Repo) {
  Write-Host "Provide your template repo URL:"
  Write-Host "  ./tools/cortex-update.ps1 -Target <dir> -Repo <url>"
  Write-Host "  (or set `$env:CORTEX_TEMPLATE_REPO)"
  exit 1
}

if (-not (Test-Path (Join-Path $Target "context-engineering"))) {
  throw "'$Target' does not look like a Cortex repo (no context-engineering/)."
}

$kind = if ((Test-Path (Join-Path $Target "active-projects")) -or (Test-Path (Join-Path $Target "shared"))) {
  "global-multi-project"
} else {
  "generic"
}
Write-Host "Detected template kind: $kind"

$tmp = Join-Path $env:TEMP ("cortex-" + [System.Guid]::NewGuid().ToString("N"))
try {
  Write-Host "Fetching latest template from $Repo ..."
  git clone --depth 1 $Repo $tmp 2>$null | Out-Null
  if ($LASTEXITCODE -ne 0) { throw "git clone failed ($Repo)." }

  $src = Join-Path $tmp "templates/$kind/.claude/skills/update-template/SKILL.md"
  if (-not (Test-Path $src)) { throw "migration runner not found in template at $src" }

  $dest = Join-Path $Target ".claude/skills/update-template"
  New-Item -ItemType Directory -Force -Path $dest | Out-Null

  # Bake the repo URL into the runner's CONFIG so it can fetch at run time.
  (Get-Content $src -Raw).Replace("{TEMPLATE_REPO_URL}", $Repo) |
    Set-Content (Join-Path $dest "SKILL.md")

  Write-Host ""
  Write-Host "[OK] Installed the Cortex migration runner -> $dest\SKILL.md"
  Write-Host ""
  Write-Host "Next steps:"
  Write-Host "  1. Open '$Target' in Claude Code"
  Write-Host "  2. Run:  /update-template"
  Write-Host "     It will show a dry-run plan, back up your files, and migrate with your confirmation."
}
finally {
  if (Test-Path $tmp) { Remove-Item -Recurse -Force $tmp }
}
