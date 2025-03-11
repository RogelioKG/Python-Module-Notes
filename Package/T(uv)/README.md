# uv

[![RogelioKG/uv](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/uv)

## Brief
我們的 🐍 Python 終於也有了一個像樣的 package manger。\
一手包辦 multi version, dependency (install, uninstall, lockfile...), virtual env, publish packages, and so on。\
由 Rust 編寫，且[相較於 pip 快<mark>數十倍</mark>的速度](https://github.com/astral-sh/uv/blob/main/BENCHMARKS.md)。

## References
+ 📑 [**Documentation - uv**](https://docs.astral.sh/uv/)
+ 🎬 [**ArjanCodes - UV for Python… (Almost) All Batteries Included**](https://youtu.be/qh98qOND6MI)

## Installation
+ Windows
  ```bash
  scoop install main/uv 
  ```

## Note

|📘 <span class="note">NOTE</span>|
|:---|
|此 package manager 仍在開發狀態，此筆記紀錄的是 version `0.6.5` 的功能|

|📘 <span class="note">NOTE</span>|
|:---|
|此 package manager 的 lockfile 叫 `uv.lock`|

|🚨 <span class="caution">CAUTION</span>|
|:---|
|uv 目前還不支援 scripts (我愛 `npm scripts`)|

## Usage

請參考 [UV CLI](https://docs.astral.sh/uv/reference/cli/#uv)。

### 創建專案 `init`

  ```
  uv init --app test_project
  ```

  在上層專案內創建的專案，不與上層專案共享依賴 (通常用於 monorepo)
  ```
  uv init yet_another_project --no-workspace
  ```


### 執行腳本 `run`
  
  還會自動創建 venv，馬的有夠貼心
  ```
  uv run main.py
  ```

### 安裝 / 移除套件 `add` / `remove`

  uv 如 poetry 或 pnpm 一樣，會自動解析並順便移除沒用到的相依套件。並且有 lockfile 嚴格管理套件版本。

### 同步套件 (安裝全部套件的加強版) `sync`

  假如發生一些意外，導致你的 venv 缺了某些套件，或者 lockfile 不小心掉入垃圾桶，都可以用這個同步重新長回來。


### 手動生成 lockfile `lock`

### 依賴樹 `tree`

### 工具 `tool`

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

### 多版本 `python`

  + `list` 列出
    ```
    uv python list
    ```

  + `install` / `uninstall` 安裝 / 移除
    ```
    uv python install 3.12.0
    ```

### 虛擬環境 `venv`

  + 創建虛擬環境

    ```
    uv venv .venv
    ```

  + `--python` 指定虛擬環境 Python 版本

    |🚨 <span class="caution">CAUTION</span>|
    |:---|
    |由於 `uv sync` 是根據 `.python-version` 和 `pyproject.toml` 內的 `requires-python` 決定 Python 版本，若有使用 `uv venv` 切換虛擬環境的 Python 版本，記得要先<mark>手動更改這兩塊地方</mark>。 |

    可靈活切換虛擬環境 Python 版本，但要重新下載相依套件

    ```
    uv venv --python 3.11.4
    ```

### pip 相容介面 `pip`

### 輸出 lockfile `export`

+ 輸出成 `requirements.txt`
  ```
  uv export --no-hashes --format requirements-txt > requirements.txt
  ```