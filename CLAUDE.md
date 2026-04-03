# Claude Code Plugin: my-plugin

## Architecture (3-layer)

| Layer | Files | Role |
|-------|-------|------|
| Hook | hooks/hooks.json + *.sh | PreToolUse でコマンドをインターセプト |
| Skill | skills/*/SKILL.md | 基本操作リファレンス（frontmatter で定義） |
| Agent | agents/*.md | 高度な問題解決（model: sonnet でコスト最適化） |

## Design Principles

- **情報重複なし**: Hook は簡潔に拒否、詳細は Skill に委譲
- **層の分離**: Hook = ガード、Skill = 知識、Agent = 実行
- **エスケープハッチ**: 意図的バイパスの仕組みを用意

## Development

```bash
just validate   # プラグインの検証
just version    # バージョン表示
just push       # バージョン一致チェック + push
```

## Version Management

**重要**: ファイル変更時は必ず version を更新すること。
Claude Code はバージョン番号で更新判定するため、バージョンが変わらないと変更が反映されない。

更新先:
1. `.claude-plugin/plugin.json` の `version`
2. `.claude-plugin/marketplace.json` の `metadata.version`

両方のバージョンは一致させること。

## Hook Implementation

### deny 応答の標準パターン

```bash
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
```

### コマンド判定の注意点

- 引用符以降を除外: `command=${command%%[\'\"]*}`
- 例外処理を明示的に記載
- `set -euo pipefail` を必ず設定
