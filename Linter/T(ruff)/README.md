# ruff

[![RogelioKG/ruff](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/ruff)

## Brief
定位如 ESLint，集 Linter、Formatter 於一身。

## References
+ 🔗 [**Python 開發：Ruff Linter、Formatter 介紹 + 設定教學**](https://blog.kyomind.tw/ruff/)

## Settings

+ `.vscode/settings.json`
  ```json
  {
    "[python]": {
      "editor.formatOnSave": true,
      "editor.codeActionsOnSave": {
        "source.fixAll": "always",
        "source.organizeImports": "always"
      },
      "editor.defaultFormatter": "charliermarsh.ruff"
    },
    "python.analysis.autoImportCompletions": false,
    "python.analysis.typeCheckingMode": "basic"
  }
  ```

+ `pyproject.toml`
  ```toml
  [tool.ruff]
  line-length = 100  # 依照自己的專案需求設定

  [tool.ruff.lint]
  select = ["E", "F", "I"]  # 至少會加入 I，因為 isort 是必要的

  [tool.ruff.format]
  quote-style = "double"  # 依照自己的喜好或專案需求設定
  ```