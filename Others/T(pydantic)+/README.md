# pydantic


## References
+ 🔗 [**MyApollo - 用 pydantic 輕鬆進行資料驗證**](https://myapollo.com.tw/blog/pydantic-validate-data/)
+ 🎬 [**ArjanCodes - Why You Should Use Pydantic in 2024 | Tutorial**](https://youtu.be/502XOB0u8OY)


## Brief
+ pydantic 用於資料驗證
    + 利用 type hints 來進行驗證
    + 仰賴 `pydantic-core` 庫，其使用 Rust 編寫而成，速度飛快
+ pydantic 的 optional dependencies
    + `pydantic[email]`：處理 email 欄位驗證
    + `pydantic[timezone]`：處理 timezone 欄位驗證

## Models
+ [Model 的方法與屬性](https://docs.pydantic.dev/latest/concepts/models/#model-methods-and-properties)
  + 繼承 `BaseModel` 的即為 Model
  + Model 允許嵌套
+ [`Strict~` 嚴格型別](https://docs.pydantic.dev/latest/concepts/types/#strict-types)
    + 使用原生型別標註，若發生型態不相符但相容，Pydantic 會自動隱式轉型
    + 若希望禁止隱式轉型，請使用嚴格型別
+ `ConfigDict` 設定 Model 行為
    ```py
    class User(BaseModel):
        id: int
        name: str

        # extra="forbid" (不允許額外欄位出現在輸入資料)
        # forzen=True (不可變物件)
        model_config = ConfigDict(extra="forbid", frozen=True)

    user = User(id=1, name="Rogelio")
    ```

## Example

### 範例一：簡單使用
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

    print(user.id)
    # 123

    print(user.model_dump(mode="python"))
    # {
    #     'id': 123,
    #     'name': 'John Doe',
    #     'signup_ts': datetime.datetime(2019, 6, 1, 12, 22),
    #     'tastes': {'wine': 9, 'cheese': 7, 'cabbage': 1},
    # }

    print(user.model_dump(mode="json"))
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