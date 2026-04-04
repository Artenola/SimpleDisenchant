# install-libs.ps1 — Download external libraries for local development
# Run once: powershell -ExecutionPolicy Bypass -File install-libs.ps1

$libsDir = Join-Path $PSScriptRoot "Libs"

# LibStub
$libStubDir = Join-Path $libsDir "LibStub"
if (-not (Test-Path $libStubDir)) {
    Write-Host "Downloading LibStub..."
    New-Item -ItemType Directory -Path $libStubDir -Force | Out-Null
    $url = "https://raw.githubusercontent.com/lua-wow/LibStub/master/LibStub.lua"
    Invoke-WebRequest -Uri $url -OutFile (Join-Path $libStubDir "LibStub.lua")
    Write-Host "  -> LibStub.lua OK"
} else {
    Write-Host "LibStub already exists, skipping."
}

# LibDataBroker-1.1
$ldbDir = Join-Path $libsDir "LibDataBroker-1.1"
if (-not (Test-Path $ldbDir)) {
    Write-Host "Downloading LibDataBroker-1.1..."
    New-Item -ItemType Directory -Path $ldbDir -Force | Out-Null
    $url = "https://raw.githubusercontent.com/tekkub/libdatabroker-1-1/master/LibDataBroker-1.1.lua"
    Invoke-WebRequest -Uri $url -OutFile (Join-Path $ldbDir "LibDataBroker-1.1.lua")
    Write-Host "  -> LibDataBroker-1.1.lua OK"
} else {
    Write-Host "LibDataBroker-1.1 already exists, skipping."
}

Write-Host "`nDone! Libs installed in: $libsDir"
