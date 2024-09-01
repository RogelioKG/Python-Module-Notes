# pytest

[![RogelioKG/pytest](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/pytest)

### 參考
+ 🔗 [**Documentation - Pytest**](https://docs.pytest.org/en/7.4.x/)
+ 🔗 [**拾遺 - Python 測試入門 - 開始使用 PyTest**](https://blog.tzing.tw/posts/python-testing-pytest-08de903a)
+ 🔗 [**CSDN - pytest.ini**](https://blog.csdn.net/Moonlight_16/article/details/122706934)
+ 🔗 [**IT 邦 - Python 與自動化測試的敲門磚**](https://ithelp.ithome.com.tw/users/20144024/ironman/5372)
+ 🔗 [**知乎 - Pytest fixture 及 conftest 详解**](https://zhuanlan.zhihu.com/p/564168267)
+ 🔗 [**Pytest With Eric - Ultimate Guide To Pytest Markers And Good Test Management**](https://pytest-with-eric.com/pytest-best-practices/pytest-markers/)
+ 🔗 [**Pytest With Eric - What Is pytest.ini And How To Save Time Using Pytest Config**](https://pytest-with-eric.com/pytest-best-practices/pytest-ini/)
+ 🎞️ [**ArjanCodes - How To Write Unit Tests For Existing Python Code // Part 1 of 2**](https://youtu.be/ULxMQ57engo?si=lhBSt6jt0NFBXTAS)
+ 🎞️ [**ArjanCodes - How To Write Unit Tests For Existing Python Code // Part 2 of 2**](https://youtu.be/NI5IGAim8XU?si=MxcKvp_wooG7H3oF)

### 待深入主題
  + [ ] pytest.ini
  + [ ] TDD (測試驅動開發)

### 注意

|🔮 <span class="important">IMPORTANT</span>|
|:---|
|1. 放置在 `test` / `tests` 目錄內|
|2. 模組名稱為 `test_*.py`|

|☢️ <span class="warning">WARNING</span>|
|:---|
|1. 測試目錄與被測試目錄皆要有 `__init__.py`|
|2. 測試目錄路徑不可有<mark>**不合法名稱**</mark> (比如有<mark>**中括號**</mark> [] 的名稱，會被誤當成 .ini 的 section)。<br>否則會產生錯誤 `OSError: Starting path not found`。|
|3. 測試目錄路徑若有任一<mark>**目錄改過名稱**</mark>，請務必<mark>**清除測試目錄底下的`__pycache__`**</mark>。<br>否則會產生錯誤 `OSError: Starting path not found`。|
|4. TestClass 的第一個引數都要是 self，就如同在寫一般 class 一樣。|


### 命令列

+ **直接測試**

  ```bash
  pytest
  ```
  > **選擇性參數**
  > + `--markers`：查看所有已登記的 markers
  > + `--fixtures`：查看所有已登記的 fixtures
  > + `-h`：參數說明 (help)
  > + `-v`：詳細結果 (verbose)
  > + `-q`：簡潔結果 (quiet)
  > + `-s`：允許 stdout / stderr 印出 (會打亂 pytest 測試結果輸出格式)

+ **針對測試**

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
  + <span style="color: #719926;">`.`</span> / <span style="color: #719926;">`PASSED`</span>：代表一個通過的 test case
  + <span style="color: #aead2a;">`s`</span> / <span style="color: #aead2a;">`SKIPPED`</span>：代表一個跳過的 test case
  + <span style="color: #aead2a;">`x`</span> / <span style="color: #aead2a;">`XFAILED`</span>：代表一個已預期失敗 (等待修復) 的 test case
  + <span style="color: #d3618b;">`F`</span> / <span style="color: #d3618b;">`FAILED`</span>：代表一個失敗的 test case
  + `[80%]`：代表的是總完成進度 (百分比)
  


### `pytest.ini`

+ **註冊自訂 marker**
  ```ini
  [pytest]
  markers =
      database: mark test as database. ; 註冊並說明這個 marker 的用途
  ```



### `conftest.py`

+ **說明**
  1. 其中的 fixture 可跨模組使用。有效範圍：當前目錄及其子目錄中的 test case 都可以使用，<mark>**無須 import**</mark>。
  2. 可在此自訂命令列的選擇性參數

+ **範例**

  + `conftest.py`
    ```py
    # 1. 全域作用 fixture
    @pytest.fixture(scope="function", name="test_data_lol")
    def test_data() -> dict[str, int]:
        data = {"a": 1, "b": 2, "c": 3}
        return data

    # 2. 自訂選擇性參數 (一定要放在 conftest.py)
    def pytest_addoption(parser: pytest.Parser):
        """"自訂一個命令列的選擇性參數"""
        parser.addoption(
            "--env", default="test", choices=["dev", "test", "pre"], help="enviroment parameter")
    ```

  + `test_something.py`
    ```py
    def update_a(data: dict[str, int], n: int) -> None:
        data["a"] += n

    # 1. 全域作用 fixture
    def test_update_a_plus_1(test_data_lol: dict[str, int]):
        update_a(test_data_lol, 1)
        assert test_data_lol["a"] == 2

    # 2. 自訂選擇性參數
    def test_option(pytestconfig: pytest.Config):
        print("the current environment is:", pytestconfig.getoption("env"))
    ```



### 使用指南

+ **斷言驗證**
  ```py
  def test_demo():
      assert 1 + 1 == 2
  ```

+ **錯誤驗證 `raises`**
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

+ **資源初始化與釋放 `setup` / `teardown`**
  > 缺點：無法接受引數
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

+ **輸入模擬 `MonkeyPatch`**
  > 猴子補丁
  ```py
  def test_card(monkeypatch: pytest.MonkeyPatch) -> None:
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

+ **夾具 `fixture`**

  + 裝飾器參數
    + [`scope`](https://www.cnblogs.com/yoyoketang/p/9762197.html)：作用域，預設為 "function"
    + `name`：參數調用名稱，預設為函式名稱
    + `autouse`：是否自動進行使用，預設為 False (根據 scope 而定，如果 scope="function"，那你不需傳遞引數就會自動調用)
    + `params`：參數化測試，應給定 list[dict[str, Any]]

  + 必要應用場景
    > Q：為何使用 fixture 而不使用 global variable？全域變數寫起來不是更簡單嗎？

    > A：如下例，若 `test_data` 為全域變數，就會造成 `test_data` 通過第一個 test case 後反而無法通過之後的 test case。\
    > 很明顯，`test_data` 需要在每個 test case 執行前重新建立一遍。`fixture(scope="function")` 因而派上用場。

    ```py
    def update_a(data: dict[str, int], n: int) -> None:
        data["a"] += n

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

+ **內建標記：條件跳過案例 `mark.skip` / `mark.skipif`**

  + 裝飾器參數
    + `condition`：條件為真時跳過該 test case
    + `reason`：跳過測試的原因 (在 verbose 模式會印出來)

  + 範例
    ```py
    @pytest.mark.skip(reason="測試案例跳過範例")
    def test_skip_test_case():
        assert 1 + 1 == 3

    @pytest.mark.skipif(condition=sys.platform == "win32", reason="測試跳過指定條件範例")
    def test_skip_test_case_by_condition():
        assert 1 + 1 == 4
    ```

+ **內建標記：已預期失敗案例 `mark.xfail`**

  + 裝飾器參數
    + `reason`：跳過測試的原因 (在 verbose 模式會印出來)

  + 範例
    ```py
    @pytest.mark.xfail(reason="該測試案例目前會失敗，等待 BUG 修復")
    def test_example_xfail():
        assert 2 * 3 == 7
    ```

+ **內建標記：參數化測試 `mark.parametrize`**
  |🚨 <span class="caution">CAUTION</span>|
  |:---|
  |可搭配 fixture 使用，但它一定要放在函式簽名的最後面|

  + 裝飾器參數
    + `argnames`：參數名稱
    + `argvalues`：參數值 (可以有多組值)
    + `ids`：每個 test case 的名稱

  + 簡單範例
    ```py
    # 算兩個 test case
    @pytest.mark.parametrize(argnames="num1, num2, result", argvalues=[(1, 1, 2), (2, 2, 4)])
    def test_add(num1: int, num2: int, result: int):
        assert num1 + num2 == result
        # tests/test_something.py::test_add[1-1-2] PASSED
        # tests/test_something.py::test_add[2-2-4] PASSED
    ```
  + ids
    ```py
    test_args = [(1, 1, 2), (2, 2, 4)]

    ids = [f"case: {test_arg[0]} + {test_arg[1]} = {test_arg[2]}" for test_arg in test_args]

    # 算兩個 test case
    @pytest.mark.parametrize(argnames="num1, num2, result", argvalues=test_args, ids=ids)
    def test_add_with_ids(num1: int, num2: int, result: int):
        assert num1 + num2 == result
        # tests/test_something.py::test_add_with_ids[case: 1 + 1 = 2] PASSED 
        # tests/test_something.py::test_add_with_ids[case: 2 + 2 = 4] PASSED
    ```

+ **內建標記：使用夾具 `mark.usefixtures`**
    > 基本上功能與 fixture 傳遞引數寫法無異。\
    > 但通常用在欲使用 fixture 達成上下文管理，而非使用它的回傳值做用途的場合。\
    > 上下文的進入順序：傳遞引數由左至右 -> usefixtures 由下至上

    + 上下文管理：fixture + yield
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
      @pytest.mark.usefixtures("func_1", "func_2", "func_3")
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

  + 可傳遞引數的 setup / teardown
    > 不像 setup / teardown 函數無法傳遞引數，使用 fixture 做上下文管理的好處是可以傳遞引數。\
    > 如下範例，傳遞的引數為 test_session
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

  + autouse
    > scope="function" 的 autouse 會讓模組內的 test case 自動使用 clear_tables。\
    > 如果有非常多的 test cases，就不須每個都套上裝飾器。
    ```py
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

+ **自訂標記：`mark.*`**

  + 註冊自訂 marker
    ```ini
    # in ./pytest.ini
    [pytest]
    markers =
        database: mark test as database. ; 註冊並說明這個 marker 的用途
    ```
  + 標記自訂 marker
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

  + 只選擇有 mark.database 的 test case 進行測試
    ```bash
    pytest -m database
    ```
