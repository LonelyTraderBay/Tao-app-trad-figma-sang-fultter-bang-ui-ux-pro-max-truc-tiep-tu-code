#Requires -Version 5.1
<#
.SYNOPSIS
  Stop the Headroom proxy listening on port 8787 (default).
#>
param(
    [int]$Port = 8787
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$connections = @()
try {
    $connections = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction Stop
}
catch {
    Write-Host "No Headroom proxy listening on port $Port."
    exit 0
}

$pids = $connections.OwningProcess | Sort-Object -Unique
foreach ($procId in $pids) {
    try {
        $proc = Get-Process -Id $procId -ErrorAction Stop
        Write-Host "Stopping $($proc.ProcessName) (PID $procId) on port $Port ..."
        Stop-Process -Id $procId -Force -ErrorAction Stop
    }
    catch {
        Write-Warning "Could not stop PID ${procId}: $_"
    }
}

Write-Host "Headroom proxy on port $Port stopped."
