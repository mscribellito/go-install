& .\GoInstall.ps1

# Refresh environment variables
$env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')

$Output = & go version

if ($Output -match "go version go") {
    exit 0
} else {
    exit 1
}
