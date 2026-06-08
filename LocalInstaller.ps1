$downloads = [Environment]::GetFolderPath("UserProfile") + "\Downloads"
$folder = Join-Path $downloads "HyperHelper"

if (!(Test-Path $folder)) {
    New-Item -ItemType Directory -Path $folder | Out-Null
}

$nodeInstalled = $false
try {
    node -v | Out-Null
    $nodeInstalled = $true
}
catch {
    $nodeInstalled = $false
}

if (-not $nodeInstalled) {
    Write-Host "Installing Node.js..."
    winget install OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements
}

$env:Path += ";C:\Program Files\nodejs"

$luaUrl = "https://raw.githubusercontent.com/evjkh/HyperHelper/main/LocalHelper.lua"
$jsUrl  = "https://raw.githubusercontent.com/evjkh/HyperHelper/main/LocalServer.js"

Invoke-WebRequest -Uri $luaUrl -OutFile (Join-Path $folder "LocalHelper.lua")
Invoke-WebRequest -Uri $jsUrl -OutFile (Join-Path $folder "LocalServer.js")

Set-Location $folder

if (!(Test-Path "package.json")) {
    npm init -y
}

npm install express

$batContent = @"
@echo off
cd /d "%~dp0"
node LocalServer.js
pause
"@
Start-Process "explorer.exe" -ArgumentList $folder

Set-Content -Path (Join-Path $folder "run.bat") -Value $batContent
Clear-Host

Write-Host "=====================================" -ForegroundColor Green
Write-Host "      HyperHelper Setup Complete     " -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green
Write-Host ""
Write-Host "Installed in Downloads/HyperHelper"
Write-Host "You can run the server by opening 'run.bat'"
Write-Host ""
Write-Host ""
Write-Host ""

Write-Host "Press any key to exit..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
