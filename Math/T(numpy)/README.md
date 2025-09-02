# numpy

[![RogelioKG/numpy](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/numpy)

## Note

### axis
  + `0`：第 0 軸 (行) [左手 - 拇指]
  + `1`：第 1 軸 (列) [左手 - 其他手指]
  + `2`：第 2 軸 (層) [左手 - 手掌]
  + `-1`：最終軸


## Class

### 陣列 [`ndarray`](https://www.delftstack.com/zh-tw/tutorial/python-numpy/numpy-ndarray/)

+ 索引方式
  ```py
  array_3D[層, 列, 行]
  array_3D[層][列][行]
  array_3D[1, 2, 3]         # 【第 1 層】-【第 2 列】-【第 3 行】的那個元素
  array_3D[1][2][3]
  array_3D[1:3, 2:4, 3:5]   # 【第 1~2 層】-【第 2~3 列】-【第 3~4 行】的那些元素
  array_3D[1:3][2:4][3:5]
  array_3D[:, :, 1]         # 【第 1 行】的那些元素
  array_3D[:][:][1]
  ```

+ 屬性
  | 屬性 | 說明 |
  |------|------|
  | `ndim` | 幾階張量 |
  | `size` | 元素數量 |
  | `shape` | 形狀 (層, 列, 行) |
  | `dtype` | 資料型態 |
  | `real` | 實部 |
  | `imag` | 虛部 |
  | `T` | 轉置 |

+ 方法
  | 方法 | 說明 |
  |------|------|
  | `transpose()` | 轉置 |
  | `sum(axis=)` | 總和 |
  | `cumsum(axis=)` | 累積總和 |
  | `min(axis=)` | 最小值 |
  | `max(axis=)` | 最大值 |
  | `mean(axis=)` | 平均數 |
  | `var(axis=)` | 變異數 |
  | `std(axis=)` | 標準差 |
  | `item(2,3,1)` | 等同 `arr[2][3][1]` |
  | `itemset((2,3,1), 10)` | 等同 `arr[2][3][1] = 10` |
  | `all(axis=)` | 是否全為 True |
  | `any(axis=)` | 是否有任一 True |
  | `flatten()` | 壓平（深拷貝） |
  | `ravel()` | 壓平（淺拷貝） |
  | `reshape(shape)` | 重塑 |
  | `unique(axis=)` | 挑出獨特元素並排序 |

+ 參數
  + `unique()`
    | 參數 | 說明 |
    |------|------|
    | `return_index=True` | 回傳獨特陣列在原陣列第一次出現的索引 |
    | `return_inverse=True` | 回傳重建原陣列所需的獨特陣列索引 |

### 資料型別 `dtype`

+ 內建型別
  | 型別 | 說明 |
  |------|------|
  | `np.bool_` | 布林 |
  | `np.string_` | ASCII 字串 |
  | `np.unicode_` | Unicode 字串 |
  | `np.int_` | 有號整數 (預設 int32) |
  | `np.int8/16/32/64/128/256` | 指定位數有號整數 |
  | `np.uint8/16/32/64/128/256` | 指定位數無號整數 |
  | `np.float_` | 浮點數 (預設 float64) |
  | `np.float16/32/64/80/96/128/256` | 指定位數浮點數 |
  | `np.complex_` | 複數 (預設 complex128) |
  | `np.complex64/128` | 指定位數複數 |

+ 自訂型別
  ```py
  Student = np.dtype([
      ('name', np.unicode_, 16),
      ('grades', np.float64, (2,))
  ])

  # struct Student
  # {
  #     unicode_ name[16];
  #     float64 grades[2];
  # };

  arr = np.array([
      ('Sarah', (8.0, 7.0)), 
      ('John', (6.0, 7.0))
  ], dtype=Student)
  ```
### 日期 `datetime64`
+ 使用
  ```py
  # 整數：自 UNIX 紀元時間開始偏移多久
  np.datetime64(1699518619, 's') # 2023-11-09T08:30:19
  # 字串：轉成日期，可指定精度
  np.datetime64('2023-11-09T08:30:19', 'D') # 2023-11-09
  ```

### 時間差 `timedelta64`
+ 使用
  ```py
  # 整數：偏移量
  np.datetime64('2009') + np.timedelta64(20, 'D') == np.datetime64('2009-01-21')
  ```

## Constant

### Math
+ 變數
  | 常數 | 說明 |
  |------|------|
  | `np.pi` | 圓周率 |
  | `np.e` | 自然常數 |

## Function

### Factory
+ 函數
  | 函數 | 說明 |
  |------|------|
  | `array(array_like)` | 從陣列類型物件建立 |
  | `asarray(array_like)` | 轉換為陣列 |
  | `arange(start, stop, step)` | 等差數列 |
  | `linspace(起點, 終點, 數量)` | 均勻分割區間 |
  | `zeros(shape)` | 全零陣列 |
  | `zeros_like(NDA)` | 與指定陣列同形狀的全零陣列 |
  | `ones(shape)` | 全一陣列 |
  | `ones_like(NDA)` | 與指定陣列同形狀的全一陣列 |
  | `empty(shape)` | 未初始化陣列 |
  | `empty_like(NDA)` | 與指定陣列同形狀的未初始化陣列 |
  | `full(shape, 值)` | 指定值填充陣列 |
  | `full_like(NDA, 值)` | 與指定陣列同形狀的指定值陣列 |
  | `eye(列, 行, k=向右位移)` | 對角矩陣 |
  | `identity(n)` | n 階單位矩陣 |
  | `tri(n)` | n 階單位下三角矩陣 |
  | `tril(列, 行, k=背對0的位移)` | 下三角矩陣 |
  | `triu(列, 行, k=背對0的位移)` | 上三角矩陣 |
  | `meshgrid(x座標點, y座標點)` | 網格化：返回 x 矩陣、y 矩陣，將所有網格點的座標分別組成矩陣 |

+ 參數
  + `linspace()`
    | 參數 | 說明 |
    |------|------|
    | `endpoint=True/False` | 是否包含終點 |
    | `retstep=True/False` | 是否回傳步進值 |
  + `array()` / `asarray()`
    | 參數 | 說明 |
    |------|------|
    | `object` | 陣列物件 |
    | `dtype=None` | 元素資料型別 |
    | `copy=True` | 是否深拷貝 |
    | `order='K'` | 記憶體儲存方式 |
    | `subok=False` | 是否允許子類別繼承 |
    | `ndmin=0` | 最小維度 |

### Math
+ 函數
  | 函數 | 說明 |
  |------|------|
  | `abs(NDA)` | 絕對值 |
  | `floor(NDA)` | 向下取整 |
  | `ceil(NDA)` | 向上取整 |
  | `power(底數NDA, 指數NDA)` | 冪運算 |
  | `exp(NDA)` | e 的指數次方 |
  | `sqrt(底數NDA)` | 平方根 |
  | `log(真數NDA)` | 自然對數 |
  | `log10(真數NDA)` | 常用對數 |
  | `radians(角度)` | 角度轉弧度 |
  | `degrees(弧度)` | 弧度轉角度 |
  | `sin()` | 正弦 |
  | `cos()` | 餘弦 |
  | `tan()` | 正切 |
  | `asin()` | 反正弦 |
  | `acos()` | 反餘弦 |
  | `atan()` | 反正切 |
  | `arcsinh()` | 反雙曲正弦 |
  | `arccosh()` | 反雙曲餘弦 |
  | `arctanh()` | 反雙曲正切 |

### Calculate
+ 函數
  | 函數 | 說明 |
  |------|------|
  | `dot(NDA, NDA)` | 內積（等同 `NDA @ NDA`） |
  | `cross(NDA, NDA)` | 外積 |
  | `allclose(NDA, NDA, 相對誤差, 絕對誤差)` | 判斷是否大致相等 |
  | `average(NDA, axis=, weights=)` | 算術平均或加權平均 |

### Condition
+ 函數
  | 函數 | 說明 |
  |------|------|
  | `count_nonzero(條件)` | 計算符合條件的元素數量 |
  | `where(條件, x操作, y操作)` | 無 x、y 操作時回傳滿足條件的 tuple[層索引, 列索引, 行索引]；有時執行對應操作並回傳 NDA |
  | `clip(NDA, min, max)` | 限制數值範圍 |

### Operation
+ 函數
  | 函數 | 說明 |
  |------|------|
  | `transpose(NDA, axes)` | 轉置 |
  | `vstack(NDA, NDA)` | 垂直堆疊 |
  | `hstack(NDA, NDA)` | 水平堆疊 |
  | `vsplit(NDA, 塊數)` | 垂直分割 |
  | `hsplit(NDA, 塊數)` | 水平分割 |
  | `append(NDA, NDA, axis=)` | 附加元素（創建新陣列） |
  | `repeat(NDA, 重複次數, axis=)` | 重複元素 |

### Setting
+ 函數
  | 函數 | 說明 |
  |------|------|
  | `set_printoptions(參數)` | 更改列印參數 |

+ 參數
  + `set_printoptions()`
    | 參數 | 說明 |
    |------|------|
    | `precision=None` | 小數精確度 |
    | `threshold=None` | 元素門檻值（超過則省略中間部分） |
    | `edgeitems=None` | 省略時前後顯示的元素數量 |
    | `linewidth=None` | 行寬度 |
    | `suppress=None` | 抑制顯示小數位 |
    | `nanstr=None` | NaN 值顯示字串 |
    | `infstr=None` | 無限值顯示字串 |
    | `formatter=None` | 自訂格式化函數 |
    | `sign=None` | 正負號控制 |
    | `floatmode=None` | 浮點數顯示模式 |

## Tips

### Vectorization

+ 單變數
  ```py
  a = np.arange(10)
  print(a)          # [0 1 2 3 4 5 6 7 8 9]
  print(a + 1)      # [1  2  3  4  5  6  7  8  9  10]
  print(a < 5)      # [True True True True True False False False False False]
  ```

+ 多變數
  ```py
  x = np.linspace(-1, 1, 3)
  y = np.linspace(-1, 1, 3)
  z = x**2 + y**2

  print(x) # [-1. 0. 1.]
  print(y) # [-1. 0. 1.]
           #   |  |  |
           #   v  v  v
  print(z) # [ 2. 0. 2.]
  ```