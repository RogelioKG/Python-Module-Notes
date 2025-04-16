# enum

## Note
| 類型      | 用途                              | 位元運算 |
| --------- | --------------------------------- | -------- |
| `Enum`    | 最基本的列舉，用來定義常數值      | ❌        |
| `IntEnum` | 與整數相容的 Enum，可以跟整數比較 | ❌        |
| `StrEnum` | 與字串相容的 Enum                 | ❌        |
| `Flag`    | 可進行位元運算的 Enum             | ✅        |
| `IntFlag` | 與整數相容的 Flag，可進行位元運算 | ✅        |

## Type

### `Enum`
```py
from enum import Enum, auto

# 自定義一個類別
class NewClass():
    New1 = "track"

# 定義一個 Enum 型態的類別
class OEM(Enum):
    ASUS = "Asus"
    MSI = "Msi"
    GIGABYTE = "Gigabyte"
    INNO3D = "Inno3D"

########################

# 類別屬性
print(NewClass.New1)        # track
print(OEM.ASUS)             # OEM.ASUS

# 建立物件
a = NewClass()
b = OEM("Asus")             # 以 value 初始化 (⚠️找不到將引發 ValueError)
print(b)                    # OEM.ASUS
c = OEM["ASUS"]             # 使用 name 索引  (⚠️找不到將引發 KeyError)
print(c)                    # OEM.ASUS
assert b == c and b is c

# 物件型態
print(type(a))              # <class "__main__.NewClass">
print(type(b))              # <enum "OEM">

# Enum 物件屬性
print(OEM.MSI.name)         # MSI
print(OEM.MSI.value)        # Msi

########################

# 使用 auto
class Manufacturer(Enum):
    NVIDIA = auto()
    AMD = auto()
    INTEL = auto()

print(Manufacturer.NVIDIA.name)     # NVIDIA
print(Manufacturer.NVIDIA.value)    # 1
print(Manufacturer.AMD.name)        # AMD
print(Manufacturer.AMD.value)       # 2

########################

# 遍歷 name
print([mfr.name for mfr in Manufacturer])
# ['NVIDIA', 'AMD', 'INTEL']

# 遍歷 value
print([mfr.value for mfr in Manufacturer])
# [1, 2, 3]
```

### `IntEnum`
```py
from enum import IntEnum


class Level(IntEnum):
    LOW = 1
    MEDIUM = 2
    HIGH = 3


if __name__ == "__main__":
    print(Level.HIGH > Level.LOW)  # True
    print(Level.MEDIUM + 1 == Level.HIGH)  # True
```

### `StrEnum`
```py
from enum import StrEnum


class Color(StrEnum):
    RED = "red"
    GREEN = "green"
    BLUE = "blue"


if __name__ == "__main__":
    print(Color.RED == "red")  # True
```

### `Flag`
```py
from enum import Flag, auto


class Mode(Flag):
    READ = auto()
    WRITE = auto()
    DELETE = auto()


if __name__ == "__main__":
    user_mode = Mode.READ | Mode.WRITE
    print(user_mode)  # Mode.READ|WRITE
    print(Mode.READ in user_mode)  # True
    print(Mode.READ & user_mode)  # Mode.READ
    print(Mode.DELETE in user_mode)  # False
    print(Mode.DELETE & user_mode)  # Mode(0)
```

### `IntFlag`

```py
from enum import IntFlag, auto


class Permission(IntFlag):
    """存取權限"""

    READ = auto()  # 1
    WRITE = auto()  # 2
    DELETE = auto()  # 4
    ADMIN = READ | WRITE | DELETE  # 1 | 2 | 4 = 7


if __name__ == "__main__":
    user_permission = Permission.READ | Permission.WRITE

    if Permission.DELETE not in user_permission:
        print("User cannot delete data")

    if user_permission & Permission.READ:
        print("User can read data")
```