# typing

## References
+ 🔗 [**好豪 - Python Type Hints 教學：我犯過的 3 個菜鳥錯誤**](https://haosquare.com/python-type-hints-3-beginner-mistakes/)
+ 🔗 [**MyApollo - Python 的 typing.Protocol 怎麼使用？**](https://myapollo.com.tw/blog/python-typing-protocol/)


## Usage

### common

| 📗 <span class="tip">TIP</span> |
| :-------- |
| 若標註型態是 `float`，接受型態是 `int`，mypy 還是會讓你過的。<br />因為 `int` ⊂ `float` ⊂ `complex`，所以不用刻意去寫 <code>int &#124; float</code>。<br />詳見 [PEP 3141 – A Type Hierarchy for Numbers](https://peps.python.org/pep-3141/)。 |

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
```py
from typing import Annotated


def hello(name: Annotated[str, "first letter is capital"]):
    print(f"hello {name}!")
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
    # (這裡型別是 list[int] 就錯了，雖然可正常運行，但 mypy 靜態型別檢查器會檢查出來)
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

### `Protocol` 協議

協議是 Duck Typing 的體現。\
它允許你在不使用繼承的情況下達成多型，\
這<mark>可被靜態型別檢查器 (如 mypy) 檢查出</mark>。

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


## Note

### `args` & `kwargs`

只需指定 value 型態即可

```py
def foo(*args: str, **kwargs: int):
    print(f"args: {args}")
    print(f"kwargs: {kwargs}")
    
if __name__ == "__main__":
    foo("a", "b", "c", x=1, y=2, z=3)
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


# 使用 mypy 靜態型別檢查器時
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