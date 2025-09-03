# random

## 🔰 採樣

+ `random.choice(seq)`

    隨機取出一個元素、等權重。

    ```python
    import random

    a = [2, 'cat', 3, 'dog']
    print(random.choice(a))  # 3 (隨機)

    print(random.choice('supercalifragilisticexpialidocious'))  
    # u (隨機)

    print(random.choice(range(100)))  
    # 31 (隨機)
    ```

+  `random.sample(population, k)`

    隨機取出數個元素、不重覆選取、等權重。

    ```python
    b = [2, 'cat', 3, 'dog']
    print(random.sample(b, 2))  
    # ['cat', 3] (隨機)

    print(random.sample('supercalifragilisticexpialidocious', 6))  
    # ['c', 'r', 'l', 'u', 'l', 'i'] (隨機)

    print(random.sample(range(100), k=5))  
    # [26, 98, 64, 40, 82] (隨機)
    ```

+ `random.choices(population, weights=None, cum_weights=None, k=1)`

    隨機取出數個元素、重覆選取、可指定權重。

    ```python
    import itertools

    population = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

    # 相對權重
    weights = list(range(len(population)))
    print(weights)
    # [0, 1, 2, ..., 25]

    # 累積權重
    C = list(itertools.accumulate(weights))
    print(C)
    # [0, 1, 3, 6, 10, 15, ..., 325]

    print(random.choices(population, weights, k=5))  
    # ['T', 'Z', 'Q', 'Z', 'Y'] (隨機)
    ```

## 🔰 均勻分佈亂數

+ `random.randint(a, b)`

    生成 `[a, b]` 的隨機整數。

    ```python
    print(random.randint(1, 6))  # 骰子 → 5 (隨機)
    ```

+ `random.randrange(start, stop[, step])`

    生成 `[a, b)` 的隨機整數、可指定步進。

    ```python
    print(random.randrange(100, 1000, 5))  # 715 (隨機)
    ```

+ `random.random()`

    生成 `[0, 1)` 的隨機浮點數。

    ```python
    print(random.random())  # 0.6414948028979464 (隨機)
    ```

+ `random.uniform(a, b)`

    生成 `[a, b]` 的隨機浮點數。

    ```python
    print(random.uniform(3, 13))  # 12.345200531397476 (隨機)
    ```

## 🔰 非均勻分佈亂數

+ `random.gauss(mu, sigma)`

    常態分佈。

    ```python
    print(random.gauss(mu=0, sigma=1))  # 平均值=0，標準差=1
    ```

+ `random.expovariate(lambd)`

    指數分佈。

    ```python
    print(random.expovariate(lambd=5))  # 平均值 = 1/5
    ```

+ `random.gammavariate(alpha, beta)`

    Gamma 分佈。

    ```python
    print(random.gammavariate(alpha=1, beta=1))
    ```

+ `random.betavariate(alpha, beta)`

    Beta 分佈。

    ```python
    print(random.betavariate(alpha=1, beta=1))
    ```

+ `random.triangular(low, high, mode)`

    三角分佈。

    ```python
    print(random.triangular(low=0, high=1, mode=1))
    ```

## 🔰 種子

+ `random.seed`

    種子會影響隨機數的生成。
    同個種子會生成相同的隨機數。
    種子在一個 process 內都是共用的，
    因此使用 multithreading 時，
    請記得它們會共享相同的種子。

    ```python
    random.seed(10)
    print(random.random())  # 0.5714025946899135
    print(random.random())  # 0.4288890546751146
    print(random.random())  # 0.5780913011344704

    random.seed(20)
    print(random.random())  # 0.9056396761745207
    print(random.random())  # 0.6862541570267026
    print(random.random())  # 0.7665092563626442

    # 重新設回 seed=10，結果與上面一致
    random.seed(10)
    print(random.random())  # 0.5714025946899135
    print(random.random())  # 0.4288890546751146
    print(random.random())  # 0.5780913011344704
    ```
