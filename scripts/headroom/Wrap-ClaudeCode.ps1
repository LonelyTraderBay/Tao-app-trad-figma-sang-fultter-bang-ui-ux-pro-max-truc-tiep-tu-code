#Requires -Version 5.1
<#
.SYNOPSIS
  [OPTIONAL] Wrap Claude Code with Headroom proxy + cross-agent memory.
.DESCRIPTION
  VitTrade default workflow is Cursor subscription only — skip this script
  unless you have a separate Anthropic account (Claude Pro/Max or API key).
.NOTES
  Install Claude Code first: https://docs.anthropic.com/en/docs/claude-code
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
& (Join-Path $ScriptDir 'Start-VitTradeHeadroom.ps1')

$HeadroomExe = (Get-Command headroom -ErrorAction Stop).Source
& $HeadroomExe wrap claude --memory

Write-Host ''
Write-Host 'Claude Code is wrapped. Verify:'
Write-Host '  1. Open a NEW terminal'
Write-Host '  2. headroom doctor   (claude row should pass)'
Write-Host '  3. claude            (launches through Headroom proxy)'
Write-Host '  4. Ask claude to edit one file; confirm git diff is non-empty'
Write-Host ''
Write-Host 'Rollback: headroom unwrap claude'
