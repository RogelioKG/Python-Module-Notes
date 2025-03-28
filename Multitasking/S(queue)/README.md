# queue

[![RogelioKG/queue](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/queue)

### 說明
專為多線程中 multiple producers & consumers 場景設計的佇列

### 常用
+ **類別**
  | class             | description      |
  | ----------------- | ---------------- |
  | `Queue()`         | 同步先進先出佇列 |
  | `PriorityQueue()` | 同步優先佇列     |
  | `LifoQueue()`     | 同步後進後出佇列 |

+ **方法**
  | method               | description                                                                                                         |
  | -------------------- | ------------------------------------------------------------------------------------------------------------------- |
  | `qsize()`            | 返回佇列的大小                                                                                                      |
  | `empty()`            | 如果佇列為空，返回 `True`，反之返回 `False`                                                                         |
  | `full()`             | 如果佇列滿了，返回 `True`，反之返回 `False`                                                                         |
  | `get(block,timeout)` | 取出佇列的項目，`timeout` 可指定等待時間                                                                            |
  | `get_nowait()`       | 等於 `get(block=False)`，因為是非 blocking 操作，線程若無法獲取元素時，不會進入等待狀態。反之，此函數 `raise Full`  |
  | `put(item)`          | 放入佇列的項目，`timeout` 可指定等待時間                                                                            |
  | `put_nowait(item)`   | 等於 `put(item, False)`，因為是非 blocking 操作，線程若無法放入元素時，不會進入等待狀態。反之，此函數 `raise Empty` |
  | `task_done()`        | 在 consumer 完成一項工作之後，向佇列發送一個工作已經完成的訊號                                                                |
  | `join()`             | 等待所有的工作完成之後，再繼續執行 (註：【佇列為空】是【所有工作完成】的必要非充分條件)                             |

### 工作完成
  > 很多時候你會遇到這種要求：「確定資料都已經由 consumer 處理完畢，\
  > 而非單純佇列為空 (說不定資料只是拿走，consumer 還沒處理完)。\
  > 因為資料必須處理完畢，其他工作才能拿這些完整的已處理資料進行下一步作業」\
  > 這個時候我們就需要多一個條件變數，來判斷被 consumer 拿走的資料是否皆已處理完畢。

  ```py
  def task_done(self):
      with self.all_tasks_done:
          unfinished = self.unfinished_tasks - 1
          if unfinished <= 0:
              if unfinished < 0:
                  raise ValueError('task_done() called too many times')
              self.all_tasks_done.notify_all() # unfinished == 0，資料皆已處理完畢，在等資料的線程們，你們可以做事了！
          self.unfinished_tasks = unfinished
  ```
  ```py
  def join(self):
      with self.all_tasks_done:
          while self.unfinished_tasks:
              self.all_tasks_done.wait() # 等待 consumer 將資料處理完畢的線程
  ```