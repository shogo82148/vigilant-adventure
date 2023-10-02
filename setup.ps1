$RUNNER_TOOL_CACHE = $env:RUNNER_TOOL_CACHE
$RUNNER_TEMP = $env:RUNNER_TEMP
$PREFIX = Join-Path $RUNNER_TOOL_CACHE "mysql" $MYSQL_VERSION "x64"

# NASM is required by OpenSSL
Write-Host "::group::Set up NASM"
choco install nasm
Set-Item -Path "env:PATH" "C:\Program Files\NASM;$env:PATH"
Write-Host "::endgroup::"

# install OpenSSL
$OPENSSL_VERSION = "3.1.3"
Write-Host "::group::fetch OpenSSL source"
Set-Location "$RUNNER_TEMP"
Write-Host "Downloading zip archive..."
Invoke-WebRequest "https://github.com/openssl/openssl/archive/openssl-$OPENSSL_VERSION.zip" -OutFile "openssl.zip"
Write-Host "Unzipping..."
Expand-Archive -Path "openssl.zip" -DestinationPath .
Remove-Item -Path "openssl.zip"
Write-Host "::endgroup::"

Write-Host "::group::build OpenSSL"
Set-Location "$RUNNER_TEMP"
Set-Location "openssl-openssl-$OPENSSL_VERSION"

C:\strawberry\perl\bin\perl.exe Configure --prefix="$PREFIX" --openssldir="$PREFIX" --libdir=lib
nmake
nmake install_sw install_ssldirs
Set-Location "$RUNNER_TEMP"
Remove-Item -Path "openssl-openssl-$OPENSSL_VERSION" -Recurse -Force

# remove debug information
Get-ChildItem "$PREFIX" -Include *.pdb -Recurse | Remove-Item

Write-Host "::endgroup::"


# install Bison
choco install winflexbison3
