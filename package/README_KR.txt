====================================================================
  Vault of the Void 한글 패치 v1.0
  (비공식 팬 번역 · 대상 게임 버전: Steam 2.8.9.0)
====================================================================

■ 설치 방법 (자동)
  1. 압축을 아무 곳에나 모두 풉니다. (압축 파일 안에서 바로 실행하지 마세요)
  2. 게임을 완전히 종료합니다.
  3. Install.bat 을 더블클릭합니다.
     - 게임 폴더를 자동으로 찾습니다. 못 찾으면 폴더 선택 창이 뜹니다.
       (VaultoftheVoid.exe 가 있는 폴더를 고르세요)
     - 권한이 필요하면 관리자 권한 확인 창이 뜹니다. "예"를 누르세요.
     - 원본 파일은 게임 폴더의 _KR_backup_original 폴더에 자동으로 백업됩니다.
  4. 게임을 실행하고 설정(Options) → 언어(Language)에서 "Korean" 을 선택합니다.
     (한국어로 바뀐 뒤에는 "한국어"로 표시됩니다)

  ※ Windows가 "PC 보호" 창을 띄우면 [추가 정보] → [실행]을 누르세요.
  ※ Install.bat 은 이 패치 폴더의 스크립트(scripts\install.ps1)만 실행합니다.
    인터넷에 접속하거나 다른 프로그램을 설치하지 않습니다.


■ 설치 방법 (수동) — 자동 설치가 안 될 때
  1. Steam 라이브러리 → Vault of the Void 우클릭 → 관리 → 로컬 파일 보기
  2. 열린 게임 폴더의 아래 파일들을 다른 곳에 백업해 둡니다.
       Locale\locale_ja.json
       spr_font_japanese.json
       spr_font_japanese_heading.json
       font_japanese_0.yytex
       font_japanese_1.yytex
  3. 이 패치의 patch 폴더 안 내용물(Locale 폴더 포함)을 게임 폴더에 덮어씁니다.
  4. 게임에서 언어를 "Japanese" 로 선택하면 한국어로 나옵니다.
     (수동 설치 때는 영어 화면의 언어 목록에 "Japanese"로 보입니다)


■ 제거 방법
  - Uninstall.bat 을 실행하면 백업해 둔 원본으로 되돌립니다.
  - 또는 Steam 라이브러리 → Vault of the Void 우클릭 → 속성 → 설치된 파일
    → "게임 파일의 무결성 검사"를 실행해도 완전히 원래대로 돌아갑니다.


■ 꼭 알아 두세요
  - 이 패치는 게임의 "일본어" 자리를 한국어로 바꾸는 방식입니다.
    패치를 설치하면 일본어는 쓸 수 없습니다. (다른 언어는 그대로)
  - 게임이 업데이트되거나 무결성 검사를 하면 패치가 풀립니다. 다시 설치해 주세요.
  - 대상 버전(2.8.9.0)과 다른 버전에서는 설치 프로그램이 경고를 띄웁니다.
    업데이트로 새 문장이 추가되면 그 부분은 한국어가 아닐 수 있습니다.
  - 세이브 파일은 건드리지 않습니다.


■ 번역 안내
  - 게임 안의 모든 문장(6,321줄)을 번역했습니다.
    카드·유물·몬스터·주문·이벤트·튜토리얼·메뉴 모두 포함합니다.
  - 주요 용어: Block 방어도 / Threat 위협 / Purge 소각 / Expel 추방 /
    Rage 분노 / Frenzy 연타 / AP 공격력 / Void Stone 공허석 / Artifact 유물 /
    Essence 정수 / Souls 영혼 / Corruption 타락 / Soultithe 영혼 십일조
  - 직업: 은신자 / 공허의 딸 / 깨달은 자 / 템페스트 / 직조자
  - 오역이나 어색한 문장, 칸을 넘치는 문장을 발견하면 스크린샷과 함께 알려 주세요.


■ 번역 수정 제안하기 (누구나 가능)
  - 함께 들어 있는 KR_translation_review.xlsx 에 게임 속 모든 문장(6,307줄)이
    영어 원문과 현재 번역으로 나란히 정리되어 있습니다.
  - 어색하거나 틀린 문장을 찾으면(Ctrl+F로 검색) 노란 '수정안' 칸에 고친 문장을,
    '메모' 칸에 이유를 적은 뒤 파일을 저장해서 패치 제작자에게 보내 주세요.
  - [k]…[/k] 같은 대괄호 표시와 #a, {name} 같은 기호는 그대로 두세요.
    자세한 규칙은 엑셀의 '안내' 시트에 있습니다. 용어 표기는 '용어집' 시트를 참고하세요.
  - 보내 주신 수정안은 규칙 검사를 거쳐 다음 버전에 반영됩니다.


■ 포함된 파일
  Install.bat / Uninstall.bat   설치·제거 실행 파일
  scripts\                      설치·제거 스크립트 (PowerShell)
  patch\                        한글 패치 파일
  README_KR.txt                 이 안내서
  KR_translation_review.xlsx    번역 검수·수정 제안용 엑셀
  LICENSE_Font_OFL.txt          한글 폰트 라이선스 (SIL OFL 1.1)

  파일 확인용 SHA-256
  36ab8cdefb5f0d3acd444ce9337a5d6e9f9db539cf8041355cb8e2184f0391b5  patch\Locale\locale_ja.json
  9170d9396c90940ffe0154e4332d3e93e5a39283a2252852189062320dc49855  patch\spr_font_japanese.json
  b664f179ae60a87f0019bd8b7424a27cd530aee117d335192ce3604ba99f68e5  patch\spr_font_japanese_heading.json
  e5bbf076b4343e0ee0433bd3df11f16241f3bbbe8a1f3e8b816d6ff380b814d5  patch\font_japanese_0.yytex
  72021e8f24e0096a61ce9019f2c0ed761b6e2d0542cd027ef6352c01ee5d409f  patch\font_japanese_1.yytex


■ 만든 사람 · 저작권
  - 한글 패치 제작: AOS (번역 작업에 Claude(Anthropic)의 도움을 받았습니다)
  - 한글 폰트: Noto Sans CJK KR © 2014-2021 Adobe — SIL Open Font License 1.1
    (LICENSE_Font_OFL.txt 참고)
  - Vault of the Void 및 게임 원문의 저작권은 Spider Nest Games에 있습니다.
    이 패치는 개발사와 관계없는 비공식 팬 번역이며, 무료로 배포합니다.
    판매하거나 유료로 배포하지 마세요.
  - 패치 사용으로 생기는 문제는 사용자 책임입니다. 설치 전 백업이 자동으로 만들어지며,
    언제든 Steam 무결성 검사로 원래대로 되돌릴 수 있습니다.


■ 변경 이력
  v1.0 (2026-09-29)  첫 배포 — 전체 번역, 한글 폰트(Noto Sans CJK KR)
