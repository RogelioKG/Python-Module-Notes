# pydantic

[![RogelioKG/pydantic](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/pydantic)


## References
+ 🔗 [**MyApollo - 用 pydantic 輕鬆進行資料驗證**](https://myapollo.com.tw/blog/pydantic-validate-data/)
+ 🎬 [**ArjanCodes - Why You Should Use Pydantic in 2024 | Tutorial**](https://youtu.be/502XOB0u8OY)
+ 📄 [**Doc - Getting help with Pydantic**](https://docs.pydantic.dev/latest/help_with_pydantic/)


## Note
此文以能最快上手 Pydantic 為優先 (學習兩成功能，滿足八成用途) 的組織結構撰寫，若有不嚴謹、不完善之處請見諒。

## Brief
+ pydantic 用於資料驗證
    + 利用 type hints 來進行驗證
    + 仰賴 `pydantic-core` 庫，其使用 Rust 編寫而成，速度飛快
+ pydantic 的 optional dependencies
    + `pydantic[email]`：處理 email 欄位驗證
    + `pydantic[timezone]`：處理 timezone 欄位驗證


## Models

### `BaseModel` [Model](https://docs.pydantic.dev/latest/concepts/models/#model-methods-and-properties)
+ 允許嵌套
+ 方法
    + `model_validate()` (instance method)
        + 輸入：object（可以是 dict 或是 ORM 物件）
        + 輸出：Model 物件
    + `model_validate_json()` (instance method)
        + 輸入：字串 (JSON)
        + 輸出：Model 物件
    + `model_dump()` (instance method)
        + 輸出：dict
    + `model_dump_json()` (instance method)
        + 輸出：字串 (JSON)
    + `model_json_schema()` (class method)
        + 參數
            + `mode="validation"` (輸入的 JSON Schema)\
              `mode="serialization"` (輸出的 JSON Schema)
        + 輸出：dict (JSON Schema)
+ 搭配 ORM
    ```py
    with db.Session() as session:
        emp = session.query(table.Employee).filter(table.Employee.emp_name == "RogelioKG").first()
        print(schema.EmployeeModel.model_validate(emp).model_dump(mode="json"))
        # model_validate 會回傳 EmployeeModel 實例
        # 再搭配 model_dump 就可以拿到 dict 了
    ```
+ 範例
    ```py
    from datetime import datetime

    from pydantic import BaseModel, PositiveInt


    class User(BaseModel):
        id: int
        name: str = "John Doe"
        signup_ts: datetime | None
        tastes: dict[str, PositiveInt]


    def test_user():
        external_data = {
            "id": 123,
            "signup_ts": "2019-06-01 12:22",
            "tastes": {
                "wine": 9,
                b"cheese": 7,
                "cabbage": "1",
            },
        }

        user = User(**external_data)

        print(type(user.signup_ts))
        # <class 'datetime.datetime'>

        print(user.model_dump())
        # {
        #     'id': 123,
        #     'name': 'John Doe',
        #     'signup_ts': datetime.datetime(2019, 6, 1, 12, 22),
        #     'tastes': {'wine': 9, 'cheese': 7, 'cabbage': 1},
        # }

        print(user.model_dump_json())
        # {
        #     'id': 123,
        #     'name': 'John Doe',
        #     'signup_ts': '2019-06-01T12:22:00',
        #     'tastes': {'wine': 9, 'cheese': 7, 'cabbage': 1},
        # }

        print(User.model_json_schema())
        # {
        #     "properties": {
        #         "id": {"title": "Id", "type": "integer"},
        #         "name": {"default": "John Doe", "title": "Name", "type": "string"},
        #         "signup_ts": {
        #             "anyOf": [{"format": "date-time", "type": "string"}, {"type": "null"}],
        #             "title": "Signup Ts",
        #         },
        #         "tastes": {
        #             "additionalProperties": {"exclusiveMinimum": 0, "type": "integer"},
        #             "title": "Tastes",
        #             "type": "object",
        #         },
        #     },
        #     "required": ["id", "signup_ts", "tastes"],
        #     "title": "User",
        #     "type": "object",
        # }


    if __name__ == "__main__":
        test_user()
    ```

### `ConfigDict` 設定 Model 行為
+ 範例
    ```py
    class User(BaseModel):
        id: int
        name: str

        # extra="forbid" (不允許額外欄位出現在輸入資料)
        # forzen=True (不可變物件)
        # from_attributes=True (可驗證 ORM - SQLAlchemy 回傳物件)
        model_config = ConfigDict(extra="forbid", frozen=True)

    user = User(id=1, name="Rogelio")
    ```


## Types

### 型別
+ [Standard Library Types](https://docs.pydantic.dev/latest/api/standard_library_types/)
+ [Pydantic Types](https://docs.pydantic.dev/latest/api/types/)
    + `Strict~` 嚴格型別
        + 使用原生型別標註，若發生型態不相符但相容，Pydantic 會自動隱式轉型
        + 若希望禁止隱式轉型，請使用嚴格型別
+ [Network Types](https://docs.pydantic.dev/latest/api/networks/)
    + `EmailStr` Email
    + `SecretStr` 密碼
    + ...

### `TypeAdaptor` 轉接頭
+ 範例

    無須顯式繼承 `BaseModel` 也能進行驗證
    ```py
    from pydantic import StrictInt, TypeAdapter

    adapter = TypeAdapter(list[StrictInt])
    print(adapter.json_schema())  # {'items': {'type': 'integer'}, 'type': 'array'}
    print(adapter.validate_python([1, 2, 3]))  # [1, 2, 3]
    print(adapter.validate_python([1, 2, "3"]))  # ValidationError
    ```
    ```py
    from dataclasses import dataclass

    from pydantic import TypeAdapter


    @dataclass
    class User:
        name: str
        age: int

    # 也可以轉接 dataclass
    adapter = TypeAdapter(User)

    data = {"name": "Alice", "age": "30"}
    print(adapter.validate_python(data))  # User(name='Alice', age=30)
    ```
### `FailFast` 出錯了就趕緊下台

+ 範例

    檢查到第一個錯誤 (`"invalid"`) 就會直接報錯，而不會將整個 `list` 都檢查完畢
    ```py
    from typing import Annotated

    from pydantic import FailFast, TypeAdapter, ValidationError

    ta = TypeAdapter(Annotated[list[bool], FailFast()])
    try:
        ta.validate_python([True, "invalid", False, "also invalid"])
    except ValidationError as exc:
        print(exc)
    ```

## Fields

+ 範例

    example, description 等資訊被用在與 FastAPI 整合的 Swagger UI 的 API 文檔之中
    ```py
    from enum import IntFlag, auto

    from pydantic import BaseModel, EmailStr, Field, SecretStr


    class Role(IntFlag):
        Author = auto()
        Editor = auto()
        Developer = auto()
        Admin = Author | Editor | Developer


    class User(BaseModel):
        name: str = Field(
            examples=["Arjan"],
            description="The full name of the user",
        )
        email: EmailStr = Field(
            examples=["example@arjancodes.com"],
            description="The email address of the user",
        )
        password: SecretStr = Field(
            examples=["Password123"],
            description="The password of the user",
        )
        role: Role = Field(
            default=Role.Author,
            description="The role of the user",
        )
    ```
+ discriminated union

    一種特殊的 Union 型別，<mark>用來描述多個子型別共用一個屬性 (通常是字串)，並根據這個屬性的值來區分不同型別的結構</mark>。\
    這些子型別都屬於某個共同的 Union 型別，通常搭配 switch 使用能讓編譯器自動進行型別推斷與檢查。
    ```ts
    type Shape =
    | { kind: "circle"; radius: number }
    | { kind: "square"; sideLength: number }
    | { kind: "rectangle"; width: number; height: number };

    function getArea(shape: Shape): number {
    switch (shape.kind) {
        case "circle":
        return Math.PI * shape.radius ** 2;
        case "square":
        return shape.sideLength ** 2;
        case "rectangle":
        return shape.width * shape.height;
        default:
        const _exhaustiveCheck: never = shape;
        return _exhaustiveCheck;
    }
    }
    ```
    ```py
    from typing import Literal

    from pydantic import BaseModel, Field, ValidationError


    class Cat(BaseModel):
        pet_type: Literal["cat"]
        meows: int


    class Dog(BaseModel):
        pet_type: Literal["dog"]
        barks: float


    class Lizard(BaseModel):
        pet_type: Literal["reptile", "lizard"]
        scales: bool


    class Model(BaseModel):
        # 這裡多指定一個 discriminator，對 Pydantic 效率幫助很大
        pet: Cat | Dog | Lizard = Field(discriminator="pet_type")  
        n: int


    print(Model(pet={"pet_type": "dog", "barks": 3.14}, n=1))
    # pet=Dog(pet_type='dog', barks=3.14) n=1
    try:
        a = Model(pet={"pet_type": "dog"}, n=1)
    except ValidationError as e:
        print(e)
    ```

## Validators
+ Pydantic 預設驗證
    + 會對可轉型的資料，進行隱式強制轉型
+ validator
    + `field_validator` 欄位驗證器
    + `model_validator` Model 驗證器
+ mode
    + `mode=before`：在 Pydantic 預設驗證之前進行驗證
    + `mode=after`：在 Pydantic 預設驗證之後進行驗證
    + `mode=wrap`：完全掌控驗證流程，可在任意位置驗證、任意決定要不要執行 Pydantic 預設驗證
        ```py
        from collections.abc import Callable
        from typing import Any

        from pydantic import BaseModel, ValidationInfo, field_validator


        class User(BaseModel):
            age: int

            @field_validator("age", mode="wrap")
            def validate_age(
                cls,
                handler: Callable[[Any], int],  # int 是目標型別
                value: Any,
                info: ValidationInfo,
            ) -> int:
                print("raw value =", value)
                result = handler(value)  # Pydantic 預設驗證
                print("validated =", result)

                if result < 0:
                    raise ValueError("Age cannot be negative!")

                return result
        ```
+ Decorator 寫法
    ```py
    from pydantic import BaseModel, ValidationError, field_validator


    class Model(BaseModel):
        number: int

        @field_validator('number', mode='after')  
        @classmethod
        def is_even_validator(cls, value: int) -> int:
            if value % 2 == 1:
                raise ValueError(f'{value} is not an even number')
            return value  


    try:
        Model(number=1)
    except ValidationError as err:
        print(err)
    ```
+ Annotated 寫法 

    此寫法無法用於驗證 Model
    ```py
    from typing import Annotated

    from pydantic import AfterValidator, BaseModel, ValidationError


    def is_even_validator(number: int) -> int:
        if number % 2 == 1:
            raise ValueError(f"{number} is not an even number")
        return number


    class Model(BaseModel):
        number: Annotated[int, AfterValidator(is_even_validator)]


    try:
        Model(number=1)
    except ValidationError as err:
        print(err)
    ```

## Serializer
+ validator
    + `field_serializer`
    + `model_serializer`
+ mode
    + `mode=before`
    + `mode=after`
    + `mode=wrap`
+ 範例 (ArjanCodes 提供)
    ```py
    import enum
    import hashlib
    import re
    from collections.abc import Callable
    from typing import Any, Self

    from pydantic import (
        BaseModel,
        EmailStr,
        Field,
        SecretStr,
        SerializationInfo,
        field_serializer,
        field_validator,
        model_serializer,
        model_validator,
    )

    VALID_PASSWORD_REGEX = re.compile(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$")
    VALID_NAME_REGEX = re.compile(r"^[a-zA-Z]{2,}$")


    class Role(enum.IntFlag):
        User = 0
        Author = 1
        Editor = 2
        Admin = 4
        SuperAdmin = 8


    class User(BaseModel):
        name: str = Field(examples=["Example"])
        email: EmailStr = Field(
            examples=["user@arjancodes.com"],
            description="The email address of the user",
            frozen=True,  # 此欄位不可變更
        )
        password: SecretStr = Field(
            examples=["Password123"],
            description="The password of the user",
            exclude=True,  # 此欄位不加入 serialization
        )
        role: Role = Field(
            description="The role of the user",
            examples=[1, 2, 4, 8],
            default=0,
            validate_default=True,  # 即便是使用預設值，也會跑一遍驗證流程
        )

        @field_validator("name")
        def validate_name(cls, v: str) -> str:
            if not VALID_NAME_REGEX.match(v):
                raise ValueError(
                    "Name is invalid, must contain only letters and be at least 2 characters long"
                )
            return v

        @field_validator("role", mode="before")
        @classmethod
        def validate_role(cls, v: int | str | Role) -> Role:
            op = {int: lambda x: Role(x), str: lambda x: Role[x], Role: lambda x: x}
            try:
                return op[type(v)](v)
            except (KeyError, ValueError) as exc:
                roles = ", ".join([x.name for x in Role])
                raise ValueError(f"Role is invalid, please use one of the following: {roles}") from exc

        @model_validator(mode="before")
        @classmethod
        def validate_user_pre(cls, v: dict[str, Any]) -> dict[str, Any]:
            if "name" not in v or "password" not in v:
                raise ValueError("Name and password are required")
            if v["name"].casefold() in v["password"].casefold():
                raise ValueError("Password cannot contain name")
            if not VALID_PASSWORD_REGEX.match(v["password"]):
                raise ValueError(
                    "Password is invalid, must contain 8 characters, 1 uppercase, 1 lowercase, 1 number"
                )
            v["password"] = hashlib.sha256(v["password"].encode()).hexdigest()
            return v

        @field_serializer("role", when_used="json")
        @classmethod
        def serialize_role(cls, v: Role) -> str:
            return v.name

        @model_validator(mode="after")
        def validate_user_post(self, v: Any) -> Self:
            if self.role == Role.Admin and self.name != "Arjan":
                raise ValueError("Only Arjan can be an admin")
            return self

        @model_serializer(mode="wrap", when_used="json")
        def serialize_user(
            self,
            serializer: Callable[[BaseModel], dict[str, Any]],  # Pydantic 預設序列化
            info: SerializationInfo,
        ) -> dict[str, Any]:
            if not info.include and not info.exclude:
                return {"name": self.name, "role": self.role.name}
            return serializer(self)


    def main() -> None:
        data = {
            "name": "Arjan",
            "email": "example@arjancodes.com",
            "password": "Password123",
            "role": "Admin",
        }
        user = User.model_validate(data)
        if user:
            print(
                "The serializer that returns a dict:",
                user.model_dump(),
                sep="\n",
                end="\n\n",
            )
            # The serializer that returns a dict:
            # {
            #     "name": "Arjan",
            #     "email": "example@arjancodes.com",
            #     "role": <Role.Admin: 4>,
            # }

            print(
                "The serializer that returns a JSON string:",
                user.model_dump(mode="json"),
                sep="\n",
                end="\n\n",
            )
            # The serializer that returns a JSON string:
            # {
            #     "name": "Arjan",
            #     "role": "Admin",
            # }

            print(
                "The serializer that returns a json string, excluding the role:",
                user.model_dump(exclude=["role"], mode="json"),
                sep="\n",
                end="\n\n",
            )
            # The serializer that returns a json string, excluding the role:
            # {
            #     "name": "Arjan",
            #     "email": "example@arjancodes.com",
            # }

            print("The serializer that encodes all values to a dict:", dict(user), sep="\n")
            # The serializer that encodes all values to a dict:
            # {
            #     "name": "Arjan",
            #     "email": "example@arjancodes.com",
            #     "password": SecretStr("**********"),
            #     "role": <Role.Admin: 4>,
            # }


    if __name__ == "__main__":
        main()
    ```

## Performace
[Pydantic - 顧慮性能的 best practices](https://docs.pydantic.dev/latest/concepts/performance/#avoid-wrap-validators-if-you-really-care-about-performance)，以下僅做簡述。
+ 多用 `FailFast`
+ 多用 `TypedDict` + `TypeAdapter`，少用 nested `BaseModel`
+ `TypeAdapter` 能重複利用最好 (所以別把它寫在函式裡)
+ discriminated union 記得指定 `discriminator`