# pre-commit

[![RogelioKG/pre-commit](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/pre-commit)


## References
+ 🪝 [**全 Hooks 查詢**](https://pre-commit.com/hooks.html)
+ 🔗 [**Python 開發：pre-commit 設定 Git Hooks 教學**](https://blog.kyomind.tw/pre-commit/)

## Note

|📘 <span class="note">NOTE</span>|
|:---|
|config 於 `.pre-commit-config.yaml`|

|🚨 <span class="caution">CAUTION</span>|
|:---|
|比如 uv-export 根據 `pyproject.toml` 和 `uv.lock` 來決定 `requirements.txt`。<br />而 pre-commit 就是檢查這些相依檔案是否有被 modified，來決定要不要跑自動流程。<br />所以請注意：手動刪除 `requirements.txt`，是不會在 commit 檢查時長回來的。<br />因為 `pyproject.toml` 和 `uv.lock` 沒有變！ |

## Config

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/astral-sh/uv-pre-commit
    rev: 0.6.5
    hooks:
      # 檢查 lockfile 是否為最新狀態
      - id: uv-lock
      # 自動翻新 requirements.txt
      - id: uv-export
        args: ["--no-hashes", "--frozen", "--format", "requirements-txt", "-o=requirements.txt"]
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.9.10
    hooks:
      # Linter 修正
      - id: ruff
        args: ["--fix"]
      # Formatter 修正
      - id: ruff-format
```

## Usage

+ `pre-commit install`
  將 pre-commit 設定到 `.git/hooks/pre-commit`，git commit 時自動執行 config 設定的流程 (hook)。

+ `pre-commit run`
  手動跑一次 config 裡的自動流程 (只有那些被 modified 的檔案才會被檢查)。\
  選項 `--all-files` 可以強制跑過所有自動流程 (無論有沒有 modified)。
