# A successful MSI transaction does not guarantee that the process inherited
# the toolchain's PATH entry. Do not silently choose between installations.
if (Get-Command swift.exe -CommandType Application -ErrorAction SilentlyContinue) {
  return
}

if ([String]::IsNullOrWhiteSpace($env:SDKROOT)) {
  throw 'Swift is absent from PATH and the installer did not set SDKROOT.'
}
$directory = Get-Item -LiteralPath $env:SDKROOT -ErrorAction Stop
while ($directory -and $directory.Name -ne 'Platforms') {
  $directory = $directory.Parent
}
if (!$directory) {
  throw "Cannot locate the Swift installation containing SDKROOT: $env:SDKROOT"
}
$root = $directory.Parent.FullName
$candidates = @(Get-ChildItem -Path "$root/Toolchains/*/usr/bin/swift.exe" `
    -File -ErrorAction Stop)
if ($candidates.Count -ne 1) {
  throw "Swift is absent from PATH; expected one toolchain in $root, found $($candidates.Count)."
}
$bin = $candidates[0].Directory.FullName
Write-Host "::warning::Swift's toolchain PATH entry is missing; selecting $bin"
$env:PATH = "$bin;$env:PATH"
