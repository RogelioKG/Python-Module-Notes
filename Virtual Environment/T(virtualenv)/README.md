# virtualenv

### 參考
+ 🔗 [**Python Documentation**](https://docs.python.org/zh-tw/3/tutorial/venv.html#creating-virtual-environments)

### 簡介
virtualenv 屬於<mark>第三方套件</mark>，是一個執行檔，放在 `"~\Python\Python3x\Scripts"` (`sys.path` 的其中一個路徑)。\
較推薦使用這個方式建立虛擬環境。


### 注意
|☢️ <span class="warning">WARNING</span>|
|:---|
|virtualenv <mark>會</mark>自動生成 `.gitignore` 檔案|

### 新建虛擬環境
> 在當前目錄新增一個子目錄 `.venv`，並在裡面建立虛擬環境相關檔案。\
> `.venv` 是 Python 官方文檔中建議之命名。

1. 因為和 `pip.exe` 一樣，放在 `"~\Python\Python3x\Scripts"`。因此若有將該路徑環境變數 Path，可直接調用：

   ```
   virtualenv .venv
   ```

2. 但若你的本機上有安裝多版本 Python，最好需詳細指定使用哪個 Python 版本的 virtualenv：

   ```
   virtualenv .venv --python=python3.12
   ```

   或者

   ```
   py -3.12 -m virtualenv .venv
   ```


### 進入虛擬環境

In Windows : 
```
.venv\Scripts\activate
```

In Unix or MacOS : 
```bash
source .venv/bin/activate
```


### 離開虛擬環境

```
deactivate
```


### pyvenv.cfg
```
home = C:\Users\user\AppData\Local\Programs\Python\Python311
implementation = CPython
version_info = 3.11.4.final.0
virtualenv = 20.24.3
include-system-site-packages = false
base-prefix = C:\Users\user\AppData\Local\Programs\Python\Python311
base-exec-prefix = C:\Users\user\AppData\Local\Programs\Python\Python311
base-executable = C:\Users\user\AppData\Local\Programs\Python\Python311\python.exe
```

1. `home`
   > **指定虛擬環境中使用的 Python 的目錄。**

2. `implementation`
   > **指定 Python Interpreter 的實作。**

3. `version_info`
   > **指定虛擬環境使用的 Python 版本。**

4. `virtualenv`
   > **指定虛擬環境的 virtualenv 工具的版本。**

5. `include-system-site-packages`
   > **指定是否在虛擬環境中包含全域 Python 的 site-packages 目錄 (第三方模組)。**

6. `base-prefix`
   > **指定全域 Python 目錄。**

7. `base-exec-prefix`
   > **指定全域 Python 執行檔目錄。**

8. `base-executable`
   > **指定全域 Python 執行檔位置。**
