# threading

[![RogelioKG/threading](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/threading)


### 參考
+ 🔗 [**louie_lu's blog: 深入 GIL**](https://blog.louie.lu/2017/05/19/%E6%B7%B1%E5%85%A5-gil-%E5%A6%82%E4%BD%95%E5%AF%AB%E5%87%BA%E5%BF%AB%E9%80%9F%E4%B8%94-thread-safe-%E7%9A%84-python-grok-the-gil-how-to-write-fast-and-thread-safe-python/)
+ 🔗 [**Maxlist**](https://www.maxlist.xyz/2020/03/15/python-threading/)
+ 🔗 [**GTW**](https://blog.gtwang.org/programming/python-threading-multithreaded-programming-tutorial/)
+ 🔗 [**Python Parallel Programmning Cookbook**](https://python-parallel-programmning-cookbook.readthedocs.io/zh-cn/latest/index.html)
+ 🔗 [**利用 Concurrency 加速你的 Python 程式執行效率**](https://hackmd.io/@YungHuiHsu/SJ5EgB5eT)


### 說明
| 🔮 <span class="important">IMPORTANT</span>   |
| :------------------------------------------- |
| 🪄 使用 multi-threading 解決 I/O-bound tasks  |
| 🪄 使用 multi-processing 解決 CPU-bound tasks |


### 函式
| function           | description                                                      |
| ------------------ | ---------------------------------------------------------------- |
| `active_count()`   | 返回當前存活的線程數量                                           |
| `enumerate()`      | 返回當前所有存活的線程物件 list                                  |
| `current_thread()` | 返回當前線程物件                                                 |
| `get_ident()`      | 返回當前線程的 ident                                             |
| `main_thread()`    | 返回主線程物件                                                   |
| `settrace(func)`   | 為從 threading 模組啟動的所有線程設置追蹤函式                    |
| `setprofile(func)` | 為從 threading 模組啟動的所有線程設置分析函式                    |
| `stack_size(size)` | 返回新線程使用的堆疊大小，或者如果提供了大小參數，則設置堆疊大小 |
| `local()`          | 創建線程本地數據                                                 |


### 類別
| class                        | description                                                                                                                   |
| ---------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `Mutex()`                    | (🗑️deprecated) 創建一個互斥鎖                                                                                                  |
| `Lock()`                     | 創建一個互斥鎖，用於防止多個線程同時訪問共享資源                                                                              |
| `RLock()`                    | 創建一個可重入互斥鎖，允許同一線程多次獲取鎖<br>(單純在 `Lock()` 的 C API 上套一層皮，其中 attribute `_block` 就是 Lock 實例) |
| `Condition(lock)`            | 創建一個條件變數，用於更高級的線程同步                                                                                        |
| `Semaphore(value)`           | 創建一個號幟，用於管理固定數量的可用資源                                                                                      |
| `BoundedSemaphore(value)`    | 創建一個號幟，但防止計數器超過初始值                                                                                          |
| [`Event()`][Myapollo: Event] | 創建一個事件，用於線程之間的訊號傳遞                                                                                          |
| `Thread(target, args, name)` | 創建一個線程物件，`target` 指定線程執行的函式，`args` 指定傳遞給該函式的引數，<br>`name` 可指定別名                           |
| `Timer(interval, func)`      | 創建一個計時器，在指定的間隔後執行給定的函式                                                                                  |
| `Barrier()`                  | 創建一個同步屏障                                                                                                              |


### 方法 / 屬性

  + `Thread`
    > 使用方法
    > 1. 使用 `target` 指定線程執行的函式
    > 2. 繼承 `Thread` 然後將工作內容覆寫至 `run()` 方法

    | method / attribute                  | description                                            |
    | ----------------------------------- | ------------------------------------------------------ |
    | `start()`                           | 啟動線程                                               |
    | `join()`                            | 阻塞當前線程，直到該線程完成才會進行後續動作           |
    | `run()`                             | 當 `start()`後會調用此函式，其執行指定的 `target` 函式 |
    | `is_alive()`                        | 線程是否啟動                                           |
    | `name`                              | 線程別名                                               |
    | `ident`                             | 取得 ID (當前 process 中 thread 的 ID)                 |
    | `native_id`                         | 取得 ID (OS 給予此 thread 的 ID)                       |
    | [`daemon`][Myapollo: Daemon Thread] | 主線程運行結束時，此線程也強制結束，預設為 `False`     |

  + `Lock` / `RLock`
    ```py
    class _RLock:
      def __init__(self):
          self._block = Lock()
          self._owner = None
          self._count = 0
    ```

    > `Lock` 規則
    > 1. 狀態 unlocked + 調用 `acquire()` : 狀態改為 locked
    > 3. 狀態 unlocked + 調用 `release()` : `RuntimeError`
    > 2. 狀態 locked + 調用 `acquire()` : 被阻塞直到另一線程調用 `release()` 釋放鎖<br>(若為 `RLock`，不阻塞，僅遞迴計數 +1)
    > 4. 狀態 locked + 調用 `release()` : 狀態改為 unlocked<br>(若為 `RLock`，不阻塞，僅遞迴計數 -1，直到為 0 則狀態改為 unlocked)

    | method / attribute                  | description                                                                                 |
    | ----------------------------------- | ------------------------------------------------------------------------------------------- |
    | `acquire(blocking=True,timeout=-1)` | 獲取鎖<br>`blocking`：若未能成功獲取鎖 thread 是否休眠<br>`timeout`：嘗試在指定秒數內獲取鎖 |
    | `release()`                         | 釋放鎖                                                                                      |
    | `__enter__`                         | 直接被定義為 `acquire` 方法 (可使用 `with` 述句獲取鎖並自動釋放鎖)                          |
    | `__exit__`                          | 直接調用 `release` 方法                                                                     |

  + `Condition`

    ```py
    class Condition:
    def __init__(self, lock=None):
        if lock is None:
            lock = RLock()
        self._lock = lock
        self.acquire = lock.acquire
        self.release = lock.release
        self._waiters = _deque()
    ```

    > 內部維護一個 deque (等待佇列)，當線程 wait 的時候，創建一個互斥鎖 `Lock`，\
    > 然後讓線程獲取鎖，並將這個鎖推入 deque，然後再次嘗試獲取它。\
    > 由於互斥鎖不可重入的特性，線程就會進入休眠 (或者反覆甦醒嘗試獲取互斥鎖)。\
    > 而 `notify()` 的奇效就在於它會 `release()` 等待佇列中的互斥鎖。\
    > 這就讓被互斥鎖卡住的線程，下次甦醒時能成功獲取互斥鎖並繼續執行\
    > (然後線程離開 `wait()` 後互斥鎖就被丟掉了，因為它只是拿來排隊用的)。

    | 📘 <span class="note">NOTE</span> : 預設為可重入互斥鎖 `RLock` |
    | :------------------------------------------------------------ |

    | method / attribute             | description                                                                             |
    | ------------------------------ | --------------------------------------------------------------------------------------- |
    | `acquire(blocking,timeout)`    | 直接被定義為鎖的 `acquire` 方法                                                         |
    | `release()`                    | 直接被定義為鎖的 `release` 方法                                                         |
    | `wait(timeout)`                | 釋放鎖後休眠，在條件變數的佇列中等待，直到被 `notify()` 喚醒，或超過指定的 timeout 時間 |
    | `wait_for(predicate, timeout)` | 若指定條件不滿足，持續 `wait()`                                                         |
    | `notify(n)`                    | 喚醒在條件變數的佇列中等待的前 n 個線程                                                 |
    | `notify_all()`                 | 喚醒在條件變數的佇列中等待的所有線程                                                    |
    | `__enter__`                    | 直接調用鎖的 `__enter__` 方法                                                           |
    | `__exit__`                     | 直接調用鎖的 `__exit__` 方法                                                            |

  + `Semaphore`
    > 獲取鎖和釋放鎖的邏輯都交給 `Condition`，`Semaphore` 單純就是套一層可使用資源數量 `value` 的皮罷了
    ```py
    class Semaphore:
      def __init__(self, value=1):
          if value < 0:
              raise ValueError("semaphore initial value must be >= 0")
          self._cond = Condition(Lock())
          self._value = value
    ```
    | method / attribute          | description                                                        |
    | --------------------------- | ------------------------------------------------------------------ |
    | `acquire(blocking,timeout)` | 獲取鎖                                                             |
    | `release()`                 | 釋放鎖                                                             |
    | `__enter__`                 | 直接被定義為 `acquire` 方法 (可使用 `with` 述句獲取鎖並自動釋放鎖) |
    | `__exit__`                  | 直接調用 `release` 方法                                            |

  + `Event`

    > flag 若為 False，釋放鎖後休眠，在條件變數的佇列中等待，直到被 `notify()` 喚醒，或超過指定的 timeout 時間
  
    ```py
    class Event:
        def __init__(self):
            self._cond = Condition(Lock())
            self._flag = False
    ```

    | method               | description                                                      |
    | -------------------- | ---------------------------------------------------------------- |
    | `set()`              | 將 flag 設置為 True，所有等待該事件的線程將被喚醒並繼續執行。    |
    | `clear()`            | 將 flag 設置為 False，後續等待該事件的線程將休眠。               |
    | `wait(timeout=None)` | 當前線程休眠，直到 flag 為 True 或超過指定的 timeout 時間。      |
    | `is_set()`           | 返回 flag 的狀態。如果 flag 為 True，返回 True，否則返回 False。 |

  + `Timer`

    ```py
    class Timer(Thread):

    def __init__(self, interval, function, args=None, kwargs=None):
        Thread.__init__(self)
        self.interval = interval
        self.function = function
        self.args = args if args is not None else []
        self.kwargs = kwargs if kwargs is not None else {}
        self.finished = Event()

    def cancel(self):
        self.finished.set()

    def run(self):
        self.finished.wait(self.interval)
        if not self.finished.is_set():
            self.function(*self.args, **self.kwargs)
        self.finished.set()
    ```

    | method       | description                                                       |
    | ------------ | ----------------------------------------------------------------- |
    | `start()`    | 啟動定時器。這會使定時器在指定的 `interval` 時間後執行`function`  |
    | `cancel()`   | 停止定時器。如果定時器尚未執行，則此方法將阻止其執行              |
    | `is_alive()` | 返回定時器是否仍在計時中。如果定時器已啟動但尚未觸發，返回 `True` |

  + `Barrier`

    | method               | description                                                                     |
    | -------------------- | ------------------------------------------------------------------------------- |
    | `wait(timeout=None)` | 阻塞直到所有線程到達 `Barrier`，`timeout` 設定等待時間                          |
    | `reset()`            | 重置 `Barrier`，使其能夠重新使用，會使所有等待中的線程引發 `BrokenBarrierError` |
    | `abort()`            | 中止 `Barrier`，所有等待中的線程都會引發 `BrokenBarrierError`                   |
    | `parties`            | 返回初始化時設置的需要等待的線程數量                                            |
    | `n_waiting`          | 返回目前已經到達 `Barrier` 並正在等待的線程數量                                 |
    | `broken`             | 返回 `True` 如果 `Barrier` 已經被中止或重置，否則返回 `False`                   |


<!-- Link -->
[Myapollo: Daemon Thread]: https://myapollo.com.tw/blog/python-daemon-thread/
[Myapollo: Event]: https://myapollo.com.tw/blog/python-event-objects/