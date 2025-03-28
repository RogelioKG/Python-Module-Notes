# typing

### 參考
+ 🔗 [**好豪 : Python Type Hints 教學：我犯過的 3 個菜鳥錯誤**](https://haosquare.com/python-type-hints-3-beginner-mistakes/)
+ 🔗 [**myapollo : Python 的 typing.Protocol 怎麼使用？**](https://myapollo.com.tw/blog/python-typing-protocol/)

### 注意

+ args 與 kwargs 的 type annotation，只需指定 value 型態即可
  ```py
  def foo(*args: str, **kwargs: int):
      print(f"args: {args}")
      print(f"kwargs: {kwargs}")
      
  if __name__ == "__main__":
      foo("a", "b", "c", x=1, y=2, z=3)
  ```