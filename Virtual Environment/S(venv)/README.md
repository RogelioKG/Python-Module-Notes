# venv

### 參考
+ 🔗 [**Python Documentation**](https://docs.python.org/zh-tw/3/tutorial/venv.html#creating-virtual-environments)

### 說明
venv 屬於<mark>標準函式庫</mark>的一個模組，放在 `"~\Python\Python3x\Lib"` (是 sys.path 的其中一個路徑)。\
它是使用 Python 腳本的寫法建立虛擬環境。


### 注意
|☢️ <span class="warning">WARNING</span>|
|:---|
|venv <mark>不會</mark>自動生成 `.gitignore` 檔案|

### 新建虛擬環境

>在當前目錄新增一個子目錄 `.venv`，並在裡面建立虛擬環境相關檔案。\
>`.venv` 是 Python 官方文檔中建議之命名。
1. 使用如下方式新建虛擬環境
   ```
   py -m venv .venv
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
include-system-site-packages = false
version = 3.11.4
executable = C:\Users\user\AppData\Local\Programs\Python\Python311\python.exe
command = C:\Users\user\AppData\Local\Programs\Python\Python311\python.exe -m venv D:\ROGELIO-256-backup\Programs\Languages\Python\Modules\Virtual Environment\(venv)\.venv
```

1. `home`
   > **指定虛擬環境使用的 Python 的目錄。**

2. `include-system-site-packages`
   > **指定是否在虛擬環境中包含全域 Python 的 site-packages 目錄 (第三方模組)。**

3. `version`
   > **指定虛擬環境使用的 Python 版本。**

4. `executable`
   > **指定虛擬環境使用的 Python 直譯器的執行檔位置。**

5. `command`
   > **建立虛擬環境時使用的命令。**
