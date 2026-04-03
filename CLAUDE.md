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
- **エスケープハッチ**: 意図的バイパスの仕組みを用意（例: `:;` prefix）

## Design Decisions

- **エスケープハッチ**: hook でブロックされるコマンドを意図的に使いたい場合がある（例: git submodule）。`:;command` 形式でバイパスを許可する設計
- **Agent の model: sonnet**: コスト最適化のため。複雑な推論が必要な場面でも sonnet で十分なケースが多い
- **strict: false**: プラグインの hook がエラーを出しても Claude Code の動作を止めない

## Development

```bash
just validate       # プラグインの検証
just version        # バージョン表示
just bump-version   # バージョンバンプ（patch）
just push           # バージョン一致チェック + push
just push-without-bump  # ドキュメント更新のみの push
```

## Version Management

**重要**: 動作に影響するファイル変更時は必ず version を更新すること。
Claude Code はバージョン番号で更新判定するため、バージョンが変わらないと変更が反映されない。

更新先:
1. `.claude-plugin/plugin.json` の `version`
2. `.claude-plugin/marketplace.json` の `metadata.version`

両方のバージョンは一致させること。`just bump-version` で自動更新可能。

**例外**: README.md, CLAUDE.md 等のドキュメントのみの変更は version 更新不要。`just push-without-bump` を使う。

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

- 引用符以降を除外: `command=${command%%[\'\"]*}`（コミットメッセージ内の誤検知回避）
- 例外処理を明示的に記載
- `set -euo pipefail` を必ず設定
