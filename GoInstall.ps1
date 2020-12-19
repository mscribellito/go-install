<#

.SYNOPSIS
Automates the installation and removal of single user Go.

.DESCRIPTION
Automates the installation and removal of single user Go. Also handles configuration of environment variables.

.EXAMPLE
.\GoInstall.ps1

.EXAMPLE
.\GoInstall.ps1 -Remove

.LINK
http://github.com/mscribellito/go-install

#>

param (
    [string]$Version = "1.15.6",
    [switch]$Remove = $false
)

$Path = [Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)
$GoRoot = Join-Path $env:USERPROFILE ".go"
$GoPath = Join-Path $env:USERPROFILE "go"

$Architecture = if ([Environment]::Is64BitOperatingSystem) { "amd64" } else { "386" }

$PackageName = "go$Version.windows-$Architecture.zip"
$PackagePath = Join-Path $env:TEMP "go.zip"

if ($Remove -eq $true) {

    if (Test-Path $GoRoot) {

        Write-Host "Deleting Go directory..."
        Remove-Item $GoRoot -Recurse -Force

        $GoPaths = @(
            (Join-Path $GoRoot "bin"),
            (Join-Path $GoPath "bin")
        )

        $NewPath = ($Path -split ";" | Where-Object {
                $_ -notin $GoPaths
            }) -join ";"

        Write-Host "Removing environment variables..."
        [Environment]::SetEnvironmentVariable("Path", $NewPath, [System.EnvironmentVariableTarget]::User)
        [Environment]::SetEnvironmentVariable("GOROOT", $null, [System.EnvironmentVariableTarget]::User)
        [Environment]::SetEnvironmentVariable("GOPATH", $null, [System.EnvironmentVariableTarget]::User)

        Write-Host "Go was removed from $GoRoot."

    } else {
        Write-Host "Go not installed in $GoRoot."
    }
    
    exit 0

}

try {

    Write-Host "Downloading archive..."
    $PackageUrl = "https://storage.googleapis.com/golang/$PackageName"
    (New-Object System.Net.WebClient).DownloadFile($PackageUrl, $PackagePath)

}
catch {
    Write-Host "Download failed." -ForegroundColor Red
    exit 1
}

try {

    Write-Host "Extracting archive..."
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($PackagePath, $env:TEMP)
    Move-Item -Path (Join-Path $env:TEMP "go") -Destination $GoRoot    

}
catch {
    Write-Host "Extract failed." -ForegroundColor Red
    exit 1
}

Write-Host "Adding environment variables..."
$NewPaths = (Join-Path $GoRoot "bin") + ";" + (Join-Path $GoPath "bin")
[Environment]::SetEnvironmentVariable("Path", $Path + ";" + $NewPaths, [System.EnvironmentVariableTarget]::User)
[Environment]::SetEnvironmentVariable("GOROOT", $GoRoot, [System.EnvironmentVariableTarget]::User)
[Environment]::SetEnvironmentVariable("GOPATH", $GoPath, [System.EnvironmentVariableTarget]::User)

"src", "pkg", "bin" | ForEach-Object {

    $Directory = Join-Path $GoPath $_
    if (Test-Path $Directory) {
        return
    }
    New-Item -Path $GoPath -Name $_ -ItemType Directory | Out-Null

}

Write-Host "Go version $Version was installed into $GoRoot."

exit 0
