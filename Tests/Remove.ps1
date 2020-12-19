& .\GoInstall.ps1 -Remove

# Refresh environment variables
$env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')

if (Get-Command "go.exe" -ErrorAction SilentlyContinue) {
    exit 1
} else {
    exit 0
}
