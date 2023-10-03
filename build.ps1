$RUNNER_TOOL_CACHE = $env:RUNNER_TOOL_CACHE
$RUNNER_TEMP = "C:\Temp"
$PREFIX = Join-Path $RUNNER_TOOL_CACHE "mysql"

New-Item "boost" -ItemType Directory -Force
$BOOST = Join-Path $RUNNER_TEMP "boost"
New-Item "build" -ItemType Directory -Force
Set-Location build
cmake .. `
    -DDOWNLOAD_BOOST=1 -DWITH_BOOST="../boost" `
    -DWITH_ROCKSDB_LZ4=OFF -DWITH_ROCKSDB_BZip2=OFF -DWITH_ROCKSDB_Snappy=OFF -DWITH_ROCKSDB_ZSTD=OFF `
    -DWITH_UNIT_TESTS=OFF `
    -DCMAKE_INSTALL_PREFIX="$PREFIX" `
    -DCMAKE_BUILD_TYPE=Release

devenv MySQL.sln /build Release
