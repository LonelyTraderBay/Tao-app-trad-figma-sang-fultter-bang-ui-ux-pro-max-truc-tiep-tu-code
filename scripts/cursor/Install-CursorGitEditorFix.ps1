# Patches Cursor git-editor.sh on Windows so Commit opens COMMIT_EDITMSG
# without the broken IPC bridge (HTTP 500).
$ErrorActionPreference = 'Stop'

$editorSh = Join-Path $env:LOCALAPPDATA 'Programs\cursor\resources\app\extensions\git\dist\git-editor.sh'
$cursorCmd = Join-Path $env:LOCALAPPDATA 'Programs\cursor\resources\app\bin\cursor.cmd'

if (-not (Test-Path $editorSh)) {
    throw "Cursor git-editor.sh not found: $editorSh"
}
if (-not (Test-Path $cursorCmd)) {
    throw "Cursor CLI not found: $cursorCmd"
}

$backup = "$editorSh.bak-vittrade"
if (-not (Test-Path $backup)) {
    Copy-Item $editorSh $backup -Force
    Write-Host "Backup: $backup"
}

$cursorCmdSh = ($cursorCmd -replace '\\', '/')
$patch = @"
#!/bin/sh

COMMIT_FILE="`${@: -1}"

# VitTrade Windows fix: open COMMIT_EDITMSG in Cursor (bypass IPC HTTP 500).
if [ -n "`$WINDIR" ] || [ -n "`$OS" ]; then
  CURSOR="$cursorCmdSh"
  if [ -f "`$CURSOR" ]; then
    "`$CURSOR" --wait "`$COMMIT_FILE"
    exit `$?
  fi
fi

ELECTRON_RUN_AS_NODE="1" \
"`$VSCODE_GIT_EDITOR_NODE" "`$VSCODE_GIT_EDITOR_MAIN" `$VSCODE_GIT_EDITOR_EXTRA_ARGS "`$@"
"@

Set-Content -Path $editorSh -Value $patch -Encoding Ascii -NoNewline
Add-Content -Path $editorSh -Value "`n" -Encoding Ascii
Write-Host "Patched: $editorSh"
Write-Host "Re-enable git.useEditorAsCommitInput in Cursor settings, then reload window."
