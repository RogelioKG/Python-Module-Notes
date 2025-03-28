# timeit

### 說明
測量小量程式片段的執行時間

### 命令行

```bash
python -m timeit [-n N] [-r N] [-u U] [-s S] [-p] [-v] [-h] [statement ...]
```
+ `-n N`, `--number=N` : 循環執行 statement N 次
+ `-r N`, `--repeat=N` : 重複 N 次 (預設 5)
+ `-s S`, `--setup=S` : 在計時之前執行一次給定陳述句 (預設為 pass)
+ `-p`, `--process` : 使用 `time.process_time()` 而非預設的 `time.perf_counter()`
+ `-u`, `--unit=U` : 指定計時輸出的時間單位；選項包括 nsec、usec、msec 或 sec


### 函式

+ `timeit`

  + `stmt` 循環測量

    ```py
    # 預設 number=1000000 (循環測量 1 million 次，重複 1 次)
    print(timeit.timeit("[*range(100)]"))
    # 0.29697520000627264
    print(timeit.timeit("list(range(100))"))
    # 0.3027831999934278
    print(timeit.timeit("[i for i in range(100)]"))
    # 1.4468121000099927
    ```

  + `setup`

    ```py
    # in main.py

    import timeit
    import numpy as np
    import random as rd


    def random_walk_with_np(len : int, step : int) -> np.ndarray:
        cur = 0
        choices = (len, -len)
        pos_list = np.array([0 for _ in range(step)])
        for i in range(1, step):
            cur += rd.choice(choices)
            pos_list[i] = cur
        return pos_list

    if __name__ == "__main__":
        print(
            timeit.timeit(
                "random_walk_with_np(1, 100)",
                setup="from __main__ import random_walk_with_np",
                number=100000,
            )
        )
        print(
            timeit.timeit(
                "random_walk_with_list(1, 100)",
                setup="from other_module import random_walk_with_list",
                number=100000,
            )
        )
    ```
    ```py
    # in other_module.py
    import random as rd

    def random_walk_with_list(len : int, step : int) -> list[int]:
        cur = 0
        choices = (len, -len)
        pos_list = [0]
        for _ in range(step):
            cur += rd.choice(choices)
            pos_list.append(cur)
        return pos_list
    ```

+ `repeat` 重複循環測量
  
  ```py
  # 預設 repeat=5 (循環測量 1 million 次，重複 5 次)
  print(timeit.repeat("[*range(100)]", repeat=4, number=100000))
  # [0.028477600018959492, 0.028065500024240464, 0.028283700055908412, 0.027781199954915792]
  print(timeit.repeat("list(range(100))", repeat=4, number=100000))
  # [0.030033899995032698, 0.03220309998141602, 0.03161269996780902, 0.032751600025221705]
  print(timeit.repeat("[i for i in range(100)]", repeat=4, number=100000))
  # [0.14540340000530705, 0.14015029999427497, 0.14177899999776855, 0.14758410002104938]
  ```