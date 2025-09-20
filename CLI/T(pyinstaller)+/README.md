# pyinstaller

## References

## Note
|📘 <span class="note">NOTE</span>|
|:---|
| 頂層目錄會產生 `dist` 目錄，裡面就可以找到打包結果 |

## Packaging

### `--onedir` 模式
+ 打包結果
  + <mark>一個大目錄</mark>
    + <mark>一個小執行檔</mark> (bootloader)
    + <mark>一個 `_internal` 目錄</mark>
      + Python 標準庫、第三方庫 (`library.zip`)
      + 資源 (`--add-data` 自行指定)
      + 動態庫
          + Python runtime (`pythonXY.dll`)
          + OS 相關 DLL

### `--onefile` 模式
+ 打包結果
  + <mark>一個大執行檔</mark> (含 `_internal` 目錄壓縮檔，執行時將其解壓縮至 `%TEMP%/_MEIxxxxxx` 目錄，利用它載入應有環境、資源)

### 注意
+ `sys._MEIPASS`
  + 代表打包後 `_internal` 目錄的路徑
  + 會在 bootloader 載入 Python runtime 前設置好
  + 使用資源路徑時，應考慮未打包和已打包情況
    ```py
    def resource_path(relative_path: str) -> str:
        """取得資源路徑"""
        if hasattr(sys, "_MEIPASS"):  # 已打包時
            base_path = getattr(sys, "_MEIPASS")  # noqa: B009
        else: # 未打包時
            base_path = os.path.abspath(".")
        return os.path.join(base_path, relative_path)
    ```

## Options

+ `-F` | `--onefile` 打包成執行檔

+ `-D` | `--onedir` 打包成目錄

+ `-n` | `--name` 執行檔命名 (預設：主程式檔名)

+ `-c` | `--console` 執行檔運行後，顯示命令行介面 (預設)

+ `-w` | `--windowed` 執行檔運行後，隱藏命令行介面

+ `-i` | `--icon` 自訂執行檔 icon

+ `--add-data` 打包時添加資源 (添加至 `_internal` 目錄)
    ```bash
    pyinstaller --onefile main.py --add-data "resources/images;resources/images"
    ```