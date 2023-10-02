$BUILD_SCRIPT = Join-Path $env:GITHUB_WORKSPACE "build.ps1"

Set-Location mysql-server
$BUILD_SCRIPT
