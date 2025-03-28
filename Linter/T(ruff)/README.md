# ruff

[![RogelioKG/ruff](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/ruff)

## Brief
定位如 ESLint，集 Linter、Formatter 於一身。

## References
+ 🔗 [**Python 開發：Ruff Linter、Formatter 介紹 + 設定教學**](https://blog.kyomind.tw/ruff/)

## Config

+ `.vscode/settings.json`
  ```json
  {
    "[python]": {
      "editor.formatOnSave": true,
      "editor.codeActionsOnSave": {
        "source.fixAll.ruff": "explicit",
        "source.organizeImports": "explicit"
      },
      "editor.defaultFormatter": "charliermarsh.ruff"
    },
    "python.analysis.autoImportCompletions": false,
    "python.analysis.typeCheckingMode": "strict"
  }
  ```

+ `pyproject.toml`
  ```toml
  [tool.ruff]
  line-length = 100

  [tool.ruff.lint]
  select = [
      "E",  # pycodestyle errors (與 PEP 8 標準不符的錯誤)
      "W",  # pycodestyle warnings (與 PEP 8 標準不符的警告)
      "F",  # pyflakes (檢查未使用的變數或模組等)
      "I",  # isort (排序模組)
      "C",  # flake8-comprehensions (簡潔表達式)
      "B",  # flake8-bugbear (可揪出 mutable default arguments 等 BUG)
      "UP",  # pyupgrade (舊語法升級)
  ]

  [tool.ruff.format]
  quote-style = "double"
  ```

## Usage

### `check` Linter 檢查

  > `--fix` Linter 修正

  ```
  ruff check                          # Lint all files in the current directory (and any subdirectories).
  ruff check path/to/code/            # Lint all files in `/path/to/code` (and any subdirectories).
  ruff check path/to/code/*.py        # Lint all `.py` files in `/path/to/code`.
  ruff check path/to/code/to/file.py  # Lint `file.py`.
  ruff check @arguments.txt           # Lint using an input file, treating its contents as newline-delimited command-line arguments.
  ```

### `format` Formatter 修正
  
  > `--check` Formatter 檢查