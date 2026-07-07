# Capture all 12 Page Rhythm Visual QA flows on Android emulator.
param(
  [string]$Device = 'emulator-5554',
  [string]$OutDir = 'run-artifacts/phone-visual-qa',
  [int]$PostRenderSeconds = 5,
  [int]$LaunchTimeoutSeconds = 120
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$logPath = Join-Path $OutDir 'capture-log.txt'
$reportPath = Join-Path $OutDir 'capture-report.json'
if (Test-Path $logPath) { Remove-Item $logPath }

function Write-Log {
  param([string]$Message)
  $line = "[$(Get-Date -Format 'HH:mm:ss')] $Message"
  Write-Host $line
  Add-Content -Path $logPath -Value $line
}

function Save-Screen {
  param([string]$Name)
  $path = Join-Path $OutDir "$Name.png"
  adb -s $Device exec-out screencap -p > $path
  $size = (Get-Item $path).Length
  Write-Log "Saved $Name.png ($size bytes)"
  return $size
}

function Wait-AppRendered {
  param([int]$TimeoutSec)
  adb -s $Device logcat -c 2>$null
  $deadline = (Get-Date).AddSeconds($TimeoutSec)
  while ((Get-Date) -lt $deadline) {
    $hit = adb -s $Device logcat -d 2>$null |
      Select-String -Pattern 'Sending viewport metrics to the engine' |
      Select-Object -First 1
    if ($hit) { return $true }
    Start-Sleep -Milliseconds 800
  }
  return $false
}

function Get-OverflowLines {
  adb -s $Device logcat -d 2>$null |
    Select-String -Pattern 'overflowed by|RenderFlex overflow|BoxConstraints forces' |
    ForEach-Object { $_.Line.Trim() }
}

function Stop-App {
  param([System.Diagnostics.Process]$Proc)
  if ($Proc -and -not $Proc.HasExited) {
    Stop-Process -Id $Proc.Id -Force -ErrorAction SilentlyContinue
  }
  adb -s $Device shell am force-stop com.vittrade.vit_trade_flutter 2>$null
  Start-Sleep -Seconds 2
}

$flows = @(
  @{ Id = 1;  File = '01-home-tab';              Route = '/home';                      Scroll = $false }
  @{ Id = 2;  File = '02-wallet-multi-manager'; Route = '/wallet/multi-manager';      Scroll = $false }
  @{ Id = 3;  File = '03-savings-guide';         Route = '/earn/savings/guide';        Scroll = $false }
  @{ Id = 4;  File = '04-p2p-merchant-apply';    Route = '/p2p/merchant-apply';        Scroll = $false }
  @{ Id = 5;  File = '05-arena-home';            Route = '/arena';                     Scroll = $false }
  @{ Id = 6;  File = '06-settings';              Route = '/profile/settings';          Scroll = $false }
  @{ Id = 7;  File = '07-admin-analytics';       Route = '/admin/analytics';           Scroll = $false }
  @{ Id = 8;  File = '08-provider-apply';        Route = '/trade/copy-provider-apply'; Scroll = $false }
  @{ Id = 9;  File = '09-unified-portfolio';     Route = '/unified-portfolio';         Scroll = $false }
  @{ Id = 10; File = '10-markets-depth';         Route = '/markets/depth';             Scroll = $false }
  @{ Id = 11; File = '11-home-product-grid';    Route = '/home';                      Scroll = $true }
  @{ Id = 12; File = '12-rewards';              Route = '/rewards';                   Scroll = $false }
)

Write-Log "Device: $Device"
adb -s $Device shell wm size | ForEach-Object { Write-Log $_ }
adb -s $Device shell wm density | ForEach-Object { Write-Log $_ }

$results = @()
$skipBuild = $false

foreach ($flow in $flows) {
  Write-Log "--- Flow $($flow.Id): $($flow.Route) ---"

  $flutterArgs = @(
    'run', '-d', $Device,
    "--dart-define=INITIAL_ROUTE=$($flow.Route)",
    '--no-pub'
  )
  if ($skipBuild) { $flutterArgs += '--no-build' }

  $proc = Start-Process -FilePath 'flutter' -ArgumentList $flutterArgs `
    -PassThru -NoNewWindow -WorkingDirectory $root

  $rendered = Wait-AppRendered -TimeoutSec $LaunchTimeoutSeconds
  if (-not $rendered) { Write-Log "WARN: viewport timeout" }

  Start-Sleep -Seconds $PostRenderSeconds
  $skipBuild = $true

  if ($flow.Scroll) {
    adb -s $Device shell input swipe 672 1800 672 600 400
    Start-Sleep -Seconds 2
  }

  $bytes = Save-Screen -Name $flow.File
  $overflows = @(Get-OverflowLines)
  $valid = $bytes -gt 200000

  $results += [ordered]@{
    id        = $flow.Id
    route     = $flow.Route
    file      = "$($flow.File).png"
    bytes     = $bytes
    rendered  = $rendered
    validShot = $valid
    overflows = $overflows
  }

  if ($overflows.Count -gt 0) {
    $overflows | ForEach-Object { Write-Log "OVERFLOW: $_" }
  }
  if (-not $valid) { Write-Log "WARN: likely blank shot (<200KB)" }

  Stop-App -Proc $proc
}

$results | ConvertTo-Json -Depth 4 | Set-Content -Path $reportPath -Encoding UTF8
Write-Log "Report: $reportPath"
Write-Log "Done - $($results.Count) screenshots"
