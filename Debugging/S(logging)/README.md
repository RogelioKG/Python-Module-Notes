# logging

## References
+ 🔗 [**Python Documentation**](https://docs.python.org/zh-tw/3/library/logging.html)
+ 🔗 [**Medium : Python Logging 日誌**](https://zx7978123.medium.com/python-logging-`%E6`%97`%A5`%E8`%AA`%8C`%E7`%AE`%A1`%E7`%90`%86`%E6`%95`%99`%E5`%AD`%B8-60be0a1a6005)
+ 🔗 [**Leon H. : Python Log 從小白到入門**](https://editor.leonh.space/2022/python-log/#google_vignette)
+ 🔗 [**zhung : Python 中的 Log 利器 - 使用 logging 模組來整理 print 訊息**](https://zhung.com.tw/article/python%E4%B8%AD%E7%9A%84log%E5%88%A9%E5%99%A8-%E4%BD%BF%E7%94%A8logging%E6%A8%A1%E7%B5%84%E4%BE%86%E6%95%B4%E7%90%86print%E8%A8%8A%E6%81%AF/)
+ 🎞️ [**ArjanCodes : Python Logging - How to Write Logs Like a Pro!**](https://youtu.be/pxuXaaT1u3k?si=1u3hSOkBmrGMYKnB)

## Level
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

## Logger

### `logging.getLogger()`

#### root logger
+ 說明
  + <mark>已預建立好的 logger 物件</mark>
  + 是所有 logger 的根節點
+ 範例
  ```py
  # 直接使用 root logger 開始記錄
  logging.critical("critical message")
  # 獲取 root logger
  root_logger = logging.getLogger(name=None)
  ```

#### custom logger
+ 說明
  + 每個 logger 都能有各自的「輸出目標」、「訊息等級」、「格式」
+ 建議
  + 不要設定 root logger (以免影響第三方套件)
  + 盡量自訂 logger (維持隔離性、可控性)
+ 範例
  ```py
  # dev logger 是 root logger 的子節點
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

  | 📗 <span class="tip">TIP</span>                        |
  | :---------------------------------------------------- |
  | 若你在煩惱 logger 的命名，慣例上我們會使用 `__name__` |

#### tree structure
+ 說明
  + <mark>用 `.` 定義 logger 之間父子關係</mark>
    + `main` (父) -> `main.sub` (子)
  + 子 logger 發出 log 時，會同時傳遞給父 logger
    + 訊息會一層層 bubbling，直到 root logger
  + 若不想讓子 logger 傳遞給父 logger
    + `child_logger.propagate = False`
+ 範例
  ```py
  main_logger = logging.getLogger("main")
  sub_logger = logging.getLogger("main.sub") # 父子關係
  sub_logger = main_logger.getChild("sub") # 也可以這樣使用
  ```
+ 圖解
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

        classDef Green fill:#1B600D
        class 1,2,3,4,5,6,7,8,9 Green
        classDef White color:#ffffff
        class 1,2,3,4,5,6,7,8,9 White
    ```

### `logging.basicConfig()`
+ 說明
  + <mark>設置 root logger</mark>
+ 範例
  ```py
  logging.basicConfig(
      level="DEBUG",
      filename="blue_ox.log",
      format="%(asctime)s %(levelname)s %(lineno)s %(message)s",
      datefmt="%Y-%m-%d %H:%M:%S"
  )
  ```


## Handler

### `logging.XXXHandler`
+ 說明
  + 處理 <mark>logger 紀錄訊息的「輸出目標」</mark> (終端、檔案)
  + 支援多 handler
    + 一個 logger 可同時綁定多個 handler
    + 同一則訊息，可同時輸出到多個位置
+ 類型
    | 類別名稱                   | 輸出目標                | 模組               | 用途                              |
    | :------------------------- | :---------------------- | :----------------- | :-------------------------------- |
    | `StreamHandler`            | 終端                    | `logging`          | 輸出到終端 (預設用 stderr)        |
    | `FileHandler`              | 檔案                    | `logging`          | 輸出到檔案                        |
    | `NullHandler`              | 無                      | `logging`          | 不輸出                            |
    | `RotatingFileHandler`      | 檔案 (自動輪轉，依大小) | `logging.handlers` | 超過一定大小，就輸出到新檔案      |
    | `TimedRotatingFileHandler` | 檔案 (自動輪轉，依時間) | `logging.handlers` | 超過一定時間，就輸出到新檔案      |
    | `SocketHandler`            | TCP socket              | `logging.handlers` | 傳送 log 到遠端主機               |
    | `DatagramHandler`          | UDP socket              | `logging.handlers` | 用 UDP 傳送 log (無連線)          |
    | `SMTPHandler`              | 電子郵件                | `logging.handlers` | 將 log 寄出 (通常是錯誤通知)      |
    | `HTTPHandler`              | HTTP POST/GET           | `logging.handlers` | 將 log 上傳到 HTTP 伺服器         |
    | `SysLogHandler`            | Syslog 伺服器           | `logging.handlers` | 給 Linux/UNIX 系統用              |
    | `NTEventLogHandler`        | Windows 事件檢視器      | `logging.handlers` | Windows 專用 event log            |
    | `MemoryHandler`            | 暫存記憶體              | `logging.handlers` | 累積到一定數量再寫出              |
    | `QueueHandler`             | 佇列                    | `logging.handlers` | 與多執行緒或 multiprocessing 結合 |
+ 範例
    + `RotatingFileHandler`：依照檔案大小輪轉
        ```py
        import time
        import logging
        from logging.handlers import RotatingFileHandler

        # === 建立 logger ===
        logger = logging.getLogger("rotate_demo")
        logger.setLevel(logging.DEBUG)

        # === 建立 RotatingFileHandler ===
        handler = RotatingFileHandler(
            filename="rotate_demo.log",
            maxBytes=1024,  # 每 1 KB 產生一個新檔案
            backupCount=3,  # 最多保留 3 份舊檔 (.1, .2, .3)
            encoding="utf-8",
        )

        # === 設定格式 ===
        formatter = logging.Formatter("[%(asctime)s][%(levelname)s] - %(message)s")
        handler.setFormatter(formatter)
        logger.addHandler(handler)

        # === 訊息輸出 ===
        for i in range(1000):
            logger.info(f"Record {i}: This is a test message.")
            time.sleep(0.1)
        ```
    + `TimedRotatingFileHandler`：依照時間輪轉
        ```py
        import logging
        from logging.handlers import TimedRotatingFileHandler
        import time

        # === 建立 logger ===
        logger = logging.getLogger("time_demo")
        logger.setLevel(logging.INFO)

        # === 建立 TimedRotatingFileHandler ===
        handler = TimedRotatingFileHandler(
            filename="time_demo.log",
            when="S",  # 單位：秒
            interval=5,  # 每 5 秒產生新檔
            backupCount=3,  # 最多保留 3 份舊檔
            encoding="utf-8",
        )

        # === 設定格式 ===
        formatter = logging.Formatter("[%(asctime)s][%(levelname)s] - %(message)s")
        handler.setFormatter(formatter)
        logger.addHandler(handler)

        # === 訊息輸出 ===
        for i in range(20):
            logger.info(f"Second {i}: This is a test message.")
            time.sleep(1)
        ```
    + `SMTPHandler`：傳送 Email 訊息
        ```py
        import logging
        from logging.handlers import SMTPHandler

        # === 建立 logger ===
        logger = logging.getLogger("mail_demo")
        logger.setLevel(logging.DEBUG)

        # === 建立 SMTPHandler ===
        mail_handler = SMTPHandler(
            mailhost=("smtp.gmail.com", 587),  # 郵件伺服器與埠號
            fromaddr="your_email@gmail.com",   # 寄件者
            toaddrs=["admin@example.com"],     # 收件者清單
            subject="[Alert] Application Error",  # 郵件主旨
            credentials=("your_email@gmail.com", "your_app_password"),  # 登入憑證
            secure=(),  # 使用 TLS 加密
        )

        # 只發送 ERROR 以上等級的訊息
        mail_handler.setLevel(logging.ERROR)

        # 設定格式
        formatter = logging.Formatter(
            "[%(asctime)s][%(levelname)s][%(name)s] - %(message)s"
        )
        mail_handler.setFormatter(formatter)

        # 加入 handler
        logger.addHandler(mail_handler)

        # === 訊息輸出 ===
        logger.info("This is an info message (won't send email).")
        logger.error("This is an error message (email will be sent).")
        ```
    + `HTTPHandler`
        ```py
        # client.py
        import logging
        from logging.handlers import HTTPHandler

        # === 建立 logger ===
        logger = logging.getLogger("http_client")
        logger.setLevel(logging.DEBUG)

        # === 建立 HTTPHandler ===
        http_handler = HTTPHandler(
            host="localhost:8000",     # 伺服器位址與埠
            url="/log",                # 接收日誌的 API 路徑
            method="POST",             # 使用 POST 方法
        )

        # 設定輸出格式
        formatter = logging.Formatter(
            "[%(asctime)s][%(name)s][%(levelname)s] - %(message)s"
        )
        http_handler.setFormatter(formatter)

        logger.addHandler(http_handler)

        # === 模擬日誌輸出 ===
        logger.info("Hello from HTTPHandler client!")
        logger.warning("This is a warning message.")
        logger.error("Something went wrong.")
        ```
        ```py
        # server.py
        from fastapi import FastAPI, Request
        import uvicorn

        app = FastAPI()


        @app.post("/log")
        async def receive_log(request: Request):
            """接收 logging.HTTPHandler 傳來的訊息"""
            data = await request.body()
            text = data.decode("utf-8", errors="ignore")
            print(f"📩 Received log:\n{text}\n{'-' * 50}")
            return {"status": "ok"}


        if __name__ == "__main__":
            uvicorn.run(app, host="0.0.0.0", port=8000)

        ```
## Formatter

### `logging.Formatter`
+ 說明
    | 格式                  | 描述                         |
    | --------------------- | ---------------------------- |
    | `%(asctime)s`         | 建立 log 時間                |
    | `%(created)f`         | 建立 log 的 Unix 時間        |
    | `%(filename)s`        | 發出 log 的程式檔名          |
    | `%(funcName)s`        | 發出 log 的函式名            |
    | `%(levelname)s`       | log 的級別                   |
    | `%(levelno)s`         | log 的級別數字               |
    | `%(lineno)d`          | 發出 log 的行號              |
    | `%(message)s`         | log 的訊息內容               |
    | `%(module)s`          | 發出 log 的模組名稱          |
    | `%(msecs)d`           | 建立 log 時間的毫秒部份      |
    | `%(name)s`            | 發出 log 的 logger 名稱      |
    | `%(pathname)s`        | 發出 log 的程式的路徑        |
    | `%(process)d`         | 發出 log 的程序的 ID         |
    | `%(processName)s`     | 發出 log 的程序名稱          |
    | `%(relativeCreated)d` | log 從創建到發出的毫秒時間差 |
    | `%(thread)d`          | 發出 log 的線程 ID           |
    | `%(threadName)s`      | 發出 log 的線程名稱          |
+ 範例
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

## Filter

### `logging.Filter`
+ 說明
  + 每條日誌訊息在進入 `Handler` 前，都會先經過 filter 檢查
    + 若 `filter(record)` 回傳 `True` → 該 log 會被輸出
    + 若 `filter(record)` 回傳 `False` → 該 log 會被丟棄
+ 範例
    ```py
    import logging
    from logging import LogRecord


    class KeywordFilter(logging.Filter):
        """只允許包含特定關鍵字的 log"""

        def __init__(self, keyword: str) -> None:
            super().__init__()
            self.keyword = keyword

        def filter(self, record: LogRecord) -> bool:
            return self.keyword in record.getMessage()


    # === 建立 logger ===
    logger = logging.getLogger("demo")
    logger.setLevel(logging.DEBUG)

    # === 建立 Handler ===
    handler = logging.StreamHandler()
    formatter = logging.Formatter("[%(levelname)s] %(message)s")
    handler.setFormatter(formatter)

    # === 加上 Filter ===
    handler.addFilter(KeywordFilter("OK"))

    logger.addHandler(handler)

    # === 測試 ===
    logger.info("This is OK message")
    logger.info("This is bad message")
    ```

### `logging.LogRecord`
| 屬性                    | 說明                                   |
| ----------------------- | -------------------------------------- |
| `name`                  | logger 名稱（例如 `"app.db"`）         |
| `levelname` / `levelno` | 等級名稱或數字（例如 `"INFO"` / `20`） |
| `pathname`              | 來源檔案的絕對路徑                     |
| `filename`              | 來源檔案名稱                           |
| `module`                | 模組名稱                               |
| `lineno`                | log 被呼叫的程式行號                   |
| `funcName`              | 呼叫 log 的函式名稱                    |
| `created`               | UNIX 時間戳                            |
| `asctime`               | 格式化後的時間字串                     |
| `process` / `thread`    | 行程與執行緒 ID                        |
| `message`               | 真正的 log 訊息內容                    |
| `args`                  | 傳給 log 的參數（若使用格式化字串）    |
| `exc_info`              | 存放 traceback 資訊                    |

## Config

### `loggging.config.dictConfig`
+ 說明
  + <mark>使用字典設置 logger</mark>
+ 範例
  ```py
    import logging
    import logging.config

    LOGGING_CONFIG = {
        "version": 1,  # 固定值：版本
        "disable_existing_loggers": False,  # 是否停用既有 logger

        "formatters": {
            "standard": {
                "format": "[%(asctime)s][%(levelname)s] %(name)s: %(message)s"
            },
            "detailed": {
                "format": "[%(asctime)s][%(levelname)s][%(name)s:%(lineno)d] %(message)s"
            }
        },

        "handlers": {
            "console": {
                "class": "logging.StreamHandler",
                "formatter": "standard",
                "level": "INFO",
            },
            "file": {
                "class": "logging.handlers.RotatingFileHandler",
                "formatter": "detailed",
                "level": "DEBUG",
                "filename": "app.log",
                "maxBytes": 1048576,
                "backupCount": 3,
                "encoding": "utf-8",
            },
        },

        "loggers": {
            "app": {
                "handlers": ["console", "file"],
                "level": "DEBUG",
                "propagate": False
            }
        },

        "root": {
            "handlers": ["console"],
            "level": "WARNING"
        }
    }

    logging.config.dictConfig(LOGGING_CONFIG)
    logger = logging.getLogger("app")
    logger.debug("debug message")
    logger.info("info message")

  ```