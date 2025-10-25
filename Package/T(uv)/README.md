# uv

[![RogelioKG/uv](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/uv)

## References
+ 📑 [**Documentation - uv**](https://docs.astral.sh/uv/)
+ 🔗 [**使用 uv 管理 Python 環境**](https://dev.to/codemee/shi-yong-uv-guan-li-python-huan-jing-53hg)
+ 🎬 [**ArjanCodes - UV for Python… (Almost) All Batteries Included**](https://youtu.be/qh98qOND6MI)

## Installation
+ Windows
  ```bash
  scoop install uv 
  ```

## Advantages

🐍 Python 終於也有了一個上得了檯面的 package manger。

### ✅ 良好的依賴解析

  刪除套件時，是真的會找出沒用到的依賴套件並刪除 (確保無 redundancy)

### ✅ 不只是依賴管理工具
  
  集成非常多 out of the box 的工具 📦
  + multiversion python
  + dependency management (install, uninstall, lockfile...)
  + virtual env
  + build & publish packages

### ✅ 相較於 pip 快<mark>數十倍</mark>的速度

  你以為 package manager 安裝套件的耗時，就是讓你去泡咖啡偷懶的時間嗎？\
  噢不我的朋友🤔，當你拿著你的杯子，準備離開電腦桌的時候，\
  uv 就已經以趕火車的速度，完成 dependency resolution 並 install 完畢。\
  想見識這個驚掉下巴的速度，詳見 [benchmark](https://github.com/astral-sh/uv/blob/main/BENCHMARKS.md)。

## Note

|☢️ <span class="warning">WARNING</span>|
|:---|
|此 package manager 仍在開發狀態！<br>此筆記紀錄的是 <mark>`0.9.4`</mark> (2025/10/19) 的功能|

|📘 <span class="note">NOTE</span>|
|:---|
|此 package manager 的 <mark>lockfile 為 `uv.lock`</mark>|
|[PEP 751](https://peps.python.org/pep-0751/) (2024/7/26) 終於正式要求了 Python 的標準 lockfile 為 `pylock.toml`，<br>這個小傢伙應該還需要一點時間，來發展成廣泛使用的 lockfile。 |

|📘 <span class="note">NOTE</span>|
|:---|
|uv 預設使用 hardlink 安裝 (連結到 local cache)|

|📘 <span class="note">NOTE</span>|
|:---|
|uv 擁有自己的 [build backend](https://hackmd.io/@RogelioKG/setuptools)：`uv-build`|


## Commands

詳見 [UV CLI](https://docs.astral.sh/uv/reference/cli/#uv)。

### `init`：創建專案

  + `--python` 指定 Python 版本

  + `--script`
    + 用於構建一個簡單<mark>腳本</mark>
    + 腳本的所有依賴直接寫在 dependencies
      ```py
      # /// script
      # requires-python = ">=3.13"
      # dependencies = ["httpx"]
      # ///


      import httpx


      def main():
          with httpx.Client() as client:
              response = client.get("https://fakestoreapi.com/products/1")
              print("Status Code:", response.status_code)
              print("Response JSON:", response.json())


      if __name__ == "__main__":
          main()
      ```
    + 執行時，自動安裝所有依賴 (若有快取，會自動使用)
      ```
      uv run main.py
      ```
    + 未在 dependencies 指定的依賴，可外加 `--with` 選項新增依賴
      > 假設你想換成某個版本的 httpx
      ```
      uv run --with httpx==0.27.0 main.py
      ```

  + `--app`
    + 用於構建一個<mark>應用程式</mark>，通常不作為套件發布
    + 目錄架構
      ```
      project_app/
      ├── .gitignore
      ├── .python-version
      ├── main.py
      ├── pyproject.toml
      └── README.md
      ```

  + `--lib`
    + 用於構建一個<mark>函式庫</mark>，可作為套件發布
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
    + `pyproject.toml`（build 相關資訊儲存於此）
      ```toml
      [project]
      ...

      [build-system]
      requires = ["uv_build>=0.9.3,<0.10.0"]
      build-backend = "uv_build"
      ```
    + `uv sync` 測試安裝
      + 在專案內「安裝」你寫的這個套件，你可以一邊開發、一邊測試功能（就如同 `pip install -e .`）
      + 原理：把 `src/` 目錄加入 `sys.path`
    + user 實際安裝
      + 只有 `src/` 目錄中的內容，會被放入 `.venv/Lib/site-packages/` 目錄
    + 命名空間套件 namespace package
      + ...
      + 一個沒有 __init__.py 檔案的命名空間目錄，多個下載的套件都被放到此處 

  + `--package`
    + 用於構建一些 <mark>CLI 工具</mark>，可作為套件發布
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
    + `pyproject.toml`（build 相關資訊儲存於此）
      ```toml
      [project.scripts]
      rogeliokg-core = "rogeliokg_core:main" 
      # 執行檔名稱 rogeliokg-core
      # 入口函式 src/rogeliokg_core/__init__.py:main

      [build-system]
      requires = ["uv_build>=0.9.3,<0.10.0"]
      build-backend = "uv_build"
      ```
    + `uv sync` 測試安裝
      + 在專案內「安裝」你寫的這個套件，你可以一邊開發、一邊測試功能（就如同 `pip install -e .`）
      + 原理：把 `src/` 目錄加入 `sys.path`
    + user 實際安裝
      + 只有 `src/` 目錄中的內容，會被放入 `.venv/Lib/site-packages/` 目錄
      + <mark>會在 `.venv/Scripts/` 生成執行檔，供 user 調用</mark> (註：需先進入 venv)

+ `--build-backend` 指定打包用 backend
  > 若專案是可發布套件才會用到的選項。\
  > 你可以自己指定第三方 build backend，比如：`hatch` (hatchling)、`setuptools` (setuptools)。\
  > 預設是 `uv-build`。

### `run`：執行腳本
  
  + 一般執行
    ```
    uv run main.py
    ```
  + `--with` 暫時將某版本的套件加入環境並執行
    > 套件會被下載到全域 cache，若很久沒清會很胖，要定期 prune 一下。
    ```
    uv run --with httpx==0.26.0 main.py
    ```


### `venv`：虛擬環境

  + 創建虛擬環境 (預設目錄名 `.venv`)
    ```
    uv venv
    ```

  + `--python` 指定虛擬環境 Python 版本
    ```
    uv venv --python 3.11.4
    ```

    |🚨 <span class="caution">CAUTION</span>|
    |:---|
    |由於 `uv sync` 根據 `.python-version` 和 `pyproject.toml` 內的 `requires-python` 決定 Python 版本，若使用 `uv venv` 切換虛擬環境的 Python 版本，記得要先<mark>手動更改這兩塊地方</mark>。 |

### `add` / `remove`：安裝 / 移除套件

  uv 如同 poetry、pnpm，會自動解析並移除未使用的相依套件。並有 lockfile 嚴格管理套件版本。

  + `--no-sync` 不自動同步
    > 只解析依賴，然後更新 `pyproject.toml` 和 `uv.lock`，不會自動使用 `uv sync` 安裝或移除套件。

### `sync`：同步套件

  <mark>安裝全部套件的加強版</mark>。\
  假如發生一些意外，導致你的 venv 缺了某些套件，或者 lockfile 不小心掉入垃圾桶，都可以用這個同步重新長回來。

### `tool`：工具

  工具是一種提供 CLI 的執行檔或 Python 套件。\
  工具會被獨立安裝在特別的環境 (非專案內的 venv)，以避免受相依套件影響。

  + `run` 類似 `npx` (可簡寫 `uvx`)
    ```
    uv tool run ruff check
    ```

  + `install` / `uninstall` 安裝 / 移除
    + 一般安裝
      ```
      uv tool install ruff
      ```
    + 指定 Python 版本安裝 (在工具未支持新版本 Python 時特別好用)
      ```
      uv tool install ruff --python 3.10
      ```
    
  + `dir` 工具被安裝在哪個目錄 (通常在 `%AppData%/Roaming/uv/tools`)
    ```
    uv tool dir
    ```

### `python`：多版本

  + `list` 列出 (通常在 `%AppData%/Roaming/uv/python`)
    ```
    uv python list
    ```

  + `install` / `uninstall` 安裝 / 移除
    ```
    uv python install 3.12.0
    ```

  + `pin` 切換 Python 版本 (更改 `.python-version`)

    + 專案內切換
      ```
      uv python pin 3.11
      ```
    + `--global` 全域切換
      ```
      uv python pin 3.11 --global
      ```


### `export`：輸出 lockfile

  + 輸出為 `requirements.txt`
    ```
    uv export --no-hashes --frozen --no-group dev --format requirements-txt > requirements.txt
    ```

### `build` / `publish`：構建 / 發布套件

  `uv build` + `uv publish`，就這麼簡單。唯 publish 時須注意兩點：
  1. 發布到不同套件源 (比如 testpypi)
      > 下指令時要指定套件源 `--index testpypi` (要先在 [`pyproject.toml` 設定](#--index：指定套件源))。
  2. 會問你 username 和 password，但現已改成使用 API token 登入
      > 因此 username 你要輸入 `__token__`，password 再輸入 API token 即可。

### `cache`：快取

  uv 為避免重複的下載，採取激進的快取策略，這導致快取容易變胖，要定期 prune。

  + `clean` / `prune` 清除 / 修剪

    這兩兄弟用法也是和 pnpm 很像，前者是完全清除所有快取，後者僅移除沒用到的快取。

### `self`：針對 uv 自身的功能

  + `update` 自行更新
    > 只能用在 standalone 安裝版 (比如 Linux 的 `curl` 或 `wget`、Windows 的 `irm`)，\
    > 若使用 Linux 的 `apt-get`、Mac 的 `brew`、Windows 的 `scoop` 等 package manager 安裝 `uv`，\
    > 需要使用 package manager 它們自己的 upgrade 方式。

### `tree`：依賴樹
  ...

### `pip`：相容 pip 介面
  ...

### `lock`：手動生成 lockfile
  ...

### `generate-shell-completion` 指令自動補全

+ PowerShell：放在 `$PROFILE` (腳本)
+ Bash：放在 `~/.bashrc` (腳本)

註：開啟 shell 時，會先執行一遍這個初始化腳本，註冊設定。

+ 將 uv 的自動補全腳本，注入到初始化腳本內
  ```
  uv generate-shell-completion powershell >> $PROFILE
  ```

## Options

### `--index`：指定套件源

  + `pyproject.toml` 可定義不同套件源，下指令時就可以加上 `--index` name 選擇
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

  + 要求某套件一定要從指定套件源下載
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
  + 本地套件源
    ```toml
    [project]
    dependencies = ["rogeliokg-core", "rogeliokg-cloud"]

    [tool.uv.sources]
    rogeliokg-core = [{ path = "C:/.../rogeliokg_core-0.1.0-py3-none-any.whl" }]
    rogeliokg-cloud = [{ path = "C:/.../rogeliokg_cloud-0.1.0-py3-none-any.whl" }]
    ```

### `--group` / `--no-group`：指定相依套件組
將 ruff 安裝到 dev groups
```
uv add ruff --group dev
```

## Project Structures

### namespace package

+ 有一種很特別的套件
  + install 時：`uv add google-auth google-cloud-storage`
  + import 時：`from google.auth import ...` `from google.cloud import ...` 
  + 嗯？我剛剛裝的是 `google-auth` 和 `google-cloud-storage` 對吧？怎麼都變 `google` 了？

+ namespace package 的魅力
  + 使用者所見目錄
    ```py
    site-packages/
    │
    └── google/ # 命名空間
        ├── auth/ # 子套件
        │   ├── __init__.py
        │   └── ...
        ├── outh2/ # 子套件
        │   ├── __init__.py
        │   └── ...
        └── cloud/ # 子套件
            ├── __init__.py
            └── ...
    ```
  + 實際開發目錄
    ```py
    google-auth/ # 套件
    │
    └── google/
        └── auth/ # 子套件
        │   ├── __init__.py
        │   └── ...
        └── outh2/
            ├── __init__.py
            └── ...

    google-cloud-storage/ # 套件
    │
    └── google/
        └── cloud/ # 子套件
            ├── __init__.py
            └── ...
    ```
+ 優勢
  + 套件變成類似插件（addons）一樣
  + 根據需求下載需要的插件，每個插件裡包含不同功能的子套件
  + 插件本身也能依賴其他插件，這樣就能包成一個功能更強大的插件
  + 對於 developer 而言，每個插件可分配一個團隊開發
  + 對於 user 而言，所有插件仍歸屬同一個 namespace（統一品牌體驗）

+ 配置
  + `pyproject.toml` 
    ```toml
    [project]
    ...

    [build-system]
    requires = ["uv_build>=0.9.3,<0.10.0"]
    build-backend = "uv_build"

    [tool.uv.build-backend]
    module-name = "google" # 命名空間
    module-root = "" # 根目錄 (預設是 "src")
    namespace = true # 使用 namespace package
    ```
  + 實際開發目錄
    ```py
    google-auth/ # 套件
    │
    └── google/
        └── auth/ # 子套件
        │   ├── __init__.py
        │   └── ...
        └── outh2/
            ├── __init__.py
            └── ...
    ```

### workspace
+ 參考
  + [**Using workspaces - uv**](https://docs.astral.sh/uv/concepts/projects/workspaces)
  + [**是 Ray 不是 Array - Monorepo**](https://israynotarray.com/other/20240413/3177435894/)
+ 簡單來說就是 <mark>monorepo</mark>
  + <mark>每個小專案（package）都有自己的設定</mark>（`pyproject.toml`）
  + 但由<mark>頂層專案（workspace）統一管理所有依賴</mark>（`uv.lock`）
+ 優勢
  + 每個小專案都可以作為套件發布（不像 monolith 是單純的模組）
  + CI / CD 根據依賴 DAG 進行部分測試（不像 monolith 改一行就要全部重測）
+ 專案目錄
  ```py
  albatross # 頂層專案
  ├── packages 
  │   ├── bird-feeder # 小專案 1
  │   │   ├── pyproject.toml
  │   │   └── src
  │   │       └── bird_feeder
  │   │           ├── __init__.py
  │   │           └── foo.py
  │   └── seeds # 小專案 2
  │       ├── pyproject.toml
  │       └── src
  │           └── seeds
  │               ├── __init__.py
  │               └── bar.py
  ├── pyproject.toml
  ├── README.md
  ├── uv.lock
  └── src
      └── albatross
          └── main.py
  ```
+ `pyproject.toml`
  ```toml
  [project]
  name = "albatross"
  version = "0.1.0"
  requires-python = ">=3.13"
  dependencies = [
      "bird-feeder",
      "seeds",
  ]

  [tool.uv.sources]
  bird-feeder = { workspace = true }
  seeds = { workspace = true }

  [tool.uv.workspace]
  members = ["packages/*"]
  ```
+ `bird-feeder/pyproject.toml`
  ```toml
  [project]
  name = "bird-feeder"
  version = "0.1.0"
  description = "Add your description here"
  requires-python = ">=3.13"
  dependencies = ["httpx", "seeds"]

  [build-system]
  requires = ["uv_build>=0.9.5,<0.10.0"]
  build-backend = "uv_build"
  ```

## Run with

### Jupyter

1. 下載 `ipykernel` 套件
    ```
    uv add ipykernel --group dev
    ```

2. 使用 VSCode 的話，Select Kernel 選擇虛擬環境的 Python Interpreter
    ![](https://code.visualstudio.com/assets/docs/datascience/jupyter/native-kernel-picker.png)

3. 使用 Browser IDE 的話
    ```
    uv run --with jupyter jupyter lab
    ```

## Others

+ Formatter 功能：[ruff](https://hackmd.io/@RogelioKG/ruff)
+ Precommit 功能：[pre-commit](https://hackmd.io/@RogelioKG/pre-commit)
