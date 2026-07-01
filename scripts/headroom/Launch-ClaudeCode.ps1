#Requires -Version 5.1
<#
.SYNOPSIS
  [OPTIONAL] Launch Claude Code through the VitTrade Headroom proxy.
.DESCRIPTION
  Not needed for Cursor subscription ($200). Use Cursor Agent + Headroom MCP
  instead (see README.md). Requires Anthropic login or API key.
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
& (Join-Path $ScriptDir 'Start-VitTradeHeadroom.ps1')

$env:Path = "$env:USERPROFILE\.local\bin;$env:USERPROFILE\AppData\Roaming\npm;" + $env:Path
& headroom wrap claude --memory --no-proxy @args
