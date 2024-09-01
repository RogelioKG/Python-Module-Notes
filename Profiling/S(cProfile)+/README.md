# cProfile

### 參考
+  🔗[**myapollo**](https://myapollo.com.tw/blog/cprofile-and-py-spy-tutorial/)

### 欄位
| field           | description                                                                     |
| --------------- | ------------------------------------------------------------------------------- |
| `ncalls`        | 每個 function 呼叫了幾次                                                        |
| `tottime`       | 每個 function 總計花費多少時間，單位秒 (但不包括該 function 所呼叫其他 function 的時間) |
| `percall`       | 平均每次呼叫會花費的時間 (`tottime` / `ncalls`)                                 |
| `cumtime`       | 每個 function 總計花費多少時間，單位秒 (包括該 function 所呼叫其他 function 的時間)     |
| `percall`       | 平均每次呼叫會花費的時間 (`cumtime` / `ncalls`)                                 |
| `standard name` | filename:lineno(function)                                                       |

### 使用

```bash
py -m cProfile test.py 1 2 3
```