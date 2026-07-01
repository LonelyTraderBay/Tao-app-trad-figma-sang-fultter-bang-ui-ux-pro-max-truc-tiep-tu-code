#Requires -Version 5.1
<#
.SYNOPSIS
  Start a VitTrade Cursor AI session (Headroom proxy + GitNexus status).
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$RepoRoot = Split-Path -Parent $PSScriptRoot
$HeadroomScript = Join-Path $PSScriptRoot 'headroom\Start-VitTradeHeadroom.ps1'

Write-Host '=== VitTrade Cursor Session ===' -ForegroundColor Cyan
Write-Host ''

& $HeadroomScript

$env:Path = "$env:APPDATA\npm;$env:USERPROFILE\.local\bin;" + $env:Path

Write-Host ''
Write-Host '=== GitNexus ===' -ForegroundColor Cyan
gitnexus status 2>&1

Write-Host ''
Write-Host '=== Checklist ===' -ForegroundColor Cyan
Write-Host '  [ ] Cursor Settings -> MCP: headroom + gitnexus Connected'
Write-Host '  [ ] Model: Sonnet (default) / Opus only for hard debug'
Write-Host '  [ ] Batch: 5-10 files per turn; new chat after each batch'
Write-Host '  [ ] Docs: one prompt + one plan via docs/INDEX.md'
Write-Host ''
