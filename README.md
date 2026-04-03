# my-plugin

<!-- プラグインの説明 -->

## Install

```bash
claude plugin add kawaz/my-plugin
```

## Features

### Hook

PreToolUse で特定のコマンドをインターセプトします。

### Skill

`/my-plugin:my-skill` で基本操作のリファレンスを表示します。

### Agent

専門的な問題解決を行うエージェントを提供します。

## Development

```bash
just validate       # プラグインの検証
just version        # バージョン表示
just bump-version   # バージョンバンプ（patch）
just push           # バージョン一致チェック + push
```

## License

MIT
