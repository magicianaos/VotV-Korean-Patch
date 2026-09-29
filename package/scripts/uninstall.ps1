param(
    [string]$GameDir = '',
    [switch]$Elevated,
    [switch]$NoPause
)
# Vault of the Void 한글 패치 제거 (Windows PowerShell 5.1 호환)
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $here 'common.ps1')
$packageRoot = Split-Path -Parent $here

Write-Host ''
Write-Host '=== Vault of the Void 한글 패치 제거 ===' -ForegroundColor Cyan
Write-Host ''

try {
    $game = Find-GameDir $GameDir $packageRoot
    if (-not $game) { throw '게임 폴더를 찾지 못했습니다. Steam에서 "게임 파일 무결성 검사"로 원래대로 되돌릴 수 있습니다.' }
    Write-Step ('게임 폴더: ' + $game)

    while (Test-GameRunning) {
        Write-Warn2 '게임이 실행 중입니다. 게임을 완전히 종료한 뒤 엔터 키를 눌러 주세요.'
        Read-Host | Out-Null
    }

    if (-not (Test-Writable $game)) {
        if ($Elevated) { throw '관리자 권한으로도 게임 폴더에 쓸 수 없습니다.' }
        Request-Elevation $MyInvocation.MyCommand.Path $game
        return
    }

    $bk = Join-Path $game $Script:BackupDir
    $restored = 0; $missing = @()
    foreach ($rel in ($Script:PatchFiles + @($Script:EnLocale))) {
        $src = Join-Path $bk $rel
        if (Test-Path -LiteralPath $src) {
            Copy-Item -LiteralPath $src -Destination (Join-Path $game $rel) -Force
            $restored++
        } else {
            $missing += $rel
        }
    }
    # 백업이 없어도 영어 언어 목록 표시는 되돌림
    $en = Join-Path $game $Script:EnLocale
    if (Test-Path -LiteralPath $en) {
        $t = Read-Utf8 $en
        $t2 = [regex]::Replace($t, '"ja"(\s*):(\s*)"Korean"', '"ja"$1:$2"Japanese"')
        if ($t2 -ne $t) { Write-Utf8NoBom $en $t2 }
    }
    Write-Ok ('원본 복구: ' + $restored + '개 파일')
    if ($missing.Count -gt 0) {
        Write-Warn2 ('백업이 없어 복구하지 못한 파일: ' + ($missing -join ', '))
        Write-Warn2 'Steam 라이브러리 → Vault of the Void 우클릭 → 속성 → 설치된 파일 → "게임 파일 무결성 검사"를 실행하면 완전히 원래대로 돌아갑니다.'
    }
    Write-Host ''
    Write-Host '제거가 끝났습니다. 백업 폴더(_KR_backup_original)는 지워도 됩니다.' -ForegroundColor Green
}
catch {
    Write-Host ''
    Write-Err $_.Exception.Message
}
finally {
    if (-not $NoPause) { Wait-Exit }
}
