#!/usr/bin/env bash
# status-tag-check.sh: Claude Code Stop hook. Never blocks.
# If the last reply looks like finished work but has no STATUS line, log it to
# memory/status-misses.log so you can see how often claims go out without evidence.
ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
PAYLOAD=$(cat 2>/dev/null || true)
[ -z "$PAYLOAD" ] && exit 0
HOOK_PAYLOAD="$PAYLOAD" python3 - "$ROOT" <<'PY' 2>/dev/null
import json, os, re, sys, datetime
root = sys.argv[1]
try:
    data = json.loads(os.environ.get("HOOK_PAYLOAD") or "{}")
    path = data.get("transcript_path") or ""
    last = ""
    with open(path, encoding="utf-8") as f:
        for line in f:
            try:
                row = json.loads(line)
            except Exception:
                continue
            msg = row.get("message") or {}
            if row.get("type") == "assistant" and isinstance(msg.get("content"), list):
                text = "".join(p.get("text", "") for p in msg["content"] if p.get("type") == "text")
                if text.strip():
                    last = text
    claims = re.compile(r"\b(done|fixed|deployed|shipped|verified|passes|complete[d]?)\b", re.IGNORECASE)
    task_shaped = len(last) > 600 or bool(claims.search(last))
    if last and task_shaped and "STATUS:" not in last:
        os.makedirs(os.path.join(root, "memory"), exist_ok=True)
        with open(os.path.join(root, "memory", "status-misses.log"), "a", encoding="utf-8") as out:
            out.write(f"{datetime.datetime.now():%Y-%m-%d %H:%M} missing STATUS · {data.get('session_id', '-')} · {last.strip()[:120]!r}\n")
except Exception:
    pass
PY
exit 0
