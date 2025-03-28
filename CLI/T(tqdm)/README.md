# tqdm

[![RogelioKG/tqdm](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/tqdm)

### 參考
+ 🔗 [**Github : source code**](https://github.com/tqdm/tqdm)
+ 🔗 [**clay-atlas**](https://clay-atlas.com/blog/2019/11/11/python-chinese-tutorial-tqdm-progress-and-ourself/)
+ 🔗 [**StackOverflow : Fix jumping of multiple progress bars (tqdm) in python multiprocessing**](https://stackoverflow.com/questions/56665639/fix-jumping-of-multiple-progress-bars-tqdm-in-python-multiprocessing)

### 注意

|🚨 <span class="caution">CAUTION</span>|
|:---|
|使用 for-loop 迭代的進度條是不會有 context management 的。|

|📗 <span class="tip">TIP</span>|
|:---|
|在極大量 total 且 update 又非常少量的情況下，<br />狀態不會實時 output (只會間斷性 output)。<br />未進行 output 的 update 耗時為 600 ns；<br />進行 output 的 update 耗時為 400 us (666 倍)。<br />而 `disable=True` 能遏止 output。<br />(如果不需要輸出的話，可以考慮關掉，雖然它通常不怎麼佔性能開銷)|

### 參數 (`tqdm`)

```py
iterable: Iterable[int]     # 迭代器
desc: str                   # 進度條敘述
total: float                # 進度條總量 (☢️ 若 iterable 為產生器，需指定總量才會顯示進度條)
leave: bool                 # 結束後，進度條是否留在輸出
ncols: int                  # 進度條使用幾行空間
mininterval: float = 0.1,   # 最小更新時間區間 (0.1s)
maxinterval: float = 10,    # 最大更新時間區間 (10s)

ascii: bool | str           # True 的話就使用 ascii
                            # 或者你也可以給 str
                            # 預設是 " 123456789#"
                            # 翻譯蒟蒻：未完成顯示 " "，已完成顯示 "#"，一格之間分成9種進度，看刷新的時候跑到哪，決定顯示哪個數字

disable: bool = False       # 不顯示
unit: str = "it",           # 單位
unit_scale: bool = False,   # 單位自動縮放
bar_format: str             # 自訂進度條格式 (會影響性能)
initial: float = 0,         # 一開始就跑到幾%
unit_divisor: float = 1000, # 單位換算 (如果你有指定單位自動縮放)
colour: str                 # 進度條顏色
delay: float = 0,           # 開頭不顯示幾秒
```

### 方法 (`tqdm`)
| method | description |
| ------ | ----------- |
| `close()` | 關閉進度條，清理其資源。 |
| `clear(nolock=False)` | 從螢幕上移除進度條，通常在多個進度條之間切換時使用。 |
| `refresh(nolock=False)` | 強制刷新進度條，立即顯示當前進度。 |
| `reset(total=None)` | 重置進度條，並可以選擇性地設置新的總步數。 |
| `update(n=1)` | 將進度條增加 `n` 步 (預設為 1)。 |
| `set_description(desc=None, refresh=True)` | 設置進度條的新描述，並可選擇是否刷新顯示。 |
| `set_description_str(desc=None, refresh=True)` | 類似於 `set_description`，但直接接受字串來設置描述。 |
| `set_postfix(ordered_dict=None, refresh=True, **kwargs)` | 設置後綴字串，允許在進度條上顯示自定義信息。 |
| `set_postfix_str(s='', refresh=True)` | 類似於 `set_postfix`，但直接接受字串來設置後綴。 |
| `write(s, file=None, end='\n', nolock=False)` | 將字串 `s` 寫入輸出檔案 (預設為 `sys.stdout`)，跳過進度條的顯示。 |
| `format_meter(...)` | 用於格式化進度條顯示的工具方法。 |
| `display(msg=None, pos=None, nolock=False)` | 渲染進度條，並可選擇性地顯示消息 `msg`。 |
| `unpause()` | 恢復被暫停的進度條。 |
| `update_to(n)` | 手動將進度條設置為 `n` 步，並相應地更新。 |
| `reset_pbar()` | 重置與進度條顯示相關的內部變量。 |
| `last_print_n()` | 返回進度條最後一次打印的位置，以 `n` 的形式表示。 |
| `last_print_t()` | 返回進度條最後一次打印的時間戳。 |
| `ema()` | 返回速率的指數移動平均值。 |
| `start_t` | 返回進度條的開始時間。 |
| `n` | 返回進度條的當前步數。 |
| `total` | 返回進度條的總步數。 |
| `sp` | 返回進度條的簡短描述 (通常顯示在終端中)。 |
| `desc` | 返回進度條的描述。 |
| `unit` | 返回進度條的計量單位 (預設為 'it')。 |
| `rate` | 返回當前的進度速率。 |
| `format_interval(t)` | 格式化時間間隔 `t` 的工具方法。 |
| `format_num(n)` | 格式化數字 `n` 的工具方法。 |

### 多進程進度條

1. 讓每個 children process 都有一個 worker_id (從 1 開始，不重複)
2. 同時 worker_id 也作為 children process 進度條的 position (每個 process 都待在自己位置)
3. 對 children process 進度條使用 leave=False 讓輸出保持乾淨 (留著會導致輸出錯位)
4. 讓 main process 負責管理總進度條
5. 要上輸出鎖 (同一時間只能有一個 update，沒鎖可能導致輸出錯位)

```py
import time
import random
from multiprocessing import get_context, current_process
from tqdm import tqdm


def progresser(n: int) -> int:
    counts = 100
    worker_id = current_process()._identity[0]
    with tqdm(
        total=counts,
        desc=f"#{n} on worker {worker_id}",
        position=worker_id,
        ascii=" ▯▮",
        leave=False,
    ) as pbar:
        for _ in range(counts):
            pbar.update(1)
            time.sleep(random.uniform(0, 0.05))
    return n


if __name__ == "__main__":
    # 進程啟動方法: spawn
    context = get_context("spawn")
    # 輸出鎖
    output_lock = context.RLock()
    tqdm.set_lock(output_lock)

    numbers = [*range(100)]
    with context.Pool(
        processes=10, initializer=tqdm.set_lock, initargs=(output_lock,)
    ) as pool:
        with tqdm(total=len(numbers), desc=f"TOTAL", ascii=" ▯▮") as pbar:
            results = pool.imap(progresser, numbers)
            for result in results:
                pbar.update(1)
```