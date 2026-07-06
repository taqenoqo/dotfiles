# model-resolution defaults

`~/.config/ai/models.yaml` に現在の harness と requested tier の対応がない場合だけ、
このファイルの既定値を使う。

## copilot-cli

- `low`: `gpt-5-mini`
- `medium`: `gpt-5.4`
- `high`: `claude-opus-4.6`

## 返答形式

```text
Requested tier: <low|medium|high>
Recommended model: <model-name>
Source: defaults.md
```

## ルール

- requested tier は呼び出し元が決める。このファイルは tier 判定をしない。
- `AGENTS.md` や `CLAUDE.md` は探索しない。
- `models.yaml` の該当値がある場合は、必ずそちらを優先する。
