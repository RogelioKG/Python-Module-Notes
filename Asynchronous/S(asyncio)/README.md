# asyncio

[![RogelioKG/asyncio](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/asyncio)

### 參考
  + 🔗 [**MyApollo - asyncio**](https://myapollo.com.tw/blog/begin-to-asyncio/)
  + 🔗 [**MyApollo - asyncio shield**](https://myapollo.com.tw/blog/asyncio-shield/)
  + 🔗 [**Python Document : asyncio-queue**](https://docs.python.org/zh-tw/3/library/asyncio-queue.html)
  + 🔗 [**Python Asyncio Part 1 – Basic Concepts and Patterns**](https://bbc.github.io/cloudfit-public-docs/asyncio/asyncio-part-1.html)
  + 🔗 [**Python Asyncio Part 2 – Awaitables, Tasks, and Futures**](https://bbc.github.io/cloudfit-public-docs/asyncio/asyncio-part-2.html)
  + 🔗 [**Python Asyncio Part 3 – Asynchronous Context Managers and Asynchronous Iterators**](https://bbc.github.io/cloudfit-public-docs/asyncio/asyncio-part-3.html)
  + 🔗 [**Python Asyncio Part 4 – Library Support**](https://bbc.github.io/cloudfit-public-docs/asyncio/asyncio-part-4.html)
  + 🔗 [**Python Asyncio Part 5 – Mixing Synchronous and Asynchronous Code**](https://bbc.github.io/cloudfit-public-docs/asyncio/asyncio-part-5.html)
  + 🔗 [**Maxlist - Async IO Design Patterns**](https://www.maxlist.xyz/2020/04/03/async-io-design-patterns-python/)
  + 🔗 [**Aureliano's Macondo**](https://aureliano90.github.io/blog/2022/04/28/A_Brief_Introduction_of_Python_Coroutines_and__await__Attribute.html)
  + 🎞️ [**ArjanCodes**](https://youtu.be/GpqAQxH1Afc?si=iIvKy9yEoIQ_shjt)


### 注意

|📘 <span class="note">NOTE</span>|
|:---|
|Python 的協程是由 generator 實作的|

|📘 <span class="note">NOTE</span>|
|:---|
|協程是單進程單線程 (如果你不使用 `to_thread` 的話)|

|📘 <span class="note">NOTE</span>|
|:---|
|Q : `asyncio` 和 `threading` 似乎都是處理 I/O bound task 的工具，<br>且在 CPython 中，他們都是並發 (concurrency) 的。<br>既然協程比線程輕量，為何我還要使用線程？<br>|
|A : 異步 (`asyncio`) 屬於協作式多工 (cooperative multitasking)，<br>意即控制權的轉讓決定在 coroutine 手上<br>(await 一個 future 或 task 的時候)，因而有可能被 blocking。<br>多線程 (`threading`) 屬於搶占式多工 (preemptive multitasking)，<br>意即控制權的轉讓決定在 OS 手上，<br>時間到了就會切換，不會發生 blocking。|


### 名詞

+ **awaitable** / **awaitable object**
  + 屬於類別 `collection.abc.Awaitable` (定義 `__await__` 抽象方法)
  + 有實作 `__await__` 魔術方法的類別，其 instance 皆是 awaitable object (例如: coroutine, future, task)\
    (該類別即為 `collection.abc.Awaitable` 的子類別，這是透過 `__subclasshook__` 實作的，無須顯式繼承)

+ **coroutine function**
  + 以 `async def` 定義的函式，稱為 coroutine function

+ **coroutine** / **coroutine object**
  + 屬於類別 `collection.abc.Coroutine` (繼承 `collection.abc.Awaitable`)
  + 調用 coroutine function 會產生一個 coroutine object
  + 一定要透過 event loop 排程，將 coroutine object 轉為 task 才能執行
  + coroutine 具有開始 (enter) / 暫停 (exit) / 任意恢復 (resume) 執行的能力

+ **furure**
  + 屬於類別 `asyncio.Future` (實作 `__await__` 方法)
  + 低階 API
  + 代表異步操作的最終結果

+ **task**
  + 屬於類別 `asyncio.Task` (繼承 `asyncio.Future`)
  + task 是 coroutine 的再包裝

+ **callback**
  + 回呼函式，作為引數被傳遞的一個函式，會在未來的某個時間點被執行。

+ **event loop**
  + 屬於類別 `asyncio.AbstractEventLoop`
  + 背景運行，會不斷地進行排程與執行 task / callback (都在同個 thread)
  + 一次僅會執行 1 個 task
  + 適合將 I/O 工作以異步方式交由 event loop 執行，例如網路通訊、檔案讀寫等等

+ **executor**
  + 負責在非 main thread 執行 (通常是會造成阻塞的) task


### 關鍵字

+ `async def`
  + 以 `async def` 定義的函式，稱為 coroutine function

+ `await`

  + 需給定 awaitable object
    + 若給定 **coroutine**
      > coroutine function 將被執行，直到它返回 (return) 一個值。
    + 若給定 **future** (或 **task**)
      > 當前 task 會在 **future** (或 **task**) 掛上一個 callback，\
      > 告訴它等它完成的時候，把我 (當前 task) 叫醒 (event loop 執行它)，\
      > 接著當前 task 暫離 event loop，event loop 將轉而執行其他 task。\
      > 範例：`asyncio.sleep()` 即為一個 **future**，它模擬一個 n 秒後會收到的 response。\
      > (收到 response 後，叫醒之前那個 task，讓它繼續執行)
    + 否則
      > 嘗試調用該物件的 `__await__` 魔術方法

  |🚨 <span class="caution">CAUTION</span> : `await`|
  |:---|
  | 1. 只能出現在 coroutine function 中|
  | 2. wait 述句的 task 都必須執行完畢，當前 task 才會繼續往下執行，<br>這並不意味 await 述句的 task 都必將在 await 述句處執行，<br>只要有 `create_task()` 或者 `gather()` (這些動作會同時將 task 同時放入 event loop)，<br>在 await 述句之前都有可能執行。|
  | 3. await 述句的 evaluation 值，為每個 task 執行完後的回傳值|


### 常用

+ **函式**
  |function|comments|
  |-------|---------|
  |`asyncio.iscoroutinefunction()`|是否為 coroutine function|
  |`asyncio.iscoroutine()`|是否為 coroutine object|
  |`asyncio.isfuture()`|是否為 future (或 task)|
  |`asyncio.get_event_loop()`|回傳一個 event loop 實例|
  |`asyncio.get_running_loop()`|回傳當前運行中的 event loop 實例|
  |`asyncio.run()`|建立 event loop，將傳入的 coroutine 包裝成 task，放入此 evenet loop 等待執行|
  |`asyncio.create_task()`|將 coroutine 包裝成 task，放入 event loop 等待執行|
  |`asyncio.sleep()`|模擬一個 n 秒後會收到的 response (非阻塞)|
  |`asyncio.gather()`|將多個 awaitable objects 包裝成 tasks，放入 event loop 等待執行，回傳 `list`|
  |`asyncio.wait_for()`|同 `create_task()`，但為 task 設置時限，超出時限則 raise `TimeoutError`|
  |`asyncio.to_thread()`|把耗時較久 (會導致阻塞 blocked) 的 task 交給 executor，並丟到其他 thread，由 executor 負責執行這個 task (event loop 留在 main thread)|
  |`asyncio.shield()`|task 的聖盾術，使得 task 免於一次 cancel|

+ **錯誤**
  |exception|comments|
  |---------|--------|
  |`asyncio.CancelledError`|此 task 已被移出 event loop|
  |`asyncio.TimeoutError`|此 task 已超出時限|

+ `Task`
  |method|comments|
  |------|--------|
  |`cancel()`|將 task 移出 event loop|
  |`add_done_callback()`|新增 callback|
  |`remove_done_callback()`|移除 callback|

+ `Future` (inherited by `Task`)
  |method|comments|
  |------|--------|
  |`set_result()`|將 future 的 state 屬性標記為結束狀態，並設定 result 屬性的值|
  |`result()`|回傳 future 的 result 屬性的值|
  |`cancelled()`|future 是否被取消|

+ [`AbstractEventLoop`](https://docs.python.org/zh-tw/3/library/asyncio-eventloop.html) (低階 API)
  |method|comments|
  |------|--------|
  |`stop()`|停止 event loop|
  |`is_running()`|如果 event loop 當前正在運行，則回傳 True|
  |`is_closed()`|如果 event loop 已關閉，則回傳 True|
  |`close()`|關閉 event loop|
  |`run_until_complete()`|運行 event loop 直到 future 完成。|
  |`run_forever()`|運行 event loop 直到 `stop()` 被呼叫|
  |`time()`|根據 event loop 的內部單調時鐘，回傳當前時間 (單位：秒)|
  |`create_task()`|將 coroutine 包裝成 task，放入 event loop 等待執行|
  |`create_future()`|創建一個 future|
  |[`call_soon()`](https://docs.python.org/zh-tw/3/library/asyncio-eventloop.html#hello-world-with-call-soon)|在 event loop 的下一次疊代中排程以 args 引數呼叫 callback|
  |`call_soon_threadsafe()`|`call_soon()` 的線程安全版|
  |[`call_later()`](https://docs.python.org/zh-tw/3/library/asyncio-eventloop.html#display-the-current-date-with-call-later)|排程 callback 在給定的 delay 秒數後呼叫|
  |`call_at()`|排程 callback 在給定的絕對時間戳 when 處呼叫，使用與 `time()` 相同的時間參照|
