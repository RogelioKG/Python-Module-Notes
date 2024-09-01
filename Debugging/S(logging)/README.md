# logging

### 參考
+ 🔗 [**Python Documentation**](https://docs.python.org/zh-tw/3/library/logging.html)
+ 🔗 [**Medium : Python Logging 日誌**](https://zx7978123.medium.com/python-logging-`%E6`%97`%A5`%E8`%AA`%8C`%E7`%AE`%A1`%E7`%90`%86`%E6`%95`%99`%E5`%AD`%B8-60be0a1a6005)
+ 🔗 [**Leon H. : Python Log 從小白到入門**](https://editor.leonh.space/2022/python-log/#google_vignette)
+ 🔗 [**zhung : Python 中的 Log 利器 - 使用 logging 模組來整理 print 訊息**](https://zhung.com.tw/article/python%E4%B8%AD%E7%9A%84log%E5%88%A9%E5%99%A8-%E4%BD%BF%E7%94%A8logging%E6%A8%A1%E7%B5%84%E4%BE%86%E6%95%B4%E7%90%86print%E8%A8%8A%E6%81%AF/)
+ 🎞️ [**ArjanCodes : Python Logging - How to Write Logs Like a Pro!**](https://youtu.be/pxuXaaT1u3k?si=1u3hSOkBmrGMYKnB)

### 訊息級別
![level](https://miro.medium.com/v2/resize:fit:828/format:webp/1*hMF19zhaww4FrjUObroByw.png)
```py
print(logging.NOTSET)    # 0
print(logging.DEBUG)     # 10
print(logging.INFO)      # 20
print(logging.WARNING)   # 30
print(logging.ERROR)     # 40
print(logging.CRITICAL)  # 50
```
```py
print(logging.getLevelName(0))   # NOTSET (最不嚴重)
print(logging.getLevelName(10))  # DEBUG
print(logging.getLevelName(20))  # INFO
print(logging.getLevelName(30))  # WARNING
print(logging.getLevelName(40))  # ERROR
print(logging.getLevelName(50))  # CRITICAL (最嚴重)
```

### Logger

+ **`root` logger**
    > 第一個範例未做任何設定的 logging，我們操作的是一個稱為 `root` 的 logger。\
    > logger 預設只輸出 warning 及比 warning 更嚴重的訊息。

    ```py
    logging.debug("debug message")
    logging.info("info message")
    logging.warning("warning message")
    logging.error("error message")
    logging.critical("critical message")

    # 輸出結果
    # warning message
    # error message
    # critical message
    ```

+ `dev_logger` logger
    >第二個範例我們用 `getLogger()` 函式建立了另一個 `dev_logger`，後面的設定也都是基於這個新的 `dev_logger`。\
    >我們可以利用 logger 的機制建立無數個 logger，每個 logger 都可以有自己的組態，\
    >例如儲存到不同的檔案，或者不同的輸出的格式等等。\
    >雖然 `root` logger 也是可以被做設定的，但個人建議另外建立自己的 logger 再把它變成自己喜歡的形狀，\
    >而不要去更動 `root` logger 的行為，避免無意中改掉專案內依賴套件的 logger 行為。

    |📗 <span class="tip">TIP</span>|
    |:---|
    |如果你在煩惱 logger 要取什麼名字，一個常見的慣例就是直接使用 `__name__` 變數|

    ```py
    dev_logger = logging.getLogger(name="dev")
    dev_logger.setLevel(logging.DEBUG)

    handler = logging.StreamHandler()
    dev_logger.addHandler(handler)

    dev_logger.debug("debug message")
    dev_logger.info("info message")
    dev_logger.warning("warning message")
    dev_logger.error("error message")
    dev_logger.critical("critical message")

    # 輸出結果
    # warning message
    # error message
    # critical message
    ```
+ **樹狀結構**
    > 利用 `.` 定義 logger 的父子關係。<mark>**一個 logger 在記錄訊息時，其父 logger 也會記錄該訊息**</mark>。

    ```py
    main_logger = logging.getLogger("main")
    sub_logger = logging.getLogger("main.sub") # 父子關係
    sub_logger = main_logger.getChild("sub") # 也可以這樣使用
    ```
    ```mermaid
    flowchart TD
        1(["main.sub1.branch1"])
        2(["main.sub1"])
        3(["main.sub1.branch2"])
        4(["main"])
        5(["main.sub2.dev1"])
        6(["main.sub2"])
        7(["main.sub2.dev2"])

        4 --> 2 & 6
        2 --> 1 & 3
        6 --> 5 & 7

        classDef Green fill:#1b400d
        class 1,2,3,4,5,6,7,8,9 Green
        classDef white color:#e3e3e3
        class 1,2,3,4,5,6,7,8,9 White
    ```
### Handler
>在 logging 模組的 handler 負責處理 log 訊息的輸出工作，例如輸出到螢幕上或者某個檔案內，\
>而上述第二個範例使用了 `StreamHandler` 這個 logging 模組內預帶的 handler。\
>`StreamHandler` 在不加任何參數的情況下，會把訊息輸出到 stderr，\
>在作業系統未做額外的配置下，stderr 可以簡單的理解為顯示到螢幕上。\
>值得一提的是，一個 logger 可以加上數個 handler，\
>意即 dev_logger 除了加入一個 `StreamHandler` 外，你還可以再定義其他的 handler，\
>例如一個 `FileHandler`，如此一則 log 訊息就會被顯示在螢幕上以及被存到某個 log 檔內。


### Formatter
|格式|描述|
|---|---|
|`%(asctime)s`         |建立 log 時間|
|`%(created)f`         |建立 log 的 Unix 時間|
|`%(filename)s`        |發出 log 的程式檔名|
|`%(funcName)s`        |發出 log 的函式名|
|`%(levelname)s`       |log 的級別|
|`%(levelno)s`         |log 的級別數字|
|`%(lineno)d`          |發出 log 的行號|
|`%(message)s`         |log 的訊息內容|
|`%(module)s`          |發出 log 的模組名稱|
|`%(msecs)d`           |建立 log 時間的毫秒部份|
|`%(name)s`            |發出 log 的 logger 名稱|
|`%(pathname)s`        |發出 log 的程式的路徑|
|`%(process)d`         |發出 log 的程序的 ID|
|`%(processName)s`     |發出 log 的程序名稱|
|`%(relativeCreated)d` |log 從創建到發出的毫秒時間差|
|`%(thread)d`          |發出 log 的線程 ID|
|`%(threadName)s`      |發出 log 的線程名稱|

```py
dev_logger = logging.getLogger(name="dev")
dev_logger.setLevel(logging.DEBUG)
handler = logging.FileHandler("test.log")
formatter = logging.Formatter("[%(asctime)s][%(name)s][%(levelname)s] - %(message)s", datefmt="%Y-%m-%d %H:%M:%S")
handler.setFormatter(formatter)
dev_logger.addHandler(handler)

dev_logger.debug("debug message")
dev_logger.info("info message")
dev_logger.warning("warning message")
dev_logger.error("error message")
dev_logger.critical("critical message")

# 輸出結果
# [2024-01-30 19:34:42,285][dev][DEBUG] - debug message
# [2024-01-30 19:34:42,285][dev][INFO] - info message
# [2024-01-30 19:34:42,285][dev][WARNING] - warning message
# [2024-01-30 19:34:42,285][dev][ERROR] - error message
# [2024-01-30 19:34:42,285][dev][CRITICAL] - critical message
```

### 函式
+ **組態設定 `basicConfig`**
    ```py
    logging.basicConfig(
        level="DEBUG", # 只紀錄比 DEBUG 還要嚴重的訊息
        filename="blue_ox.log",
        format="%(asctime)s %(levelname)s %(lineno)s %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S"
    )
    ```