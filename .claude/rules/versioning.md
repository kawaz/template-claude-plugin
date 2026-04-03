# バージョン管理ルール

## いつ version を上げるか

- hook スクリプトの変更 → **必須**
- skill の内容変更 → **必須**
- agent の定義変更 → **必須**
- plugin.json / marketplace.json のメタデータ変更 → **必須**
- README.md / CLAUDE.md のみの変更 → **不要**（`just push-without-bump` を使う）

## 更新方法

```bash
just bump-version          # patch bump (0.1.0 → 0.1.1)
just bump-version minor    # minor bump (0.1.0 → 0.2.0)
just bump-version major    # major bump (0.1.0 → 1.0.0)
```

plugin.json と marketplace.json の version は一致させること。`just push` で自動チェックされる。
