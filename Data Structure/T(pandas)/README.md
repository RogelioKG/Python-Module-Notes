# pandas

[![RogelioKG/pandas](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/pandas)

```py
import numpy as np
import pandas as pd
from pandas.core.groupby.generic import DataFrameGroupBy, SeriesGroupBy
```

### 常見參數
```py
inplace: bool                   # True：更動原物件(-> None)，False：直接創建新物件(-> 物件)
axis: int                       # 0：列，1：欄 (table[欄][列])
index: list[str] | pd.Index     # 指定是哪幾列
columns: list[str] | pd.Index   # 指定是哪幾欄
```

### 索引

```
     A   B   C   D   E  (欄/行)
 a   1   2   3   4   5     |
 b   2   4   6   8  10     |
 c   3   6   9  12  15     |
 d   4   8  12  16  20     v
(列) --------------------->
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

### `Series[bool]`

  + **範例**

    ```py
    data = {
        "value": [10, 15, 8, 12, 14],
        "date": ["2023-10-01", "2023-10-02", "2023-10-03", "2023-10-04", "2023-10-05"],
    }

    df = pd.DataFrame(data)

    # Series
    print(df["value"])
    # 0    10
    # 1    15
    # 2     8
    # 3    12
    # 4    14
    # Name: value, dtype: int64
    ```

  + **布林 Series**
    ```py
    # 布林 Series
    print(df["value"] < 11)
    # 0     True
    # 1    False
    # 2     True
    # 3    False
    # 4    False
    # Name: value, dtype: bool

    # 布林 Series 作為過濾器
    print(df.loc[df["value"] < 11])
    #    value        date
    # 0     10  2023-10-01
    # 2      8  2023-10-03
    ```

### `Series[datetime[ns]]`
    
  + **範例**
    ```py
      data = {
          "value": [10, 15, 8, 12, 14],
          "date": ["2023-10-01", "2023-10-02", "2023-10-03", "2023-10-04", "2023-10-05"],
      }
      df = pd.DataFrame(data)
      
      # 從 object 轉成 datetime[ns]
      df["date"] = pd.to_datetime(df["date"], format=r"%Y-%m-%d")
      
      print(df["date"].dt.day)
      # 0    1
      # 1    2
      # 2    3
      # 3    4
      # 4    5
      # Name: date, dtype: int64
    ```

  + **時間的 groupby: resample**
    + 🔗 [**Pandas数据处理——玩转时间序列数据**](https://zhuanlan.zhihu.com/p/106675563?utm_id=0)
    + 🔗 [**pandas.DataFrame.resample**](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.resample.html)
    ```py
    df.resample()   # 時間的 groupby
                    # 回傳：DatetimeIndexResampler
                    # 說明：進行欄索引後退化為 SeriesGroupBy
                    # 參數：
                        # rule:   切分頻率
                        # label:  降採樣時，選擇左邊的時間還是右邊的時間
                        # origin: 採樣開始時間，選用 "start" 即為原 DataFrame 開始時間
                        # closed: 區間的封閉
                        # on:     取樣欄位，如果你沒將時間欄位設為索引，這個要設 (datetime[ns])
                    # 範例：df.resample('6H', on='time')["price"].agg("mean")
                    # 翻譯：以 "time" 為取樣欄位，以【6小時】為切分頻率，求出每一份取樣的【平均價格】

    # 無論你要做升採樣還是降採樣，一律建議將時間欄位設為索引 (pd.set_index)
    # 範例：df = df.set_index("time")
    
    # 🕤 時間降採樣 (downsample)：時間粒度變粗
        # 指引：
        # 做完 resample 後
        # 調用聚合函數，就和 GroupBy 一樣
    # 🕒 時間升採樣   (upsample)：時間粒度變細
        # 指引：
        # 做完 resample 後
        # 調用 DatetimeIndexResampler 實例方法 asfreq / bfill / ffill
        # 它們回傳一個新頻率採樣的 DataFrame

        # asfreq():         指定填充空值
        # 範例：df.resample('10min', origin='start').asfreq()
        # bfill(): backward 向後填充空值
        # 範例：df.resample('10min', origin='start').bfill()
        # ffill():  forward 向前填充空值
        # 範例：df.resample('10min', origin='start').ffill()
    ```

### 類別

  + `pd.Index()`
    > Pandas 儲存【索引名稱列表】的資料結構

  + `pd.MultiIndex()`
    > Pandas 儲存兩欄以上【索引名稱列表】的資料結構

    + 工廠函式
      ```py
      pd.MultiIndex.from_tuples   # 用 list[tuple] 創建
      pd.MultiIndex.from_arrays   # 用 list[list] 創建
      ```

  + `pd.Series()`

    ```
    (
      data  : 單欄資料 (列表)
      name  : 名稱 (串接時作為每欄索引名稱)
      index : 每列索引名稱 🔅:列舉
      dtype : 資料型態
      copy  : deep copy 🔅:False (如果是 True，就不會改變到原先 input 進來的一維資料)
    )
    ```

    ```py
    # 屬性
      ser.values  # -> 一維NDA
      ser.index   # -> 每列索引名稱
      ser.plot    # 建立在 matplotlib 上的高層封裝，用它快速畫圖
                  #  - (x="x軸索引名稱", y="y軸索引名稱", kind="圖類型")

    # 方法 - to 系列
      ser.to_frame()

    # 方法 (請參考 DataFrame)
      pass
    
    # 方法 - 映射
      ser.map()       # 映射 (給 dict)
                          # - 範例：data["gender"].map({"男":1, "女":0})
                          # - 翻譯：gender 男變1 女變0

      ser.apply()     # 映射 (給 自訂函數)
                          # - 說明：自訂函數，第一個參數一定是資料。剩下的參數用 args 給。

                          # - 範例：
                          # def get_older(x, bias):
                          #     return x + bias
                          # data["age"] = data["age"].apply(get_older,args=(+3,))

                          # - 翻譯：每人年齡+3
      ser.transform() # 映射
                          # - 說明：(❌有但基本上你不能用)
    ```

  + `pd.DataFrame()`
    ```py
    # (
    #  data    : 多欄資料 (若給定字典，index := key，data := value)
    #                    (若給定矩陣，每列就是一筆資料，可追加指定 index / column 分別有哪些)
    #  index   : 每列索引名稱 🔅:列舉
    #  columns : 每欄索引名稱 🔅:列舉
    #  dtype   : 資料型態
    #  name    : 名字
    #  copy    : deep copy 🔅:False (如果是 True，就不會改變到原先 input 進來的一維資料)
    # )

    # 📍 小技巧

        # 範例資料
          data1 = {"Column1": [1, 3, 5],
                  "Column2": [2, 4, 6]}
          df1 = pd.DataFrame(data1)
          #    Column1  Column2
          # 0        1        2
          # 1        3        4
          # 2        5        6

        # 索引
          df1["Column2"]              # 這是 Series 
          df1[["Column2"]]            # 這是 DataFrame
          df1[["Column1", "Column2"]] # 這是 DataFrame

        # 資料附加
          data2 = [[7, 8]]                               # 有兩欄的一筆資料 (⚠️須為矩陣，這表示我們可以同時塞入多筆資料)
          df2 = pd.DataFrame(data2, columns=df1.columns) # 將一筆資料建構成 DataFrame，其中 columns 採用 df1 的。 
          df1 = pd.concat([df1, df2], ignore_index=True) # (⚠️須為列表) 串接，且忽略現有原索引，採用 0 ~ n-1。
          #    Column1  Column2
          # 0        1        2
          # 1        3        4
          # 2        5        6
          # 3        7        8

        # 欄位附加
            df1["Column3"] = [-1, -2, -3, -4]
            #    Column1  Column2  Column3
            # 0        1        2       -1
            # 1        3        4       -2
            # 2        5        6       -3
            # 3        7        8       -4

    # 屬性
      df.shape    # -> (列,欄)
      df.values   # -> 二維NDA
      df.index    # 每列索引名稱
      df.columns  # 每欄索引名稱
      df.plot     # 建立在 matplotlib 上的高層封裝，用它快速畫圖
                  #  - (x="x軸索引名稱", y="y軸索引名稱", kind="圖類型")
      df.loc      # 矩陣名稱索引 (可切片)
                  #  - df.loc["r1"]["c2"]
                  #  - df.loc["r1", "c2"]
                  #  - df.loc["r1":"r3", "c2":"c5"]
                  #  - df.loc[布林 Series]
      df.iloc     # 矩陣數字索引 (可切片)

    # 方法 - to 系列
      df.to_pickle()      # 存成  pkl 檔
      df.to_hdf()         # 存成  hdf 檔
      df.to_csv()         # 存成  csv 檔
      df.to_json()        # 存成 json 檔
      df.to_xml()         # 存成  xml 檔
      df.to_excel()       # 存成 xlsx 檔
      df.to_markdown()    # 存成   md 檔
      df.to_sql()         # 存入資料庫    (較支援 SQLAlchemy)
      ...

    # 方法 - 初步資料分析
      df.info()           # 每欄之索引名稱、非空值統計、資料型態
      df.describe()       # 每欄最大值、最小值、中位數、平均值、標準差、四分位數

    # 方法 - 欄位計算 (聚合函數)
      df.max()            # 最大值
      df.min()            # 最小值
      df.mean()           # 平均值
      df.median()         # 中位數
      df.std()            # 標準差
      df.count()          # 總數量
      df.sum()            # 加總       

    # 方法 - 過濾
      df.head()            # 只取前n列資料
      df.tail()            # 只取後n列資料
      df.nlargest()        # 只取前n大資料
      df.nsmallest()       # 只取前n小資料
      df.query()           # 查詢
                              # - 說明：要給一個字串化的布林判斷式
                              # - 範例：result = df.query('Age > 30 and Salary > 50000')
                              # - 翻譯：尋找年齡大於 50 歲且薪水超過 5 萬的人

    # 方法 - 更改
      df.drop()            # 丟掉某幾欄/列
      df.rename()          # 更改索引名稱 (dict)
      df.reindex()         # 更改索引名稱，按現有順序 (list)
      df.set_index()       # 索引名稱 := 某欄的值 (可以選多欄，那麼就是 MultiIndex)
      df.reset_index()     # 還原 set_index
      df.astype()          # 轉換型態
    
    # 方法 - 缺失值
      df.fillna()          # 填充缺失值
      df.dropna()          # 丟棄有缺失值的資料

    # 方法 - 排序
      df.sort_index()      # 根據欄/列索引名稱排序
      df.sort_values()     # 根據值排序 (kwargs: by 指定欄)
      df.value_counts()    # 計數並排序

    # 方法 - 映射
      df.apply()      # 映射 (給 自訂函數)
                          # - 說明：(用法類似 Series apply，但可指定軸)
      df.transform()  # 映射 (給 聚合函數)
                          # - 說明：(用法類似 SeriesGroupBy transform，但可指定軸)
      df.applymap()   # 映射 (給 自訂函數)
                          # - 說明：把所有資料格瞎七八套上你的自訂函數
      df.resample()   # 重新取樣時間 (假如原本記錄一個每小時出生人數的表，可以藉由重新取樣時間轉成每天出生人數的表)
    ```

  + `SeriesGroupBy()`
    ```py
    # 創建實例
      df.groupby("公司")          # 這個創建的是 DataFrameGroupBy
      df.groupby("公司")["薪水"]   # 再加一層就是 SeriesGroupBy

    # 方法 - 映射
      ser_group.apply()       # 映射 (給 自訂函數)
                                  # - 說明：(用法類似 Series apply，但分群執行自訂函數)
      ser_group.transform()   # 映射 (給 聚合函數)
                                  # - 說明：指定聚合函數 (str) 進行轉換
                                  # - 範例：df.groupby("公司")["薪水"].transform("mean")
                                  # - 翻譯：產生一個 Series，為【每家公司】其員工的【薪水平均】貼回去給員工
                                  # - 範例：df["薪水"] = df.groupby("公司")["薪水"].transform("mean")
                                    # - 翻譯：將這個 Series 貼回去原來的資料
    ```

  + `DataFrameGroupBy()`
    + **範例**
      ```py
      company = ["A", "B", "C"]
      df = pd.DataFrame(
          {
              "公司": [company[x] for x in np.random.randint(0, len(company), 10)],
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
    + **創建實例**
      ```py
      df.groupby()            # 樞紐分析表
                                  #  - 說明：根據某個欄位分組，分成若干個子 DataFrame
                                  #  - 範例：df.groupby("公司")["薪水"].mean()
                                  #  - 翻譯：【每家公司】其員工的【平均薪水】
                                  #  - https://zhuanlan.zhihu.com/p/101284491?utm_id=0
      ```

    + **方法 - 映射**
      ```py
      df_group.apply()        # 映射 (給 自訂函數)
                                  # - 說明：(用法類似 Series apply，但是全欄套用)
      df_group.transform()    # 映射 (給 聚合函數)
                                  # - 說明：(用法類似 SeriesGroupBy transform，但是全欄套用)
      df_group.aggregate()    # 聚合 (給 聚合函數) (別名 agg)
                                  #  - 說明：指定聚合函式 (str) 進行聚合
                                  #  - 範例：df.groupby(["公司"]).agg({"薪水": ["median", "std"], "年齡": "mean"})
                                  #  - 翻譯：【每家公司】其員工的【薪水中位數、標準差】和【平均年齡】
      df_group.resample()
      df_group.first()
      df_group.quantile()
      ```



### 函式

  + **read 系列** (可給 Raw Data URL)
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

  + **合併**
    + 🔗 [**merging**](https://pandas.pydata.org/docs/user_guide/merging.html)
    + 🔗 [**簡單合併**](https://pandas.pydata.org/docs/user_guide/merging.html#concatenating-objects)
    + 🔗 [**鍵匹配合併**](https://pandas.pydata.org/docs/user_guide/merging.html#database-style-dataframe-or-named-series-joining-merging)
    + 🔗 [**JOIN 可視化**](https://joins.spathon.com/)
    ```py
    # 簡單合併
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
        
    # 鍵匹配合併 (如 SQL 中的 JOIN)
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