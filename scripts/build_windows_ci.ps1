# Builds and tests this project on Windows similar to CI.
# Prerequisites: Visual Studio (with C++ and CMake), Python 3, Internet for first run.
# Usage: From repo root, run in PowerShell: ./scripts/build_windows_ci.ps1 -QtVersion 6.7.2 -Config Debug

param(
    [string]$QtVersion = "6.7.2",
    [ValidateSet('Debug','Release')]
    [string]$Config = "Debug",
    # aqt arch for Windows desktop with MSVC toolchain (fallback only)
    [string]$Arch = "win64_msvc2019_64",
    # Path to existing Qt root (Maintenance Tool), e.g. C:\DevTools\Qt
    [string]$QtRoot = "C:\\DevTools\\Qt",
    [switch]$NoInstall
)

$ErrorActionPreference = 'Stop'

function Ensure-Command($name) {
    if (-not (Get-Command $name -ErrorAction SilentlyContinue)) {
        throw "Required command '$name' not found in PATH. Please install or open a Developer PowerShell for VS."
    }
}

function Ensure-CMake {
    if (Get-Command cmake -ErrorAction SilentlyContinue) { return }
    # Try Qt Maintenance Tool's bundled CMake
    try {
            if ($QtRoot -and (Test-Path $QtRoot)) {
                $possibleDirs = @(
                    (Join-Path $QtRoot 'Tools\CMake_64\bin'),
                    (Join-Path $QtRoot 'Tools\CMake\bin')
                )
                # Also search Tools subfolders for any CMake*/bin
                $toolDirs = Get-ChildItem -Path (Join-Path $QtRoot 'Tools') -Directory -ErrorAction SilentlyContinue
                foreach ($td in $toolDirs) {
                    if ($td.Name -match 'CMake' -or $td.Name -match 'cmake') {
                        $candidate = Join-Path $td.FullName 'bin'
                        $possibleDirs += $candidate
                    }
                }
                foreach ($d in $possibleDirs) {
                    if (Test-Path (Join-Path $d 'cmake.exe')) {
                        if ($env:PATH -notlike "*${d}*") { $env:PATH = "$d;$env:PATH" }
                        if (Get-Command cmake -ErrorAction SilentlyContinue) { return }
                    }
                }
            }
    } catch {}
    $candidatePaths = @(
        (Join-Path $Env:ProgramFiles 'CMake\bin\cmake.exe'),
        (Join-Path $Env:ProgramFiles 'CMake\bin\ctest.exe'),
        (Join-Path ${Env:ProgramFiles(x86)} 'CMake\bin\cmake.exe'),
        (Join-Path ${Env:ProgramFiles(x86)} 'CMake\bin\ctest.exe')
    ) | Where-Object { $_ -ne $null }

    $found = $false
    foreach ($p in $candidatePaths) {
        if (Test-Path $p) {
            $dir = Split-Path $p -Parent
            if ($env:PATH -notlike "*${dir}*") { $env:PATH = "$dir;$env:PATH" }
            $found = $true
        }
    }
    if ($found -and (Get-Command cmake -ErrorAction SilentlyContinue)) { return }

    # Try Visual Studio's bundled CMake
    try {
        $vswhere = "${Env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
        if (Test-Path $vswhere) {
            $vsinst = & $vswhere -latest -products * -requires Microsoft.Component.MSBuild -format json | ConvertFrom-Json
            if ($vsinst) {
                $root = $vsinst[0].installationPath
                $vsCMakeDirs = @(
                    (Join-Path $root 'Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin'),
                    (Join-Path $root 'Common7\IDE\CommonExtensions\Microsoft\CMake\bin')
                )
                foreach ($d in $vsCMakeDirs) {
                    if (Test-Path (Join-Path $d 'cmake.exe')) {
                        if ($env:PATH -notlike "*${d}*") { $env:PATH = "$d;$env:PATH" }
                        break
                    }
                }
            }
        }
    } catch {}

    if (-not (Get-Command cmake -ErrorAction SilentlyContinue)) {
        throw "cmake not found. Install CMake (https://cmake.org/download/) or add Visual Studio's CMake tools to PATH."
    }
}

function Import-VsDevEnv {
    param(
        [string]$Arch = 'x64',
        [string]$VsPath,
        [string]$VsDevCmdPath
    )
    try {
        $vsDevCmd = $VsDevCmdPath
        if (-not $vsDevCmd) {
            $root = $VsPath
            if (-not $root) {
                $vswhere = "${Env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
                if (-not (Test-Path $vswhere)) { return }
                $vsinst = & $vswhere -latest -products * -requires Microsoft.Component.MSBuild -format json | ConvertFrom-Json
                if (-not $vsinst) { return }
                $root = $vsinst[0].installationPath
            }
            $vsDevCmd = Join-Path $root 'Common7\Tools\VsDevCmd.bat'
        }
        if (-not (Test-Path $vsDevCmd)) { return }
    # VsDevCmd expects amd64, not x64
    if ($Arch -ieq 'x64') { $vcArch = 'amd64' } else { $vcArch = $Arch }
        Write-Host "Initializing VS Developer environment ($vcArch) from: $vsDevCmd" -ForegroundColor Cyan
        $output = & cmd.exe /c "call `"$vsDevCmd`" -no_logo -arch=$vcArch && set"
        foreach ($line in $output) {
            if ($line -match '^(.*?)=(.*)$') {
                $name = $matches[1]
                $value = $matches[2]
                Set-Item -Path Env:$name -Value $value -ErrorAction SilentlyContinue | Out-Null
            }
        }
    } catch {}
}

function Get-VSInstance {
    param(
        [string]$VersionRange
    )
    $vswhere = "${Env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
    if (-not (Test-Path $vswhere)) { return $null }
    $args = @('-latest','-products','*','-requires','Microsoft.VisualStudio.Component.VC.Tools.x86.x64','-requires','Microsoft.Component.MSBuild','-format','json')
    if ($VersionRange) { $args += @('-version', $VersionRange) }
    $raw = & $vswhere @args
    if (-not $raw) { return $null }
    $vs = $raw | ConvertFrom-Json
    if ($vs -is [System.Array]) { if ($vs.Length -gt 0) { return $vs[0] } else { return $null } }
    return $vs
}

function Find-VsDevCmdPath {
    param(
        [string]$InstallPath
    )
    if ($InstallPath) {
        $p = Join-Path $InstallPath 'Common7\Tools\VsDevCmd.bat'
        if (Test-Path $p) { return $p }
    }
    $candidates = @(
        'C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat',
        'C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\Tools\VsDevCmd.bat',
        'C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\VsDevCmd.bat',
        'C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\VsDevCmd.bat',
        'C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\Tools\VsDevCmd.bat',
        'C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\Tools\VsDevCmd.bat'
    )
    foreach ($c in $candidates) { if (Test-Path $c) { return $c } }
    return $null
}

function Test-ToolsetInstalled {
    param(
        [string]$VsInstallPath,
        [string]$Toolset
    )
    if (-not $VsInstallPath -or -not $Toolset) { return $false }
    $msbuildVcDir = Join-Path $VsInstallPath ("MSBuild\\Microsoft\\VC\\$Toolset")
    return (Test-Path $msbuildVcDir)
}

# Verify base tooling
Ensure-CMake

# Detect VS instance early and import its environment
$vsInstance = $null
$vsInstancePath = $null
try {
    $vsInstance = Get-VSInstance -VersionRange "[17.0,18.0)"
    if (-not $vsInstance) { $vsInstance = Get-VSInstance -VersionRange "[16.0,17.0)" }
    if ($vsInstance) { $vsInstancePath = $vsInstance.installationPath }
} catch {}

# Try to ensure MSVC environment is loaded (cl.exe)
if (-not (Get-Command cl -ErrorAction SilentlyContinue)) {
    Import-VsDevEnv -Arch 'x64' -VsPath $vsInstancePath
}
if (-not (Get-Command cl -ErrorAction SilentlyContinue)) {
    Write-Host "MSVC build tools not detected in PATH. Please open 'Developer PowerShell for VS' and rerun." -ForegroundColor Yellow
}

$RepoRoot = (Resolve-Path "$PSScriptRoot\..\").Path
Set-Location $RepoRoot

# Determine Qt location: prefer existing Maintenance Tool install if present
$QtArchDir = $null
if (Test-Path $QtRoot) {
    $qtVersionDir = Join-Path $QtRoot $QtVersion
    if (Test-Path $qtVersionDir) {
        $candidates = @(
            'msvc2022_64','msvc2019_64','msvc2017_64','win64_msvc2019_64','win64_msvc2017_64'
        ) | ForEach-Object { Join-Path $qtVersionDir $_ }
        $QtArchDir = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1
        if (-not $QtArchDir) {
            # Try any msvc*_64 directory
            $msvcDirs = Get-ChildItem -Path $qtVersionDir -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'msvc.*_64' -or $_.Name -match 'win64_msvc.*_64' }
            if ($msvcDirs) { $QtArchDir = $msvcDirs[0].FullName }
        }
    }
}

# If still not found, optionally install via aqt (unless NoInstall)
if (-not $QtArchDir) {
    if ($NoInstall) {
        throw "Qt $QtVersion not found under $QtRoot and installation disabled (NoInstall). Please specify -QtRoot or install Qt."
    }
    # Install aqtinstall if needed
    Ensure-Command python
    if (-not (python -c "import aqt" 2>$null)) {
        Write-Host "Installing aqtinstall (first run only)" -ForegroundColor Cyan
        python -m pip install --upgrade pip
        python -m pip install aqtinstall
    }
    $QtDir = Join-Path $RepoRoot "Qt"
    $QtInstallRoot = Join-Path $QtDir $QtVersion
    $QtArchDir = Join-Path $QtInstallRoot $Arch
    if (-not (Test-Path $QtArchDir)) {
        Write-Host "Downloading Qt $QtVersion ($Arch) with aqtinstall..." -ForegroundColor Cyan
        New-Item -ItemType Directory -Force -Path $QtDir | Out-Null
        python -m aqt install-qt windows desktop $QtVersion $Arch --outputdir "$QtDir"
    }
}

# Set environment variables for CMake to find Qt
$env:Qt6_DIR = Join-Path $QtArchDir "lib\cmake\Qt6"
$env:CMAKE_PREFIX_PATH = $QtArchDir
$env:PATH = "$($QtArchDir)\bin;$env:PATH"

Write-Host "Using Qt from: $QtArchDir" -ForegroundColor Green

# Configure & build
# Use a unique build dir to avoid generator/platform cache conflicts
$genTag = 'vs'
if ($vsInstance) {
    $ver = [version]$vsInstance.installationVersion
    if ($ver.Major -ge 17) { $genTag = 'vs2022' } elseif ($ver.Major -ge 16) { $genTag = 'vs2019' }
}
$buildDir = Join-Path $RepoRoot ("build-$Config-$genTag-x64")
if (Test-Path (Join-Path $buildDir 'CMakeCache.txt')) {
    Write-Host "Cleaning existing CMake cache in $buildDir (platform/generator may have changed)" -ForegroundColor Yellow
    Remove-Item -Recurse -Force (Join-Path $buildDir 'CMakeFiles') -ErrorAction SilentlyContinue
    Remove-Item -Force (Join-Path $buildDir 'CMakeCache.txt') -ErrorAction SilentlyContinue
}
if (-not (Test-Path $buildDir)) { New-Item -ItemType Directory -Path $buildDir | Out-Null }

# Try to pick a sensible generator: prefer VS 2022, then 2019
$vsGen = $null
$vsInstancePath = $null
if ($vsInstance) {
    $ver = [version]$vsInstance.installationVersion
    if ($ver.Major -ge 17) { $vsGen = 'Visual Studio 17 2022' }
    elseif ($ver.Major -ge 16) { $vsGen = 'Visual Studio 16 2019' }
    $vsInstancePath = $vsInstance.installationPath
}

if ($vsGen) {
    # Choose toolset based on Qt kit if possible
    $toolset = $null
    if ($QtArchDir -match 'msvc2019_64') { $toolset = 'v142' }
    elseif ($QtArchDir -match 'msvc2022_64') { $toolset = 'v143' }
    # Use toolset only if installed
    if ($toolset -and -not (Test-ToolsetInstalled -VsInstallPath $vsInstancePath -Toolset $toolset)) {
        Write-Host "Requested toolset '$toolset' not installed in VS at $vsInstancePath. Falling back to default toolset." -ForegroundColor Yellow
        $toolset = $null
    }
    $cmakeArgs = @('-S','.', '-B', $buildDir, '-G', $vsGen, '-A','x64', '-DCMAKE_BUILD_TYPE='+$Config, '-DBUILD_TESTING=ON', "-DQt6_DIR=$env:Qt6_DIR")
    if ($toolset) { $cmakeArgs += @('-T', $toolset) }
    if ($vsInstancePath) { $cmakeArgs += ("-DCMAKE_GENERATOR_INSTANCE=$vsInstancePath") }
    & cmake @cmakeArgs
} else {
    & cmake -S . -B $buildDir '-DBUILD_TESTING=ON' ('-DCMAKE_BUILD_TYPE='+$Config) ("-DQt6_DIR=$env:Qt6_DIR")
}
cmake --build $buildDir --config $Config -- /m

# Run tests
Push-Location $buildDir
ctest --output-on-failure --build-config $Config
Pop-Location
