# asyncio

[![RogelioKG/asyncio](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/asyncio)

## References
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
  + 🎞️ [**GaoGaoTianTian - asyncio的理解与入门，搞不明白协程？看这个视频就够了**](https://youtu.be/brYsDi-JajI)
  + 🎞️ [**GaoGaoTianTian - await机制详解。再来个硬核内容，把并行和依赖背后的原理全给你讲明白**](https://youtu.be/K0BjgYZbgfE)


## Note

| 🚨 <span class="caution">CAUTION</span>                                                                                                                 |
| :----------------------------------------------------------------------------------------------------------------------------------------------------- |
| 此篇文章嘗試描述異步機制的觀點，是<mark>筆者在尚未學習 JavaScript 的 Promise 前所著</mark>。在此還是建議讀者先去學 Promise，會更好理解與入門異步機制。 |
| 🎞️ [**Lydia Hallie - JavaScript Visualized - Event Loop, Web APIs, (Micro)task Queue**](https://youtu.be/eiC58R16hb8)                                   |
| 🎞️ [**Lydia Hallie - JavaScript Visualized - Promise Execution**](https://youtu.be/Xs1EMmBLpn4)                                                         |


| 📘 <span class="note">NOTE</span> : 協程                                 |
| :---------------------------------------------------------------------- |
| 實作：在 Python 中以 generator 實作                                     |
| 本質：一個可以開始 (enter) / 暫停 (exit) / 任意恢復執行 (resume) 的函式 |
| 單進程單線程 (若不使用 `to_thread`)                                     |

| 📘 <span class="note">NOTE</span> : 異步 v.s. 多線程                                                                                                                                                                                                                                                                                                                                               |
| :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Q : `asyncio` 和 `threading` 似乎都是處理 I/O bound task 的工具，<br />且在 CPython 中，它們都是並發 (concurrency)。<br />既然協程比線程輕量，為何我還要使用線程？<br />                                                                                                                                                                                                                          |
| A :<br /><mark>異步</mark> (`asyncio`) 屬於<mark>協作式多工</mark> (cooperative multitasking)，<br />意即控制權的轉讓決定在 coroutine 手上<br />(await 一個 future 或 task 的時候)，因而有可能被 blocking。<br /><br /><mark>多線程</mark> (`threading`) 屬於<mark>搶占式多工</mark> (preemptive multitasking)，<br />意即控制權的轉讓決定在 OS 手上，<br />時間到了就會切換，不會發生 blocking。 |


## Nouns

### awaitable / awaitable object
  + 屬於類別 `collection.abc.Awaitable` (實作 `__await__` 抽象方法)
  + 有實作 `__await__` 魔術方法的類別，即為 `collection.abc.Awaitable` 的子類別，\
    其 instance 即為 awaitable object (例如：coroutine, future, task)，這是透過 `__subclasshook__` 實作的，無須顯式繼承

### coroutine function
  + 以 `async def` 定義的函式，稱為 coroutine function

### coroutine / coroutine object
  + 屬於類別 `collection.abc.Coroutine` (繼承 `collection.abc.Awaitable`)
  + 調用 coroutine function 會產生一個 coroutine object

### future
  + 屬於類別 `asyncio.Future` (繼承 `collection.abc.Awaitable`)
  + 非常類似 JavaScript 的 Promise
  + 低階 API，<mark>不建議直接使用</mark>

### task
  + 屬於類別 `asyncio.Task` (繼承 `asyncio.Future`)
  + task 其實是一種特化的 future，其[專門管理 coroutine object 的執行與回傳結果](https://stackoverflow.com/a/64858226)
  + 必須將 coroutine object 包裝為 task
    + 使用 `asyncio.create_task()`
    + 此動作會順便把創建出來的 task 丟進 event loop 等待執行

### event loop
  + 屬於類別 `asyncio.AbstractEventLoop`
  + 背景運行，會不斷地排程、執行 task 和 callback (同個 thread 下)
  + 一次僅會執行 1 個 task

### executor
  + 負責在非 main thread 執行會造成阻塞的 task


## Keywords

### `async def`
  + 以此定義的函式，稱為 coroutine function

### `await`
  + 只能出現在 coroutine function 中
  + 需給定 awaitable object
    + 若給定 **coroutine**
      > coroutine function 將直接被執行，直到它 return 一個值。
    + 若給定 **task** (或 **future**)
      > 當前 task 會在給定 **task** (或 **future**) 掛上一個 callback，\
      > 告訴它等它完成的時候，把我 (當前 task) 叫醒 (event loop 執行它)，\
      > 接著當前 task 暫離 event loop，event loop 將轉而執行其他 task。
    + 否則
      > 嘗試調用該物件的 `__await__` 魔術方法
  + await 述句
    + 等待的 awaitable object 須執行完畢，當前 task 才會繼續往下執行
      + 這並不意味 await 述句的 task 必將在 await 述句處執行
      + 只要有 `create_task()` 或者 `gather()` (因為這些動作同時會將 task 同時放入 event loop)，在 await 述句之前都有可能執行
    + evaluation 值為 task 執行完後的回傳值

## Behind the Scences

### `asyncio.sleep()`

+ 實作
  ```py
  async def sleep(delay, result=None):
      """Coroutine that completes after a given time (in seconds)."""
      if delay <= 0:
          await __sleep0()
          return result

      if math.isnan(delay):
          raise ValueError("Invalid delay: NaN (not a number)")

      loop = events.get_running_loop()
      future = loop.create_future()
      h = loop.call_later(delay,
                          futures._set_result_unless_cancelled,
                          future, result)
      try:
          return await future
      finally:
          h.cancel()
  ```
+ 說明
  1.  `asyncio.sleep()` 即為一個 **coroutine object**，其內部等待一個 n 秒後會收到結果的 **future**
      + 所以當外層在 `await asyncio.sleep()` 時，實際上是在 await 一個 **coroutine object**
      + 根據 [await](#await) 的結論，這個 coroutine function 會即刻執行，直到它 `await future`，event loop 才會轉而執行其他 task
  2. 收到結果後，`asyncio.sleep()` 執行完畢，因為 `future` 設定的結果是 `None`，所以 `return None`
      + 所以說外層若 `print(await asyncio.sleep())` 就是 `None`
  3. 叫醒最外層那個 `await asyncio.sleep()` 的 **task**，讓它繼續執行。

## Usage

### Function
  | function                            | comments                                                                                                                              |
  | ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
  | `asyncio.iscoroutinefunction()`     | 是否為 coroutine function                                                                                                             |
  | `asyncio.iscoroutine()`             | 是否為 coroutine object                                                                                                               |
  | `asyncio.isfuture()`                | 是否為 future 或 task                                                                                                                 |
  | `asyncio.get_event_loop()`          | 回傳一個 event loop 實例                                                                                                              |
  | `asyncio.get_running_loop()`        | 回傳當前運行中的 event loop 實例                                                                                                      |
  | `asyncio.run()`                     | 建立 event loop，將傳入的 coroutine object 包裝成 task，放入此 event loop 等待執行                                                    |
  | `asyncio.create_task(coro)`         | 將 coroutine object 包裝成 task，放入 event loop 等待執行                                                                             |
  | `asyncio.sleep(n)`                  | 模擬一個 n 秒後會收到的 response (非阻塞)                                                                                             |
  | `asyncio.gather(coro1, coro2, ...)` | 將多個 coroutine objects 包裝成 tasks，放入 event loop 等待執行                                                                       |
  | `asyncio.wait_for()`                | 同 `create_task()`，但為 task 設置時限，超出時限則 raise `TimeoutError`                                                               |
  | `asyncio.to_thread()`               | 把耗時較久 (會導致阻塞 blocked) 的 task 交給 executor，並丟到其他 thread，由 executor 負責執行這個 task (event loop 留在 main thread) |
  | `asyncio.shield(task)`              | task 的聖盾術，使得 task 免於一次 cancel                                                                                              |

### Error
  | exception                | comments                    |
  | ------------------------ | --------------------------- |
  | `asyncio.CancelledError` | 此 task 已被移出 event loop |
  | `asyncio.TimeoutError`   | 此 task 已超出時限          |

+ `Task`
  | method                           | comments                |
  | -------------------------------- | ----------------------- |
  | `cancel()`                       | 將 task 移出 event loop |
  | `add_done_callback(callback)`    | 新增 callback           |
  | `remove_done_callback(callback)` | 移除 callback           |

+ `Future` (低階 API，<mark>不建議使用</mark>)
  | method         | comments                                                      |
  | -------------- | ------------------------------------------------------------- |
  | `set_result()` | 將 future 的 state 屬性標記為結束狀態，並設定 result 屬性的值 |
  | `result()`     | 回傳 future 的 result 屬性的值                                |
  | `cancelled()`  | future 是否被取消                                             |

+ `AbstractEventLoop` (低階 API，<mark>不建議使用</mark>)
  | method                               | comments                                                                                     |
  | ------------------------------------ | -------------------------------------------------------------------------------------------- |
  | `stop()`                             | 停止 event loop                                                                              |
  | `is_running()`                       | 如果 event loop 當前正在運行，則回傳 True                                                    |
  | `is_closed()`                        | 如果 event loop 已關閉，則回傳 True                                                          |
  | `close()`                            | 關閉 event loop                                                                              |
  | `run_until_complete(future)`         | 運行 event loop 直到 future 完成                                                             |
  | `run_forever()`                      | 運行 event loop 直到 `stop()` 被呼叫                                                         |
  | `time()`                             | 根據 event loop 的內部單調時鐘，回傳當前時間 (單位：秒)                                      |
  | `create_task(coro)`                  | 將 coroutine 包裝成 task，放入 event loop 等待執行                                           |
  | `create_future()`                    | 創建一個 future                                                                              |
  | `call_soon(callback, *args)`         | 把 callback 安排在下一次 event loop 的開頭執行。類似 JavaScript 的 `setTimeout(cb, 0)`       |
  | `call_later(delay, callback, *args)` | 在指定的秒數後，把 callback 丟進 event loop 排程。類似 JavaScript 的 `setTimeout(cb, delay)` |
  | `call_at(when, callback, *args)`     | 指定一個絕對時間點 (時間參照同 `time()`) 來安排 callback 的執行                              |

## Example

### 範例一：非阻塞任務
```py
import asyncio
import time
import random


class BaseTask:
    def __init__(self, payload: str, task_id: int):
        self.payload = payload
        self.task_id = task_id

    async def run(self) -> tuple[str, int]:
        """樣板方法 (一個任務固定經過三個步驟)"""
        await self.step_one()
        await self.step_two()
        await self.step_three()
        return (self.payload, self.task_id)

    async def step_one(self):
        """任務 1"""
        response_time = random.randint(2, 4)
        print(f"Task {self.task_id} step 1, takes {response_time}s")
        await asyncio.sleep(response_time)
        print(f"Task {self.task_id} step 1, done")
        self.payload += '1'

    async def step_two(self):
        """任務 2"""
        response_time = random.randint(1, 3)
        print(f"Task {self.task_id} step 2, take {response_time}s")
        await asyncio.sleep(response_time)
        print(f"Task {self.task_id} step 2, done")
        self.payload += '2'

    async def step_three(self):
        """任務 3"""
        response_time = random.randint(3, 5)
        print(f"Task {self.task_id} step 3, take {response_time}s")
        await asyncio.sleep(response_time)
        print(f"Task {self.task_id} step 3, done")
        self.payload += '3'


async def main():
    tasks = [BaseTask("payload", n).run() for n in range(3)]
    result = await asyncio.gather(*tasks)
    print(result)
    # [('payload123', 0), ('payload123', 1), ('payload123', 2)]


if __name__ == "__main__":
    start = time.perf_counter()
    asyncio.run(main())
    end = time.perf_counter()
    print(f"TIME: {end - start:.2f}s")

    # Task 0 step 1, takes 3s                                                                                                                                                               
    # Task 1 step 1, takes 4s
    # Task 2 step 1, takes 3s
    # Task 0 step 1, done
    # Task 0 step 2, take 2s
    # Task 2 step 1, done
    # Task 2 step 2, take 2s
    # Task 1 step 1, done
    # Task 1 step 2, take 2s
    # Task 0 step 2, done
    # Task 0 step 3, take 5s
    # Task 2 step 2, done
    # Task 2 step 3, take 3s
    # Task 1 step 2, done
    # Task 1 step 3, take 3s
    # Task 2 step 3, done
    # Task 1 step 3, done
    # Task 0 step 3, done
    # TIME: 10.04s
    
    # 3 個任務，阻塞式等待 6 秒，原需耗費至少 18 秒，
    # 在這裡因非阻塞等待，而降低到 10 秒。
```

### 範例二：如同 Promise 的 `Future`
```py
import asyncio


async def set_after(future: asyncio.Future, delay: float, value: str):
    await asyncio.sleep(delay)
    future.set_result(value)


def callback(future: asyncio.Future):
    # 第一個參數是固定會傳進來的
    print("I am callback!")


async def main():
    loop = asyncio.get_running_loop()
    future = loop.create_future()
    future.add_done_callback(callback)
    coro = set_after(future, 3, "... world")  # 3 秒後返回結果
    loop.create_task(coro)
    print("hello ")
    print(future.done())
    print(await future)
    print(future.done())
    print(future.result())


if __name__ == "__main__":
    asyncio.run(main())
    # hello
    # False
    # I am callback!
    # ... world
    # True
    # ... world
```

### 範例三：套套聖盾術 `shield`

```py
import asyncio


async def do_async_job():
    print("do_async_job!")
    await asyncio.sleep(2)
    print("protect me from cancelling!")


async def main():
    task = asyncio.create_task(do_async_job())
    shield = asyncio.shield(task)
    print("shield's type =>", type(shield))
    try:
        await asyncio.wait_for(shield, timeout=1)
    except asyncio.TimeoutError:
        print("timeout!")
        print(f"shield canceled: {shield.cancelled()}")
        print(f"task canceled: {task.cancelled()}")
        await task


if __name__ == "__main__":
    asyncio.run(main())
    # shield's type => <class '_asyncio.Future'>
    # do_async_job!
    # timeout!
    # shield canceled: True
    # task canceled: False
    # protect me from cancelling!
```

### 範例四：異步迭代器 AsyncIterator

```py
async for item in iterable:
    ...

# async for 的本質
iterator = iterable.__aiter__()
while True:
    try:
        item = await iterator.__anext__()
        ...
    except StopAsyncIteration:
        break
```

```py
import asyncio
import random


class WebSocketClient:
    def __init__(self, name, total_messages=5):
        self.name = name
        self.total_messages = total_messages
        self.received = 0

    def __aiter__(self):
        return self

    async def __anext__(self):
        if self.received >= self.total_messages:
            raise StopAsyncIteration
        await asyncio.sleep(random.uniform(0.5, 2))  # 模擬 request 延遲
        self.received += 1
        return f"Message for {self.name}: {self.received}"

    async def listen(self):
        async for msg in self:
            print("📩", msg)


async def main():
    client1 = WebSocketClient("ClientA")
    client2 = WebSocketClient("ClientB")

    await asyncio.gather(
        client1.listen(),
        client2.listen(),
    )


if __name__ == "__main__":
    asyncio.run(main())
    # 📩 Message for ClientB: 1
    # 📩 Message for ClientA: 2
    # 📩 Message for ClientA: 3
    # 📩 Message for ClientA: 4
    # 📩 Message for ClientB: 2
    # 📩 Message for ClientA: 5
    # 📩 Message for ClientB: 3
    # 📩 Message for ClientB: 4
    # 📩 Message for ClientB: 5
```

### 範例五：異步上下文管理器 AsyncContextManager

```py
async with resource as r:
    ...

# async with 的本質
r = await resource.__aenter__()
try:
    ...
finally:
    await resource.__aexit__(...)
```

```py
import asyncio
import random


class WebSocketClient:
    def __init__(self, name, total_messages=5):
        self.name = name
        self.total_messages = total_messages
        self.received = 0
        self.connected = False

    async def __aenter__(self):
        print(f"🔌 {self.name} connecting...")
        await asyncio.sleep(0.5)
        self.connected = True
        print(f"✅ {self.name} connected")
        return self

    async def __aexit__(self, exc_type, exc, tb):
        print(f"❌ {self.name} disconnecting...")
        await asyncio.sleep(0.5)
        self.connected = False
        print(f"✅ {self.name} disconnected")

    def __aiter__(self):
        return self

    async def __anext__(self):
        if self.received >= self.total_messages:
            raise StopAsyncIteration
        await asyncio.sleep(random.uniform(0.5, 1.5))  # 模擬 request 延遲
        self.received += 1
        return self.received

    async def listen(self):
        async for msg in self:
            print(f"📩 Message for {self.name}: {msg}")


async def main():
    async with WebSocketClient("ClientA") as c1, WebSocketClient("ClientB") as c2:
        await asyncio.gather(
            c1.listen(),
            c2.listen(),
        )


if __name__ == "__main__":
    asyncio.run(main())
    # 🔌 ClientA connecting...
    # ✅ ClientA connected
    # 🔌 ClientB connecting...
    # ✅ ClientB connected
    # 📩 Message for ClientB: 1
    # 📩 Message for ClientA: 1
    # 📩 Message for ClientB: 2
    # 📩 Message for ClientB: 3
    # 📩 Message for ClientA: 2
    # 📩 Message for ClientB: 4
    # 📩 Message for ClientA: 3
    # 📩 Message for ClientB: 5
    # 📩 Message for ClientA: 4
    # 📩 Message for ClientA: 5
    # ❌ ClientB disconnecting...
    # ✅ ClientB disconnected
    # ❌ ClientA disconnecting...
    # ✅ ClientA disconnected
```