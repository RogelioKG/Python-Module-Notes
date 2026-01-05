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



## Cheatsheet
👇 最常用到的指令

![uv.drawio](https://hackmd.io/_uploads/Byn2TYA0xx.svg)



## Advantages
🐍 Python 終於也有了一個上得了檯面的 package manger

### 🧩 良好的依賴解析
> 刪除套件時，是真的會找出沒用到的依賴套件並刪除 (確保無 redundancy)

### 🧰 不只是依賴管理
> 集成非常多 out-of-the-box 的工具
> + Dependency Management
> + Virtual Environment
> + Multi-version Python
> + Publish Packages

### ⚡ 比 pip 快<mark>數十倍</mark>的速度
> 你以為 package manager 安裝套件的耗時，就是讓你去泡咖啡偷懶的時間嗎？\
> 噢不我的朋友，當你拿著你的杯子，準備離開電腦桌的時候，\
> uv 就已經以趕火車的速度，完成 dependency resolution 並 install 完畢。\
> 想見識這個驚掉下巴的速度，詳見 [benchmark](https://github.com/astral-sh/uv/blob/main/BENCHMARKS.md)。



## Note
|📘 <span class="note">NOTE</span> : uv|
|:---|
|uv 仍在開發中！<br><span style="color: grey;">註：此筆記紀錄的是 `0.9.21` (2025/12/30) 的功能！</span>|
| uv 安裝第三方套件的方式：使用 hardlink (詳見：[cache](#cache：快取))|
|uv 的 <mark>[build backend](https://hackmd.io/@RogelioKG/setuptools)：`uv-build`</mark> (打包成可發布套件的工具)|
|uv 的 <mark>lockfile：`uv.lock`</mark> (紀錄每個套件的版本與它們的依賴關係) <br><span style="color: grey;">註：PEP 751 (2024/7/26) 終於正式要求了 Python 的標準 lockfile 為 `pylock.toml`。</span>|



## Resolving
| 類型 | 套件共用策略 | 套件多版本共存 | 範例 |
| --- | --- | --- | --- |
| **Tree** | 不共用 | ✅ 允許 | `npm v2` |
| **Partial Graph** | 儘量共用，衝突時允許多版本 | ✅ 允許 | `npm v3+` / `pnpm` (peer dependency 衝突) |
| **Full Graph** | 所有套件，共用唯一版本 | ❌ 不允許 | `uv` / `pip` / `pnpm` |

> Full Graph 版本求解，本質上是一個 SAT 問題，\
> 通常採用 SAT solver 來嘗試找解。\
> uv 使用的是一種特別的 solver：[PubGrub](https://github.com/pubgrub-rs/pubgrub)。



## Commands
詳見 [UV CLI](https://docs.astral.sh/uv/reference/cli/#uv)。

### `init`：創建專案
+ #### `--python`
  > 指定 Python 版本
+ #### `--script`
  > 用於構建一個簡單<mark>腳本</mark>
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
+ #### `--app`
  > 用於構建一個<mark>應用程式</mark>，通常不作為套件發布
  + 目錄架構
    ```
    project_app/
    ├── .gitignore
    ├── .python-version
    ├── main.py
    ├── pyproject.toml
    └── README.md
    ```
+ #### `--lib`
  > 用於構建一個<mark>函式庫</mark>，可作為套件發布
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
  + `pyproject.toml` (build 相關資訊儲存於此)
    ```toml
    [project]
    ...

    [build-system]
    requires = ["uv_build>=0.9.3,<0.10.0"]
    build-backend = "uv_build"
    ```
  + `uv sync` 測試安裝
    + 在專案內「安裝」你寫的這個套件，你可以一邊開發、一邊測試功能 (如同 `pip install -e .`)
    + 原理：把 `src/` 目錄加入 `sys.path`
  + user 實際安裝
    + 只有 `src/` 目錄中的內容，會被放入 `.venv/Lib/site-packages/` 目錄
+ #### `--package`
  > 用於構建一些 <mark>CLI 工具</mark>，可作為套件發布
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
  + `pyproject.toml` (build 相關資訊儲存於此)
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
    + 在專案內「安裝」你寫的這個套件，你可以一邊開發、一邊測試功能 (如同 `pip install -e .`)
    + 原理：把 `src/` 目錄加入 `sys.path`
  + user 實際安裝
    + 只有 `src/` 目錄中的內容，會被放入 `.venv/Lib/site-packages/` 目錄
    + <mark>會在 `.venv/Scripts/` 生成執行檔，供 user 調用</mark> (註：需先進入 venv)
+ #### `--build-backend`
  > 指定打包用 backend\
  > (若專案是可發布套件才會用的到)
  + 可自己指定第三方 build backend
    > 比如：`hatch` (hatchling)、`setuptools` (setuptools)。\
    > 預設是 `uv-build`。

### `sync`：同步套件
> <mark>安裝全部套件的加強版</mark>。\
> 假如發生一些意外，導致你的 venv 缺了某些套件，\
> 或者 lockfile 不小心掉入垃圾桶，都可以用這個同步重新長回來。

### `add` ：安裝套件
|📗 <span class="tip">TIP</span>|
|:---|
|有 wheel 包的話，也可以直接安裝：`uv add ???.whl`|

|🚨 <span class="caution">CAUTION</span>|
|:---|
|在某些 OS 中，點擊 wheel 檔是有可能直接安裝的<br>(<mark>傳給別人前請務必詳細說明，不要直接點擊！</mark>)|

+ #### `-r`
  > 使用 `requirements.txt` 安裝套件，並更新 `pyproject.toml` 和 `uv.lock`
  ```
  uv add -r requirements.txt
  ```
  |🚨 <span class="caution">CAUTION</span>|
  |:---|
  |  若想用同事給的 `requirements.txt`，使用 uv 安裝套件，只能把所有套件都安裝進來。<br><mark>無法得知同事原先使用 `pip install` 哪些套件</mark>。 |
  + 使用 pip (對它而言是<mark>同一個結構</mark>)
    + 安裝 `requests`
      ```
      certifi==2025.10.5
      charset-normalizer==3.4.4
      idna==3.11
      requests==2.32.5
      urllib3==2.5.0
      ```
    + 安裝 `urllib3` 和 `requests`
      ```
      certifi==2025.10.5
      charset-normalizer==3.4.4
      idna==3.11
      requests==2.32.5
      urllib3==2.5.0
      ```
  + 使用 uv (對它而言卻是<mark>不同結構</mark>)
    + 安裝 `requests`
      ```
      temp v0.1.0
      └── requests v2.32.5
          ├── certifi v2025.10.5
          ├── charset-normalizer v3.4.4
          ├── idna v3.11
          └── urllib3 v2.5.0
      ```
    + 安裝 `urllib3` 和 `requests`
      > 注意到了嗎，你手動安裝的套件，會在頂層。
      ```
      temp v0.1.0
      ├── requests v2.32.5
      │   ├── certifi v2025.10.5
      │   ├── charset-normalizer v3.4.4
      │   ├── idna v3.11
      │   └── urllib3 v2.5.0 (*)
      └── urllib3 v2.5.0
      ```
  |🚨 <span class="caution">CAUTION</span>|
  |:---|
  | 既然一種扁平狀結構，能推斷出多種樹狀結構，<br>我們就無法用一種扁平狀結構，去唯一決定為一種樹狀結構。<br>意即：無法猜測同事原先使用 `pip install` 哪些套件。<br><mark>這絕不是 uv 的缺陷，恰恰相反，這是 pip 的缺陷！</mark> |
  ```toml
  # 使用 `requiremets.txt` 安裝後，會長成這副慘烈的模樣
  [project]
  ...
  dependencies = [
      "certifi==2025.10.5",
      "charset-normalizer==3.4.4",
      "idna==3.11",
      "requests==2.32.5",
      "urllib3==2.5.0",
  ]
  ```
  |📗 <span class="tip">TIP</span>|
  |:---|
  |那要怎麼解決呢？<br>只能<mark>請你的同事回想，他當初手動安裝過的是哪些套件</mark>囉！|
+ #### `--no-sync`
  > 不自動同步
  + 只解析依賴，並更新 `pyproject.toml` 和 `uv.lock`
  + 不會自動安裝、移除套件

### `remove`：移除套件
> 移除套件時，會自動解析並移除未使用的依賴套件。
+ #### `--no-sync`
  > 不自動同步
  + 只解析依賴，並更新 `pyproject.toml` 和 `uv.lock`
  + 不會自動安裝、移除套件

### `run`：執行腳本
+ #### ` `
  > 一般執行
  ```
  uv run main.py
  ```
+ #### `--with`
  > 暫時將某版本的套件加入環境並執行。
  ```
  uv run --with httpx==0.26.0 main.py
  ```
  |🚨 <span class="caution">CAUTION</span>|
  |:---|
  |會下載到快取，若太久沒清會很胖，要定期清|
+ #### `--python`
  > 暫時使用某版本 Python 執行
  ```
  uv run --python 3.13.7 main.py
  ```
  |📗 <span class="tip">TIP</span>|
  |:---|
  |超好用：開發套件時，進行多版本測試|
+ ### `--env-file`
  > 暫時載入某個環境變數檔執行
  ```
  uv run --env-file .env main.py
  ```
  |📗 <span class="tip">TIP</span>|
  |:---|
  |超好用：因 monorepo 架構而在根目錄統一管理 `.env`，使用它可跨目錄將 `.env` 引入|

### `tree`：依賴樹
> 展示套件們的依賴關係

### `python`：多版本
+ #### `list`
  > 列出可用 Python 版本
  ```
  uv python list
  ```
+ #### `install` / `uninstall`
  > 安裝 / 移除
  ```
  uv python install 3.12.0
  ```
  |📘 <span class="note">NOTE</span>|
  |:---|
  |Python 直譯器會被放在 `~/.local/bin` (全域可見)|
  |<mark>在全域可使用 `python3.xx` 把 REPL 互動式環境叫出來</mark>|
+ #### `pin`
  > 切換 Python 版本 (更改 `.python-version`)
  + ` `
    > 專案內的 Python 版本
    ```
    uv python pin 3.11
    ```
  + `--global`
    > 之後 init 專案的 Python 版本
    ```
    uv python pin 3.11 --global
    ```

### `export`：將 lockfile 導出為其他格式

+ #### ` `
  ```
  uv export --no-hashes --format requirements-txt > requirements.txt
  ```
  |🚨 <span class="caution">CAUTION</span>|
  |:---|
  |當 `pyproject.toml` 和 `uv.lock` 不一致時，<br><mark>試圖同步</mark>，再導出 `uv.lock` 的 lockfile 資訊。|
+ #### `--format`
  > 輸出格式
+ #### `--no-hashes`
  > 不希望導出內容有 hash 值。\
  > (hash 值確保你下載到的是原本的套件，能防止供應鏈攻擊、中間人攻擊)
+ #### `--frozen`
  > 當 `pyproject.toml` 和 `uv.lock` 不一致時，\
  > <mark>不會試圖先同步</mark>，而是直接導出 `uv.lock` 的 lockfile 資訊。
+ #### `--locked`
  > 斷言 `uv.lock` 在導出過程中，不會被更改。\
  > (即斷言 <mark>`pyproject.toml` 和 `uv.lock` 一致</mark>)
+ #### `--only-group`
  > 僅導出特定 group 內的依賴套件

### `cache`：快取
  |🚨 <span class="caution">CAUTION</span>|
  |:---|
  |uv 為避免重複下載，採取激進快取策略，若太久沒清會很胖，要定期清|
+ #### `dir`
  > 快取目錄 (通常是 `%LOCALAPPDATA%/uv/cache`)
  + 補充
    ```py
    cache
    ├── archive-v0/      # 套件 hardlink (與虛擬環境 hardlink 指向同塊存放套件的空間)
    ├── interpreter-v4/  # ...
    ├── sdists-v9/       # ...
    ├── simple-v18/      # ...
    ├── wheels-v5/       # ...
    ├── .gitignore
    ├── .lock
    └── CACHEDIR.TAG
    ```
+ #### `clean`
  > 清除 - 清除所有快取
+ #### `prune`
  > 修剪 - 清除舊版快取

  |🔮 <span class="important">IMPORTANT</span>|
  |:---|
  |「修剪」中[舊版快取](https://github.com/astral-sh/uv/issues/10153#issuecomment-2564360859)的意思是，<mark>uv 因實作調整，而遺留下來的舊版目錄結構</mark>。 |
  |比如在快取目錄中，有類似 `wheels-v5` 這樣的快取，它的上一版可能就是 `wheel-v4`，當 uv 版本更新時，這些舊版快取就會變成孤兒。 |

  |🚨 <span class="caution">CAUTION</span>|
  |:---|
  | 所以 `uv cache prune` 和 `pnpm store prune` 實作上並不一樣。|
  | pnpm 可以知道 hardlink 的 link count，然後去自動清理；uv 並沒有選擇這麼做。|
  | 根據 [uv 的 contributer 所述](https://github.com/astral-sh/uv/issues/16008#issuecomment-3333296869)，他們針對快取修剪這塊還在討論中，她認為 pnpm 的未用及刪不是好主意，她更傾向 LRU 的作法 (下載熱點保留、被冷落的修剪掉) |

### `tool`：工具
> 工具是一種 CLI 執行檔。\
> 會被安裝在獨立環境 (非專案內)，以避免受不相關的依賴套件影響。
+ #### `run`
  > 暫時下載工具 (可簡寫 `uvx`)
  ```
  uv tool run ruff check
  ```
  |📘 <span class="note">NOTE</span>|
  |:---|
  |CLI 執行檔會被放在 `~/.local/bin` (全域可見)|
+ #### `install` / `uninstall`
  > 安裝 / 移除
  + 一般安裝
    ```
    uv tool install ruff
    ```
  + 指定 Python 版本安裝
    > 在工具未支持新版本 Python 時特別好用
    ```
    uv tool install ruff --python 3.10
    ```
+ #### `dir` 
  > 工具被安裝在哪個目錄\
  > (通常是 `%AppData%/Roaming/uv/tools`)
  ```
  uv tool dir
  ```

### `build` ：構建套件
> ...

### `publish`：發布套件
1. 發布到不同套件源 (比如 testpypi)
    > 下指令時要指定套件源 `--index testpypi` (要先在 [`pyproject.toml` 設定](#--index：指定套件源)
2. 會問你 username 和 password (但現在不是改用 API token 登入？)
    > 因此 username 要輸入 `__token__`，password 再輸入 API token 即可

### `version` 版本控制
> 自己 project 的版本控制

| 情境 | 指令 | 原版 | 新版 |
| :--- | :--- | :--- | :--- |
| 發布新版 |`uv version 0.1.0` | ... | 0.1.0 |
| 小修小補<br>(向下相容的問題修正) | `uv version --bump patch` | 0.1.0 | 0.1.1 |
| 小修小補<br>(有大 BUG) | `uv version --bump patch --bump dev` | 0.1.1 | 0.1.2.dev1 |
| 小修小補<br>(有大 BUG) | `uv version --bump dev` | 0.1.2.dev1 | 0.1.2.dev2 |
| 小修小補<br>(完工了) | `uv version --bump stable` | 0.1.2.dev2 | 0.1.2 |
| 文檔修正<br>(說明文件沒寫好) | `uv version --bump post` | 0.1.2 | 0.1.2.post1 |
| 新功能開發 | `uv version --bump minor --bump dev` | 0.1.2.post1 | 0.2.0.dev1 |
| 開發過程 | `uv version --bump dev` | 0.2.0.dev1 | 0.2.0.dev2 |
| 內部測試 - 版本 1 | `uv version --bump alpha` | 0.2.0.dev2 | 0.2.0a1 |
| 內部測試 - 版本 2 | `uv version --bump alpha` | 0.2.0a1 | 0.2.0a2 |
| 公開測試 - 版本 1 | `uv version --bump beta` | 0.2.0a2 | 0.2.0b1 |
| 發布候選版 | `uv version --bump rc` | 0.2.0b1 | 0.2.0rc1 |
| 正式發布 | `uv version --bump stable` | 0.2.0rc1 | 0.2.0 |
| 重大架構重寫 | `uv version --bump major --bump dev` | 0.2.0 | 1.0.0.dev1 |
| 史詩冒險持續中 | `...` | 1.0.0.dev1 | ... |

+ #### `--bump`
  >  升版
  + `major`：1.2.3 => 2.0.0
  + `minor`：1.2.3 => 1.3.0
  + `patch`：1.2.3 => 1.2.4
  + `stable`：1.2.3b4.post5.dev6 => 1.2.3
  + `alpha`：1.2.3a4 => 1.2.3a5
  + `beta`：1.2.3b4 => 1.2.3b5
  + `rc`：1.2.3rc4 => 1.2.3rc5
  + `post`：1.2.3.post5 => 1.2.3.post6
  + `dev`：1.2.3a4.dev6 => 1.2.3.dev7

### `pip`：相容 pip 介面
> ...

### `venv`：創建虛擬環境
> 預設目錄名 `.venv`
+ #### `--python`
  > 指定虛擬環境 Python 版本
  ```
  uv venv --python 3.11.4
  ```

### `lock`：生成 lockfile
> ...


### `auth`：套件上傳、下載需授權
+ 請參考：[PyPI Server](https://hackmd.io/@RogelioKG/pypi-server)

### `generate-shell-completion`：指令自動補全
+ 將 uv 的自動補全腳本，注入到初始化腳本內
  ```
  uv generate-shell-completion powershell >> $PROFILE
  ```
  |📘 <span class="note">NOTE</span>|
  |:---|
  |開啟 shell 時，會先執行一遍初始化腳本，註冊設定<br>PowerShell：放在 `$PROFILE`；Bash：放在 `~/.bashrc`|



## Options

### `--group` / `--no-group`：optional 依賴套件組 (開發者)
> 詳見 [dependency-groups](#dependency-groups：optional-依賴套件組-開發者)
+ 開發階段時，將 ruff 安裝到 dev 依賴套件組
    ```
    uv add ruff --group dev
    ```
+ 開發階段時，安裝整個 dev 依賴套件組
    ```
    uv sync --group dev
    ```

### `--index`：額外套件源
> 給定 url。此選項可重複多次，指定多個額外 index。

### `--default-index`：預設套件源
> 給定 url。指定優先度最高的 index。

### `--index-strategy`：多套件源選定策略
| 策略 | `first-index` | `unsafe-first-match` | `unsafe-best-match` |
| --- | --- | --- | --- |
| **行為** | 依 index 優先序解析，選擇優先序高的解析成功 index (預設) | 對每個依賴套件，依 index 優先序尋找版本，前一個 index 都沒合適版本，才換下一個 index | 對每個依賴套件，無視優先序從所有 index 找，若有多個則取優先序高的 index |
| **說明** | ✅ 依賴套件皆來自同 index | ☢️ 依賴套件可來自不同 index  | ☢️ 依賴套件可來自不同 index |

| ☢️ <span class="warn">WARNING</span>|
| :------------------------------------- |
| <mark>混用套件源</mark>之所以被定調為 <mark>unsafe</mark>：<br>1. 通常不是 developer 在開發階段預期的情況，可能會出現不兼容的情況<br>2. 同名冒充套件的供應鏈攻擊 |



## Project Metadata
> 詳見 [uv - project metadata](https://docs.astral.sh/uv/reference/settings/#project-metadata)

### `project.optional-dependencies`：optional 依賴套件組 (使用者)
> PEP 621 規範。\
> 使用者可決定是否安裝的 optional 依賴：`uv add llm-crawler[proxy]`

|📗 <span class="tip">TIP</span>|
|:---|
|使用者若使用 wheel 安裝，也是可以的。<br>例如：`uv add ./llm_crawler-0.4.1-py3-none-any.whl[proxy]`|

```toml
[project]
name = "llm-crawler"
version = "0.1.0"
dependencies = [
    "selenium",
    "webdriver-manager",
]

[project.optional-dependencies]
proxy = [
    "swiftshadow>=0.3.0",
]
```

### `tool.uv.dependency-groups`：optional 依賴套件組 (開發者)
> uv 擴充。\
> 開發者可決定是否安裝的 optional 依賴：`uv add --group lint`
```toml
[dependency-groups]
dev = [
  "pytest"
]
lint = [
  "ruff"
]
```

### `tool.uv.default-groups`：預設安裝 optional 依賴套件組 (開發者)
> uv 擴充。
```toml
[tool.uv]
default-groups = ["lint"]
```

### `tool.uv.index`：額外套件源
> uv 擴充。
```toml
[[tool.uv.index]]
name = "pytorch-cu124"
url = "https://download.pytorch.org/whl/cu124"

[[tool.uv.index]]
name = "pypi"
url = "https://pypi.org/simple/"
publish-url = "https://upload.pypi.org/legacy/"

[[tool.uv.index]]
name = "testpypi"
url = "https://test.pypi.org/simple/"
publish-url = "https://test.pypi.org/legacy/"
```

### `tool.uv.sources`：此套件需從【指定套件源】下載
> uv 擴充。
> 
> `explicit = true`
> + 代表僅此套件的 wheel 檔從【指定套件源】抓取
> + 其餘依賴套件的 wheel 檔從【預設套件源】抓取
```toml
[tool.uv.sources]
torch = [
  { index = "pytorch-cu124"},
]

[[tool.uv.index]]
name = "pytorch-cu124"
url = "https://download.pytorch.org/whl/cu124"
explicit = true
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
  + 套件變成類似插件 (addons) 一樣
  + 根據需求下載需要的插件，每個插件裡包含不同功能的子套件
  + 插件本身也能依賴其他插件，這樣就能包成一個功能更強大的插件
  + 對於 developer 而言，每個插件可分配一個團隊開發
  + 對於 user 而言，所有插件仍歸屬同一個 namespace (統一品牌體驗)
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
  + <mark>每個小專案 (package) 都有自己的設定</mark>(`pyproject.toml`)
  + 但由<mark>頂層專案 (workspace) 統一管理所有依賴</mark>(`uv.lock`)
+ 優勢
  + 每個小專案都可以作為套件發布 (不像 monolith 是單純的模組)
  + CI / CD 根據依賴 DAG 進行部分測試 (不像 monolith 改一行就要全部重測)
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



## Packaging

### multi-version
  > 利用 `uv run --python <version>` 的特性，\
  > 完全可以寫個小腳本，達成套件的 Python 多版本測試，\
  > 而不需要再仰賴 [tox](https://tox.wiki/en/4.32.0/) 之類的工具。
  ```ps
  # PowerShell
  $ErrorActionPreference = "Stop"

  $pyVersions = @("3.13", "3.12", "3.11", "3.10", "3.9", "3.8")

  foreach ($v in $pyVersions) {
      Write-Host ">>> Testing with Python $v" -ForegroundColor Cyan

      # 這裡可執行 pytest 之類的單元測試
      uv run --python $v -m src.llm_crawler.examples

      if ($LASTEXITCODE -eq 0) {
          Write-Host "✅ Python $v tests passed`n" -ForegroundColor Green
      }
      else {
          Write-Host "❌ Python $v tests failed`n" -ForegroundColor Red
          exit 1
      }

      Start-Sleep -Seconds 1
  }

  Write-Host "🎉 All versions tested successfully!" -ForegroundColor Green
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
