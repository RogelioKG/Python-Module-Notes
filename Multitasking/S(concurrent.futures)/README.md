# concurrent.futures

[![RogelioKG/concurrent.futures](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/concurrent-futures)


### 參考
+ 🔗 [**myapollo**](https://myapollo.com.tw/blog/python-concurrent-futures/#google_vignette)
+ 🔗 [**louie_lu's blog**](https://blog.louie.lu/2017/08/01/%E4%BD%A0%E6%89%80%E4%B8%8D%E7%9F%A5%E9%81%93%E7%9A%84-python-%E6%A8%99%E6%BA%96%E5%87%BD%E5%BC%8F%E5%BA%AB%E7%94%A8%E6%B3%95-06-concurrent-futures/)
+ 🔗 [**大質數表**](https://www.cnblogs.com/ljxtt/p/13514346.html)
<!-- link -->
[`concurrent.futures.Executor.shutdown`]: https://docs.python.org/zh-tw/3/library/concurrent.futures.html#concurrent.futures.Executor.shutdown
[`as_completed`]: #函式

### 說明
| 🔮 <span class="important">IMPORTANT</span>   |
| :------------------------------------------- |
| 🪄 使用 multi-threading 解決 I/O-bound tasks  |
| 🪄 使用 multi-processing 解決 CPU-bound tasks |

| 🚨 <span class="caution">CAUTION</span>|
| :------------------------------------- |
| 啟動新進程大概會有幾百毫秒左右的 overhead<br>(若任務沒有繁重到能慢於這個時間，那就別開多進程) |

### 函式

| function | desc |
| ------ | ---- |
| `as_completed(futures, timeout=None)` | 給定 `Future` 物件集合，回傳一個 Future 物件迭代器，<br>任務一旦完成，就產出它的 `Future` 物件 |


### 方法 / 屬性

+ **`Future`**

  | 📘 <span class="note">NOTE</span> : Future 物件                                          |
  | :-------------------------------------------------------------------------------------- |
  | 由於派發出去的任務，計算結果尚未出爐，故而需要一種物件來代理這個未知的結果。這就是 Future 物件。<br>「老闆，我要一份蚵仔煎，待會來拿！」，這句話就體現 Future 物件的精髓所在。 |

  | method | desc |
  | ------ | ---- |
  | `result(timeout=None)`                                  | 取得 `Future` 物件的結果。若尚未可取得，則阻塞主進程。若指定時間內仍未取得結果，則引發 `TimeoutError`。(類似隔壁棚 `multiprocessing` 的 `get()`) |
  | `cancel()`                                              | 嘗試取消尚未開始執行的 `Future` 物件 |
  | `cancelled()`                                           | 若 `Future` 物件已成功取消，回傳 `True` |
  | `running()`                                             | 若 `Future` 物件正在執行，回傳 `True` |
  | `done()`                                                | 若 `Future` 物件已完成，回傳 `True` |
  | `add_done_callback(fn)`                                 | 附加一個 callback，當 `Future` 物件完成後將被調用 (此 callback 函數的參數為 `Future` 物件) |
  | `exception(timeout=None)`                               | 取得 `Future` 物件引發的異常 (如果有的話)。若在指定時間仍未取得異常，引發 `TimeoutError` |

+ **`ProcessPoolExecutor`** / **`ThreadPoolExecutor`**
  
  > 進程池 / 線程池高階 API，皆繼承自 `Executor` 類別，這兩者 API 相同。可使用 `with` 進行上下文管理。


  | 📗 <span class="tip">TIP</span> : init arg - `max_workers` (int) |
  | :-------------------------------------------------------------- |
  | 創建進程 / 線程個數，預設 `os.cpu_count()`                             |

  | 📗 <span class="tip">TIP</span> : init arg - `initializer` (function) |
  | :------------------------------------------------------------------- |
  | 進程 / 線程初始化函數                                                       |

  | 📗 <span class="tip">TIP</span> : init arg - `initargs` (tuple[Any, ...]) |
  | :----------------------------------------------------------------------- |
  | 進程 / 線程初始化函數的引數                                                     |

  | 📘 <span class="note">NOTE</span> : 同步作業                                             |
  | :-------------------------------------------------------------------------------------- |
  | 表示**任務的執行會阻塞主進程**，直到所有任務完成後，主進程才會繼續執行。 |

  | 📘 <span class="note">NOTE</span> : 異步作業                                             |
  | :-------------------------------------------------------------------------------------- |
  | 表示**任務的執行不會阻塞主進程**，任務派發完畢後，主進程就會繼續執行。 |

  |🚨 <span class="caution">CAUTION</span>|
  | :--- |
  | 任務一派發下去就會開始計算，不存在甚麼 lazy evaluation 的部分。<br>別把這裡的 `map` 和 Python 內建的 `map` 搞混了。 |

  | method | desc |
  | ------ | ---- |
  | `submit(fn, *args, **kwargs)`                           | **#異步作業**<br>將<mark>**一組引數帶入**</mark>函式 `func` 執行，回傳 `Future` 物件<br>(📗 <span class="tip">TIP</span> : 類似 `apply_async`)<br>(🔮 <span class="important">IMPORTANT</span> : 對 `Future` 物件集合調用 [`as_completed`]，<br>就能達成類似 `imap_unordered` 的效果) |
  | `map(fn, *iterables, timeout=None, chunksize=1)`        | **#異步作業**<br>#結果按原順序<br>將<mark>**多個引數一個一個帶入**</mark>函式 `func` 執行，回傳結果迭代器<br>(📗 <span class="tip">TIP</span> : 類似 `imap`)<br>(🔮 <span class="important">IMPORTANT</span> : 迭代時會按原順序等待結果，產出即可被主進程利用) |
  | `shutdown(wait=True, cancel_futures=False)`             | 當前所有未定的 `Future` 物件都執行完後才釋放資源 (`__exit__()` 將調用此方法)。(關於 `wait` 與 `cancel_futures` 選項詳見[此處][`concurrent.futures.Executor.shutdown`]) |