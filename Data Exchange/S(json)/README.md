# json

### 參考
+ 🔗 [**myapollo: 製作 JSON serializable 的類別**](https://myapollo.com.tw/blog/python-make-json-serializable-class/)

### 說明

JSON (JavaScript Object Notation)
是一種輕量級資料交換格式，是 JavaScript 的子集。

| ⚠️ <span class="warning">WARNING</span> |
| :------------------------------------- |
| 標準 JSON 使用雙引號                   |

| ⚠️ <span class="warning">WARNING</span>         |
| :--------------------------------------------- |
| 讀取/寫入 JSON 檔時 mode 使用 "r"/"w" (純文字) |

### JSON 資料型別

  | ⚠️ <span class="warning">WARNING</span>                                         |
  | :----------------------------------------------------------------------------- |
  | 除以下之外，其他 Python 型別都是無法序列化的 (除非你[自訂序列化](#自訂序列化)) |

  + **encode**
    | Python           | JSON   |
    | :--------------- | :----- |
    | `dict`           | object |
    | `list` / `tuple` | array  |
    | `str`            | string |
    | `int` / `float`  | number |
    | `True`           | true   |
    | `False`          | false  |
    | `None`           | null   |

  + **decode**
    | JSON          | Python  |
    | :------------ | :------ |
    | object        | `dict`  |
    | array         | `list`  |
    | string        | `str`   |
    | number (int)  | `int`   |
    | number (real) | `float` |
    | true          | `True`  |
    | false         | `False` |
    | null          | `None`  |


### 函數
  + **反序列化** : `json_file` -> `dict`
    ```py
    json.load(fp) -> dict:
    #參數 fp: 檔案流
    ```

  + **反序列化** : `str` -> `dict`
    ```py
    json.loads(s) -> dict:
    #參數 s: 字串
    ```
        
  + **序列化** : `dict` -> `json_file`
    ```py
    json.dump(obj) -> None:
    #參數 obj: Python 物件 (比如 dict)
    ```

  + **序列化** : `dict` -> `str`
    ```py
    json.dumps(obj) -> str: 
    #參數 obj: Python 物件 (比如 dict)
    #參數 indent= 縮排 (pprint)
    #參數 ensure_ascii= 以 ascii 形式轉義 (如果要顯示中文要設成 False)
    ```

### 自訂序列化



+ 繼承 `JSONEncoder` 並覆寫 `default()` 方法
  ```py
  import json


  class AdvancedJSONEncoder(json.JSONEncoder):
      def default(self, obj):
          if isinstance(obj, set):  # 遇到 set 把它攔截下來
              return list(obj)  # 轉為 list

          # 剩下無法進行 JSON 序列化的型別，仍引起 TypeError
          return json.JSONEncoder.default(self, obj)


  if __name__ == "__main__":
      # 原物件
      obj1 = {"name": "oxxo", "age": 18, "eat": {"orange", "apple"}}
      print(type(obj1["eat"]))
      # <class 'set'>

      # 序列化
      str_obj = json.dumps(obj1, cls=AdvancedJSONEncoder)
      print(str_obj)
      # {"name": "oxxo", "age": 18, "eat": ["orange", "apple"]}

      # 反序列化
      obj2 = json.loads(str_obj)
      print(obj2)
      # {"name": "oxxo", "age": 18, "eat": ["orange", "apple"]}
      print(type(obj2["eat"]))
      # <class 'list'>
  ```
+ 威力加強版：所有實作 `__jsonencode__()` 方法的類別，都使用此方法序列化
  ```py
  import json


  class User:
      def __init__(self, username):
          self.username = username

      def __jsonencode__(self):
          return {"username": self.username}


  class AdvancedJSONEncoder(json.JSONEncoder):
      def default(self, obj):
          if hasattr(obj, "__jsonencode__"):
              return obj.__jsonencode__()

          if isinstance(obj, set):
              return list(obj)

          return json.JSONEncoder.default(self, obj)


  if __name__ == "__main__":
      user = User("foo")
      print(json.dumps(user, cls=AdvancedJSONEncoder))
  ```