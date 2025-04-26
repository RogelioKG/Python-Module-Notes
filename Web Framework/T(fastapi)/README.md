# FastAPI

[![RogelioKG/fastapi](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/fastapi)


![](https://i.makeagif.com/media/6-04-2017/O5F8ol.gif)

![](https://raw.githubusercontent.com/jason810496/iThome2023-FastAPI-Tutorial/Images/assets/Day02/banner.png)

## References
+ 🔗 [**IT 邦幫忙 - FastAPI 如何 Fast ？**](https://ithelp.ithome.com.tw/users/20148985/ironman/6772)

## Toolkits
+ **Uvicorn**：實現 ASGI 的 Web Server
+ **Starlette**：輕量級 ASGI 的 Web App 框架 
+ **Pydantic**：資料驗證工具
+ **FastAPI**：ASGI 的 Web App 框架
  + 依賴 **Starlette** 和 **Pydantic**
  + 可以自動生成文檔

## Directory Structure
```py
.
└── app
    ├── __init__.py
    ├── main.py          # 入口點
    ├── dependencies.py  # 依賴注入的函式
    ├── api              # API 路由
    │   ├── __init__.py
    │   ├── items.py
    │   └── users.py
    ├── models           # Pydantic Model
    │   ├── __init__.py
    │   ├── base.py
    │   ├── item.py
    │   └── user.py
    ├── schemas          # SQLAlchemy Table
    │   ├── __init__.py
    │   ├── items.py
    │   └── users.py
    └── internal         # 內部業務邏輯
        ├── __init__.py
        └── ...
```

## API document
![](https://hackmd.io/_uploads/rJOpvhe1el.png)
![](https://hackmd.io/_uploads/HJ4ag6lylg.png)


## Usage


### `Depends`
+ 依賴注入
  ```py
  async def common_params(skip: int = 0, limit: int = 100):
      return {"skip": skip, "limit": limit}

  @app.get("/items/")
  async def read_items(commons: Annotated[dict, Depends(common_params)]):
      return commons
  ```
  |🚨 <span class="caution">CAUTION</span>|
  |:---|
  |只能用於 API endpoint 的 handle funtion 內的 `Annotated` 註釋<br>（想必是在 app decorator 做了一些處理，詳見 [Annotated 黑魔法](https://hackmd.io/@RogelioKG/pythons_flying_circus/%2F%40RogelioKG%2Ftyping#Annotated-%E8%A8%BB%E9%87%8B)）。|
  |當然你也能用三方庫 [fastapi-injectable](https://github.com/JasperSui/fastapi-injectable) 的 `@injectable`，<br>讓它脫離 app decorator 也能運作。|

  |📗 <span class="tip">TIP</span>|
  |:---|
  |`Annotated[Type, Depends()]` 等價於 `Annotated[Type, Depends(Type)]`|
  |也就是說當給定 `None` 時，自動帶入前方型態|

+ <mark>隔山打牛</mark> (對於一時不可見的依賴，會自動往外去尋找)
  ```py
  def get_double(n: int) -> int:
      return n * 2

  # 在 /test?n=2 時，會回傳 4 🚩
  # 注意：n 可以不用明確寫在參數裡 (太神奇了我的傑克🪄)
  @app.post("/test")
  async def test(doubled_number: Annotated[int, Depends(get_double)]):
      return doubled_number
  ```

### `Query`

```py
@app.get("/items") # 讀取 request 中 query 的 numbers 參數
def read_items(numbers):
    return {"numbers": numbers}
```

### `Cookie`
[Cookie - Samesite settings](https://medium.com/%E7%A8%8B%E5%BC%8F%E7%8C%BF%E5%90%83%E9%A6%99%E8%95%89/%E5%86%8D%E6%8E%A2%E5%90%8C%E6%BA%90%E6%94%BF%E7%AD%96-%E8%AB%87-samesite-%E8%A8%AD%E5%AE%9A%E5%B0%8D-cookie-%E7%9A%84%E5%BD%B1%E9%9F%BF%E8%88%87%E6%B3%A8%E6%84%8F%E4%BA%8B%E9%A0%85-6195d10d4441)

```py
@app.get("/login") # 設定 cookie "token"
def login(response: Response):
    response.set_cookie(key="token", value="my-secret", httponly=True)
    return {"message": "logged in"}

@app.get("/logout") # 刪除 cookie "token"
def logout(response: Response):
    response.delete_cookie(key="token")
    return {"message": "logged out"}

@app.get("/profile") # 讀取 request 中的 cookie "token"
def profile(token: Annotated[str, Cookie()]):
    if token != "my-secret":
        return {"error": "unauthorized"}
    return {"message": "Welcome back!"}
```

### `Header`
```py
@app.get("/read-header") # 讀取 request 中 header 的 User-Agent 欄位
def read_header(user_agent: Annotated[str | None, Header()] = None):
    return {"User-Agent": user_agent}
```

### `Form`
```py
class FormData(BaseModel):
    username: str
    password: str
    model_config = {"extra": "forbid"}  # 不允許出現其他欄位

# Form 的 media_type 選項
# 預設使用 application/x-www-form-urlencode
# 也可指定 multipart/form-data
@app.post("/test/")
async def test(data: Annotated[FormData, Form()]):
    return data
```

### `@app.HTTP_METHOD(...)`
+ `response_model=`：response 採用的 schema
+ `deprecated=`：棄用
+ `dependencies=`：先行依賴
  ```py
  def get_double(n: int) -> int:
      return n * 2

  def verify_even(n: int) -> None:
      if n % 2 == 1:
          raise ValueError("Odd value!")

  # 在 /test?n=2 時，先檢查是不是偶數，再來回傳 4 🚩
  # 在 /test?n=5 時，先檢查是不是偶數，然後就爆炸了
  @app.post("/test", dependencies=[Depends(verify_even)])
  async def test(doubled_number: Annotated[int, Depends(get_double)]):
      return doubled_number
  ```


## Uvicorn
+ `--reload`：開啟 hot reload
  ```bash
  uvicorn <app_script>:<app_object_name> --host <host> --port <port>
  ```

## Async

### modification
+ 資料庫部分
  ```py
  from collections.abc import AsyncGenerator
  from typing import Any

  from sqlalchemy.ext.fastapi import AsyncSession, async_sessionmaker, create_async_engine

  from config import get_settings
  from models.base import Base

  engine = create_async_engine(get_settings().database_uri)
  AsyncSessionLocal = async_sessionmaker(engine, expire_on_commit=False)


  async def get_session() -> AsyncGenerator[AsyncSession, Any, None]:
      async with AsyncSessionLocal() as session:
          async with session.begin():
              yield session


  async def init_db() -> None:
      async with engine.begin() as conn:
          await conn.run_sync(Base.metadata.create_all)


  async def drop_db():
      async with engine.begin() as conn:
          await conn.run_sync(Base.metadata.drop_all)


  async def close_db() -> None:
      await engine.dispose()
  ```

+ 記得 API 通通改成 `async`
  ```py
  # FastAPI 範例
  @router.post(
      "/users",
      response_model=UserSchema.UserRead,
      status_code=status.HTTP_201_CREATED,
      response_description="成功建立使用者",
      summary="建立使用者",
  )
  async def create_user(
      user_data: UserSchema.UserCreate, 
      session: Annotated[AsyncSession, Depends(get_session)]
  ):
      db_user = User(user_data)
      session.add(db_user)
      await session.flush()
      await session.refresh(db_user)
      return db_user

  # 執行路徑：
  # 1. yield 前 (transaction starts)
  # 2. session.add(db_user) (session 中新增使用者)
  # 3. session.flush() (將 session 變更刷新入資料庫)
  # (如果你的 ID 使用 autoincrement，此時資料庫會自動配給 ID)
  # 4. session.refresh(db_user)
  # (為了抓取這個 ID，我們必須重新 query 一遍資料庫，將資料刷新回 ORM 實例)
  # 5. yield 後 (transaction ends)

  # 🤔 個人意見：不要用 autoincrement 啦，用 UUID 吧！
  ```
+ `lifespan` 寫法
  ```py
  from contextlib import asynccontextmanager

  from fastapi import FastAPI

  from api.items import router as items_router
  from api.users import router as users_router
  from database.session import close_db, init_db


  @asynccontextmanager
  async def lifespan(app: FastAPI):
      await init_db()
      yield
      await close_db()


  app = FastAPI(
      title="Simple API",
      description="簡易 API",
      version="1.0.0",
      lifespan=lifespan,
  )


  app.include_router(items_router)
  app.include_router(users_router)

  ```
+ `.env` 內的 DATABASE_URI 改成異步庫
  ```env
  # MySQL
  MYSQL_DATABASE_URI="mysql+asyncpg://${MYSQL_USER}:${MYSQL_PASSWORD}@${MYSQL_HOST}:${MYSQL_PORT}/${MYSQL_DB}"
  # PostgreSQL
  POSTGRES_DATABASE_URI="postgresql+aiomysql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}"
  ```

## Unit Testing
+ `pytest`
+ `pytest-mock`
+ `pytest-asyncio`

## OAuth 2.0

+ <mark>使用 [JWT](https://kucw.io/blog/jwt/) 最簡實作 OAuth 2.0 授權流程</mark>
  ```py
  from datetime import UTC, datetime, timedelta
  from typing import Annotated, Any, Literal

  from fastapi import Depends, FastAPI, HTTPException
  from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
  from jose import jwt

  app = FastAPI()

  # 自動從 request 的 authorization header 拿取 bearer token
  OAuth2Token = Annotated[str, Depends(OAuth2PasswordBearer(tokenUrl="login"))]
  # 自動從 request 抓取登入資訊 (username 與 password 欄位，此為 OAuth 2.0 規定)
  LoginForm = Annotated[OAuth2PasswordRequestForm, Depends()]


  def generate_token(
      payload: dict[str, Any],
      secret: str,
      *,
      usage: Literal["access", "refresh"],
  ):
      expire_time_dict = {"access": 30, "refresh": 60}  # 幾秒後過期
      token_expire_time = datetime.now(UTC) + timedelta(seconds=expire_time_dict[usage])
      token_payload = {
          **payload,
          "exp": token_expire_time,  # 指定過期時間
          "usage": usage,  # 指定用途
      }
      token = jwt.encode(token_payload, secret)
      return token


  def verify_user(payload: dict[str, Any]) -> None:
      _user_id = payload.get("id")
      _email = payload.get("sub")
      if _user_id != 5 or _email != "rogelio@example.com":
          raise HTTPException(status_code=401, detail="Unauthorized")


  # * 登入路由，獲取 token 用
  @app.post("/login")
  def login(form_data: LoginForm):
      if form_data.username != "RogelioKG" or form_data.password != "123456":
          raise HTTPException(status_code=401, detail="Invalid credentials")

      secret = "my-secret"
      payload = {
          "sub": "rogelio@example.com",
          "id": 5,
      }

      access_token = generate_token(payload, secret, usage="access")
      refresh_token = generate_token(payload, secret, usage="refresh")

      return {"access_token": access_token, "refresh_token": refresh_token}


  # * 刷新路由，獲取新的 token 用
  @app.post("/refresh")
  def refresh(token: OAuth2Token):
      secret = "my-secret"
      payload = jwt.decode(token, secret)
      verify_user(payload)
      assert payload.get("usage") == "refresh"  # ! 只能使用 refresh_token 來 refresh

      access_token = generate_token(payload, secret, usage="access")
      refresh_token = generate_token(payload, secret, usage="refresh")

      return {"access_token": access_token, "refresh_token": refresh_token}


  # * 私人路由，獲取 private resources 用
  @app.get("/profile")
  def profile(token: OAuth2Token):
      secret = "my-secret"
      payload = jwt.decode(token, secret)
      verify_user(payload)
      assert payload.get("usage") == "access"  # ! 只能使用 access_token 來 access

      return {"message": "Welcome back!"}
  ```


+ `OAuth2PasswordBearer`
  + 名稱意義：使用者要以密碼換取 token
  + 呼叫時，就會從 request 的 authorization header 拿取 bearer token
    ```py
    # 實作
    class OAuth2PasswordBearer(OAuth2):
        ...
        # 所以當你依賴注入時，最後回傳的其實是字串 (token)
        async def __call__(self, request: Request) -> Optional[str]:
            authorization = request.headers.get("Authorization")
            scheme, param = get_authorization_scheme_param(authorization)
            if not authorization or scheme.lower() != "bearer":
                if self.auto_error:
                    raise HTTPException(
                        status_code=HTTP_401_UNAUTHORIZED,
                        detail="Not authenticated",
                        headers={"WWW-Authenticate": "Bearer"},
                    )
                else:
                    return None
            return param
    ```
+ `OAuth2PasswordRequestForm`
  + request 嚴格要求：
    + 一定要用 POST
    + body 一定要用 x-www-form-urlencoded 格式

+ PostMan 測試
  ![](https://hackmd.io/_uploads/HJWMDcv1xg.png)



## Docker

### database

+ 同步
  + SQLite: `sqlite3`
  + MySQL: `pymysql`
  + Postgers: `psycopg2` (若要在 container 上使用，須改為 `psycopg2-binary`)
+ 異步
  + SQLite: `aiosqlite`
  + MySQL: `aiomysql`
  + Postgers: `asyncpg`

### caution
+ 後端的 `HOST` 要設定成 `0.0.0.0`
  ...

+ 資料庫 URI 的 `HOST` 要設定成 `docker-compose.yml` 內指定的 services 名稱

  如下範例，為 `postgresql-db`
  ```yaml
  services:
    backend:
      ...
    postgresql-db:
      ...
  ```
