# Prepares a USB stick with Headunit Revived (Android Auto for Android head units).
# Usage: powershell -ExecutionPolicy Bypass -File prepare_usb.ps1 -Drive F:
param([Parameter(Mandatory)][string]$Drive)

$Version = 'v.3.4.0'
$Sha256  = 'ed5cb51535e0377e4bc5d0d232e536a4eca1a46874b6cd0f8ab1b0dbe4de66dd'
$Url     = "https://github.com/andreknieriem/open-headunit/releases/download/$Version/com.andrerinas.headunitrevived_3.4.0.apk"

$Drive = $Drive.TrimEnd('\', ':') + ':\'
if (-not (Test-Path $Drive)) { throw "Drive $Drive not found." }
if ((Get-Volume -DriveLetter $Drive[0]).DriveType -ne 'Removable') { throw "$Drive is not a removable drive." }

$tmp = Join-Path $env:TEMP 'HeadunitRevived.apk'
Write-Host "Downloading $Url"
curl.exe -sS --fail -L --retry 5 -o $tmp $Url
if ($LASTEXITCODE -ne 0) { throw 'Download failed.' }

if ((Get-FileHash $tmp -Algorithm SHA256).Hash -ne $Sha256.ToUpper()) { Remove-Item $tmp; throw 'SHA-256 mismatch, aborting.' }
Write-Host 'SHA-256 verified.'

New-Item -ItemType Directory -Force (Join-Path $Drive 'apk') | Out-Null
Copy-Item $tmp (Join-Path $Drive 'HeadunitRevived.apk') -Force
Copy-Item $tmp (Join-Path $Drive 'apk\HeadunitRevived.apk') -Force
Write-Host "Done. Eject $Drive safely, then install HeadunitRevived.apk on the car screen."
