param(
    [string]$GameDir = '',
    [switch]$Elevated,
    [switch]$NoPause,
    [switch]$Force
)
# Vault of the Void 한글 패치 설치 (Windows PowerShell 5.1 호환)
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $here 'common.ps1')
$packageRoot = Split-Path -Parent $here
$patchDir = Join-Path $packageRoot 'patch'

Write-Host ''
Write-Host '=== Vault of the Void 한글 패치 설치 ===' -ForegroundColor Cyan
Write-Host ''

try {
    # 0) 패치 파일 확인
    foreach ($rel in $Script:PatchFiles) {
        if (-not (Test-Path -LiteralPath (Join-Path $patchDir $rel))) {
            throw ('패치 파일이 없습니다: patch\' + $rel + ' (압축을 전부 푼 뒤 실행해 주세요)')
        }
    }

    # 1) 게임 폴더 찾기
    $game = Find-GameDir $GameDir $packageRoot
    if (-not $game) { throw '게임 폴더를 찾지 못했습니다. README_KR.txt의 "수동 설치"를 참고해 주세요.' }
    Write-Step ('게임 폴더: ' + $game)

    # 2) 게임 실행 중인지
    while (Test-GameRunning) {
        Write-Warn2 '게임이 실행 중입니다. 게임을 완전히 종료한 뒤 엔터 키를 눌러 주세요.'
        Read-Host | Out-Null
    }

    # 3) 게임 버전 확인
    $dataWin = Join-Path $game 'data.win'
    if (Test-Path -LiteralPath $dataWin) {
        $size = (Get-Item -LiteralPath $dataWin).Length
        if ($size -ne $Script:KnownDataWin -and -not $Force) {
            Write-Warn2 '이 패치를 만든 게임 버전(2.8.9.0)과 설치된 게임 버전이 다를 수 있습니다.'
            Write-Warn2 '게임이 업데이트되면 글자가 깨지거나 일부 문장이 영어로 나올 수 있습니다.'
            $ans = Read-Host '그래도 설치하시겠습니까? (Y/N)'
            if ($ans -notmatch '^[yYㅛ]') { throw '설치를 취소했습니다.' }
        }
    }

    # 4) 쓰기 권한
    if (-not (Test-Writable $game)) {
        if ($Elevated) { throw '관리자 권한으로도 게임 폴더에 쓸 수 없습니다.' }
        Request-Elevation $MyInvocation.MyCommand.Path $game
        return
    }

    # 5) 원본 백업 (현재 파일이 원본일 때만 백업을 새로 갱신)
    $bk = Join-Path $game $Script:BackupDir
    New-Item -ItemType Directory -Force -Path (Join-Path $bk 'Locale') | Out-Null
    $backedUp = 0
    foreach ($rel in $Script:PatchFiles) {
        $cur = Join-Path $game $rel
        if (-not (Test-Path -LiteralPath $cur)) { continue }
        $isPatched = (Get-FileHashHex $cur) -eq (Get-FileHashHex (Join-Path $patchDir $rel))
        if (-not $isPatched) {
            Copy-Item -LiteralPath $cur -Destination (Join-Path $bk $rel) -Force
            $backedUp++
        }
    }
    $en = Join-Path $game $Script:EnLocale
    if (Test-Path -LiteralPath $en) {
        $enText = Read-Utf8 $en
        if ($enText -notmatch '"ja"\s*:\s*"Korean"') {
            Copy-Item -LiteralPath $en -Destination (Join-Path $bk $Script:EnLocale) -Force
            $backedUp++
        }
    }
    Write-Ok ('원본 백업: ' + $backedUp + '개 파일 → ' + $Script:BackupDir)

    # 6) 패치 파일 복사
    foreach ($rel in $Script:PatchFiles) {
        $dst = Join-Path $game $rel
        Copy-Item -LiteralPath (Join-Path $patchDir $rel) -Destination $dst -Force
        if ((Get-FileHashHex $dst) -ne (Get-FileHashHex (Join-Path $patchDir $rel))) {
            throw ('복사 확인 실패: ' + $rel)
        }
    }
    Write-Ok ('패치 파일 ' + $Script:PatchFiles.Count + '개 설치')

    # 7) 영어 화면의 언어 목록에서 Japanese → Korean 표시
    if (Test-Path -LiteralPath $en) {
        $enText = Read-Utf8 $en
        $newText = [regex]::Replace($enText, '"ja"(\s*):(\s*)"Japanese"', '"ja"$1:$2"Korean"')
        if ($newText -ne $enText) { Write-Utf8NoBom $en $newText }
        Write-Ok '언어 목록 표시 변경 (Japanese → Korean)'
    }

    Write-Host ''
    Write-Host '설치가 끝났습니다!' -ForegroundColor Green
    Write-Host '게임을 실행한 뒤 설정(Options) → 언어(Language)에서 "Korean"을 선택하세요.'
    Write-Host '(한국어 화면에서는 "한국어"로 표시됩니다. 일본어 자리를 한국어로 바꾸는 방식입니다.)'
    Write-Host '게임이 업데이트되거나 Steam에서 "파일 무결성 검사"를 하면 패치가 풀리니, 그때는 다시 설치해 주세요.'
}
catch {
    Write-Host ''
    Write-Err $_.Exception.Message
}
finally {
    if (-not $NoPause) { Wait-Exit }
}
