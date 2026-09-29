# Vault of the Void 한글 패치

덱빌딩 로그라이크 [Vault of the Void](https://store.steampowered.com/app/1135810/Vault_of_the_Void/)(Spider Nest Games)의 비공식 한글 패치입니다.
카드·유물·몬스터·주문·이벤트·튜토리얼·메뉴까지 게임 안의 모든 문장(6,321줄)을 번역했습니다.

- 대상 버전: Steam **2.8.9.0**
- 폰트: Noto Sans CJK KR (본문 Medium, 제목 Bold)
- 방식: 게임의 "일본어" 자리를 한국어로 바꿉니다. 다른 언어는 그대로입니다.

### [최신 버전 내려받기 (Releases)](../../releases/latest)

> 초록색 **Code → Download ZIP** 으로 받은 파일에는 폰트가 없어서 설치되지 않습니다.
> 꼭 **Releases**에서 `VotV_Korean_Patch_v*.zip` 파일을 받아 주세요.

<!-- 스크린샷: docs/images/ 에 이미지를 넣고 아래 줄의 주석을 풀어 주세요.
<p align="center">
  <img src="docs/images/menu.png" width="49%"> <img src="docs/images/battle.png" width="49%">
</p>
-->

## 설치

1. [Releases](../../releases/latest)에서 `VotV_Korean_Patch_v*.zip`을 받아 **압축을 모두 풉니다.**
2. 게임을 완전히 종료합니다.
3. `Install.bat`을 더블클릭합니다.
   - Steam 라이브러리에서 게임 폴더를 자동으로 찾습니다. 못 찾으면 폴더 선택 창이 뜹니다.
   - 권한이 필요하면 관리자 권한 확인 창이 뜹니다. "예"를 누르세요.
   - 원본 파일은 게임 폴더의 `_KR_backup_original`에 자동으로 백업됩니다.
4. 게임에서 **Options → Language → Korean**을 고릅니다.

Windows가 "PC 보호" 창을 띄우면 **추가 정보 → 실행**을 누르세요.
`Install.bat`은 같은 폴더의 PowerShell 스크립트(`scripts\install.ps1`)만 실행하며, 인터넷에 접속하지 않습니다. 스크립트 내용은 이 저장소의 [`package/scripts`](package/scripts)에서 볼 수 있습니다.

자동 설치가 안 되면 압축 파일 안의 `README_KR.txt`에 있는 **수동 설치** 방법을 따라 주세요.

## 제거

- `Uninstall.bat`을 실행하면 백업해 둔 원본으로 되돌립니다.
- 또는 Steam에서 **속성 → 설치된 파일 → 게임 파일의 무결성 검사**를 실행해도 완전히 원래대로 돌아갑니다.

## 꼭 알아 두세요

- 패치를 설치하면 일본어는 쓸 수 없습니다.
- 게임이 업데이트되거나 무결성 검사를 하면 패치가 풀립니다. 다시 설치해 주세요.
- 대상 버전과 다른 버전에서는 설치 프로그램이 경고를 띄웁니다. 업데이트로 추가된 문장은 한국어가 아닐 수 있습니다.
- 세이브 파일은 건드리지 않습니다.

## 번역 수정 제안하기

오역, 어색한 문장, 칸을 넘치는 문장을 발견하면 편한 방법으로 알려 주세요.

| 방법 | 이런 분께 |
|---|---|
| [이슈 양식으로 제안](../../issues/new/choose) | 한두 문장만 고치고 싶을 때. 스크린샷을 붙이면 더 좋습니다. |
| 검수 엑셀 (`KR_translation_review.xlsx`) | 많이 고치고 싶을 때. Releases나 패치 압축 파일 안에 있습니다. 노란 '수정안' 칸을 채워서 이슈에 첨부해 주세요. |
| Pull Request | GitHub에 익숙한 분. [`translation/locale_ja.json`](translation/locale_ja.json)을 직접 고쳐 주세요. |

용어 표기는 [용어집](translation/GLOSSARY.md)을, 자세한 규칙은 [CONTRIBUTING.md](CONTRIBUTING.md)를 참고해 주세요.

## 저장소 구성

| 경로 | 내용 |
|---|---|
| `translation/locale_ja.json` | 번역문 (게임의 일본어 자리에 들어가는 파일) |
| `translation/GLOSSARY.md` | 용어집 (`glossary.json`은 같은 내용의 데이터) |
| `translation/font_charset.txt` | 현재 한글 폰트에 들어 있는 글자 목록 |
| `package/` | 설치·제거 스크립트와 안내서 (배포 압축 파일 구성) |
| `tools/check_translation.py` | 번역 파일 자동 검사 (PR마다 GitHub Actions로 실행) |

폰트 파일(`.yytex`, 폰트 `.json`)은 용량이 커서 저장소에는 넣지 않고 Releases의 압축 파일에만 넣습니다.

## 만든 사람 · 라이선스

- 한글 패치 제작: **AOS** (번역 작업에 Claude(Anthropic)의 도움을 받았습니다)
- 한글 폰트: Noto Sans CJK KR © 2014-2021 Adobe, [SIL Open Font License 1.1](package/LICENSE_Font_OFL.txt)
- Vault of the Void와 게임 원문의 저작권은 Spider Nest Games에 있습니다. 이 패치는 개발사와 관계없는 비공식 팬 번역이며 무료로 배포합니다.
- 자세한 내용은 [LICENSE.md](LICENSE.md)를 참고해 주세요.
