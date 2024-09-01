# orjson

### 參考
+ 🔗 [**GitHub**](https://github.com/ijl/orjson)
+ 🔗 [**myapollo**](https://myapollo.com.tw/blog/python-orjson/)

### 使用原因
1. 它支援 `dataclass`, `datetime`, `enum`, `numpy`, `uuid` (標準庫 json 不支援這些類型的序列化)
2. 它超快 (是 Python JSON library 中序列化速度最快的)

### 函式

|🚨 <span class="caution">CAUTION</span>|
|:---|
| orjson 的 `dumps()` 回傳的是 `bytes` |

|🚨 <span class="caution">CAUTION</span>|
|:---|
| orjson 不提供 `load()` 和 `dump()` |