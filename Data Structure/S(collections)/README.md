# collections

[![RogelioKG/collections](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/collections)

## `collections.abc` 抽象容器
[📑 抽象容器整理表](https://docs.python.org/3/library/collections.abc.html#collections-abstract-base-classes)

## `ChainMap` 鏈式字典
```py
# 範例：ChainMap(dict_a, dict_b, dict_c)
# 先從 dict_a 找，找不到再從 dict_b 找，找不到再從 dict_c 找。

from collections import ChainMap


def find_from_dicts(dicts: list[dict[str, int]], key: str):
    for dict in dicts:
        if key in dict:
            return dict[key]
    raise KeyError


if __name__ == "__main__":

    # dict_a 和 dict_c 都有 key: "c1"
    dict_a = {"a1": 1, "a2": 2, "c1": 3}
    dict_b = {"b1": 4, "b2": 5, "b3": 6}
    dict_c = {"c1": 7, "c2": 8, "c3": 9}

    dicts = [dict_a, dict_b, dict_c]

    print(find_from_dicts("a2", dicts))  # 2
    print(find_from_dicts("c1", dicts))  # 3 (回傳最先找到的)
    print(find_from_dicts("b2", dicts))  # 5
    print(find_from_dicts("b4", dicts))  # KeyError

    dicts = ChainMap(dict_a, dict_b, dict_c)

    print(dicts["a2"])  # 2
    print(dicts["c1"])  # 3 (回傳最先找到的)
    print(dicts["b2"])  # 5
    print(dicts["b4"])  # KeyError
```

## `Counter` 計數字典
```py
# 參考：https://steam.oxxostudio.tw/category/python/library/collections.html#a4
# 說明：Counter 繼承 dict。dict 無法使用加法/集合運算子，而 Counter 則可以。

from collections import Counter


if __name__ == "__main__":

    numbers_list1 = ["A", "B", "F", "F", "G", "G", "G", "H", "H", "H", "I", "I"]
    numbers_list2 = ["A", "B", "B", "E", "E", "G", "G", "I", "I", "I"]
    counter1 = Counter(numbers_list1)
    counter2 = Counter(numbers_list2)
    counter3 = Counter("AGTCTACTGTGGAGAACTC")

    print(counter1)
    # Counter({'G': 3, 'H': 3, 'F': 2, 'I': 2, 'A': 1, 'B': 1})

    print(counter2)
    # Counter({'I': 3, 'B': 2, 'E': 2, 'G': 2, 'A': 1})

    print(counter3)
    # Counter({'A': 5, 'G': 5, 'T': 5, 'C': 4})

    # 並集 (兩集合的最大子集 -> 選出數量最少的那個)
    print(counter1 & counter2)
    # Counter({'G': 2, 'I': 2, 'A': 1, 'B': 1})

    # 聯集 (兩集合的最小父集 -> 選出數量最多的那個)
    print(counter1 | counter2)
    # Counter({'G': 3, 'H': 3, 'I': 3, 'B': 2, 'F': 2, 'E': 2, 'A': 1})

    # 數量相加
    print(counter1 + counter2)
    # Counter({'G': 5, 'I': 5, 'B': 3, 'H': 3, 'A': 2, 'F': 2, 'E': 2})

    # 差集
    print(counter1 - counter2)
    # Counter({'H': 3, 'F': 2, 'G': 1})

    # Top n
    print(counter1.most_common(3))
    # [('G', 3), ('H', 3), ('F', 2)]
```

## `ChainMap` 預設字典
```py
# 說明：defaultdict 繼承 dict，給定預設工廠，如果有缺漏值會 call 這個預設工廠，其產出值作為預設值

from collections import defaultdict


# builtins 預設工廠
print(int())   # 0
print(list())  # []
print(dict())  # {}
print(set())   # set()
print(tuple()) # ()


# 工廠函式
def no_idea():
    return "Huh?"


if __name__ == "__main__":
    periodic_table = defaultdict(int)
    periodic_table["H"] = 1
    print(periodic_table["He"])
    # 0
    print(periodic_table)
    # defaultdict(<class 'int'>, {'H': 1, 'He': 0})

    information = defaultdict(no_idea)
    information["name"] = "Kira Yoshikage"
    information["age"] = "33"
    information["gender"] = "male"
    print(information["occupation"])
    # Huh?
    print(information)
    # defaultdict(<function no_idea at 0x00000184E23BD1C0>, {'name': 'Kira Yoshikage', 'age': '33', 'gender': 'male', 'occupation': 'Huh?'})
```

## `deque` 雙端佇列

```py
# 說明：可限制長度。
# 若雙端佇列已滿，但仍 push 東西進去，則另一端會 pop 東西出來。

from collections import deque

if __name__ == "__main__":
    seasons = ["Spring", "Summer", "Fall", "Winter"]
    dq = deque(seasons, maxlen=6)

    print(dq)           # deque(["Spring", "Summer", "Fall", "Winter"], maxlen=6)
    print(dq.pop())     # Winter
    print(dq)           # deque(["Spring", "Summer", "Fall"], maxlen=6)
    print(dq.popleft()) # Spring
    print(dq)           # deque(["Summer", "Fall"], maxlen=6)
    dq.append("Winter")
    print(dq)           # deque(["Summer", "Fall", "Winter"], maxlen=6)
    dq.appendleft("Spring")
    print(dq)           # deque(["Spring", "Summer", "Fall", "Winter"], maxlen=6)
    dq.appendleft("a")
    print(dq)           # deque(["a", "Spring", "Summer", "Fall", "Winter"], maxlen=6)
    dq.appendleft("b")
    print(dq)           # deque(["b", "a", "Spring", "Summer", "Fall", "Winter"], maxlen=6)
    dq.appendleft("c")
    print(dq)           # deque(["c", "b", "a", "Spring", "Summer", "Fall"], maxlen=6)
```

## `namedtuple` 具名元組

```py
# 說明：
# 類別工廠

# 比較：namedtuple vs tuple
# tuple
#   + 使用數字索引取得值
# namedtuple
#   + 使用字串索引取得值 (✅ 可讀性)

# 比較：namedtuple vs dict
# dict
#   + 搜尋速度 O(1)
# namedtuple
#   + 搜尋速度 O(n) (❌ 比 dict 慢)
#   + 所占空間較小 (✅ 因為它是 immutable object)
#   + IDE 支援屬性提示 (✅ 腦袋過載程序猿的勝利)

# 使用方式：
# 類別 = namedtuple("類別名稱", ["屬性名稱1", "屬性名稱2"])
# 實例 = 類別(屬性值1, 屬性值2)

from collections import namedtuple

if __name__ == "__main__":

    " 類別 "
    info = namedtuple("Character", ["name", "gender", "titan"])

    " 創建實例 "
    Grisha_Jaeger = info("Grisha Jaeger", "male", "Attack Titan")
    print(Grisha_Jaeger)
    # Character(name="Grisha Jaeger", gender="male", titan="Attack Titan")
    print(type(Grisha_Jaeger))
    # <class '__main__.Character'>

    " 實例屬性 "
    print(Grisha_Jaeger.name)   # Grisha Jaeger
    print(Grisha_Jaeger.gender) # male
    print(Grisha_Jaeger.titan)  # Attack Titan

    " 關鍵字初始化 "
    Zeke_Jaeger = info("Zeke Jaeger", titan="Beast Titan", gender="male")
    print(Zeke_Jaeger)
    # Character(name="Zeke Jaeger", gender="male", titan="Beast Titan")

    " 使用已存在實例創建另一實例 "
    Eren_Jaeger = Grisha_Jaeger._replace(name="Eren Jaeger") # (艾連繼承了他老爸的進巨)
    print(Eren_Jaeger)
    # Character(name="Eren Jaeger", gender="male", titan="Attack Titan")
    
    " 轉成字典 "
    print(Eren_Jaeger._asdict())
    # {'name': 'Eren Jaeger', 'gender': 'male', 'titan': 'Attack Titan'}
```

## `Ordered` 有序字典
```py
# 說明：
# 自從 Python 3.7 後，dict 元素順序為加入順序 (之前是無法預測的)。
# 現在 OrderedDict 已不再那麼重要。

from collections import OrderedDict

if __name__ == "__main__":

    information = {
        "name": "Kira Yoshikage",
        "age": 33,
        "sex": "male",
        "occupation": None,
    }

    for key in information:
        print(key)
        # name
        # age
        # sex
        # occupation

    for key in OrderedDict(information):
        print(key)
        # name
        # age
        # sex
        # occupation
```
