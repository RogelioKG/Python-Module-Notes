# pytest

[![RogelioKG/pytest](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/pytest)

## References
+ 🔗 [**Documentation - Pytest**](https://docs.pytest.org/en/7.4.x/)
+ 🔗 [**拾遺 - Python 測試入門 - 開始使用 PyTest**](https://blog.tzing.tw/posts/python-testing-pytest-08de903a)
+ 🔗 [**CSDN - pytest.ini**](https://blog.csdn.net/Moonlight_16/article/details/122706934)
+ 🔗 [**IT 邦 - Python 與自動化測試的敲門磚**](https://ithelp.ithome.com.tw/users/20144024/ironman/5372)
+ 🔗 [**知乎 - Pytest fixture 及 conftest 详解**](https://zhuanlan.zhihu.com/p/564168267)
+ 🔗 [**Pytest With Eric - Ultimate Guide To Pytest Markers And Good Test Management**](https://pytest-with-eric.com/pytest-best-practices/pytest-markers/)
+ 🔗 [**Pytest With Eric - What Is pytest.ini And How To Save Time Using Pytest Config**](https://pytest-with-eric.com/pytest-best-practices/pytest-ini/)
+ 🎞️ [**ArjanCodes - How To Write Unit Tests For Existing Python Code // Part 1 of 2**](https://youtu.be/ULxMQ57engo?si=lhBSt6jt0NFBXTAS)
+ 🎞️ [**ArjanCodes - How To Write Unit Tests For Existing Python Code // Part 2 of 2**](https://youtu.be/NI5IGAim8XU?si=MxcKvp_wooG7H3oF)

## Note

|📘 <span class="note">NOTE</span>|
|:---|
|1. 放置在 `test` / `tests` 目錄內|
|2. 模組名稱為 `test_*.py`|

|☢️ <span class="warning">WARNING</span>|
|:---|
|1. 測試目錄與被測試目錄皆要有 `__init__.py`|
|2. 測試目錄路徑不可有<mark>**不合法名稱**</mark> (比如有<mark>**中括號**</mark> [] 的名稱，會被誤當成 .ini 的 section)。<br>否則會產生錯誤 `OSError: Starting path not found`。|
|3. 測試目錄路徑若有任一<mark>**目錄改過名稱**</mark>，請務必<mark>**清除測試目錄底下的`__pycache__`**</mark>。<br>否則會產生錯誤 `OSError: Starting path not found`。|
|4. TestClass 的第一個引數都要是 `self`，就如同在寫一般 class 一樣。|

## CLI

+ **選項**
  ```bash
  pytest
  ```
  + `--markers` : 查看所有已註冊的 markers
  + `--fixtures` : 查看所有已註冊的 fixtures
  + `-h` : 參數說明 (help)
  + `-v` : 詳細結果 (verbose)
  + `-q` : 簡潔結果 (quiet)
  + `-s` : 允許 stdout / stderr 印出 (會打亂 pytest 測試結果輸出格式)

+ **測試範圍**

  + 全部測試
    ```bash
    pytest
    ```

  + 針對某個子目錄進行測試
    ```bash
    pytest tests/end_to_end
    ```

  + 針對某個模組進行測試
    ```bash
    pytest tests/test_module.py
    ```

  + 針對某個模組中某個函式進行測試
    ```bash
    pytest tests/test_module.py::test_func
    ```

  + 針對某個模組中某個類別進行測試
    ```bash
    pytest tests/test_module.py::TestClass
    ```

  + 針對某個模組中某個類別的某個方法進行測試
    ```bash
    pytest tests/test_module.py::TestClass::test_method
    ```

+ **CLI 測試結果**
  + <code><span style="color: #719926;">.</span></code> / <code><span style="color: #719926;">PASSED</span></code> : 代表一個通過的 test case
  + <code><span style="color: #aead2a;">s</span></code> / <code><span style="color: #aead2a;">SKIPPED</span></code> : 代表一個跳過的 test case
  + <code><span style="color: #aead2a;">x</span></code> / <code><span style="color: #aead2a;">XFAILED</span></code> : 代表一個已預期失敗 (等待修復) 的 test case
  + <code><span style="color: #d3618b;">F</span></code> / <code><span style="color: #d3618b;">FAILED</span></code> : 代表一個失敗的 test case
  + `[80%]` : 代表的是總完成進度 (百分比)
  

## Config

### `.vscode/settings.json`

```json
{
  "python.testing.pytestEnabled": true, // 開啟 Pytest
  "python.testing.cwd": "${workspaceFolder}/tests" // test case 目錄
}
```

![vscode-testing](https://code.visualstudio.com/assets/docs/python/testing/test-explorer.png)

### `pytest.ini`

|📗 <span class="tip">TIP</span>|
|:---|
|如果你使用 `pyproject.toml`，只要將以下設定都置於 `[tool.pytest.ini_options]` 即可|

```ini
[pytest]
# 指定測試時的最小 pytest 版本要求
minversion = 6.0

# 設定 pytest 預設的測試參數
# -q: 安靜模式，減少輸出資訊
# --disable-warnings: 禁用警告顯示
addopts = -q --disable-warnings

# 指定測試的搜尋路徑，預設 pytest 會搜尋 tests/ 目錄
# 這樣可以避免 pytest 搜索到不相關的測試文件
norecursedirs = .* build dist CVS _darcs

testpaths = tests

# 指定 pytest 應該辨識的測試檔案名稱模式
# 預設是 test_*.py 和 *_test.py
python_files = test_*.py *_test.py

# 指定 pytest 應該辨識的測試類別名稱模式
# 這樣只會執行以 "Test" 開頭的類別
python_classes = Test*

# 指定 pytest 應該辨識的測試函數名稱模式
# 這樣只會執行以 "test_" 開頭的函數
python_functions = test_*

# 設定測試輸出的格式 (例如 junit, html, xml 等)
# 這裡設定為 JUnit 格式輸出到 reports/pytest_report.xml
junit_family = xunit1
junit_logging = all
junit_suite_name = pytest_suite
junitxml = reports/pytest_report.xml

# 設定 logging 相關選項
log_cli = true
log_cli_level = INFO
log_file = logs/pytest.log
log_file_level = DEBUG
log_format = %(asctime)s [%(levelname)s] %(message)s
log_date_format = %Y-%m-%d %H:%M:%S

# 自訂 marker，這些 marker 可用於區分測試
markers = 
    slow: 執行較慢的測試 ; 說明文字
    regression: 回歸測試
    integration: 整合測試
```

## Global

### `conftest.py`

+ **說明**
  1. 可創建 fixture，有效範圍：同目錄內所有 test case 可見，<mark>**無須 import**</mark>。
  2. 自訂命令列選項

+ **example**

  + `tests/conftest.py`
    ```py
    # 1. 同目錄內所有 test case 可見的 fixture
    @pytest.fixture(scope="function", name="test_data_lol")
    def test_data() -> dict[str, int]:
        data = {"a": 1, "b": 2, "c": 3}
        return data

    # 2. 自訂命令列選項 (一定要放在 conftest.py)
    def pytest_addoption(parser: pytest.Parser):
        """"自訂命令列選項"""
        parser.addoption(
           "--env", 
           default="test", 
          choices=["dev", "test", "pre"], help="enviroment parameter"
        )
    ```

  + `tests/test_something.py`
    ```py
    def update_a(data: dict[str, int], n: int) -> None:
        data["a"] += n

    # 1. 使用 conftest.py 的 fixture
    def test_update_a_plus_1(test_data_lol: dict[str, int]):
        update_a(test_data_lol, 1)
        assert test_data_lol["a"] == 2

    # 2. 檢查自訂命令列選項
    def test_option(pytestconfig: pytest.Config):
        print("the current environment is:", pytestconfig.getoption("env"))
    ```

## Usage

### 斷言驗證
  ```py
  def test_demo():
      # 1 個 test case
      assert 1 + 1 == 2
  ```

### 錯誤驗證 `raises`
  |🚨 <span class="caution">CAUTION</span>|
  |:---|
  |每個 with 述句只能驗證一個錯誤|

  ```py
  def raise_error():
      raise IndexError("list 的位置錯誤")

  def test_error():
      # 將接收到的錯誤丟給一個名為 exc 的變數，該變數可於外部使用
      with pytest.raises(IndexError) as exc:
          raise_error()
      
      # 錯誤
      exc.value: IndexError
      print(exc.value) # list 的位置錯誤
      
      # 錯誤類別名稱
      exc.typename: str
      print(exc.typename) # IndexError
  ```

### 資源初始化與釋放 `setup` / `teardown`
  + <mark>context management</mark>\
    缺點 : 無法接受引數
    ```py
    def setup_module():
        print("setup_module")

    def teardown_module():
        print("teardown_module")


    def setup_function():
        print("setup_function")


    def teardown_function():
        print("teardown_function")


    def test_demo():
        assert 1 + 1 == 2


    def test_demo_2():
        assert 2 + 2 == 4

    # setup_module
    # setup_function
    # .teardown_function
    # setup_function
    # .teardown_function
    # teardown_module
    ```

### 夾具 `fixture`

  + **decorator kwargs**
    + [<mark>`scope`</mark>](https://www.cnblogs.com/yoyoketang/p/9762197.html) : 變數生命週期的作用域，預設為 "function"\
      (在每個 test case 裡都會重新 create 一遍)
    + `name` : 變數調用名稱，預設就是函式的名稱
    + `autouse` : 是否在每個 test case 中自動使用，預設為 False\
      (根據 scope 而定，如果 scope="function"，那不需傳遞引數就會自動調用)
    + `params` : 參數化測試，應給定 list[dict[str, Any]]

  + **必要性**
    > Q : 為何使用 fixture，而不使用 global variable 就好？\
    > global variable 寫起來不是更簡單嗎？

    > A : 請看下例，如果 fixture `test_data` 變成一般的 global variable，\
    > 就會造成 `test_data` 通過第一個 test case 後，反而無法通過之後的 test case。\
    > 很明顯，`test_data` 需要在每個 test case 執行前重新 create 一遍。\
    > `fixture(scope="function")` 因而派上用場。

    ```py
    # 功能
    def update_a(data: dict[str, int], n: int) -> None:
        data["a"] += n

    # 測試
    @pytest.fixture(scope="function", name="test_data_lol")
    def test_data() -> dict[str, int]:
        data = {"a": 1, "b": 2, "c": 3}
        return data

    def test_update_a_plus_1(test_data_lol: dict[str, int]):
        update_a(test_data_lol, 1)
        assert test_data_lol["a"] == 2

    def test_update_a_times_5(test_data_lol: dict[str, int]):
        update_a(test_data_lol, 5)
        assert test_data_lol["a"] == 6
    ```

+ 參數 `autouse`

  scope="function" 的 autouse 會讓模組內的 test case 自動使用 clear_tables。\
  如果有非常多的 test cases，就不須每個都套上 decorator。

  ```py
  # 每次 test case 後自動清除資料表
  @pytest.fixture(scope="function", autouse=True)
  def clear_tables(test_session: Session) -> None:
      yield
      for _, table in Base.metadata.tables.items():
          test_session.query(table).delete()
      test_session.commit()

  # 這邊就不需再使用 fixture 了
  def test_create_user(test_user: User, test_session: Session):
      result = user_services.create_user(test_user, test_session)
      assert result.id is not None
      assert result.username == test_user.username
      assert result.birthday == test_user.birthday
  ```

### 內建夾具 : 猴子補丁 `monkeypatch`
  + 輸入 mock
    ```py
    import pytest

    class CreditCard:
        def __init__(self, number: str, expiry_month: int, expiry_year: int):
            self.number = number
            self.expiry_month = expiry_month
            self.expiry_year = expiry_year
        @classmethod
        def read_card_info(cls) -> "CreditCard":
            number = input("Card Number: ")
            expiry_month = input("Expiry Month: ")
            expiry_year = input("Expiry Year: ")
            return cls(number, int(expiry_month), int(expiry_year))

    def test_credit_card(monkeypatch: pytest.MonkeyPatch) -> None:
        # 信用卡號 / 到期月份 / 到期年分
        inputs = ["1249190007575069", "12", "2024"]
        # 暫時魔改 builtins.input 函數
        monkeypatch.setattr("builtins.input", lambda _: inputs.pop(0))
        # read_card_info 會使用到 builtins.input 函數 (只要呼叫，我們就把假輸入餵給它)
        card = CreditCard.read_card_info()
        assert card.number == "1249190007575069"
        assert card.expiry_month == 12
        assert card.expiry_year == 2024
    ```
  + 覆蓋環境變數
    ```py
    import os
    import pytest

    def get_secret():
        return os.getenv("SECRET_KEY", "default")

    def test_get_secret(monkeypatch: pytest.MonkeyPatch):
        monkeypatch.setenv("SECRET_KEY", "super-secret")
        assert get_secret() == "super-secret"
    ```


### 內建夾具 : 擷取輸出流 `capsys`

+ 輸出流
  ```py
  import pytest

  def greet():
      print("Hello, pytest!")

  def test_greet(capsys: pytest.CaptureFixture):
      greet()
      captured = capsys.readouterr()
      assert captured.out == "Hello, pytest!\n"
      greet()
      greet()
      captured = capsys.readouterr()
      assert captured.out == "Hello, pytest!\nHello, pytest!\n"
  ```

+ 錯誤流
  ```py
  import pytest
  import sys

  def error():
      print("Error, pytest!", file=sys.stderr)

  def test_error(capsys: pytest.CaptureFixture):
      error()
      captured = capsys.readouterr()
      assert captured.err == "Error, pytest!\n"
  ```

### 內建夾具 : 擷取日誌 `caplog`

  ```py
  import logging
  import pytest

  def log_warning():
      logging.warning("This is a warning!")

  def test_log_warning(caplog: pytest.LogCaptureFixture):
      with caplog.at_level(logging.WARNING):
          log_warning()
      assert "This is a warning!" in caplog.text

      caplog.clear()

      with caplog.at_level(logging.WARNING):
          log_warning()
      assert ('root', 30, 'This is a warning!') in caplog.record_tuples
  ```

### 內建夾具 : 暫時路徑 `tmp_path`
  |📘 <span class="note">NOTE</span>|
  |:---|
  |在 Windows 中，這些暫時目錄或檔案會放在 `%APPDATA%/Local/Temp/pytest-of-user` 中|

  ```py
  from pathlib import Path
  import pytest

  class FileHandler:
      def read_file(self, filename):
          with open(filename, 'r') as file:
              return file.read()

      def write_file(self, filename, content):
          with open(filename, 'w') as file:
              file.write(content)

  def test_file_handling(tmp_path: Path):
      # 
      sub_dir = tmp_path / "tmp_dir"
      sub_dir.mkdir()

      file1 = sub_dir / "file1.txt"
      file2 = sub_dir / "file2.txt"

      handler = FileHandler()
      handler.write_file(file1, "Content of file 1")
      handler.write_file(file2, "Content of file 2")

      assert file1.exists()
      assert file2.exists()

      assert file1.read_text() == "Content of file 1"
      assert file2.read_text() == "Content of file 2"
  ```

### 內建夾具 : 快取 `cache`
  ```py
  import time
  import pytest

  def expensive_calculation():
      time.sleep(2)  # 模擬一個耗時的計算
      return 42

  def test_expensive_calculation(cache: pytest.Cache):
      # 嘗試讀取快取資料
      result = cache.get("expensive_result")
      
      # 如果快取資料不存在，進行計算並快取結果
      if result is None:
          result = expensive_calculation()
          cache.set("expensive_result", result)

      assert result == 42
  ```

### 標記 `mark.?`

  |🚨 <span class="caution">CAUTION</span>|
  |:---|
  |要先在 `pytest.ini` 註冊，方可使用自訂標記|
  
  + **標記自訂 marker**
    ```py
    # in ./tests/test_something.py
    @pytest.mark.database
    def test_database_connection(): # 被標記
        pass

    def test_case_a():
        pass

    @pytest.mark.database
    class TestDatabaseCrud:
        def test_create(self): # 被標記
            pass
        
        def test_read(self): # 被標記
            pass
        
        def test_update(self): # 被標記
            pass
        
        def test_delete(self): # 被標記
            pass
    ```

  + **只選擇有 mark.database 的 test case 進行測試**
    ```bash
    pytest -m database
    ```

### 內建標記 : 條件跳過案例 `mark.skip` / `mark.skipif`

  + **decorator kwargs**
    + `condition` : 條件為真時跳過該 test case
    + `reason` : 跳過測試的原因 (在 verbose 模式會印出來)

  + **example**
    ```py
    # 測試
    @pytest.mark.skip(reason="沒有理由但我就想跳過")
    def test_skip_test_case():
        assert 1 + 1 == 3

    @pytest.mark.skipif(condition=sys.platform == "win32", reason="因為是萬惡 Windows")
    def test_skip_test_case_by_condition():
        assert 1 + 1 == 4
    ```

### 內建標記 : 已預期失敗案例 `mark.xfail`

  + **decorator kwargs**
    + `reason` : 跳過測試的原因 (在 verbose 模式會印出來)

  + **example**
    ```py
    @pytest.mark.xfail(reason="該測試案例目前會失敗，等待 BUG 修復")
    def test_example_xfail():
        assert 2 * 3 == 7
    ```

### 內建標記 : 參數化測試 `mark.parametrize`
  |🚨 <span class="caution">CAUTION</span>|
  |:---|
  |可搭配 fixture 使用，但它一定要裝飾在最靠近函式的地方|

  + **decorator kwargs**
    + `argnames` : 參數名稱
    + `argvalues` : 參數值 (可以有多組值)
    + `ids` : 每個 test case 的名稱

  + **example**
    ```py
    # 算兩個 test case
    @pytest.mark.parametrize(
        argnames="num1, num2, result", 
        argvalues=[(1, 1, 2), (2, 2, 4)]
    )
    def test_add(num1: int, num2: int, result: int):
        assert num1 + num2 == result
        # tests/test_something.py::test_add[1-1-2] PASSED
        # tests/test_something.py::test_add[2-2-4] PASSED
    ```
  + **ids**
    ```py
    test_args = [(1, 1, 2), (2, 2, 4)]

    ids = [f"case: {test_arg[0]} + {test_arg[1]} = {test_arg[2]}" 
           for test_arg in test_args]

    # 算兩個 test case
    @pytest.mark.parametrize(
        argnames="num1, num2, result", 
        argvalues=test_args, ids=ids
    )
    def test_add_with_ids(num1: int, num2: int, result: int):
        assert num1 + num2 == result
        # tests/test_something.py::test_add_with_ids[case: 1 + 1 = 2] PASSED 
        # tests/test_something.py::test_add_with_ids[case: 2 + 2 = 4] PASSED
    ```

### 內建標記 : 使用夾具 `mark.usefixtures`

  基本上功能與 fixture 傳遞引數寫法無異。\
  但通常用在欲使用 fixture 達成 <mark>context management</mark> 的場合，\
  而非使用它的回傳值做用途的場合。\
  上下文順序 : 由左至右、由下至上

  + **context management : fixture + yield**

    ```py
    @pytest.fixture
    def func_1():
        print("setup 1")
        yield
        print("teardown 1")

    @pytest.fixture
    def func_2():
        print("setup 2")
        yield
        print("teardown 2")

    @pytest.fixture
    def func_3():
        print("setup 3")
        yield
        print("teardown 3")

    # 注意上下文順序
    @pytest.mark.usefixtures("func_3")
    @pytest.mark.usefixtures("func_1", "func_2")
    def test_func():
        print("Hello!")
        # setup 1
        # setup 2
        # setup 3
        # Hello!
        # .teardown 3
        # teardown 2
        # teardown 1
    ```

  + **為什麼不用 `setup` / `teardown` 就好？**

    不像 setup / teardown 函數無法傳遞引數，\
    使用 fixture 做 context management 的好處是<mark>可以傳遞引數</mark>。\
    如下，傳遞的引數為 `test_session`
    
    ```py
    @pytest.fixture(scope="session")
    def test_session() -> Session:
        # 建立引擎
        engine_url = "sqlite://"
        engine = create_engine(engine_url)
        # 建立資料表
        Base.metadata.create_all(engine)
        # yield 會話
        with sessionmaker(engine)() as session:
            yield session
        # 刪除資料表
        Base.metadata.drop_all(engine)

    # 我希望每個 test case 結束後都清空所有資料表的資料
    @pytest.fixture(scope="function")
    def clear_tables(test_session: Session) -> None:
        yield
        for _, table in Base.metadata.tables.items():
            test_session.query(table).delete()
        test_session.commit()

    @pytest.mark.usefixtures("clear_tables")
    def test_create_user(test_user: User, test_session: Session):
        result = user_services.create_user(test_user, test_session)
        assert result.id is not None
        assert result.username == test_user.username
        assert result.birthday == test_user.birthday
    ```


# pytest-cov

插件：覆蓋率測試

## References
+ 📑 [**Documentation - pytest-cov**](https://pytest-cov.readthedocs.io/en/latest/index.html)

## Note
|🚨 <span class="caution">CAUTION</span>|
|:---|
|預設的覆蓋率計算方法是<mark>[行數覆蓋 (line coverage)](https://hackmd.io/@RogelioKG/testing#%E7%99%BD%E7%AE%B1%E6%B8%AC%E8%A9%A6-white-box-testing)</mark>|

## CLI

+ **選項**
  ```bash
  pytest --cov=src --cov-report=html:tests/report
  ```
  + `--cov=<path>` : 只根據指定路徑，進行覆蓋率測試 (會產生一個 `.coverage` 檔)
  + `--cov-report=<type>:<path>` : 產生覆蓋率測試報告 (`<type>` 指定格式，如 `html` / `xml`；`<path>` 指定報告輸出目錄)
  + `--cov-config=<path>` : 覆蓋率測試的 config (預設是 `.coveragerc`)
  + `--cov-branch` : 將覆蓋率計算方法設為<mark>分支覆蓋 (branch coverage)</mark>

+ 快速打開覆蓋率測試 HTML 報告 (Windows)
  ```bat
  @echo off
  set "REPORT_PATH=%CD%\tests\report\index.html"
  start chrome %REPORT_PATH%
  ```

## Config

### `.coveragerc`

  ```ini
  [run]
  # .coverage 路徑 (含檔案名稱)
  data_file = tests/.coverage
  # 覆蓋率測試要包含哪些檔案
  include = ...
  # 覆蓋率測試要排除哪些檔案
  omit = ...
  ```


## Usage

### 內建夾具 : 不計入覆蓋率 `no_cover`
無效化某個 test case 所造成的覆蓋
```py
def test_deactivate_user(no_cover):
    user = User("testuser", "test@example.com")
    user.deactivate()
    assert not user.is_active()
```

# pytest-mock

插件：提供 [Stub、Mock、Spy](https://hackmd.io/@RogelioKG/testing#stub--mock--spy) 等功能，擴充自標準庫的 `unittest.mock`


## References
+ 📑 [**Documentation - pytest-mock**](https://pytest-mock.readthedocs.io/en/latest/index.html)


## Usage

### 內建夾具 : Mocker `mocker`

+ `mocekr.Mock` : 建立一個 mock 物件
  + `return_value` : 被呼叫時的回傳值。
  + `spec`
    + 給定 class，此 mock 物件只能使用給定 class 存在的屬性或方法，否則引發 `AttributeError`。
    + 給定 list，此 mock 物件只能使用給定 list 中的屬性或方法，否則引發 `AttributeError`。
  + `side_effect`
    + 給定 function，此 mock 物件被呼叫時，由此函數代為執行。
    + 給定 exception，將引發錯誤
    + 給定 iterable，將其中每個值作為每次呼叫 mock 物件的不同回傳值。

+ `mocekr.MagicMock` : 建立一個 mock 物件 (已事先設定好 magic method)，此類別繼承自 `Mock`

+ `mocker.patch` : 全域補丁一個函式或變數
  ```py
  import os
  from pytest_mock import MockFixture

  class UnixFS:
      @staticmethod
      def rm(filename: str):
          os.remove(filename)

  def test_unix_fs(mocker: MockFixture):
      mock = mocker.patch("os.remove")
      UnixFS.rm("file")
      mock.assert_called_once_with("file")
  ```
+ `mocker.patch.object` : 針對某物件補丁一個方法或屬性
  ```py
  from pytest_mock import MockFixture

  class MyClass:
      def method(self):
          return "real method"

  def test_patch_object(mocker: MockFixture):
      instance1 = MyClass()

      # 這裡補丁的是實例的 __dict__ 內的函數
      mock = mocker.patch.object(instance1, "method", return_value="mocked method")
      assert instance1.method() == "mocked method"

      instance2 = MyClass()
      assert instance2.method() == "real method"
  ```
+ `mocker.patch.multiple` : 針對某物件補丁多個方法或屬性
  ```py
  from pytest_mock import MockFixture

  class MyClass:
      def method1(self):
          return "real method1"

      def method2(self):
          return "real method2"

  def test_patch_multiple(mocker: MockFixture):
      instance = MyClass()

      # 類別自身也是一個物件，這裡補丁的是類別的 __dict__ 內的函數
      mock = mocker.patch.multiple(
          MyClass,
          method1=lambda self: "mocked method1",
          method2=lambda self: "mocked method2",
      )

      assert instance.method1() == "mocked method1"
      assert instance.method2() == "mocked method2"
  ```
+ `mocker.patch.dict` : 特別針對字典補丁 (採用 update，常用於環境變數)
  ```py
  import os
  from pytest_mock import MockFixture

  os.environ["MY_ENV_VAR"] = "value"

  def test_patch_dict(mocker: MockFixture):
      mock = mocker.patch.dict("os.environ", {"MY_MOCK_ENV_VAR": "mocked_value"})

      # 原本的環境變數並沒有不見 (若使用 mocker.patch 會讓整個字典直接被換掉)
      assert os.environ["MY_ENV_VAR"] == "value"
      assert os.environ["MY_MOCK_ENV_VAR"] == "mocked_value"
  ```
+ `mocker.stop` : 停止一個 mock 物件的功能
  ```py
  from pytest_mock import MockFixture

  class MyClass:
      def method(self):
          return "real method"

  def test_stop(mocker: MockFixture):
      instance = MyClass()
      
      # Mock method
      mock = mocker.patch.object(instance, "method", return_value="mocked method")
      assert instance.method() == "mocked method"  # 🚩 被 mock 了

      # 停止 mock，恢復原始行為
      mocker.stop(mock)
      assert instance.method() == "real method"  # ✅ 回到原本的方法
  ```
+ `mocker.stopall` : 停止所有 mock 物件的功能
  ```py
  import os
  import pytest
  from pytest_mock import MockFixture

  os.environ["MY_ENV_VAR"] = "value"

  class MyClass:
      def method(self):
          return "real method"

  def test_stop_all(mocker: MockFixture):
      mock1 = mocker.patch.dict("os.environ", {"MY_MOCK_ENV_VAR": "mocked_value"})
      mock2 = mocker.patch.object(MyClass, "method", return_value="mock method")

      instance = MyClass()

      assert os.environ["MY_ENV_VAR"] == "value"
      assert os.environ["MY_MOCK_ENV_VAR"] == "mocked_value"
      assert instance.method() == "mock method"

      mocker.stopall()

      with pytest.raises(KeyError) as err:
          os.environ["MY_MOCK_ENV_VAR"]
      assert err.typename == "KeyError"

      assert instance.method() == "real method"
  ```
+ `mocker.spy` : spy 功能 (僅做監控不做替代，MUT 的原功能仍會執行)
  ```py
  from pytest_mock import MockFixture

  class Foo:
      def bar(self, v):
          return v * 2

  def test_spy_method(mocker: MockFixture):
      foo = Foo()
      spy = mocker.spy(foo, 'bar')
      assert foo.bar(21) == 42

      spy.assert_called_once_with(21)
      assert spy.spy_return == 42
  ```
+ `mocker.stub` : stub 功能 (常用於頂替 callback)
  ```py
  from typing import Callable
  from pytest_mock import MockerFixture

  class EventHandler:
      def __init__(self):
          self.callbacks: list[Callable[[str], None]] = []  # 存放所有 callback

      def register_callback(self, callback: Callable[[str], None]):
          """ 註冊 callback 到列表 """
          self.callbacks.append(callback)

      def trigger_event(self, data: str):
          """ 觸發事件時，依序呼叫所有已註冊的 callback """
          for callback in self.callbacks:
              callback(data)

  def test_event_handler_calls_all_callbacks(mocker: MockerFixture):
      handler = EventHandler()
      mock_callback_1 = mocker.stub("callback_1")
      mock_callback_2 = mocker.stub("callback_2")

      handler.register_callback(mock_callback_1)
      handler.register_callback(mock_callback_2)

      handler.trigger_event("test_event")

      # ✅ 確保所有 callback 都有被呼叫
      mock_callback_1.assert_called_once_with("test_event")
      mock_callback_2.assert_called_once_with("test_event")
  ```

+ `mocker.mock_open` : 模擬 `builtins.open` 的行為 (讓我們在測試時，不須去讀寫檔案)
  ```py
  def read_file(filepath: str) -> str:
      with open(filepath, "r", encoding="utf-8") as f:
          return f.read()

  def test_read_file(mocker):
      # 模擬 open() 回傳 'Hello, World!' 這個檔案內容
      mock_open = mocker.mock_open(read_data="Hello, World!")
      mocker.patch("builtins.open", mock_open)

      # 測試函式是否正確讀取內容
      result = read_file("fake_file.txt")
      assert result == "Hello, World!"

      # 確保 open() 被正確呼叫
      mock_open.assert_called_once_with("fake_file.txt", "r", encoding="utf-8")
  ```

+ mock 物件
  + 每種 `mocker.?` 都會回傳一個 mock 物件
  + 你可以藉由這個 mock 物件，進行監控、停止功能等操作。
  + 方法
    | method | description |
    |------|------|
    | `mock.assert_called()` | 確保 mock 物件至少被呼叫一次 |
    | `mock.assert_called_once()` | 確保 mock 物件只被呼叫一次 |
    | `mock.assert_called_with(*args, **kwargs)` | 確保 mock 物件最後一次呼叫的參數符合 |
    | `mock.assert_called_once_with(*args, **kwargs)` | 確保 mock 物件只被呼叫一次，且參數完全匹配 |
    | `mock.assert_any_call(*args, **kwargs)` | 確保 mock 物件至少有一次以該參數呼叫 |
    | `mock.assert_has_calls([call(*args, **kwargs), call(*args, **kwargs), ...], any_order=False)` | 確保 mock 物件有一組特定的呼叫序列，可選擇順序是否無關。記得 `from unittest.mock import call`！ |
    | `mock.assert_not_called()` | 確保 mock 物件從未被呼叫過 |
    | `mock.assert_call_count(n)` | 確保 mock 物件被呼叫 `n` 次 |


## Note

### dependency injection

```py
# src/payment.py

class PaymentGateway:
    def process_payment(self, amount):
        # 模擬實際的付款邏輯，例如呼叫第三方 API
        return f"Processed payment of {amount}"
```

```py
# src/order.py
from src.payment import PaymentGateway

class OrderService:
    def __init__(self, payment_gateway: PaymentGateway):
        self.payment_gateway = payment_gateway

    def create_order(self, amount):
        return self.payment_gateway.process_payment(amount)
```

```py
# tests/test_order.py
from pytest_mock import MockerFixture
from src.order import OrderService

def test_order_service_with_dependency_injection(mocker: MockerFixture):
    # 創建一個模擬的 PaymentGateway
    mock_payment_gateway = mocker.MagicMock()
    
    # 設定 mock 的行為
    mock_payment_gateway.process_payment = mocker.Mock(return_value="Mocked payment processed")

    # 注入 mock 到 OrderService
    order_service = OrderService(mock_payment_gateway)

    # 調用服務方法
    result = order_service.create_order(100)

    # 驗證
    mock_payment_gateway.process_payment.assert_called_once_with(100)
    assert result == "Mocked payment processed"
```

### non-dependency injection

+ case 1 : MUT 使用到了外部依賴
  ```py
  # src/payment.py

  class PaymentGateway:
      def process_payment(self, amount):
          # 模擬實際的付款邏輯，例如呼叫第三方 API
          return f"Processed payment of {amount}"
  ```

  ```py
  # src/order.py
  from src.payment import PaymentGateway

  class OrderService:
      def create_order(self, amount):
          payment_gateway = PaymentGateway()  # 內部創建 PaymentGateway 實例
          return payment_gateway.process_payment(amount)
  ```

  ```py
  # tests/test_order.py
  from pytest_mock import MockerFixture
  from src.order import OrderService

  def test_order_service_with_non_dependency_injection(mocker: MockerFixture):
      # 使用 mocker.patch 來模擬 PaymentGateway 的方法
      mock_process_payment = mocker.patch("src.order.PaymentGateway.process_payment", return_value="Mocked payment processed")

      # 創建 OrderService 並調用 create_order 方法
      order_service = OrderService()
      result = order_service.create_order(100)

      # 驗證
      mock_process_payment.assert_called_once_with(100)
      assert result == "Mocked payment processed"
  ```

  |🚨 <span class="caution">CAUTION</span>|
  |:---|
  |當 SUT 採用 `from A import B` 使用外部依賴時，<br />`mocker.patch` 的路徑應填上 `"SUT_path.B"`，<br />否則會導致 SUT 沒有使用到你設定好的 mock 物件！|

+ case 2 : MUT 呼叫了 SUT 內的另一個方法

  ```py
  class OrderService:
      def create_order(self, amount):
          if amount <= 0:
              raise ValueError("Amount must be greater than zero")
          return self._process_payment(amount)

      def _process_payment(self, amount):
          # 模擬實際的付款邏輯，例如呼叫第三方 API
          return f"Processed payment of {amount}"
  ```

  ```py
  import pytest

  def test_create_order_with_mocked_internal_method(mocker):
      order_service = OrderService()

      # 使用 mocker.patch.object 來 mock _process_payment 方法
      mock_process_payment = mocker.patch.object(order_service, "_process_payment", return_value="Mocked payment processed")

      # 執行帶測方法
      result = order_service.create_order(100)

      # 驗證內部方法是否被呼叫，並且返回 mock 值
      mock_process_payment.assert_called_once_with(100)
      assert result == "Mocked payment processed"
  ```