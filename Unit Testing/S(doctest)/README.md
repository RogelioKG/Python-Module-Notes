# doctest

### 參考
+ 🔗 [**Documentation - doctest**](https://docs.python.org/zh-tw/3/library/doctest.html)
+ 🔗 [**嗡嗡的隨手筆記 - doctest in function，搭配 function**](https://www.wongwonggoods.com/all-posts/python/python-misc/python-testcase/python-doctest/#%E5%AE%89%E8%A3%9D)
+ 🔗 [**嗡嗡的隨手筆記 - doctest in class，搭配 class 的用法**](https://www.wongwonggoods.com/all-posts/python/python-misc/python-testcase/leetcode-python-testcase/)
+ 🔗 [**OpenHome - 使用 doctest 進行單元測試**](https://openhome.cc/Gossip/CodeData/PythonTutorial/AssertDocTest.html)

### 注意
|☢️ <span class="warning">WARNING</span>|
|:---|
|doctest 嚴格要求輸出字串與結果匹配|

斷言 set 這類無序容器的輸出內容是不可靠的：
```py
"""
>>> foo()
{"Hermione", "Harry"}
"""
```
可靠的寫法應當為：
```py
"""
>>> foo() == {"Hermione", "Harry"}
True
"""
```
