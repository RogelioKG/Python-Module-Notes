# pyinstaller

### 參考

### 注意
|📘 <span class="note">NOTE</span>|
|:---|
|生成的 dist 資料夾中找到 freeze executable|

### 選項

+ `-F` | `--onefile` 打包成單執行檔 (適合小檔)
    ```bat
    pyinstaller -F main.py
    ```

+ `-D` | `--onedir` 打包成多個文件 (適合框架程式)
    ```bat
    pyinstaller -D main.py
    ```

+ `-n` | `--name` 執行檔命名 (預設：主程式檔名)

+ `-c` | `--console` 執行檔運行後，顯示命令行介面 (預設)

+ `-w` | `--windowed` 執行檔運行後，隱藏命令行介面

+ `-i` | `--icon` 自訂執行檔 icon

    ```bat
    pyinstaller -F main.py --icon=main.ico
    ```

+ `--splash` 添加啟動畫面