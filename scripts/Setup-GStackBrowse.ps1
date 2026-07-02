#Requires -Version 5.1
<#
.SYNOPSIS
  Install gstack for Cursor (global ~/.cursor/skills/gstack-*) - browse + review QA.
.DESCRIPTION
  Windows-friendly installer: Bun + Git Bash + gen:skill-docs --host cursor.
  VitTrade workflow uses only /browse and /review skills.
.EXAMPLE
  .\scripts\Setup-GStackBrowse.ps1
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$GstackRoot = Join-Path $env:USERPROFILE 'gstack'
$UserCursorSkills = Join-Path $env:USERPROFILE '.cursor\skills'
$RepoCursorSkills = Join-Path $GstackRoot '.cursor\skills'

function Test-Command($Name) {
    return $null -ne (Get-Command $Name -ErrorAction SilentlyContinue)
}

function Ensure-BunInPath {
    if (Test-Command bun) { return (Get-Command bun).Source }

    $candidates = @(
        (Join-Path $env:USERPROFILE '.bun\bin\bun.exe'),
        (Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Links\bun.exe')
    )

    $wingetRoot = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages'
    if (Test-Path $wingetRoot) {
        $candidates += Get-ChildItem -Path $wingetRoot -Recurse -Filter 'bun.exe' -ErrorAction SilentlyContinue |
            Select-Object -ExpandProperty FullName
    }

    foreach ($candidate in $candidates) {
        if ($candidate -and (Test-Path $candidate)) {
            $dir = Split-Path -Parent $candidate
            $env:Path = "$dir;" + $env:Path
            Write-Host "Added Bun to PATH: $dir" -ForegroundColor Yellow
            return $candidate
        }
    }

    return $null
}

function Resolve-GitBash {
    if (Test-Command bash) { return (Get-Command bash).Source }
    $gitBash = 'C:\Program Files\Git\bin\bash.exe'
    if (Test-Path $gitBash) { return $gitBash }
    return $null
}

Write-Host '=== VitTrade gstack Setup (Cursor) ===' -ForegroundColor Cyan
Write-Host ''

if (-not (Test-Command git)) {
    Write-Error 'git is required. Install Git for Windows first.'
}

$bunExe = Ensure-BunInPath
if (-not $bunExe) {
    Write-Host 'Bun not found. Install with: winget install Oven-sh.Bun' -ForegroundColor Yellow
    Write-Host 'Then restart the terminal and re-run this script.' -ForegroundColor Yellow
    exit 1
}

$bash = Resolve-GitBash
if (-not $bash) {
    Write-Error 'Git Bash is required (install Git for Windows).'
}

if (Test-Path $GstackRoot) {
    Write-Host "gstack already exists at $GstackRoot - pulling latest..." -ForegroundColor Yellow
    Push-Location $GstackRoot
    git pull --ff-only
    Pop-Location
} else {
    Write-Host "Cloning gstack to $GstackRoot ..."
    git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git $GstackRoot
}

Push-Location $GstackRoot

Write-Host 'Installing gstack dependencies (bun install)...'
& $bunExe install

Write-Host 'Generating Cursor skills (gen:skill-docs --host cursor)...'
& $bunExe run gen:skill-docs --host cursor

if (-not (Test-Path $RepoCursorSkills)) {
    Write-Error "Expected skills at $RepoCursorSkills after gen:skill-docs."
}

Write-Host "Copying skills to $UserCursorSkills ..."
New-Item -ItemType Directory -Force -Path $UserCursorSkills | Out-Null
Get-ChildItem -Path $RepoCursorSkills -Directory | ForEach-Object {
    $dest = Join-Path $UserCursorSkills $_.Name
    if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
    Copy-Item -Recurse -Force $_.FullName $dest
}

Write-Host 'Building browse CLI (bash scripts/build.sh)...'
$buildExit = 0
& $bash -lc "cd '$($GstackRoot -replace '\\','/')' && bun run build"
if ($LASTEXITCODE -ne 0) { $buildExit = $LASTEXITCODE }

Write-Host 'Installing Playwright Chromium...'
& $bunExe x playwright install chromium

Pop-Location

Write-Host ''
if ($buildExit -eq 0) {
    Write-Host '=== Done ===' -ForegroundColor Green
} else {
    Write-Host '=== Done with build warnings ===' -ForegroundColor Yellow
    Write-Host "browse build exited $buildExit - /browse may need manual fix in $GstackRoot"
}

Write-Host "Skills: $UserCursorSkills\gstack-*"
Write-Host ''
Write-Host 'VitTrade policy - use ONLY:'
Write-Host '  /browse  - visual QA after UI batch (flutter run -d chrome)'
Write-Host '  /review  - pre-merge supplement to code-review skill'
Write-Host ''
Write-Host 'Do NOT invoke plan-ceo-review, design-shotgun, or other gstack plan skills'
Write-Host 'during VitTrade migration batches (conflicts with execution prompts).'
Write-Host ''
Write-Host 'Use gstack in a separate QA chat to save Cursor context tokens.'

if ($buildExit -ne 0) { exit $buildExit }
