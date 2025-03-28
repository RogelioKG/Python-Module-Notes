# multiprocessing

[![RogelioKG/multiprocessing](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/multiprocessing)


### 參考
+ 🔗 [**myapollo: multiprocessing 基礎篇**](https://myapollo.com.tw/blog/python-multiprocessing/)
+ 🔗 [**myapollo: multiprocessing 進階篇**](https://myapollo.com.tw/blog/python-multiprocessing-pipe-queue-array-rawarray-structure/)
+ 🔗 [**maxlist**](https://www.maxlist.xyz/2020/03/20/multi-processing-pool/)
+ 🔗 [**simonxander**](https://blog.simonxander.tw/2020/03/python-cpp-library-class.html?m=1)
+ 🔗 [**codemee: multiprocessing 模組的注意事項**](https://dev.to/codemee/multiprocessing-mo-zu-de-zhu-yi-shi-xiang-355d)
+ 🔗 [**pythonforthelab: Differences of Multiprocessing on Windows and Linux**](https://pythonforthelab.com/blog/differences-between-multiprocessing-windows-and-linux/)
+ 🔗 [**jeremy: python多进程实战**](https://jeremyxu2010.github.io/2020/09/python%E5%A4%9A%E8%BF%9B%E7%A8%8B%E5%AE%9E%E6%88%98/)
+ 🔗 [**stackoverflow: chunksize (part 1)**](https://stackoverflow.com/a/54032744)
+ 🔗 [**stackoverflow: chunksize (part 2)**](https://stackoverflow.com/a/54813527)
+ 🔗 [**Multiprocessing Pool Initializer in Python**](https://superfastpython.com/multiprocessing-pool-initializer/)
<!-- link -->
[進程啟動方法 (start method)]: #進程啟動方法-start-method
[進程間通訊 (IPC)]: #進程間通訊-inter-process-communication


### 說明
| 🔮 <span class="important">IMPORTANT</span>   |
| :------------------------------------------- |
| 🪄 使用 multi-threading 解決 I/O-bound tasks  |
| 🪄 使用 multi-processing 解決 CPU-bound tasks |

| 🚨 <span class="caution">CAUTION</span>|
| :------------------------------------- |
| 啟動新進程大概會有幾百毫秒左右的 overhead<br>(若任務沒有繁重到能慢於這個時間，那就別開多進程) |

| ☢️ <span class="warn">WARNING</span>|
| :------------------------------------- |
| 在[進程啟動方法 (start method)] 設定為 spawn 的情況下，<br>請確保子進程的創建在 `if __name__ == "__main__"` 保護之下。<br>(否則會導致遞迴創建，因為 spawn 是重新創一個進程，整個模組會再重新導入一遍) |

### 使用決策

+ 盡量減少在進程間傳遞資料的量，越少越好。
+ 優先使用 `Queue` 或 `Pipe` 進行[進程間通訊 (IPC)]，而不是底層的同步操作 (比如 `Lock`)。
+ 若多個任務共用傳遞的數據，使用 `Pool` 的 initializer 傳遞。對於單線程父進程，使用 fork 方式建立子進程可以節省記憶體。
+ 資料的操作不頻繁時，考慮使用 server process 裡的共享物件。注意盡量減少操作次數，能批量操作就批量操作。
+ 若資料僅對特定任務有效，可在提交任務時透過引數傳遞。
+ 若資料可以方便地與普通 ctype 類型轉換，使用共享記憶體也是不錯的選擇。
+ 在多生產者多消費者場景中，優先使用 `Queue`。


### 進程間通訊 inter-process communication
| IPC               | description                                                                                                                       |
| ----------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| **file**          | 例如 A Process 將資料寫至一個檔案後由 B Process 進行讀取，達成通訊的效果                                                          |
| **socket**        | 透過 TCP/UDP 等網路協定進行通訊                                                                                                   |
| **shared memory** | 透過共享記憶體區塊進行通訊                                                                                                        |
| **signal**        | 透過作業系統提供的訊號機制進行通訊，例如 A Process 發出訊號給 B Process，<br>B Process 針對不同訊號做出不同的處理，達成通訊的效果 |


### 進程啟動方法 start method
> Python 啟動一個新的 child process 時，因作業系統差異有不同的預設方法

| start method   | description | supported platform |
| -------------- | ----------- | ------------------ |
| **spawn**      | 創建一個全新的 Python interpreter 進程。<br>它不繼承 file descriptors 等等非必要資源，只繼承運行 target 函式的相關資源。<br>它將重新載入程式並執行 target 函式。效率較 **fork** 或 **fork server** 低。 | Windows / Unix / macOS |
| **fork**       | 從當前進程以 `os.fork()` 分叉出一個 Python interpreter 進程。<br>它會繼承父進程的所有資源，在 Linux 中由於採用 copy-on-write 方式實作，<br>因此實際上不會占用太多空間。它會從父進程當前執行處繼續執行下去。<br>(☢️<span class="warn">WARNING</span> : **fork** 一個多線程的進程可能導致 deadlock 風險) | Unix / macOS |
| **forkserver** | 建立一個 server 進程，創建新進程時將由它分叉出新進程。<br>由於 server 進程是一個單線程的進程，fork 它並沒有 deadlock 風險。| Unix / macOS |

### 類別
| class              | description                                                                            |
| ------------------ | -------------------------------------------------------------------------------------- |
| `Process`          | 表示一個進程物件，允許在獨立的進程中執行目標函式                                       |
| `Lock`             | 提供一個簡單的鎖機制，用於防止多個進程同時存取共享資源                                 |
| `RLock`            | 可重入鎖，允許同一個進程多次獲取鎖                                                     |
| `Condition`        | 提供一個條件變數，允許進程等待特定條件的滿足，並通知其他進程該條件已經滿足             |
| `Semaphore`        | 提供一個號誌，允許最多 `n` 個進程同時存取共享資源                                      |
| `BoundedSemaphore` | 與 `Semaphore` 類似，但當減少計數超過初始值時會引發 `ValueError`                         |
| `Event`            | 提供一個簡單的旗標機制，允許進程等待事件的發生                                         |
| `Barrier`          | 允許進程在指定的屏障等待，直到指定數量的進程都達到該點後才繼續執行                     |
| `Value`            | 允許進程之間共享一個值                                                                 |
| `Array`            | 允許進程之間共享一個陣列                                                               |
| `RawArray`         | 允許進程之間共享一個陣列，但沒有 `Lock` 相關方法可呼叫，只適合傳遞 read-only 的資料    |
| `Pool`             | 提供一個進程池，用於管理多個工作進程，允許平行地執行目標函式                           |
| `Manager`          | 提供一個進程管理器，允許創建和管理共享的資料結構，如 `list`, `dict`                   |
| `SharedMemory`     | 允許在進程之間共享記憶體，支援高效的記憶體共享和通訊                                   |
| `Namespace`        | 提供一個簡單的命名空間物件，允許在進程之間共享屬性                                     |
| `Pipe`             | 提供雙向通訊的管道，允許兩個進程之間傳遞訊息                                           |
| `Queue`            | 提供進程之間通訊的 FIFO 佇列，允許進程之間傳遞訊息                                     |
| `SimpleQueue`      | 與 `Queue` 類似，簡單版，輕量級                                                        |
| `JoinableQueue`    | 與 `Queue` 類似，但允許工作進程通知主進程它們的工作已經完成，如 `join()`, `task_done()` |

### 函式

```py
from multiprocessing import Process, freeze_support

def f():
    print('hello world!')

if __name__ == '__main__':
    freeze_support() # 若要打包成 Windows 可執行檔，一定要加上這行
    Process(target=f).start()
```

| function                                | description                                                               |
| --------------------------------------- | ------------------------------------------------------------------------- |
| `active_children()`                     | 回傳當前存活的所有子進程列表                                              |
| `cpu_count()`                           | 回傳當前系統的 CPU 核心數 (邏輯，非物理)                                         |
| `current_process()`                     | 回傳當前進程物件                                                          |
| `get_all_start_methods()`               | 回傳支援的所有[進程啟動方法 (start method)] 列表 |
| `get_start_method()`                    | 回傳當前使用的[進程啟動方法 (start method)]  |
| `get_context(method=None)`              | 回傳一個 `BaseContext` 物件，指定[進程啟動方法 (start method)] |
| `get_logger()`                          | 回傳 `multiprocessing` 模組的日誌記錄器物件                               |
| `log_to_stderr(level=None)`             | 配置日誌記錄器以將日誌輸出到標準錯誤                                      |
| `set_executable(path)`                  | 設置新進程的 Python 可執行檔案的路徑                                      |
| `set_start_method(method, force=False)` | 設置[進程啟動方法 (start method)]，這個方法必須在程序啟動時設置一次，不能在進程創建後更改  |
| `simple_queue()`                        | 回傳一個基於管道 (`Pipe`) 實現的簡單佇列物件                              |
| `freeze_support()`                      | 將多進程腳本<mark>打包成 Windows 可執行檔</mark> (frozen executable) 時需使用<br>(否則試圖執行將引發 `RuntimeError`) |

### 方法 / 屬性

+ **`Process`**
  
  > 同 threading 的 Thread，也可覆寫 `run()`

  | method        | description                                                                                            |
  | ------------- | ------------------------------------------------------------------------------------------------------ |
  | `run()`       | 定義進程在 `start()` 後執行的操作                                                                      |
  | `start()`     | 啟動進程，調用 `run()` 方法                                                                            |
  | `join()`      | 阻塞當前進程，直到被調用的進程結束。可指定 timeout 參數來設置等待時間                                  |
  | `is_alive()`  | 回傳進程是否仍在運行                                                                                   |
  | `terminate()` | 強制終止進程 (SIGTERM)                                                                                 |
  | `kill()`      | 強制終止進程 (SIGKILL)                                                                                 |
  | `close()`     | 在 Windows 上釋放進程資源 (在 Unix 上無需手動調用)                                                     |
  | `exitcode`    | 回傳進程的退出代碼 (正常退出為 0，異常退出為非零值)                                                    |
  | `pid`         | 回傳進程 ID                                                                                            |
  | `name`        | 設置或獲取進程的名稱                                                                                   |
  | `daemon`      | 設置或獲取是否將進程設置為守護進程 (守護進程在主進程結束時自動終止)                                    |
  | `authkey`     | 設置或獲取[進程間通訊 (IPC)]的身份驗證密鑰                                                                     |
  | `sentinel`    | 回傳一個 file descriptor，可用來監測進程的終止 (在 Unix 上為 file descriptor，在 Windows 上為事件物件) |
  | `ident`       | 回傳進程 ID                                                                         |

+ **`Pipe`**

  | 📗 <span class="tip">TIP</span> : init arg - `duplex` (bool)                                                                 |
  | :-------------------------------------------------------------------------------------------------------------------------- |
  | `duplex=True` (預設)，管道是可雙向通訊的 |
  | `duplex=False`，管道是僅單向通訊的 (conn1 僅使用 `recv()`、conn2 僅使用 `send()`) |


  | method                    | description                                                                                                              |
  | ------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
  | `send(obj)`               | 發送數據到管道的另一端。可發送任何能被 `pickle` 序列化的 Python 物件<br>(註 : 超過 32 MiB 的大物件可能引發 `ValueError`) |
  | `send_bytes(buffer)`      | 和 `send()` 類似，但這個方法允許發送 bytes                                                                               |
  | `poll(timeout=None)`      | 非阻塞地檢查管道中是否有數據可接收。可選擇指定 `timeout`，以秒為單位                                                     |
  | `recv()`                  | 接收來自管道另一端的數據，並將其反序列化為 Python 物件。<br>(註 : 此方法會阻塞直到接收到數據。若管道已經被關閉，拋出 `EOFError`)    |
  | `recv_bytes()`            | 和 `recv()` 類似，但這個方法允許接收 bytes                                                                               |
  | `recv_bytes_into(buffer)` | 接收 bytes 數據並將其寫入到給定的 buffer。其需要有足夠的容量來容納接收到的 bytes 數據                             |
  | `close()`                 | 關閉管道的這一端。關閉後，這一端將無法發送或接收數據 (`__exit__()` 將調用此方法)                                         |
  | `fileno()`                | 回傳管道物件的 file descriptor，這可與低階檔案操作一起使用                                                               |
  | `join_thread()`           | 若這一端的管道的背景線程在使用中，可使用此方法等待背景線程結束                                                         |
  | `cancel_join_thread()`    | 取消對背景線程的等待。若你不再需要等待背景線程，可使用此方法來節省資源                                                 |


+ **`Queue`** / **`SimpleQueue`** / **`JoinableQueue`**

  > API 大部分和 threading 的一樣，就不列出來了

  | 📗 <span class="tip">TIP</span> : class - `JoinableQueue`                                                 |
  | :------------------------------------------------------------------------------------------------------- |
  | 記得任務處理完畢時要呼叫 `task_done()`。<br>(否則 queue 內部的 semaphore 計數會錯誤統計，導致 Exception) |

  | 📘 <span class="note">NOTE</span> : 內部實現 | 
  | :------------------------------------------ |
  | `Queue` 底層實作基於 `Pipe`、`Lock` 和 `Thread`。 |
  | 當你往 `Queue` 中 `put()` 一個物件時，<br>物件會被序列化 (使用 pickle) 並使用 `Pipe` 的 `send()` 將序列化數據送入管道。 |
  | 當你從 `Queue` 中 `get()` 一個物件時，<br>使用 `Pipe` 的 `recv()` 從管道拿起序列化數據。接著反序列化回 Python 物件。<br>當然考慮到同步問題，因此實作也用上了 `Lock`。 |

  | 📘 <span class="note">NOTE</span> : 並非回傳原始物件      |
  | :------------------------------------------------------- |
  | 我們所取得的物件，只是反序列化後的副本，並不是原始物件。 |



+ **`Pool` 進程池**

  > 傳入 `func` 的引數會被序列化，在而後 spawn 的新進程中被反序列化，\
  > 被新進程拿來使用，所以他們是不共享的。\
  > 若 start method 是 fork，那甚至不用將其作為引數傳遞進去，\
  > 只要確保共享記憶體物件 (比如 `Value` 或 `Array`) 是全域變數即可。

  | 📗 <span class="tip">TIP</span> : init arg - `processes` (int) |
  | :------------------------------------------------------------ |
  | 創建進程個數，預設 `os.cpu_count()`                           |

  | 📗 <span class="tip">TIP</span> : init arg - `initializer` (function) |
  | :------------------------------------------------------------------- |
  | 進程初始化函式                                                       |

  | 📗 <span class="tip">TIP</span> : init arg - `initargs` (tuple[Any, ...]) |
  | :----------------------------------------------------------------------- |
  | 進程初始化函式的引數                                                     |

  | 📗 <span class="tip">TIP</span> : init arg - `maxtasksperchild` (int)                                                                       |
  | :----------------------------------------------------------------------------------------------------------------------------------------- |
  | 指定每個工作進程處理的最大任務數。當達到這個數量後，工作進程會被終止並由新工作進程取代。<br>好處是可避免工作進程意外的資源洩漏或過度膨脹。 |

  | 📗 <span class="tip">TIP</span> : method kwarg - `chuncksize` (int) |
  | :------------------------------------------------------------------ |
  | `chunk_size=1` : **每個工作進程一次處理一個任務 (預設)**<br>這樣可以保證所有工作進程均勻地分配任務，但在處理大量小型任務時，可能會導致性能下降，<br>因為每次分配任務時都需要進行[進程間通訊 (IPC)]。|
  |`chunk_size>1` : **每個工作進程一次處理多個任務**<br>減少了[進程間通訊 (IPC)] 的次數，可能提高效率，尤其是在每個任務執行時間短而需要頻繁調度的情況下。<br>但要注意若混雜大型任務，可能導致一個工作進程不幸被分配到多個大型任務 (拖慢整體執行時間)。|

  | 🔮 <span class="important">NOTE</span> : 同步作業                                             |
  | :-------------------------------------------------------------------------------------- |
  | 表示<mark>任務的執行會阻塞主進程</mark>，直到所有任務完成後，主進程才會繼續執行。 |

  | 🔮 <span class="important">NOTE</span> : 異步作業                                             |
  | :-------------------------------------------------------------------------------------- |
  | 表示<mark>任務的執行不會阻塞主進程</mark>，任務派發完畢後，主進程就會繼續執行。 |

  | 🔮 <span class="important">NOTE</span> : Future 物件                                          |
  | :-------------------------------------------------------------------------------------- |
  | 由於派發出去的任務，計算結果尚未出爐，故而需要一種物件來代理這個未知的結果。這就是 Future 物件。<br>「<mark>老闆，我要一份蚵仔煎，待會來拿！</mark>」，這句話就體現 Future 物件的精髓所在。 |

  |🚨 <span class="caution">CAUTION</span>|
  | :--- |
  | 任務一派發下去就會開始計算，不存在甚麼 lazy evaluation 的部分。<br>別把這裡的 `map` 和 Python 內建的 `map` 搞混了。 |

  | method / attribute                               | description                                                                              |
  | ------------------------------------------------ | ---------------------------------------------------------------------------------------- |
  | `apply(func, args=(), kwds={})`                  | <mark>**#同步作業**</mark><br>傳入 : <mark>一組引數帶入</mark>函式 `func` 執行<br>回傳 : 結果物件 |
  | `apply_async(func, args=(), kwds={})`            | <mark>**#異步作業**</mark><br>傳入 : <mark>一組引數帶入</mark>函式 `func` 執行<br>回傳 : Future 物件 |
  | `map(func, iterable, chunksize=None)`            | <mark>**#同步作業**</mark><br>傳入 : <mark>多個引數一個一個帶入</mark>函式 `func` 執行<br>回傳 : 結果物件 list (<ins>按原順序</ins>)<br>(🔮 <span class="important">IMPORTANT</span> : `get()` 時需等所有結果到齊)  |
  | `map_async(func, iterable, chunksize=None)`      | <mark>**#異步作業**</mark><br>傳入 : <mark>多個引數一個一個帶入</mark>函式 `func` 執行<br>回傳 : Future 物件容器 (<ins>按原順序</ins>)<br>(🔮 <span class="important">IMPORTANT</span> : `get()` 時需等所有結果到齊)   |
  | `imap(func, iterable, chunksize=None)`           | <mark>**#異步作業**</mark><br>傳入 : <mark>多個引數一個一個帶入</mark>函式 `func` 執行<br>回傳 : 結果物件迭代器 (<ins>按原順序</ins>)<br>(🔮 <span class="important">IMPORTANT</span> : 迭代時按原順序等待結果，產出即可被主進程利用)   |
  | `imap_unordered(func, iterable, chunksize=None)` | <mark>**#異步作業**</mark><br>傳入 : <mark>多個引數一個一個帶入</mark>函式 `func` 執行<br>回傳 : 結果物件迭代器(<ins><mark>不</mark>按原順序</ins>)<br>(🔮 <span class="important">IMPORTANT</span> : 迭代時不按原順序等待結果，產出即可被主進程利用)<br>(📗 <span class="tip">TIP</span> : 若你想使用此特色，但函式 `func` 有多個參數，<br>請善用 `partial` 將函式固定成僅接受單引數)   |
  | `starmap(func, iterable, chunksize=None)`        | <mark>**#同步作業**</mark><br>傳入 : <mark>多組引數一組一組帶入</mark>函式 `func` 執行<br>回傳 : Future 迭代器 (<ins>按原順序</ins>) |
  | `starmap_async(func, iterable, chunksize=None)`  | <mark>**#異步作業**</mark><br>傳入 : <mark>多組引數一組一組帶入</mark>函式 `func` 執行<br>回傳 : Future 迭代器 (<ins>按原順序</ins>) |
  | `close()`                                        | 進程池停止接受新的任務 (在 `terminate()` 之前調用)                    |
  | `join()`                                         | 等待進程池中的所有工作進程完成任務 (在 `terminate()` 之前調用)    |
  | `terminate()`                                    | 強制終止進程池中的所有工作進程 (`__exit__()` 將調用此方法)    |
  | `processes`                                      | `Pool` 中的工作進程數量  |

  ```mermaid
  gantt
      dateFormat  mm:ss
      axisFormat  %M:%S
      tickInterval 1second
      title       imap

      section Process 1
      C          :C, 00:00, 3s
      section Process 2
      B          :B, 00:00, 2s
      section Process 3
      D          :D, 00:00, 4s
      section Process 4
      E          :E, 00:00, 5s
      section Process 5
      A          :A, 00:00, 1s
      section Process main
      review C result  :c, after C, 0.4s
      review B result  :b, after c, 0.4s
      review D result  :d, after D, 0.4s
      review E result  :e, after E, 0.4s
      review A result  :a, after e, 0.4s
  ```

  ```mermaid
  gantt
      dateFormat  mm:ss
      axisFormat  %M:%S
      tickInterval 1second
      title       imap_unordered

      section Process 1
      C          :C, 00:00, 3s
      section Process 2
      B          :B, 00:00, 2s
      section Process 3
      D          :D, 00:00, 4s
      section Process 4
      E          :E, 00:00, 5s
      section Process 5
      A          :A, 00:00, 1s
      section Process main
      review A result  :a, after A, 0.4s
      review B result  :b, after B, 0.4s
      review C result  :c, after C, 0.4s
      review D result  :d, after D, 0.4s
      review E result  :e, after E, 0.4s
  ```

+ `ApplyResult` / `AsyncResult` / `MapResult`
  > 皆為異步作業時回傳的代理結果物件。\
  > 前兩者為 Future 物件，後者為 Future 物件容器。

  | method / attribute | description                                                                    |
  | ------------------ | ------------------------------------------------------------------------------ |
  | `get(timeout)`     | 取得 Future 物件 (們) 的結果。若尚未可取得，則阻塞主進程。<br>若指定時間內仍未取得結果，則引發 `TimeoutError` |
  | `wait(timeout)`    | 檢查結果是否出爐，會阻塞主進程，或等 timeout 秒後繼續執行     |
  | `ready()`          | 檢查結果是否出爐，不阻塞主進程        |
  | `successful()`     | 若 `not ready()` 則引發 `ValueError`     |

+ `IMapIterator` / `IMapUnorderedIterator`
  > 皆為異步作業時回傳的結果物件迭代器。


+ `Manager`
  > 不僅提供跨 process 共享數據，還能透過網路跨主機共享數據。

  | 📘 <span class="note">NOTE</span> : 管理支援類型                                             |
  | :-------------------------------------------------------------------------------------- |
  | `list`,`dict`,`Namespace`,`Lock`,`RLock`,`Semaphore`,`BoundedSemaphore`,`Condition`,`Event`,`Barrier`,`Queue`,`Value`,`Array` |

  | 📘 <span class="note">NOTE</span> : 內部實現                                             |
  | :-------------------------------------------------------------------------------------- |
  | 創建了一個 server process，它負責管理共享物件，並允許其它進程使用代理物件 (proxy) 操縱共享物件。 |
