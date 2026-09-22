$ErrorActionPreference = 'Stop'
$script = Join-Path $PSScriptRoot '../scripts/Select-WindowsToolchain.ps1'
$root = Join-Path ([IO.Path]::GetTempPath()) ([Guid]::NewGuid().ToString())
$originalPath = $env:PATH
$originalSDK = $env:SDKROOT
$passed = 0

function Assert-Failure([string]$label) {
  $before = $env:PATH
  $failed = $false
  try { & $script } catch { $failed = $true }
  if (!$failed -or $env:PATH -ne $before) {
    throw "$label did not fail without changing PATH"
  }
  Write-Host "PASS: $label"
}

try {
  foreach ($layout in @('Platforms/Windows.platform',
                        'Platforms/6.4.0/Windows.platform')) {
    $installation = Join-Path $root ([Guid]::NewGuid().ToString())
    $sdk = Join-Path $installation "$layout/Developer/SDKs/Windows.sdk"
    $bin = Join-Path $installation 'Toolchains/6.4.0+Asserts/usr/bin'
    New-Item -ItemType Directory -Path $sdk, $bin | Out-Null
    # Used only for command discovery, never executed as a Swift compiler.
    Copy-Item -LiteralPath $env:ComSpec -Destination "$bin/swift.exe"
    $env:SDKROOT = $sdk
    $env:PATH = $env:SystemRoot

    if (Get-Command swift.exe -ErrorAction SilentlyContinue) {
      throw 'The missing-toolchain baseline unexpectedly resolves Swift'
    }
    & $script
    $command = Get-Command swift.exe -ErrorAction Stop
    if ($command.Source -ne [IO.Path]::GetFullPath("$bin/swift.exe")) {
      throw 'Recovery selected the wrong toolchain'
    }
    Write-Host "PASS: missing PATH entry ($layout)"
    $passed++

    $before = $env:PATH
    $env:SDKROOT = $null
    & $script
    if ($env:PATH -ne $before) { throw 'A working PATH was changed' }
    Write-Host 'PASS: working PATH is preserved'
    $passed++

    $env:SDKROOT = $sdk
    $env:PATH = $env:SystemRoot
    $second = Join-Path $installation 'Toolchains/6.4.0+NoAsserts/usr/bin'
    New-Item -ItemType Directory -Path $second | Out-Null
    Copy-Item -LiteralPath $env:ComSpec -Destination "$second/swift.exe"
    Assert-Failure 'ambiguous toolchains'
    $passed++

    Remove-Item -LiteralPath "$bin/swift.exe", "$second/swift.exe"
    Assert-Failure 'missing toolchain'
    $passed++
  }

  $env:SDKROOT = $null
  Assert-Failure 'missing SDKROOT'
  $passed++
  $env:SDKROOT = Join-Path $root 'nonexistent'
  Assert-Failure 'nonexistent SDKROOT'
  $passed++
  $env:SDKROOT = $root
  Assert-Failure 'SDKROOT outside a Swift installation'
  $passed++
  Write-Host "$passed checks passed"
} finally {
  $env:PATH = $originalPath
  $env:SDKROOT = $originalSDK
  if (Test-Path -LiteralPath $root) {
    Remove-Item -LiteralPath $root -Recurse -Force
  }
}
