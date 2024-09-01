# ctypes

### 參考
+ 🔗 [**Python Documentation**](https://docs.python.org/3/library/ctypes.html)
+ 🔗 [**linmao**](https://www.linmao.dev/joy/881/)
+ 🔗 [**用ctypes模块调用C接口**](https://cs.pynote.net/sf/python/202112281/#null)

### 注意

| 🚨 <span class="caution">CAUTION</span> : C type 的 `char` 型態為位元組 (byte) |
| :---------------------------------------------------------------------------- |
| 所以字元或字串的 Python type 要給定 `bytes`                                   |

| 🚨 <span class="caution">CAUTION</span> : Python type `None`         |
| :------------------------------------------------------------------ |
| 如果指定於輸入，表示空指標 (NULL)；如果指定於輸出，表示不關心回傳值 |

| 🔮 <span class="important">IMPORTANT</span> : 調用                                                |
| :----------------------------------------------------------------------------------------------- |
| 1. **Python 端輸入型態** : ctypes type / Python type (需在 Python 端指定 `argtypes=ctypes_type`) |
| 2. **C 端輸入型態** : 將 1. 轉譯為 C type                                                        |
| 3. **C 端輸出型態** : 預設 C type `int` (需在 Python 端指定 `restype=ctypes_type`)               |
| 4. **Python 端輸出型態** : 將 3. 轉譯為 Python type                                              |

### 載入動態鏈結庫
  ```py
  # 1.
  lib = ctypes.cdll.LoadLibrary("./test_func/func.dll")
  # 2.
  lib = ctypes.CDLL("./test_func/func.dll")

  # cdll = LibraryLoader(CDLL)
  # pydll = LibraryLoader(PyDLL)
  # windll = LibraryLoader(WinDLL)
  # oledll = LibraryLoader(OleDLL)
  ```

### 類別
+ **primitive type**
  | ctypes type    | C type               | Python type       |
  | -------------- | -------------------- | ----------------- |
  | `c_bool`       | `_Bool`              | `bool`            |
  | `c_char`       | `char`               | `bytes`           |
  | `c_wchar`      | `wchar_t`            | `str`             |
  | `c_byte`       | `char`               | `int`             |
  | `c_ubyte`      | `unsigned char`      | `int`             |
  | `c_short`      | `short`              | `int`             |
  | `c_ushort`     | `unsigned short`     | `int`             |
  | `c_int`        | `int`                | `int`             |
  | `c_uint`       | `unsigned int`       | `int`             |
  | `c_long`       | `long`               | `int`             |
  | `c_ulong`      | `unsigned long`      | `int`             |
  | `c_longlong`   | `long long`          | `int`             |
  | `c_ulonglong`  | `unsigned long long` | `int`             |
  | `c_size_t`     | `size_t`             | `int`             |
  | `c_ssize_t`    | `ssize_t`            | `int`             |
  | `c_time_t`     | `time_t`             | `int`             |
  | `c_float`      | `float`              | `float`           |
  | `c_double`     | `double`             | `float`           |
  | `c_longdouble` | `long double`        | `float`           |
  | `c_char_p`     | `char*`              | `bytes` or `None` |
  | `c_wchar_p`    | `wchar_t*`           | `str` or `None`   |
  | `c_void_p`     | `void*`              | `int or None`     |

+ **array type**
  > 對 ctypes type 的乘法會產生陣列類別，比如 ctypes type `c_char * 40`，其對應 C type `char[40]`

  | ctypes type |
  | ----------- |
  | `Array`     |

+ **user defined type**
  > 需在 Python 端寫 class，並繼承 ctypes type。\
  > 其實例可使用存取屬性的方式來存取欄位。

  | ctypes type             |
  | ----------------------- |
  | `Structure`             |
  | `BigEndianStructure`    |
  | `LittleEndianStructure` |
  | `Union`                 |
  | `BigEndianUnion`        |
  | `LittleEndianUnion`     |

### 方法
+ **primitive type**
  | method / attribute | description                                                              |
  | ------------------ | ------------------------------------------------------------------------ |
  | `value`            | 回傳 Python type 的值                                                    |
  | `contents`         | 回傳指標指向的 ctypes type 物件 (每次查詢構建新物件，並不會返回原始物件) |

### 函數
| function               | description                                              |
| ---------------------- | -------------------------------------------------------- |
| `POINTER`              | 製造 ctypes type 指標型態                                |
| `pointer`              | 製造 ctypes type instance 指標                           |
| `CFUNCTYPE`            |                                                          |
| `byref`                | 更輕量的 `pointer`                                       |
| `sizeof`               | C sizeof                                                 |
| `create_string_buffer` | 一個可創建 char array 的工廠函數，通常做為創建緩衝區使用 |


### 動態庫函數
> 這步驟有點類似定義 C 函數原型 (prototype)
```py
lib = cdll.LoadLibrary("./test_func/func.dll")
lib.circle_area.argtypes = (c_double,)
lib.circle_area.restype = c_double
```

| attribute  | description  |
| ---------- | ------------ |
| `argtypes` | 指定引數型態 |
| `restype`  | 指定回傳型態 |