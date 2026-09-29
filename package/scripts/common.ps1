# Vault of the Void 한글 패치 - 공용 함수 (Windows PowerShell 5.1 호환)

$Script:ExeName      = 'VaultoftheVoid.exe'
$Script:GameDirName  = 'Vault of the Void'
$Script:BackupDir    = '_KR_backup_original'
$Script:KnownDataWin = 40550336   # 이 패치를 만든 게임 버전(2.8.9.0)의 data.win 크기
# 패치가 바꾸는 파일 (게임 폴더 기준 상대 경로)
$Script:PatchFiles = @(
    'Locale\locale_ja.json',
    'spr_font_japanese.json',
    'spr_font_japanese_heading.json',
    'font_japanese_0.yytex',
    'font_japanese_1.yytex'
)
$Script:EnLocale = 'Locale\locale_en.json'

function Write-Step([string]$msg)  { Write-Host ('  - ' + $msg) }
function Write-Ok([string]$msg)    { Write-Host ('  [완료] ' + $msg) -ForegroundColor Green }
function Write-Warn2([string]$msg) { Write-Host ('  [주의] ' + $msg) -ForegroundColor Yellow }
function Write-Err([string]$msg)   { Write-Host ('  [오류] ' + $msg) -ForegroundColor Red }

function Test-GameDir([string]$dir) {
    if ([string]::IsNullOrWhiteSpace($dir)) { return $false }
    return (Test-Path -LiteralPath (Join-Path $dir $Script:ExeName)) -and
           (Test-Path -LiteralPath (Join-Path $dir 'Locale'))
}

function Get-SteamLibraries {
    $roots = New-Object System.Collections.Generic.List[string]
    foreach ($key in @('HKCU:\Software\Valve\Steam', 'HKLM:\SOFTWARE\WOW6432Node\Valve\Steam', 'HKLM:\SOFTWARE\Valve\Steam')) {
        try {
            $p = Get-ItemProperty -Path $key -ErrorAction Stop
            foreach ($name in @('SteamPath', 'InstallPath')) {
                $v = $p.$name
                if ($v) { $roots.Add(($v -replace '/', '\')) }
            }
        } catch { }
    }
    $roots.Add('C:\Program Files (x86)\Steam')
    $roots.Add('C:\Program Files\Steam')
    $libs = New-Object System.Collections.Generic.List[string]
    foreach ($r in ($roots | Select-Object -Unique)) {
        if (-not (Test-Path -LiteralPath $r)) { continue }
        $libs.Add($r)
        $vdf = Join-Path $r 'steamapps\libraryfolders.vdf'
        if (Test-Path -LiteralPath $vdf) {
            $text = [System.IO.File]::ReadAllText($vdf)
            foreach ($m in [regex]::Matches($text, '"path"\s+"([^"]+)"')) {
                $libs.Add(($m.Groups[1].Value -replace '\\\\', '\'))
            }
        }
    }
    return $libs | Select-Object -Unique
}

function Find-GameDir([string]$hint, [string]$packageRoot) {
    # 1) 직접 지정한 경로
    if (Test-GameDir $hint) { return $hint }
    # 2) 패치 폴더를 게임 폴더 안(또는 바로 옆)에 풀었을 때
    foreach ($c in @($packageRoot, (Split-Path -Parent $packageRoot))) {
        if (Test-GameDir $c) { return $c }
    }
    # 3) Steam 라이브러리 검색
    foreach ($lib in (Get-SteamLibraries)) {
        $c = Join-Path $lib ('steamapps\common\' + $Script:GameDirName)
        if (Test-GameDir $c) { return $c }
    }
    # 4) 직접 고르기
    Write-Warn2 '게임 폴더를 자동으로 찾지 못했습니다. 창에서 Vault of the Void 설치 폴더를 선택해 주세요.'
    try {
        Add-Type -AssemblyName System.Windows.Forms
        $dlg = New-Object System.Windows.Forms.FolderBrowserDialog
        $dlg.Description = 'Vault of the Void 설치 폴더(VaultoftheVoid.exe가 있는 폴더)를 선택하세요'
        if ($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
            if (Test-GameDir $dlg.SelectedPath) { return $dlg.SelectedPath }
            Write-Err '선택한 폴더에 VaultoftheVoid.exe가 없습니다.'
        }
    } catch {
        $typed = Read-Host '게임 폴더 경로를 직접 입력하세요'
        if (Test-GameDir $typed) { return $typed }
    }
    return $null
}

function Test-Writable([string]$dir) {
    $probe = Join-Path $dir ('.kr_write_test_' + [guid]::NewGuid().ToString('N'))
    try {
        [System.IO.File]::WriteAllText($probe, 'x')
        Remove-Item -LiteralPath $probe -Force
        return $true
    } catch { return $false }
}

function Request-Elevation([string]$scriptPath, [string]$gameDir) {
    Write-Warn2 '게임 폴더에 쓸 권한이 없어 관리자 권한으로 다시 실행합니다. (확인 창이 뜨면 "예")'
    $args2 = '-NoProfile -ExecutionPolicy Bypass -File "' + $scriptPath + '" -GameDir "' + $gameDir + '" -Elevated'
    Start-Process -FilePath 'powershell.exe' -ArgumentList $args2 -Verb RunAs
}

function Get-FileHashHex([string]$path) {
    if (-not (Test-Path -LiteralPath $path)) { return '' }
    return (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash
}

function Test-GameRunning {
    return [bool](Get-Process -Name 'VaultoftheVoid' -ErrorAction SilentlyContinue)
}

function Read-Utf8([string]$path) {
    return [System.IO.File]::ReadAllText($path, (New-Object System.Text.UTF8Encoding($false)))
}
function Write-Utf8NoBom([string]$path, [string]$text) {
    [System.IO.File]::WriteAllText($path, $text, (New-Object System.Text.UTF8Encoding($false)))
}

function Wait-Exit {
    Write-Host ''
    Read-Host '엔터 키를 누르면 창이 닫힙니다' | Out-Null
}
