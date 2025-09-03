# pandas

[![RogelioKG/pandas](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/pandas)

## 參考
+ 🔗 [**JOIN 可視化**](https://joins.spathon.com/)

## 常見參數
```py
inplace: bool                   # True：更動原物件，False：直接創建新物件
axis: int                       # 0：列，1：欄 (table[欄][列])
index: list[str] | pd.Index     # 指定是哪幾列
columns: list[str] | pd.Index   # 指定是哪幾欄
```

## 索引

```
     A   B   C   D   E  (欄/行)
 a   1   2   3   4   5
 b   2   4   6   8  10
 c   3   6   9  12  15
 d   4   8  12  16  20
(列)
```

```py
df = pd.DataFrame(
    [[i * j for i in range(1, 6)] for j in range(1, 5)],
    ["a", "b", "c", "d"],
    ["A", "B", "C", "D", "E"],
)

# ⚠️ 資料表索引
print(df["C"]["a"])
#         欄   列
print(df["C"])   # Series
print(df[["C"]]) # DataFrame

# ⚠️ 矩陣名稱索引
print(df.loc["a"]["C"])
#             列   行
print(df.loc["a"])   # Series
print(df.loc[["a"]]) # DataFrame


# ⚠️ 矩陣數字索引
print(df.iloc[0][2])
#             列 行
print(df.iloc[0])   # Series
print(df.iloc[[0]]) # DataFrame
```

## 小技巧

### `布林 Series`

```py
data = {
    "value": [10, 15, 8, 12, 14],
    "date": ["2023-10-01", "2023-10-02", "2023-10-03", "2023-10-04", "2023-10-05"],
}

df = pd.DataFrame(data)

print(df["value"])
# 0    10
# 1    15
# 2     8
# 3    12
# 4    14
# Name: value, dtype: int64

print(df["value"] < 11)
# 0     True
# 1    False
# 2     True
# 3    False
# 4    False
# Name: value, dtype: bool

print(df.loc[df["value"] < 11])
#    value        date
# 0     10  2023-10-01
# 2      8  2023-10-03
```

## 類別

### `pd.Index()`
> Pandas 儲存【索引名稱列表】的資料結構

### `pd.MultiIndex()`
> Pandas 儲存多重【索引名稱列表】的資料結構

+ 工廠函式
  ```py
  pd.MultiIndex.from_tuples   # 用 list[tuple] 創建
  pd.MultiIndex.from_arrays   # 用 list[list] 創建
  ```

### `pd.Series()`

+ 參數
  ```
  data  : 一欄資料
  name  : 名稱 (串接時，作為每欄索引名稱)
  index : 每列索引名稱 (預設：列舉)
  dtype : 資料型態
  copy  : 深拷貝 (預設：False)
  ```

+ 屬性
  ```py
  ser.values  # 一維 NDA
  ser.index   # 每列索引名稱
  ser.plot    # 建立在 matplotlib 上的高層封裝，用它快速畫圖
              #  - 參數：(x="x軸索引名稱", y="y軸索引名稱", kind="圖類型")
  ```

+ 方法
  ```py
  # 方法 - to 系列
  ser.to_frame()

  # 方法 - 欄位計算 (聚合函數)
  ser.max()       # 最大值
  ser.min()       # 最小值
  ser.mean()      # 平均值
  ser.median()    # 中位數
  ser.std()       # 標準差
  ser.count()     # 總數量
  ser.sum()       # 加總
  
  # 方法 - 映射
  ser.map()       # 映射 (字典)
                      # - 範例：pd.Series(['cat', 'dog', 'bird']).map({'cat': '貓', 'dog': '狗'})

  ser.apply()     # 映射 (函數)
                      # - 範例：pd.Series([1, 2, 3, 4]).apply(lambda x: x ** 2)
  ```

### `pd.DataFrame()`

+ 參數
  ```
  data    : 多欄資料 (字典，key 為欄索引名稱、value 為一欄資料；矩陣，每列即一列資料)
  index   : 每列索引名稱 (預設：列舉)
  columns : 每欄索引名稱 (預設：列舉)
  dtype   : 資料型態
  name    : 名字
  copy    : 深拷貝 (預設：False)
  ```

+ 小技巧
  ```py
  # 範例資料
  data1 = {"Column1": [1, 3, 5],
          "Column2": [2, 4, 6]}
  df1 = pd.DataFrame(data1)
  #    Column1  Column2
  # 0        1        2
  # 1        3        4
  # 2        5        6

  # 索引
  df1["Column2"]              # Series 
  df1[["Column2"]]            # DataFrame
  df1[["Column1", "Column2"]] # DataFrame

  # 新增一欄資料
  df1["Column3"] = [-1, -2, -3, -4]
  #    Column1  Column2  Column3
  # 0        1        2       -1
  # 1        3        4       -2
  # 2        5        6       -3
  # 3        7        8       -4

  # 新增一列資料
  data2 = [[7, 8]]                               # ⚠️ 須為矩陣
  df2 = pd.DataFrame(data2, columns=df1.columns) # df2 欄索引同 df1
  df1 = pd.concat([df1, df2], ignore_index=True) # ⚠️ 須為列表，忽略 df2 原有列索引，串接
  #    Column1  Column2
  # 0        1        2
  # 1        3        4
  # 2        5        6
  # 3        7        8
  ```

+ 屬性
  ```py
  df.shape    # (列,欄)
  df.values   # 二維 NDA
  df.index    # 每列索引名稱
  df.columns  # 每欄索引名稱
  df.plot     # 建立在 matplotlib 上的高層封裝，用它快速畫圖
              #  - 參數：(x="x軸索引名稱", y="y軸索引名稱", kind="圖類型")
  df.loc      # 矩陣名稱索引 (可切片)
              #  - df.loc["r1"]["c2"]
              #  - df.loc["r1", "c2"]
              #  - df.loc["r1":"r3", "c2":"c5"]
              #  - df.loc[布林 Series]
  df.iloc     # 矩陣數字索引 (可切片)
  ```

+ 方法
  ```py
  # 方法 - to 系列
  df.to_pickle()      # 存成  pkl 檔
  df.to_hdf()         # 存成  hdf 檔
  df.to_csv()         # 存成  csv 檔
  df.to_json()        # 存成 json 檔
  df.to_xml()         # 存成  xml 檔
  df.to_excel()       # 存成 xlsx 檔
  df.to_markdown()    # 存成   md 檔
  df.to_sql()         # 存入資料庫 (較支援 SQLAlchemy)
  ...

  # 方法 - 初步資料分析
  df.info()           # 每欄索引名稱、非空值統計、資料型態
  df.describe()       # 每欄最大值、最小值、中位數、平均值、標準差、四分位數

  # 方法 - 過濾
  df.head()            # 只取前n列資料
  df.tail()            # 只取後n列資料
  df.nlargest()        # 只取前n大資料 (指定欄位)
  df.nsmallest()       # 只取前n小資料 (指定欄位)
  df.query()           # 查詢
                          # - 說明：要給一個字串化的布林判斷式
                          # - 範例：result = df.query('Age > 30 and Salary > 50000')
                          # - 翻譯：尋找年齡大於 50 歲且薪水超過 5 萬的人

  # 方法 - 更改
  df.drop()            # 丟掉某幾欄/列
  df.rename()          # 更改欄/列索引名稱 (給定 dict)
  df.reindex()         # 更改欄/列索引名稱，按現有順序 (給定 list)
  df.set_index()       # 列索引名稱 := 某欄所有值 (若給定多欄，則為 MultiIndex)
  df.reset_index()     # 還原 set_index
  df.astype()          # 轉換型態

  # 方法 - 缺失值
  df.fillna()          # 填充缺失值
  df.dropna()          # 丟棄有缺失值的資料

  # 方法 - 排序
  df.sort_index()      # 欄/列索引名稱排序
  df.sort_values()     # 值排序 (by=指定欄)
  df.value_counts()    # 計數後排序

  # 方法 - 映射
  df.apply(axis=)      # 映射 (函數、字典)
                        # - 說明：不要求映射結果對齊
                        # - 範例：df.apply(np.sum, axis=0)
  df.transform(axis=)  # 映射 (函數、字典)
                        # - 說明：要求映射結果對齊
                        # - 範例：df.transform(lambda x: x + 1)
                        # - 範例：df.transform({"薪水": np.log, "年齡": lambda x: x*2}
  ```

+ 方法
  ```py
  df.resample()
  # 說明
    # groupby    你傳一個分類欄位 (公司)，它就依照那個欄位分組
    # resample   你傳一個時間頻率 (6h、1D)，它就依照時間區間分組 (時間的 groupby)
  # 參數
    # rule       切分頻率
    # label      降採樣時，選擇左邊的時間還是右邊的時間
    # origin     採樣開始時間，選用 "start" 即為原 DataFrame 開始時間
    # closed     區間的封閉
    # on         取樣欄位，若未將時間欄位設為索引，這個要設 (datetime[ns])
  # 採樣
    # downsample 時間降採樣，時間粒度變粗
    # upsample   時間升採樣，時間粒度變細
  # 方法
    # asfreq()   指定填充空值
    # bfill()    向後填充空值
    # ffill()    向前填充空值
  # 範例
    df = pd.DataFrame({
        "time": pd.date_range("2024-01-01", periods=10, freq="6h"),
        "price": [10, 12, 14, 13, 15, 20, 18, 19, 25, 30]
    })

    df = df.set_index("time")  # ✅ 建議先把時間設成索引

    # 以 1 天為頻率，以平均作為新價格
    downsampled = df.resample("1D")["price"].mean()
    print(downsampled)

    # 以 1 小時為頻率，以向前填充作為新價格
    upsampled = df.resample("1h").ffill()
    print(upsampled)
  ```

### `DataFrameGroupBy()`
+ 範例
  ```py
  df = pd.DataFrame(
      {
          "公司": np.random.choice(["A", "B", "C"], 10),
          "薪水": np.random.randint(5, 50, 10),
          "年齡": np.random.randint(15, 50, 10),
      }
  )
  #   公司    薪水   年齡
  #    C      13    18
  #    A      33    22
  #    A      28    22
  #    B      44    17
  #    B      23    21
  #    B      39    35
  #    A      18    44
  #    C      34    28
  #    C      13    16
  #    C      35    39
  ```

+ 產生實例
  ```py
  df.groupby()            # 樞紐分析表
                            #  - 說明：根據某個欄位分組，分成若干個子 DataFrame
                            #  - 範例：df.groupby("公司")["薪水"].mean()
                            #  - 翻譯：【每家公司】其員工的【平均薪水】

  df.groupby("公司")         # DataFrameGroupBy
  df.groupby("公司")["薪水"]  # SeriesGroupBy
  ```

+ 方法
  ```py
  # 方法 - 映射
  df_group.apply()        # 映射 (函數)
                            # - 說明：不要求映射結果對齊、函數輸入為 Dataframe
  df_group.transform()    # 映射 (函數)
                            # - 說明：要求映射結果對齊、函數輸入為 Dataframe
  df_group.aggregate()    # 聚合 (字典)
                            # - 說明：不要求映射結果對齊
                            # - 範例：df.groupby("公司").agg({"薪水": ["median", "std"], "年齡": "mean"})
                            # - 翻譯：【每家公司】其員工的【薪水中位數、標準差】和【平均年齡】
  ```

### `SeriesGroupBy()`
+ 方法
  ```py
  # 方法 - 映射
  ser_group.apply()       # 映射 (函數)
                            # - 說明：不要求映射結果對齊、函數的輸入為 Series
  ser_group.transform()   # 映射 (函數)
                            # - 說明：要求映射結果對齊、函數的輸入為 Series
  ```


## 函數

### 讀取
> 可給 Raw Data URL
```py
pd.read_pickle() # 讀取  pkl 檔 (速度比: 6)
pd.read_hdf()    # 讀取  hdf 檔 (速度比: 5)
pd.read_csv()    # 讀取  csv 檔 (速度比: 1)
pd.read_json()   # 讀取 json 檔
pd.read_xml()    # 讀取  xml 檔
pd.read_excel()  # 讀取 xlsx 檔 (速度比: 1/136)
pd.read_sql()    # 讀取資料庫    (較支援 SQLAlchemy)
...
```

### 合併
+ [簡單合併](https://pandas.pydata.org/docs/user_guide/merging.html#concatenating-objects)
  ```py
  pd.concat(
      objs=None,              # list[DataFrame] | list[Series]
      axis=0,                 # {0, 1, …}，要串接的軸。
      join="outer",           # {'inner'，'outer'}。如何處理其他軸上的索引。outer 用於並集，inner 用於交集。
      ignore_index=False,     # 是否忽略現有索引，直接以 0 ~ n-1 代替
      keys=None,              # 建構多層索引 (就原有的索引直接再蓋一層上去，每個串接的表可再擁有多種索引)
      names=None,             # 每種多層索引的名稱
      verify_integrity=False, # 檢查新串接的表是否包含重複項 (重度消耗資源)
      copy=True,              # 深拷貝 
  )
  ```
+ [鍵匹配合併](https://pandas.pydata.org/docs/user_guide/merging.html#database-style-dataframe-or-named-series-joining-merging) (如 SQL 中的 JOIN)
  ```py
  pd.merge(
      left=None,              # 左 DataFrame
      right=None,             # 右 DataFrame
      how="inner",            # 合併 {'left', 'right', 'outer', 'inner', 'cross'}，詳見 JOIN 可視化

      # 第一種選擇: 同名欄 JOIN
      on=None,                # 黏合鍵 (須在左右 DataFrame 中找到)
      # 第二種選擇: 非同名欄 JOIN
      left_on=None,           # 左黏合鍵 (須在左 DataFrame 中找到)
      right_on=None,          # 右黏合鍵 (須在右 DataFrame 中找到)
      # (兩種選擇是互斥的，不能每個參數都給)

      left_index=False,
      right_index=False,
      sort=True,
      suffixes=("_x", "_y"),
      copy=True,
      indicator=False,
      validate=None,
  )
  ```


### 資料型態
```py
pd.to_datetime()
pd.to_numeric()
pd.to_timedelta()

# object            通常是字串，或者是其他型態
# int64             np.int64
# float64           np.float64
# bool              np.bool_
# datetime64        np.datetime64
# timedelta[ns]     np.timedelta[ns]
# category          類似枚舉，是只會出現有限集合中的字串 (例如性別：男或女)
```

### 其他
```py
# 日期區段
pd.date_range("2024-01-01", periods=10, freq="6h")
```