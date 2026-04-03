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

# --- 判定ロジックの例 ---

# 例1: シンプルな prefix 判定
# if [[ $command == dangerous-command\ * ]]; then
#     suggest_deny "dangerous-command は使用禁止です。safe-command を使ってください。"
# fi

# 例2: 正規表現 + コマンドセパレータ対応
# CMD_PREFIX='(^|[|&;({][[:space:]]*)'
# if [[ $command =~ ${CMD_PREFIX}npm([[:space:]]|$) ]]; then
#     # 例外: npm version, npm publish は許可
#     if [[ $command =~ ${CMD_PREFIX}npm\ (version|publish) ]]; then
#         exit 0
#     fi
#     suggest_deny "npm ではなく bun を使ってください。"
# fi

# 例3: エスケープハッチ（:; prefix で意図的バイパス）
# if [[ "$command" == ":;"* ]]; then
#     exit 0  # バイパス許可
# fi

exit 0
