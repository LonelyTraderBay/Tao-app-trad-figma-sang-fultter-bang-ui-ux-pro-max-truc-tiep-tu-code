# Capture Page Rhythm Visual QA screenshots on Android emulator.
# Requires: adb, running emulator (default emulator-5554), VitTrade app installed.
param(
  [string]$Device = 'emulator-5554',
  [string]$OutDir = 'run-artifacts/phone-visual-qa'
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

function Save-Screen {
  param([string]$Name)
  $path = Join-Path $OutDir "$Name.png"
  adb -s $Device exec-out screencap -p > $path
  Write-Host "Saved $path"
}

# Bottom nav tap coords for 1344x2992 gphone (5 tabs, nav ~142px from bottom).
$navY = 2850
$tabs = @{
  home    = 134
  markets = 403
  trade   = 672
  wallet  = 941
  profile = 1210
}

adb -s $Device shell wm size
Save-Screen '01-home-tab'

foreach ($pair in $tabs.GetEnumerator()) {
  if ($pair.Key -eq 'home') { continue }
  adb -s $Device shell input tap $pair.Value $navY
  Start-Sleep -Seconds 2
  Save-Screen "tab-$($pair.Key)"
}

Write-Host "Done. Screenshots in $OutDir"
