#!/bin/bash
set -euo pipefail

# deny 応答の標準パターン
suggest_deny() {
    local reason="$1"
    jq -cn --arg reason "$reason" \
        '{
            "hookSpecificOutput": {
                "hookEventName": "PreToolUse",
                "permissionDecision": "deny",
                "permissionDecisionReason": $reason
            }
        }'
    exit 1
}

# 標準入力から JSON を解析
input=$(</dev/stdin)
command=$(jq -r '.tool_input.command // empty' <<< "$input")

# 空コマンドは無視
[[ -z "$command" ]] && exit 0

# 引用符以降を除外（コミットメッセージ内の誤検知回避）
command=${command%%[\'\"]*}

# --- ここに判定ロジックを記述 ---
# 例: 特定コマンドをブロック
# if [[ $command =~ some_pattern ]]; then
#     suggest_deny "Use alternative-command instead of some_pattern"
# fi

exit 0
