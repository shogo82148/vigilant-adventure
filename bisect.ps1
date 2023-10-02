$RUNNER_TOOL_CACHE = $env:RUNNER_TOOL_CACHE
$RUNNER_TEMP = $env:RUNNER_TEMP
$PREFIX = Join-Path $RUNNER_TOOL_CACHE "mysql" $MYSQL_VERSION "x64"

Write-Host "::group::Set up Visual Studio 2022"
New-Item $RUNNER_TEMP -ItemType Directory -Force
Set-Location "$RUNNER_TEMP"
Remove-Item -Path * -Recurse -Force

# https://help.appveyor.com/discussions/questions/18777-how-to-use-vcvars64bat-from-powershell
# https://stackoverflow.com/questions/2124753/how-can-i-use-powershell-with-the-visual-studio-command-prompt
cmd.exe /c "call `"C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvarsall.bat`" x64 && set > %temp%\vcvars.txt"
Get-Content "$env:temp\vcvars.txt" | Foreach-Object {
    if ($_ -match "^(.*?)=(.*)$") {
        Set-Item -Path "env:$($matches[1])" $matches[2]
        Write-Host "::debug::$($matches[1])=$($matches[2])"
    }
}
Write-Host "::endgroup::"

$BUILD_SCRIPT = Join-Path $env:GITHUB_WORKSPACE "build.ps1"

Set-Location mysql-server
$BUILD_SCRIPT
