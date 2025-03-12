# uv

[![RogelioKG/uv](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/uv)

## References
+ 📑 [**Documentation - uv**](https://docs.astral.sh/uv/)
+ 🔗 [**使用 uv 管理 Python 環境**](https://dev.to/codemee/shi-yong-uv-guan-li-python-huan-jing-53hg)
+ 🎬 [**ArjanCodes - UV for Python… (Almost) All Batteries Included**](https://youtu.be/qh98qOND6MI)

## Installation
+ Windows
  ```bash
  scoop install main/uv 
  ```

## Advantages

我們的 🐍 Python 終於也有了一個像樣的 package manger。

+ ✅ 良好的依賴解析

  刪除套件時，是真的會找出沒用到的依賴套件並刪除 (確保無 redundancy)

+ ✅ 不只是依賴管理工具
  
  集成非常多 out of the box 的工具 📦
  + multi version python
  + dependency management (install, uninstall, lockfile...)
  + virtual env
  + build & publish packages

+ ✅ 相較於 pip 快<mark>數十倍</mark>的速度

  上個廁所褲子都還沒拉下來，uv 就已經以趕火車的速度，完成 dependency resolution 並 install。\
  因為它是由 Rust 編寫而成的。詳細比對請見 [benchmark](https://github.com/astral-sh/uv/blob/main/BENCHMARKS.md)。

## Note

|📘 <span class="note">NOTE</span>|
|:---|
|此 package manager 仍在開發狀態，此筆記紀錄的是 version `0.6.5` 的功能|

|📘 <span class="note">NOTE</span>|
|:---|
|此 package manager 的 lockfile 叫 `uv.lock`|

|🚨 <span class="caution">CAUTION</span>|
|:---|
|uv 目前還沒有自己的 build backend (他們是用現有的三方庫 `hatchling`)|

|🚨 <span class="caution">CAUTION</span>|
|:---|
|uv 目前還不支援 scripts (我愛 `npm scripts`)|

## Usage

請參考 [UV CLI](https://docs.astral.sh/uv/reference/cli/#uv)。

### `init` 創建專案

  + `--app`
    + 目錄架構
      ```
      project_app/
      ├── .gitignore
      ├── .python-version
      ├── main.py
      ├── pyproject.toml
      └── README.md
      ```
    + `app` 通常是一些應用程式，比如 web app 或 api endpoints 等等
    + 通常不作為套件發布

  + `--lib`
    + 目錄架構
      ```
      project_lib/
      ├── .gitignore
      ├── .python-version
      ├── pyproject.toml
      ├── README.md
      └── src/
          └── project_lib/
              ├── py.typed
              └── __init__.py
      ```
    + `lib` 類型通常是一些函式庫
    + 可作為套件發布
    + 使用 `uv sync` 時，會順便在 developer 本地 venv 安裝一次，可一邊開發一邊實驗功能
    + user 實際安裝時
      + 只有 `src/project_lib/` 目錄與其內容，會被放入 user 的 `.venv/Lib/site-packages/`

  + `--package`
    + 目錄架構
      ```
      project_package/
      ├── .gitignore
      ├── .python-version
      ├── pyproject.toml
      ├── README.md
      └── src/
          └── project_package/
              └── __init__.py
      ```
    + `package` 類型通常是一些好用的 CLI 工具
    + 可作為套件發布
    + 使用 `uv sync` 時，會順便在 developer 本地 venv 安裝一次，可一邊開發一邊實驗功能
    + user 實際安裝時
      + 只有 `src/project_package/` 目錄與其內容，會被放入 user 的 `.venv/Lib/site-packages/`
      + 會在 `.venv/Scripts/` 生成執行檔，供 user 調用 (記得他得先進入 venv 才能用)
    + 入口點 (developer 應以這樣的架構去開發)
      ```toml
      # pyproject.toml
      [project.scripts]
      rogeliokg-cli = "rogeliokg_cli.cli:cli"
      ```
      ```
      rogeliokg-cli/
      ├── ...
      └── src/
          └── rogeliokg_cli/
              ├── __init__.py
              ├── cli.py
              └── commands/
                  └── ...
      ```
      ```py
      # src/rogeliokg_cli/cli.py
      import click
      from rogeliokg_cli.commands.hello import hello
      from rogeliokg_cli.commands.config import config
      from rogeliokg_cli.commands.math import math

      @click.group()
      def cli():
          """這是一個模擬真實應用的命令列工具"""
          pass

      # 註冊子命令
      cli.add_command(hello)
      cli.add_command(config)
      cli.add_command(math)

      if __name__ == "__main__":
          cli()
      ```

+ `--no-workspace`
  在上層專案內創建的專案，不與上層專案共享依賴 (通常用於 monorepo)
  ```
  uv init --no-workspace yet_another_project
  ```


### `run` 執行腳本
  
  ```
  uv run main.py
  ```

### `venv` 虛擬環境

  + 創建虛擬環境 (預設目錄名 `.venv`)

    ```
    uv venv
    ```

  + `--python` 指定虛擬環境 Python 版本

    |🚨 <span class="caution">CAUTION</span>|
    |:---|
    |由於 `uv sync` 是根據 `.python-version` 和 `pyproject.toml` 內的 `requires-python` 決定 Python 版本，若使用 `uv venv` 切換虛擬環境的 Python 版本，記得要先<mark>手動更改這兩塊地方</mark>。 |

    可靈活切換虛擬環境 Python 版本，但要重新下載相依套件

    ```
    uv venv --python 3.11.4
    ```

### `add` / `remove` 安裝 / 移除套件

  uv 如 poetry 或 pnpm 一樣，會自動解析並順便移除沒用到的相依套件。並且有 lockfile 嚴格管理套件版本。

### `sync` 同步套件

  <mark>安裝全部套件的加強版</mark>。\
  假如發生一些意外，導致你的 venv 缺了某些套件，或者 lockfile 不小心掉入垃圾桶，都可以用這個同步重新長回來。

### `tool` 工具

  工具是一種提供 CLI 的執行檔或 Python 套件。\
  工具會被獨立安裝在特別的環境 (非專案內的 venv)，以避免受相依套件影響。

  + `run` 功能類似 `npx` (更簡短的寫法是 `uvx`)
    ```
    uv tool run ruff check
    ```

  + `install` / `uninstall` 安裝 / 移除工具
    ```
    uv tool install ruff
    ```

  + `dir` 工具被安裝在哪個目錄
    ```
    uv tool dir
    ```

### `python` 多版本

  + `list` 列出
    ```
    uv python list
    ```

  + `install` / `uninstall` 安裝 / 移除
    ```
    uv python install 3.12.0
    ```

### `export` 輸出 lockfile

  + 輸出為 `requirements.txt`
    ```
    uv export --no-hashes --frozen --format requirements-txt -o=requirements.txt
    ```

### `build` / `publish` 構建 / 發布套件

  `uv build` + `uv publish`，就這麼簡單。唯 publish 時須注意兩點：
  1. 發布到不同套件源 (比如 testpypi)
      > 下指令時要指定套件源 `--index testpypi` (要先在 [`pyproject.toml` 設定](#--index-套件源))。
  2. 會問你 username 和 password，但現已改成使用 API token 登入
      > 因此 username 你要輸入 `__token__`，password 再輸入 API token 即可。

### `cache` 快取

  uv 為了避免重複的下載，所以採取激進的快取策略。\
  這會導致快取很容易變胖。

  + `clean` | `prune`

    這兩兄弟用法也是和 pnpm 很像，前者是移除所有快取，後者是指移除沒用到的快取。

### `self` 針對 uv 自身的功能

  + `update` 自行更新

### `lock` 手動生成 lockfile
  ...

### `tree` 依賴樹
  ...

### `pip` pip 相容介面
  ...

### `--index` 套件源

  可在 `pyproject.toml` 定義不同套件源，下指令時就可以加上 `--index` name 選擇。
  ```toml
  # pyproject.toml
  [[tool.uv.index]]
  name = "pypi"
  url = "https://pypi.org/simple/"
  publish-url = "https://upload.pypi.org/legacy/"

  [[tool.uv.index]]
  name = "testpypi"
  url = "https://test.pypi.org/simple/"
  publish-url = "https://test.pypi.org/legacy/"
  ```

  指定某個套件一定要從這個套件源下載
  ```toml
  [project]
  dependencies = ["torch"]

  [tool.uv.sources]
  torch = [
    { index = "pytorch-cu118", marker = "sys_platform == 'darwin'"},
    { index = "pytorch-cu124", marker = "sys_platform != 'darwin'"},
  ]

  [[tool.uv.index]]
  name = "pytorch-cu118"
  url = "https://download.pytorch.org/whl/cu118"

  [[tool.uv.index]]
  name = "pytorch-cu124"
  url = "https://download.pytorch.org/whl/cu124"
  ```

## Others

+ Linter / Formatter 功能請參考：[ruff](https://hackmd.io/@RogelioKG/ruff)
+ Precommit 功能請參考：[pre-commit](https://hackmd.io/@RogelioKG/pre-commit)