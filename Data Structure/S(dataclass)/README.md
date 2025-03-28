# dataclass

### 參考
+ 🔗 [**maxlist**](https://www.maxlist.xyz/2022/04/30/python-dataclasses/)
+ 🎞️ [**ArjanCodes: This Is Why Python Data Classes Are Awesome**](https://youtu.be/CvQ7e6yUtnw)

### 說明
  dataclass 為純資料類別預定好一套常用功能。\
  比如 `__init__` / `__repr__` / `__lt__` / `__gt__` / `__eq__` ...


### 範例

+ 一般使用

  ```py
  from dataclasses import dataclass, field, asdict, astuple
  import random
  import string


  def genereate_id():
      return "".join(random.choices(string.ascii_uppercase, k=12))


  # ✅ frozen
  # 資料物件是否為常數
  # (⚠️注意：和 __post_init__ 衝突，不可混用)
  # ✅ kw_only
  # 只能使用 kwargs 初始化
  # ✅ slots
  # 使用 __slots__ 儲存屬性
  # ✅ order
  # 自動建立全序關係 (__lt__ / __gt__ / __eq__ ...)
  # (⚠️注意：由上至下比較屬性)
  @dataclass(frozen=False, kw_only=True)
  class Person:
      name: str
      address: str
      active: bool = True  # 預設值

      # ✅ field() - default_factory
      # 這裡預設值 empty list 預設值不能直接寫成 = []。
      # 在 Python 中，預設值若給予一個 mutable 物件，所有物件將共享它。
      # 這是因為函數定義時，它的預設值只會 evaluate 一次。
      email_address: list[str] = field(default_factory=list)

      # ✅ field() : init
      # 是否能在初始化 (__init__) 時設定
      id: str = field(init=False, default_factory=genereate_id)

      # ✅ field() : repr
      # 是否打印出此屬性

      # ✅ field() : compare
      # 是否加入比較行列
      _search_string: str = field(init=False, repr=False, compare=False)

      # ✅ __post_init__
      # 初始化 (__init__) 後的設定
      def __post_init__(self) -> None:
          self._search_string = f"{self.name} {self.address}"


  if __name__ == "__main__":
      person = Person(name="Peter", address="123 Main St")
      print(person)
      # Person(name='Peter', address='123 Main St', active=True, email_address=[], id='QULJGZZSTUOP')
      
      # ✅ asdict()
      # 轉為字典
      print(asdict(person))
      # {'name': 'Peter', 'address': '123 Main St', 'active': True, 'email_address': [], ...}

      # ✅ astuple()
      # 轉為元組
      print(astuple(person))
      # ('Peter', '123 Main St', True, [], 'BCXLKCWEYOSD', 'Peter 123 Main St')
  ```

+ 初始化中間變數 `InitVar`

  > InitVar 需在 `__post_init__` 方法中使用。\
  > 它只在初始化過程中存在，並且會作為參數傳遞給 `__post_init__`，不會成為屬性。

  ```py
  from dataclasses import dataclass, InitVar


  @dataclass
  class Document:
      filename: str
      content: str = ""
      encoding: InitVar[str | None] = None
      raw_content: InitVar[bytes | None] = None

      def __post_init__(self, encoding: str, raw_content: bytes):
          if encoding and raw_content:
              self.content = raw_content.decode(encoding)


  if __name__ == "__main__":
      raw_data = b"\xe4\xbd\xa0\xe5\xa5\xbd"
      doc = Document(filename="greeting.txt", encoding="utf-8", raw_content=raw_data)
      print(doc.content)  # 你好
      print(doc) # Document(filename='greeting.txt', content='你好')
  ```

+ 類別屬性 `ClassVar`

  ```py
  from dataclasses import dataclass
  from typing import ClassVar # ⚠️ 在 typing 模組中


  @dataclass
  class Employee:
      name: str
      salary: float
      bonus_rate: ClassVar[float] = 0.05

      def annual_bonus(self) -> float:
          return self.salary * Employee.bonus_rate

  emp1 = Employee(name="Alice", salary=50000)
  emp2 = Employee(name="Bob", salary=60000)
  print(emp1) # Employee(name='Alice', salary=50000)
  print(emp2) # Employee(name='Bob', salary=60000)

  print(emp1.annual_bonus())  # 2500.0
  print(emp2.annual_bonus())  # 3000.0

  # 修改 class 變量
  Employee.bonus_rate = 0.1

  print(emp1.annual_bonus())  # 5000.0
  print(emp2.annual_bonus())  # 6000.0

  print(emp1) # Employee(name='Alice', salary=50000)
  print(emp2) # Employee(name='Bob', salary=60000)
  ```