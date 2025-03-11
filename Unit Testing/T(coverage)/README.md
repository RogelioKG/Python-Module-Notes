# coverage

### 參考
+ 🔗 [**利用 Coverage 計算 Python 程式碼的涵蓋率**](https://kkboxsqa.wordpress.com/2014/05/11/%E5%88%A9%E7%94%A8-coverage-%E8%A8%88%E7%AE%97-python-%E7%A8%8B%E5%BC%8F%E7%A2%BC%E7%9A%84%E6%B6%B5%E8%93%8B%E7%8E%87/)

### `.coverage`

  ```ini
  [run]
  data_file = ...   ; .coverage 位置
  include = ...     ; 測試要包含哪些檔案
  omit = ...        ; 測試要排除哪些檔案
  ```

### 命令列

1. 先進到專案的頂層目錄

2. 運行測試程式
    > 會產生一個 `.coverage` 檔案

    + unittest 框架
        ```bash
        coverage run -m unittest discover
        ```

    + pytest 框架
        ```bash
        coverage run -m pytest
        ```

3. 涵蓋率
    > 根據 `.coverage` 所記錄的測試結果，顯示涵蓋率結果
    ```bash
    coverage report -m
    ```

1. 產生精美 HTML 報告
    > 根據 `.coverage` 所記錄的測試結果，產生一個 `htmlcov` 的目錄，裡面包含測試結果的詳盡 html 文檔
    ```bash
    coverage html
    ```
