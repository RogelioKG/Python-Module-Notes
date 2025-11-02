# typing

[![RogelioKG/typing](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/typing)

## References
+ 🔗 [**好豪 - Python Type Hints 教學：我犯過的 3 個菜鳥錯誤**](https://haosquare.com/python-type-hints-3-beginner-mistakes/)
+ 🔗 [**MyApollo - Python 的 typing.Protocol 怎麼使用？**](https://myapollo.com.tw/blog/python-typing-protocol/)
+ 📜 [**Python Typing Documentation**](https://typing.python.org/en/latest/index.html)

## Type Hinting

| 📗 <span class="tip">TIP</span> |
| :-------- |
| `type()` 類別比對是嚴格相等，`isinstance()` 的類別比對有考慮到繼承關係 |

| 📗 <span class="tip">TIP</span> |
| :-------- |
| 若標註型態是 `float`，接受型態是 `int`，mypy 還是會讓你過的。<br />因為 `int` ⊂ `float` ⊂ `complex`，所以不用刻意去寫 <code>int &#124; float</code>。<br />詳見 [PEP-3141] – A Type Hierarchy for Numbers。 |

### Basic
+ 範例
  ```py
  x: float
  x: list[int] = [1]
  x: set[int] = {6, 7}
  x: dict[str, float] = {"field": 2.0}
  x: tuple[int, str, float] = (3, "yes", 7.5)
  x: tuple[int, ...] = (1, 2, 3)
  ```
  ```py
  x: Any # 任意型態
  x: Literal[4] # 字面量 4
  x: Callable[[int, bytes], str] # def x(a: int, b: bytes) -> str: ...

  x: list[int | str] = [3, 5, "test", "fun"]
  x: list[Union[int, str]] = [3, 5, "test", "fun"]

  x: str | None
  x: Optional[str] = "something" if some_condition() else None
  ```

### args & kwargs
+ 說明
  + type hinting 是給定 <mark>value 的型態</mark>
+ 範例
  ```py
  def foo(*args: str, **kwargs: int):
      print(f"args: {args}")
      print(f"kwargs: {kwargs}")

  if __name__ == "__main__":
      foo("a", "b", "c", x=1, y=2, z=3)
  ```

### Variadic Generics
+ 說明
  + [PEP-646] (2020/09/16)
+ 新式寫法：`*` (Python 3.12)
  > 舊式寫法：[Unpack](#Unpack：tuple-引數型別解包)
  ```py
  def prepend[T, *Ts](element: T, collection: tuple[*Ts]) -> tuple[T, *Ts]:
      return (element, *collection)

  z = prepend(element=0, collection=(True, "a"))
  # z: tuple[int, bool, str]
  ```
+ ⚠️ [嚴禁 Type Parameter 中出現多個 Variadic Generics](https://peps.python.org/pep-0646/#multiple-type-variable-tuples-not-allowed)
  > 因為無法去確認其中每個元素具體屬於哪個 Variadic Generic
  ```py
  class Array[*Ts1, *Ts2]:
      def test(self, n: tuple[*Ts1]):
          return n

  x: Array[int, str, bool] = Array()
  # 那這樣 Ts1 是 [int]、[int, str] 還是 [int, str, bool]？
  x.test(2)
  x.test(2, "3", True)
  ```


### Type Parameter Syntax
+ 說明
  + [PEP-695] (2022/06/15)
+ 新式寫法：`[T]` (Python 3.12)
  > 舊式寫法：[TypeVar](#TypeVar：型別參數)、[Generic](#Generic：泛型)
  ```py
  def func[T](a: T) -> T:
      return a
  ```
  ```py
  class Stack[T]:
      def __init__(self) -> None:
          self._items: list[T] = []
  ```
  ```py
  class Matrix[A, B]:
      def multiply[C](self, other: "Matrix[B, C]") -> "Matrix[A, C]": ...

  x: Matrix[Literal[30], Literal[20]] = ...
  y: Matrix[Literal[20], Literal[50]] = ...
  
  z = x.multiply(y)
  # z: Matrix[Literal[30], Literal[50]]
  ```
+ 新式寫法：`**` (Python 3.12)
  > 舊式寫法：[ParamSpec](#ParamSpec：函式簽名型別)
  ```py
  from typing import Callable

  def to_str[**P, R](func: Callable[P, R]) -> Callable[P, str]:
      def wrapper(*args: P.args, **kwargs: P.kwargs) -> str:
          result = func(*args, **kwargs)
          return str(result)
      return wrapper

  @to_str
  def multiply(a: int, b: int) -> int:
      return a * b

  a = multiply(3, 2)
  # a 可被正確的判定成 str 型別 (以往會誤判成 int)
  ```

## Utility Types

### `TypeAlias`：型別別名
+ 範例
  ```py
  Vector: TypeAlias = list[float] # 顯式宣稱其為別名，不是一個變數
  ```

### `TypedDict`：型別字典
+ 範例
  ```py
  class Point2D(TypedDict): # total=False：全體屬性 Partial
      x: int
      y: int
      label: str # NotRequired[str]：個別屬性 Partial


  a: Point2D = {"x": 1, "y": 2, "label": "good"}  # OK
  b: Point2D = {"z": 3, "label": "bad"}  # Fails type check

  assert Point2D(x=1, y=2, label="first") == dict(x=1, y=2, label="first")
  ```



### `NoReturn`：永不回傳
+ 說明
  + 只要有機會正常回傳，或隱式回傳 None，都不算！
+ 範例
  ```py
  # 若你註釋 NoReturn，調用此類函數後的程式碼，是無法存取的 (unreachable)
  # IDE 很貼心，會將其後程式碼黯淡化
  def stop() -> NoReturn:
      raise RuntimeError("no way")


  if __name__ == "__main__":
      stop()
      a = 5
  ```

### `Annotated`：註釋
+ 說明
  + 型別標註的額外資訊
  + 可被 `inspect.signature()` 提煉出來
  + 常被 static type checker、第三方函式庫等利用
    + [Pydantic - Validator](https://docs.pydantic.dev/latest/concepts/validators/#__tabbed_1_1)
    + [FastAPI - Depends](https://fastapi.tiangolo.com/tutorial/dependencies/#import-depends)
+ 範例
  ```py
  from typing import Annotated


  def hello(name: Annotated[str, "first letter is capital"]):
      print(f"hello {name}!")
  ```
  > 手刻驗證器 (向 Pydantic 致敬一波)
  ```py
  import inspect
  from functools import wraps
  from typing import Annotated, get_args

  # validator
  def min_length_3(value: str) -> str:
      if len(value) < 3:
          raise ValueError(f"'{value}' is too short, must be at least 3 characters.")
      return value

  def is_adult(value: int) -> int:
      if value < 18:
          raise ValueError(f"{value} is not an adult age (must be ≥ 18).")
      return value

  def is_email(value: str) -> str:
      if "@" not in value:
          raise ValueError(f"'{value}' is not a valid email.")
      return value

  # decorator
  def injectable(func):
      @wraps(func)
      def wrapper(*args, **kwargs):
          # ⚠️ 仔細看這裡是怎麼取得註釋內的 validator
          sig = inspect.signature(func)
          for arg, param in zip(args, sig.parameters.values()):
              annotation = param.annotation
              validator = get_args(annotation)[1]
              validator(arg)
          return func(*args, **kwargs)
      return wrapper

  @injectable
  def create_user(
      username: Annotated[str, min_length_3],
      age: Annotated[int, is_adult],
      email: Annotated[str, is_email]
  ):
      return {
          "username": username,
          "age": age,
          "email": email,
      }

  print(create_user("Tommy", 21, "tommy@example.com"))    # ✅
  print(create_user("Al", 22, "al@example.com"))          # ❌ username 太短
  print(create_user("Alice", 16, "alice@example.com"))    # ❌ 未成年
  print(create_user("Bob", 30, "bobexample.com"))         # ❌ email 無效
  ```

### `TypeVar`：型別參數
+ 範例
  ```py
  T = TypeVar("T")
  # 型別 T 可為任意型別

  U = TypeVar("U", str, bytes)
  # 型別 U 須為 str 或 bytes

  V = TypeVar("V", bound=str)
  # 型別 V 須為 str 或其子類別 (Java 觀點：<? extends V>)

  List = TypeVar("List", covariant=True)
  # 型別 List 具有協變性
      # 已知 Cat 類別是 Animal 類別的子類別，
      # 若 List<Cat> 可視為 List<Animal> 的子型別，
      # 則 List<T> 具有協變性 (covariant)。

  Dict = TypeVar("Dict", contravariant=True)
  # 型別 Dict 具有逆變性
      # 已知 Cat 類別是 Animal 類別的子類別，
      # 若 List<Animal> 可視為 List<Cat> 的子型別，
      # 則 List<T> 具有逆變性 (contravariant)。
  # 在沒有指定變異性的情況下，預設具有不變性
      # 已知 Cat 類別是 Animal 類別的子類別，
      # 若 List<Cat> 與 List<Animal> 沒有子型別關係，
      # 則 List<T> 具有不變性 (invariant)。



  def repeat(x: T, n: int) -> list[T]:
      "Return a list containing n references to x."
      return [x] * n


  def longest(x: U, y: U) -> U:
      "Return the longest of two strings."
      return x if len(x) >= len(y) else y


  if __name__ == "__main__":
      # TypeVar 屬性
      print(T.__name__)
      # T
      print(U.__constraints__)
      # (<class 'str'>, <class 'bytes'>)
      print(U.__covariant__)
      # False
      print(List.__covariant__)
      # True
      print(Dict.__contravariant__)
      # True

      # 正確範例
      print(repeat(10, 6))
      print(repeat('a', 6))
      print(longest("1234567", "123"))
      print(longest(b"1234567", b"123"))
      # 錯誤範例
      # (這裡型別是 list[int] 就錯了，雖然可正常運行，但 mypy 等 static type checker 會檢查出來)
      print(longest([1, 2, 3, 4, 5, 6, 7], [1, 2, 3]))
  ```

### `Generic`：泛型
+ 範例
  ```py
  # 說明：IDE 會補上詳細的提示，對 API 使用者友好

  KT = TypeVar("KT")  # key type
  VT = TypeVar("VT")  # value type


  # 繼承泛型
  class Map(Generic[KT, VT]):
      def __init__(self, key_arr: Iterable[KT], value_arr: Iterable[VT]):
          assert len(key_arr) == len(value_arr)
          self.__keys = key_arr
          self.__values = value_arr

      def get(self, key: KT) -> VT:
          for i, k in enumerate(self.__keys):
              if k == key:
                  break
          return self.__values[i]


  if __name__ == "__main__":
      num_arr = [1, 2, 3, 4, 5]
      char_arr = ["a", "b", "c", "d", "e"]
      m = Map(num_arr, char_arr)
      print(m.get(1))

  # 完全不給型別提示
  # (method) def get(key: Any) -> Any

  # 未補上泛型的 get 方法註釋
  # (method) def get(key: KT@get) -> VT@get

  # 補上泛型的 get 方法註釋
  # (method) def get(key: int) -> str
  ```


### `Unpack`：tuple 引數型別解包
+ 範例
  ```py
  from typing import TypedDict, TypeVar, TypeVarTuple, Unpack

  T = TypeVar("T")
  Ts = TypeVarTuple("Ts")

  def prepend(element: T, collection: tuple[Unpack[Ts]]) -> tuple[T, Unpack[Ts]]:
      return (element, *collection)

  z = prepend(element=0, collection=(True, "a"))
  # z: tuple[int, bool, str]
  ```
  > 對於 `TypedDict` 提供的 IDE 提示特別好用
  ```py
  class UserInfo(TypedDict):
      name: str
      age: int

  def print_user_info(**kwargs: Unpack[UserInfo]) -> None:
      print(f"Name: {kwargs['name']}, Age: {kwargs['age']}")

  # 提示：(*, name: str, age: int) -> None
  print_user_info(name="Alice", age=30)
  ```

### `ParamSpec`：函式簽名型別
+ 說明
  + 為了避免 closure 屏蔽掉回傳型別
+ 範例
  ```py
  from typing import Callable, TypeVar, ParamSpec

  P = ParamSpec('P')
  R = TypeVar('R')

  def to_str(func: Callable[P, R]) -> Callable[P, str]:
      def wrapper(*args: P.args, **kwargs: P.kwargs) -> str:
          result = func(*args, **kwargs)
          return str(result)
      return wrapper

  @to_str
  def multiply(a: int, b: int) -> int:
      return a * b

  a = multiply(3, 2)
  # a 可被正確的判定成 str 型別 (以往會誤判成 int)
  ```

### `Self`：實例自身
+ 說明
  + [PEP-673]
+ 範例
  > `set_scale` 回傳的是 `Shape`，然而 `Shape` 並沒有 `set_radius` 方法。\
  > static type checker 會報錯。
  ```py
  from __future__ import annotations


  class Shape:
      def set_scale(self, scale: float) -> Shape: # ❓
          self.scale = scale
          return self


  class Circle(Shape):
      def set_radius(self, r: float) -> Circle:
          self.radius = r
          return self


  Circle().set_scale(0.5).set_radius(2.7)
  ```
  > 解法：自己設 `TypeVar`，有點麻煩
  ```py

  from __future__ import annotations

  from typing import TypeVar

  TShape = TypeVar("TShape", bound="Shape")


  class Shape:
      def set_scale(self: TShape, scale: float) -> TShape: # 🤔
          self.scale = scale
          return self


  class Circle(Shape):
      def set_radius(self, radius: float) -> Circle:
          self.radius = radius
          return self


  Circle().set_scale(0.5).set_radius(2.7)  # => Circle
  ```
  > 3.11 後有個更簡單的寫法 `Self`
  ```py
  class Shape:
      def set_scale(self, scale: float) -> Self: # ✅
          self.scale = scale
          return self


  class Circle(Shape):
      def set_radius(self, radius: float) -> Circle:
          self.radius = radius
          return self


  Circle().set_scale(0.5).set_radius(2.7)
  ```

### `Protocol`：協議
+ 說明
  > 協議是 Duck Typing 的體現。\
  > 它允許你在不使用繼承的情況下達成多型，\
  > 這<mark>可被 static type checker (如 mypy) 檢查出</mark>。

  > 一言以蔽之：\
  > 繼承是<mark>名義性的 (nominal)</mark>、<mark>侵入性的</mark>，\
  > 協議是<mark>結構性的 (structural)</mark>、<mark>非侵入性的</mark>。
  > 協議就像 `interface`。

  > 這其實在某些情況下相當好用，\
  > 假如你使用到某三方庫的某類別 `EarBuds`，\
  > 你的代碼仰賴其中的 `connect`、`disconnect` 方法。\
  > 你想要將其抽象化，變成一個允許連線或斷線的介面 `Device`，\
  > 好方便你未來去抽換你自己實作的各種 `Device`。\
  > 問題是，你無法修改這個 `EarBuds` 類別 (人家是第三方庫)，\
  > 你就不能讓它繼承你定義的 `Device` 介面，\
  > 此時傳統的繼承就派不上用場了，這正是協議發揮威力的時刻。

+ 範例
  ```py
  from typing import Protocol

  class Device(Protocol):
      def connect(self) -> None:
          ...
      def disconnect(self) -> None:
          ...

  class SmartSpeaker:
      def connect(self) -> None:
          print("connect device")
      def disconnect(self) -> None:
          print("disconnect device")

  def connect_device(device: Device) -> None:
      device.connect()


  device = SmartSpeaker()
  connect_device(device)
  ```




### `TypeGuard`：呃...
+ 說明
  + [PEP-647] (2020/10/07)
  + <mark>並不是真正的型別守衛，其會在 Union 型別分支的情況判斷錯誤</mark>
+ 範例
  ```py
  from typing import Literal, TypedDict, TypeGuard, assert_type


  class Cat(TypedDict):
      kind: Literal["cat"]
      meow: str


  class Dog(TypedDict):
      kind: Literal["dog"]
      bark: str


  def is_cat(val: Cat | Dog) -> TypeGuard[Cat]:
      return val["kind"] == "cat"


  def make_sound(animal: Cat | Dog):
      if is_cat(animal):
          assert_type(animal, Cat)
          # ✅ animal 被縮窄為 Cat
      else:
          assert_type(animal, Dog)
          # ❓ error: Expression is of type "Cat | Dog", not "Dog"
  ```

### `TypeIs`：型別守衛
+ 說明
  + 這才是真正的型別守衛！
+ 範例
  ```py
  from typing import Literal, TypedDict, TypeIs, assert_type


  class Cat(TypedDict):
      kind: Literal["cat"]
      meow: str


  class Dog(TypedDict):
      kind: Literal["dog"]
      bark: str


  def is_cat(val: Cat | Dog) -> TypeIs[Cat]:
      return val["kind"] == "cat"


  def make_sound(animal: Cat | Dog):
      if is_cat(animal):
          assert_type(animal, Cat)
          # ✅ animal 被縮窄為 Cat
      else:
          assert_type(animal, Dog)
          # ✅ animal 被縮窄為 Dog

  ```
  ```ts
  type Dog = { kind: "dog"; bark(): void };
  type Cat = { kind: "cat"; meow(): void };
  type Animal = Dog | Cat;

  function isCat(animal: Animal): a is Cat {
    return animal.kind === "cat";
  }

  function makeSound(animal: Animal) {
    if (isCat(animal)) {
      animal.meow(); // ✅ animal 被縮窄為 Cat
    } else {
      animal.bark(); // ✅ animal 被縮窄為 Dog
    }
  }
  ```

## Functions

### `get_origin`
```py
print(get_origin(list[int])) # <class 'list'>
```

### `get_args`
```py
print(get_args(list[int])) # (<class 'int'>,)
```


### `final`：無法繼承、無法覆寫
+ 說明
  + 被裝飾的類別無法被繼承 (inherit)
  + 被裝飾的方法無法覆寫 (override)
+ 範例
  ```py
  @final
  class Car():
      @final
      def meow():
          pass
  ```

### `overload`：函數多載
+ 範例
  ```py
  @overload
  def utf8(value: bytes) -> bytes: ...
  @overload
  def utf8(value: str) -> bytes: ...
  # 實作
  def utf8(value: str | bytes) -> str | bytes:
      pass
  ```
+ 用途
  > 可看到實作處的型別是混雜的，\
  > 若你想為不同簽名的函式做出不同實作，你要自己比對型別 (`isinstance`)。\
  > 假如<mark>函式因不同參數簽名回傳不同型態</mark>，\
  > 使用 `@overload` 能有效地告訴 static type checker，\
  > 當傳入某某參數時，回傳型態是什麼？
  ```py
  @overload
  def enable_repr[T](
      cls: None,
      *,
      sensitive: set[str] | None = None,
  ) -> Callable[[type[T]], type[T]]: ...


  @overload
  def enable_repr[T](
      cls: type[T],
      *,
      sensitive: set[str] | None = None,
  ) -> type[T]: ...


  def enable_repr[T](
      cls: type[T] | None = None,
      *,
      sensitive: set[str] | None = None,
  ) -> Callable[[type[T]], type[T]] | type[T]:
      """自動為每個 SQLAlchemy Model 提供 `__repr__` 方法，並屏蔽敏感欄位

      Example
      -------
      >>> @enable_repr(sensitive={"password", "email"})
      ... class User(Base):
      ...     __tablename__ = "User"
      ...     id = mapped_column(Integer, primary_key=True)
      ...     username = mapped_column(String(50))
      ...     email = mapped_column(String(100))
      ...     password = mapped_column(String(100))
      >>> user = User(id=1, username="john", email="john@example.com", password="123")
      >>> print(user)
      User(id=1, username='john', email=***, password=***)
      """

      if sensitive is None:
          sensitive = set()

      def wrapper(cls_: type[T]) -> type[T]:
          setattr(cls_, "_sensitive", sensitive)  # noqa: B010

          def __repr__(self) -> str:
              columns = class_mapper(self.__class__).columns.keys()
              repr_dict = {}
              for col in columns:
                  value = getattr(self, col)
                  if col in self.__class__._sensitive:
                      repr_dict[col] = "***"
                  else:
                      repr_dict[col] = repr(value)
              repr_data = ", ".join(f"{k}={v}" for k, v in repr_dict.items())
              return f"{self.__class__.__name__}({repr_data})"

          cls_.__repr__ = __repr__
          return cls_

      return wrapper if cls is None else wrapper(cls)
  ```

## Others


### `from __future__ import annotation`
+ 說明
  + 未加上前：parser 會試圖找到 type hinting 中，各個型別的定義
    1. 若 type hinting 中出現【未定義的引用】，會導致 `NameError`
    2. 若 type hinting 中出現【無法辨識的語法】，會導致 `SyntaxError`
  + 加上後：<mark>將所有 type hinting 通通當作普通字串看待</mark>
    1. type hinting 將允許前向聲明、循環引用
    2. type hinting 將允許新式 typing hinting 語法，又同時支援舊版 Python
        > 寫支援多版本套件時，非常實用
+ 範例
  ```py
  from __future__ import annotations # 一定要寫在第一行


  class Node:
      def __init__(self, next_node: Node | None = None):
          self.next = next_node
  ```
  ```py
  # 可以不加，那你的未定義引用就要自己寫成字串

  class Node:
      def __init__(self, next_node: "Node" | None = None):
          self.next = next_node
  ```

### covariant, invariant, contravariant
+ 範例
  ```py
  from typing import Generic, TypeVar, Iterable, Iterator

  # 若容器型態不具協變性 (把 covariant=True 去掉)，
  # 意即只具備不變性的話 (看 dump_employees 函數)...
  T = TypeVar("T", covariant=True)


  class ImmutableList(Generic[T]):
      def __init__(self, items: Iterable[T]) -> None:
          self._items: list[T] = list(items)

      def __iter__(self) -> Iterator[T]:
          return iter(self._items)

      def __len__(self) -> int:
          return len(self._items)

      def __getitem__(self, index: int) -> T:
          return self._items[index]

      def __repr__(self) -> str:
          return f"ImmutableList({self._items})"


  class Employee:
      def __init__(self, id: int) -> None:
          self.id = id

      def __repr__(self) -> str:
          return f"Employee(id:{self.id})"


  class Manager(Employee):
      def __init__(self, id: int) -> None:
          super().__init__(id)

      def __repr__(self) -> str:
          return f"Manager(id:{self.id})"


  # 使用 mypy 等 static type checker 時
  # 若此處傳入 ImmutableList[Manager] 會出錯
  # 因為 ImmutableList[Manager] is not a ImmutableList[Employee]
  def dump_employees(employees: ImmutableList[Employee]) -> None:
      for employee in employees:
          print(employee)


  if __name__ == "__main__":
      employees = ImmutableList([Employee(i) for i in range(1, 6)])
      dump_employees(employees)
      managers = ImmutableList([Manager(i) for i in range(6, 11)])
      dump_employees(managers)

  ```


[PEP-646]: https://peps.python.org/pep-0646/
[PEP-647]: https://peps.python.org/pep-0647/
[PEP-673]: https://peps.python.org/pep-0673/
[PEP-695]: https://peps.python.org/pep-0695/
[PEP-3141]: https://peps.python.org/pep-3141/