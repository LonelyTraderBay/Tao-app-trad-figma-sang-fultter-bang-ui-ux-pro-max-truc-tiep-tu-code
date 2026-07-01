#Requires -Version 5.1
<#
.SYNOPSIS
  Refresh the GitNexus knowledge graph for this repo.
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$RepoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
Set-Location $RepoRoot

$env:Path = "$env:APPDATA\npm;" + $env:Path

Write-Host "Refreshing GitNexus index (may take several minutes)..."
gitnexus analyze --skip-agents-md --skip-skills
gitnexus status
gitnexus doctor
