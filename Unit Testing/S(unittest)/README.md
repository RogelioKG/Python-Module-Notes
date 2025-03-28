# unittest

### 參考
+ 🔗 [**Documentation - unittest**](https://docs.python.org/zh-tw/3/library/unittest.html)
+ 🔗 [**OpenHome - 使用 unittest 進行單元測試**](https://openhome.cc/Gossip/CodeData/PythonTutorial/UnitTestPy3.html)
+ 🔗 [**灣區筆記 Bay Area Notes**](https://bayareanotes.com/python-unittest/)
+ 🔗 [**拾遺 - Python 測試入門 - 使用 unittest**](https://blog.tzing.tw/posts/python-testing-use-builtin-unittest-19e9cbe4)

### 提醒

+ **unittest 模組主要包括四個部份**

  1. 測試案例 (test case)：測試的最小單元。
  2. 測試設備 (test fixture)：執行一或多個測試前必要的預備資源，以及相關的清除資源動作。
  3. 測試套件 (test suite)：一組測試案例、測試套件或者是兩者的組合。
  4. 測試執行器 (test runner)：負責執行測試並提供測試結果的元件。

### 命令列

  + **運行測試**

    + **選擇性參數**
      + `-v`：詳細模式 (verbose)

    + 腳本執行
      ```bash
      py test_module1.py
      ```

    + 模組執行
      ```bash
      py -m unittest tests.test_module1 tests.test_module2
      py -m unittest tests.test_module.TestClass
      py -m unittest tests.test_module.TestClass.test_method
      ```

    + 全數執行 (我們將所有測試模組都放在 test 目錄)
      ```bash
      py -m unittest discover test
      ```


### 範例

  + **測試案例**

    應繼承 `unittest.TestCase`
    ```py
    class TextTestCase(unittest.TestCase):
        def setUp(self): # called before every test method
            self.string = "hello"

        def tearDown(self): # called after every test method
            self.string = None

        def test_cap(self):
            expected = "Hello"
            result = text.cap(self.string)
            self.assertEqual(expected, result)
    ```

  + **斷言函數 `assert~()`**

    檢查待測函數的輸出是否符合預期
    ```py
    self.assertEqual()
    self.assertNotEqual()
    self.assertTrue()
    self.assertFalse()
    self.assertIs()
    self.assertIsNot()
    self.assertIn()
    self.assertNotIn()
    self.assertRaises()
    ```