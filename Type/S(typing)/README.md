# typing

[![RogelioKG/typing](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/typing)

## References
+ 🔗 [**好豪 - Python Type Hints 教學：我犯過的 3 個菜鳥錯誤**](https://haosquare.com/python-type-hints-3-beginner-mistakes/)
+ 🔗 [**MyApollo - Python 的 typing.Protocol 怎麼使用？**](https://myapollo.com.tw/blog/python-typing-protocol/)
+ 📜 [**Python Typing Documentation**](https://typing.python.org/en/latest/index.html)

## Note
|🚨 <span class="caution">CAUTION</span>|
|:---|
|此筆記所使用的 Python 版本為 3.12|
|Python 近幾年在 type annotation 的道路上狂奔突進，deprecated 與 features 等層出不窮，也許這篇筆記不到半年就會變成考古學家手上的資料！|


## Usage

### common

| 📗 <span class="tip">TIP</span> |
| :-------- |
| 若標註型態是 `float`，接受型態是 `int`，mypy 還是會讓你過的。<br />因為 `int` ⊂ `float` ⊂ `complex`，所以不用刻意去寫 <code>int &#124; float</code>。<br />詳見 [PEP-3141] – A Type Hierarchy for Numbers。 |

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

### `TypeAlias` 型別別名
```py
Vector: TypeAlias = list[float] # 顯式宣稱其為別名，不是一個變數
```

### `TypedDict` 型別字典
```py
class Point2D(TypedDict): # 加上 total=False 類似 TS 的 Partial
    x: int
    y: int
    label: str # 若僅單個不需要，可使用 NotRequired[str]


a: Point2D = {"x": 1, "y": 2, "label": "good"}  # OK
b: Point2D = {"z": 3, "label": "bad"}  # Fails type check

assert Point2D(x=1, y=2, label="first") == dict(x=1, y=2, label="first")
```

### `Annotated` 註釋
型別標註的額外資訊，其可被 `inspect` 標準庫中的黑魔法 `signature()` 提煉出來。
常被 static type checker、第三方函式庫等利用。
+ [Pydantic - Validator](https://docs.pydantic.dev/latest/concepts/validators/#__tabbed_1_1)
+ [FastAPI - Depends](https://fastapi.tiangolo.com/tutorial/dependencies/#import-depends)
```py
from typing import Annotated


def hello(name: Annotated[str, "first letter is capital"]):
    print(f"hello {name}!")
```
手刻驗證器 (向 Pydantic 致敬一波)
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

### `NoReturn` 從不正常回傳的函數
|🚨 <span class="caution">CAUTION</span>|
|:---|
|從不！只要有機會正常返回，或隱式返回 None，都不算|
```py
# 註：如果你註釋 NoReturn，調用此類函數後的程式碼是無法存取的 (Code is unreachable)
# Pylance 很貼心，會將其後程式碼黯淡化
def stop() -> NoReturn:
    raise RuntimeError("no way")


if __name__ == "__main__":
    stop()
    a = 5
```

### `TypeVar` 型別參數
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

### `Generic` 泛型
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

### `Self` 實例自身
[PEP-673]

`set_scale` 回傳的是 `Shape`，\
然而 `Shape` 並沒有 `set_radius` 方法。\
static type checker 會報錯。
```py
from __future__ import annotations


class Shape:
    def set_scale(self, scale: float) -> Shape:
        self.scale = scale
        return self


class Circle(Shape):
    def set_radius(self, r: float) -> Circle:
        self.radius = r
        return self


Circle().set_scale(0.5).set_radius(2.7)
```
一個最簡單的方式是自己設 `TypeVar`，但這的確很麻煩
```py

from __future__ import annotations

from typing import TypeVar

TShape = TypeVar("TShape", bound="Shape")


class Shape:
    def set_scale(self: TShape, scale: float) -> TShape:
        self.scale = scale
        return self


class Circle(Shape):
    def set_radius(self, radius: float) -> Circle:
        self.radius = radius
        return self


Circle().set_scale(0.5).set_radius(2.7)  # => Circle
```
3.11 後有個更簡單的寫法 `Self`
```py
class Shape:
    def set_scale(self, scale: float) -> Self:
        self.scale = scale
        return self


class Circle(Shape):
    def set_radius(self, radius: float) -> Circle:
        self.radius = radius
        return self


Circle().set_scale(0.5).set_radius(2.7)
```

### `Protocol` 協議

協議是 Duck Typing 的體現。\
它允許你在不使用繼承的情況下達成多型，\
這<mark>可被 static type checker (如 mypy) 檢查出</mark>。

一言以蔽之：\
繼承是<mark>名義性的 (nominal)</mark>、<mark>侵入性的</mark>，\
協議是<mark>結構性的 (structural)</mark>、<mark>非侵入性的</mark>。
協議就像 `interface`。

這其實在某些情況下相當好用，\
假如你使用到某三方庫的某類別 `EarBuds`，\
你的代碼仰賴其中的 `connect`、`disconnect` 方法。\
你想要將其抽象化，變成一個允許連線或斷線的介面 `Device`，\
好方便你未來去抽換你自己實作的各種 `Device`。\
問題是，你無法修改這個 `EarBuds` 類別 (人家是第三方庫)，\
你就不能讓它繼承你定義的 `Device` 介面，\
此時傳統的繼承就派不上用場了，這正是協議發揮威力的時刻。

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

### `final` 無法繼承、無法覆寫
```py
# 被裝飾的類別無法被繼承(inherit)，被裝飾的方法無法覆寫(override)
@final
class Car():
    @final
    def meow():
        pass
```

### `overload` 函數多載
```py
@overload
def utf8(value: None) -> None: ...
@overload
def utf8(value: bytes) -> bytes: ...
@overload
def utf8(value: str) -> bytes: ...
```

### `get_origin`
```py
print(get_origin(list[int])) # <class 'list'>
```

### `get_args`
```py
print(get_args(list[int])) # (<class 'int'>,)
```

## Caution

### `args` & `kwargs`

只需指定 value 型態即可

```py
def foo(*args: str, **kwargs: int):
    print(f"args: {args}")
    print(f"kwargs: {kwargs}")
    
if __name__ == "__main__":
    foo("a", "b", "c", x=1, y=2, z=3)
```

### `from __future__ import annotation`

避免 Python 立即解析類型註解，而引發 NameError
```py
from __future__ import annotations # 一定要寫在第一行


class Node:
    def __init__(self, next_node: Node | None = None):
        self.next = next_node
```
要不然就寫成字串
```py
class Node:
    def __init__(self, next_node: "Node" | None = None):
        self.next = next_node
```

### covariant, invariant, contravariant

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


## Syntax

### Variadic Generics
+ [PEP-646] (2020/09/16)
+ `Unpack` (舊式寫法)
  ```py
  from typing import TypedDict, TypeVar, TypeVarTuple, Unpack

  T = TypeVar("T")
  Ts = TypeVarTuple("Ts")

  def prepend(element: T, collection: tuple[Unpack[Ts]]) -> tuple[T, Unpack[Ts]]:
      return (element, *collection)

  z = prepend(element=0, collection=(True, "a"))
  # z: tuple[int, bool, str]
  ```
  對於 `TypedDict` 提供的 IDE 提示特別好用
  ```py
  class UserInfo(TypedDict):
      name: str
      age: int

  def print_user_info(**kwargs: Unpack[UserInfo]) -> None:
      print(f"Name: {kwargs['name']}, Age: {kwargs['age']}")

  # 提示：(*, name: str, age: int) -> None
  print_user_info(name="Alice", age=30)
  ```
+ `*` (新式寫法，3.12)
  ```py
  def prepend[T, *Ts](element: T, collection: tuple[*Ts]) -> tuple[T, *Ts]:
      return (element, *collection)

  z = prepend(element=0, collection=(True, "a"))
  # z: tuple[int, bool, str]
  ```
+ ⚠️ PEP-646 [嚴禁 Type Parameter 中出現多個 Variadic Generics](https://peps.python.org/pep-0646/#multiple-type-variable-tuples-not-allowed)
  > 理由是因為無法去確認其中每個元素具體屬於哪個 Variadic Generic
  ```py
  class Array[*Ts1, *Ts2]:
      def test(self, n: tuple[*Ts1]):
          return n

  x: Array[int, str, bool] = Array()
  # 那這樣 Ts1 是 [int]、[int, str] 還是 [int, str, bool]？
  x.test(2)
  x.test(2, "3", True)
  ```

### User-Defined Type Guards
+ [PEP-647] (2020/10/07)
+ 基本上類似 TypeScript 的 typeguard
+ `TypeGuard`
  ```py
  def is_str_list(val: list[object]) -> TypeGuard[list[str]]:
      return all(isinstance(x, str) for x in val)


  def func1(val: list[object]):
      if is_str_list(val):
          # val 被判斷成 list[str]
          print(" ".join(val))
      else:
          # val 被判斷成 list[object]
          print(f"{val} Not a list of strings!")
  ```

### Type Parameter Syntax

+ [PEP-695] (2022/06/15)
+ 功能同 [TypeVar](#TypeVar-型別參數)，但這個寫法更直觀
+ `[?]` 新式寫法 (3.12)
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
+ `ParamSpec` 舊式寫法
  > 表示函式參數列的型別
  ```py
  from collections.abc import Callable
  from typing import ParamSpec, TypeVar

  P = ParamSpec("P")
  R = TypeVar("R")

  def apply(func: Callable[P, R], *args: P.args, **kwargs: P.kwargs) -> R:
      return func(*args, **kwargs)

  def func(a: str, b: str, *, m: int) -> str:
      return (a + b) * m

  result = apply(func, "a", "b", m=5)  # result 被判定為 str
  ```
+ `**` 新式寫法 (3.12)
  ```py
  from collections.abc import Callable

  def apply[**P, R](func: Callable[P, R], *args: P.args, **kwargs: P.kwargs) -> R:
      return func(*args, **kwargs)

  def func(a: str, b: str, *, m: int) -> str:
      return (a + b) * m

  result = apply(func, "a", "b", m=5)  # result 被判定為 str
  ```

[PEP-646]: https://peps.python.org/pep-0646/
[PEP-647]: https://peps.python.org/pep-0647/
[PEP-673]: https://peps.python.org/pep-0673/
[PEP-695]: https://peps.python.org/pep-0695/
[PEP-3141]: https://peps.python.org/pep-3141/