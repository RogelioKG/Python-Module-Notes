# poetry

[![RogelioKG/poetry](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/poetry)

### References
+ 🔗 [**poetry**](https://python-poetry.org/)
+ 🔗 [**kyomind - poetry**](https://blog.kyomind.tw/python-poetry/)
+ 🔗 [**pipx**](https://pipx.pypa.io/stable/)
+ 🔗 [**Josix is Only Joking - pipx**](https://josix.tw/post/pipx-deep-dive/)
+ 🔗 [**⚡JS 套件管理大師**](https://hackmd.io/@RogelioKG/package_management_js)

### Advantages

poetry 相比於 pip 的四大優勢 ✨

1. ✅ **良好的依賴解析**
    > 刪除套件時，是真的會找出沒用到的依賴套件並刪除 (確保無 redundancy)
2. ✅ **不只是依賴管理工具**
    > 還集成打包、發布於一身
4. ✅ **將依賴套件分成 prod / dev**
    > 容器化部署時，過多在生產環境不必要的套件，會徒增 image 肥大
6. ✅ **範圍版本號**
    > 對使用者來說相容性更好 (相較於 pip 的固定版本號)

### Install
1. install `pipx` (Windows)
    ```
    scoop install pipx
    ```

2. install `poetry`
    ```
    pipx install poetry
    ```

    > 當使用 `pipx install <pkg>` 後， pipx 會<mark>為要安裝的套件開啟一個虛擬環境</mark>，並且將該套件安裝到裡面，再為其執行檔複製或建立一個軟連結 (symbolic link) 到 `$PIPX_BIN_DIR/bin` 下，供使用者直接調用。

    |☢️ <span class="warning">WARNING</span>|
    |:---|
    |安裝 poetry 的時候，一定將它安裝在一個「專屬於它」的虛擬環境。<br />千萬不要為了方便，把 poetry 直接安裝至你的專案虛擬環境或者全域環境，這麼做是危險的。<br />因為 poetry 所依賴的套件非常多，<br />可能會在其他具有共同依賴套件的套件更新時，意外更新到 poetry。|


### Development Setting
1. 改一下設定，讓它在 project 頂層目錄產生虛擬環境
    ```
    poetry config virtualenvs.in-project true
    ```
    > 原本會在這裡產生虛擬環境：\
    > %AppData%\Local\pypoetry\Cache\virtualenvs\專案名稱-亂數-Python版本

### Development

1. 建立虛擬環境
    ```
    poetry env use python
    ```
    > 使用的 Python 版本，取決於 python 指令在你的「PATH」是連結到哪個版本
2. 進入虛擬環境
    ```
    poetry shell
    ```
3. 安裝 `pyproject.toml` 指定的所有依賴套件
    > 若你的專案不打算做為套件發布
    ```
    poetry install --no-root
    ```
    > 若你的專案不打算做為套件發布
    ```
    poetry install
    ```
    |☢️ <span class="warning">WARNING</span>|
    |:---|
    |記得專案底下還要有一個目錄，<br />同 `pyproject.toml` 的 `name` 指定的套件名稱，<br />然後記得那個目錄底下要有一個 `__init__.py`。|

### Distribution Setting

1. TestPyPI 的 POST API 設定
    ```
    poetry config repositories.testpypi https://test.pypi.org/legacy/
    ```

2. API Token 設定
    ```
    poetry config pypi-token.pypi <token>
    ```
    ```
    poetry config pypi-token.testpypi <token>
    ```

### Distribution

1. 套件升版 (minor)
    ```
    poetry version minor
    ```
2. 構建
    ```
    poetry build
    ```
3. 發布
    + PyPI 
      ```
      poetry publish
      ```
    + TestPyPI
      ```
      poetry publish -r testpypi
      ```

### Others

![CLI](https://hackmd.io/_uploads/HyUKiGQ7ye.png)


