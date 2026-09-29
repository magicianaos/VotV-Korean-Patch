# -*- coding: utf-8 -*-
"""번역 파일 검사

사용법:
  python tools/check_translation.py translation/locale_ja.json [이전 버전 locale_ja.json]

검사 항목
  1) JSON 형식이 올바른지
  2) (이전 버전이 있으면) 키 구조가 그대로인지 - 키 추가·삭제·이름 변경 금지
  3) (이전 버전이 있으면) 바뀐 문장마다 태그 [..], 자리표시자(#a @a #d @d # $ {..} (c.N)), 숫자가 이전과 같은지
  4) 한자·가나 등 쓰면 안 되는 글자
  5) 폰트(translation/font_charset.txt)에 없는 새 글자 - 경고만 (반영할 때 폰트를 다시 만듦)

오류가 있으면 종료 코드 1. GitHub Actions에서는 결과를 PR 화면에 표시합니다.
"""
import collections
import json
import os
import re
import sys

TAG = re.compile(r"\[[^\[\]]*\]")
FORBIDDEN = re.compile(r"[぀-ヿ㐀-䶿一-鿿豈-﫿À-ɏ]")
GH = os.environ.get("GITHUB_ACTIONS") == "true"


def tags(s):
    return collections.Counter(TAG.findall(s))


def placeholders(s):
    s2 = TAG.sub(" ", s)
    toks = re.findall(r"[#@][A-Za-z]|\$|\{[^}]*\}|\(c\.\d+\)", s2)
    toks += re.findall(r"(?<![A-Za-z0-9_#@])#(?![A-Za-z0-9_])", s2)
    return collections.Counter(toks)


def numbers(s):
    s2 = TAG.sub(" ", re.sub(r"\(c\.\d+\)", "", s))
    return collections.Counter(re.findall(r"\d+(?:[.,]\d+)?%?", s2))


def walk(d, p=()):
    if isinstance(d, dict):
        for k, v in d.items():
            yield from walk(v, p + (str(k),))
    elif isinstance(d, list):
        for i, v in enumerate(d):
            yield from walk(v, p + (str(i),))
    else:
        yield "/".join(p), d


def load(path):
    with open(path, encoding="utf-8-sig") as f:
        text = f.read()
    return text, json.loads(text)


def line_of(text, key_path, value):
    """번역 파일에서 해당 문장이 있는 줄 번호 (PR 화면 표시용, 못 찾으면 0)"""
    last = key_path.split("/")[-1]
    needle = json.dumps(value, ensure_ascii=False)
    for i, line in enumerate(text.splitlines(), 1):
        if needle in line and (f'"{last}"' in line or last.isdigit()):
            return i
    return 0


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        return 2
    path = sys.argv[1]
    base_path = sys.argv[2] if len(sys.argv) > 2 else None
    errors, warnings = [], []

    def err(msg, line=0):
        errors.append((msg, line))

    def warn(msg, line=0):
        warnings.append((msg, line))

    try:
        text, new = load(path)
    except json.JSONDecodeError as e:
        err(f"JSON 형식 오류: {e.msg} (줄 {e.lineno}, 칸 {e.colno}). 쉼표·따옴표를 확인해 주세요.", e.lineno)
        return report(path, errors, warnings, 0)

    new_map = dict(walk(new))
    changed = 0

    if base_path and os.path.exists(base_path):
        _, base = load(base_path)
        base_map = dict(walk(base))
        added = sorted(set(new_map) - set(base_map))
        removed = sorted(set(base_map) - set(new_map))
        for k in added[:20]:
            err(f"새로 생긴 키: {k} — 키는 추가하지 말고 문장만 고쳐 주세요.")
        for k in removed[:20]:
            err(f"사라진 키: {k} — 키를 지우거나 이름을 바꾸지 마세요.")
        for k, v in new_map.items():
            old = base_map.get(k)
            if old is None or v == old:
                continue
            changed += 1
            if not isinstance(v, str) or not isinstance(old, str):
                err(f"{k}: 문장이 아닌 값이 바뀌었습니다.", line_of(text, k, v))
                continue
            ln = line_of(text, k, v)
            if tags(v) != tags(old):
                err(f"{k}: 대괄호 표시가 달라졌습니다. 빠짐 {dict(tags(old) - tags(v))} / 추가 {dict(tags(v) - tags(old))}", ln)
            if placeholders(v) != placeholders(old):
                err(f"{k}: 기호(#a, {{name}} 등)가 달라졌습니다. 빠짐 {dict(placeholders(old) - placeholders(v))} / 추가 {dict(placeholders(v) - placeholders(old))}", ln)
            if numbers(old) - numbers(v):
                err(f"{k}: 숫자가 빠졌습니다 {dict(numbers(old) - numbers(v))}", ln)
            if not v.strip() and old.strip():
                err(f"{k}: 문장이 비었습니다.", ln)

    here = os.path.dirname(os.path.abspath(__file__))
    cs_path = os.path.join(here, "..", "translation", "font_charset.txt")
    charset = set()
    if os.path.exists(cs_path):
        with open(cs_path, encoding="utf-8") as f:
            charset = set(f.read()) | {"\n", "\r", "\t"}
    values = "".join(v for v in new_map.values() if isinstance(v, str))
    # 폰트에 이미 있는 기호(× 등)는 허용, 폰트에 없는 한자·가나·악센트 문자만 오류
    bad = sorted({c for c in values if FORBIDDEN.search(c) and c not in charset})
    if bad:
        err(f"쓰면 안 되는 글자(한자·가나·악센트 문자): {' '.join(bad)}")
    if charset:
        newchars = sorted({c for c in values if c not in charset} - set(bad))
        if newchars:
            warn(f"폰트에 없는 새 글자 {len(newchars)}개: {''.join(newchars)} — 괜찮습니다. 반영할 때 폰트를 다시 만듭니다.")

    return report(path, errors, warnings, changed)


def report(path, errors, warnings, changed):
    summary = [f"## 번역 검사 결과", "",
               f"- 바뀐 문장: {changed}줄",
               f"- 오류: {len(errors)}건",
               f"- 경고: {len(warnings)}건", ""]
    for msg, line in errors:
        if GH:
            print(f"::error file={path},line={line or 1}::{msg}")
        print("[오류] " + msg)
        summary.append(f"- 오류: {msg}")
    for msg, line in warnings:
        if GH:
            print(f"::warning file={path}::{msg}")
        print("[경고] " + msg)
        summary.append(f"- 경고: {msg}")
    if not errors:
        print(f"통과 — 바뀐 문장 {changed}줄, 경고 {len(warnings)}건")
        summary.append("통과했습니다.")
    step = os.environ.get("GITHUB_STEP_SUMMARY")
    if step:
        with open(step, "a", encoding="utf-8") as f:
            f.write("\n".join(summary) + "\n")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
