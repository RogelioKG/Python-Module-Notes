# FastAPI

[![RogelioKG/fastapi](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/fastapi)


![](https://i.makeagif.com/media/6-04-2017/O5F8ol.gif)

![](https://raw.githubusercontent.com/jason810496/iThome2023-FastAPI-Tutorial/Images/assets/Day02/banner.png)

## References
+ 🔗 [**Doc - FastAPI**](https://fastapi.tiangolo.com/)
+ 🔗 [**IT 邦幫忙 - FastAPI 如何 Fast ？**](https://ithelp.ithome.com.tw/users/20148985/ironman/6772)

## Toolkits
+ **Uvicorn**：實現 ASGI 的 Web Server
+ **Starlette**：輕量級 ASGI 的 Web App 框架 
+ **Pydantic**：資料驗證工具
+ **FastAPI**：ASGI 的 Web App 框架
  + 依賴 **Starlette** 和 **Pydantic**
  + 可以自動生成文檔

## Note
|🔮 <span class="important">IMPORTANT</span>|
|:---|
|前端在發送 request 時，browser 會開啟一個 ephemeral port 作為對外溝通的窗口|

|🔮 <span class="important">IMPORTANT</span>|
|:---|
|前端在發送 request 時，browser 會開啟一個 ephemeral port 作為對外溝通的窗口|

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

### Image
![](https://hackmd.io/_uploads/rJOpvhe1el.png)
![](https://hackmd.io/_uploads/HJ4ag6lylg.png)


### `@app.method(...)`
+ `deprecated=`：棄用
+ `response_model=`：response 採用的 schema
  ```ps
  curl -X POST "http://127.0.0.1:8000/items/" `
  -H "Content-Type: application/json" `
  -d '{
    "name": "antigravity",
    "price": 99.9,
    "tags": ["google"]
  }'
  ```
  ```py
  class Item(BaseModel):
      name: str
      description: str | None = None
      price: float
      tax: float | None = None
      tags: list[str] = []


  @app.post("/items/", response_model=Item)
  async def create_item(item: Item) -> Item:
      return item
  ```
  ```json
  {
    "name": "antigravity",
    "description": null,
    "price": 99.9,
    "tax": null,
    "tags": ["google"]
  }
  ```
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

## Tutorial

### Path Parameters

+ 範例
  ```sh
  curl "http://127.0.0.1:8000/items/5"
  ```
  ```py
  @app.get("/items/{item_id}")
  async def read_item(item_id: int):
      return {"item_id": item_id}
  ```
+ 範例：`Path`
  ```sh
  curl "http://127.0.0.1:8000/items/5"
  ```
  ```py
  @app.get("/items/{item_id}")
  async def read_item(item_id: Annotated[int, Path()]):
      return {"item_id": item_id}
  ```

### Query Parameters

+ 範例
  ```sh
  curl "http://127.0.0.1:8000/items/5"
  ```
  ```py
  # http://127.0.0.1:8000/items/?skip=0&limit=4
  @app.get("/items/")
  async def read_items(skip: int = 0, limit: int = 4):
      fake_items_db = [
          {"id": 1, "name": "apple"},
          {"id": 2, "name": "banana"},
          {"id": 3, "name": "carrot"},
          {"id": 4, "name": "durian"},
          {"id": 5, "name": "egg"},
      ]
      return fake_items_db[skip : skip + limit]
  ```
+ 範例：`Query`
  ```ps
  curl "http://127.0.0.1:8000/search?keyword=ap&limit=1"
  ```
  ```py
  @app.get("/search")
  async def search_products(
      keyword: Annotated[str | None, Query(min_length=1, max_length=30)] = None,
      limit: Annotated[int, Query(ge=1, le=20)] = 10,
  ):
      products = ["apple", "banana", "cherry", "grape"]

      if keyword:
          products = [p for p in products if keyword.lower() in p.lower()]

      return {"count": len(products), "results": products[:limit]}
  ```
+ 範例：`Query` + `BaseModel`
  ```ps
  curl "http://127.0.0.1:8000/items/?limit=40&offset=60&tags=red&tags=blue"
  ```
  ```py
  class FilterParams(BaseModel):
      limit: int = Field(100, gt=0, le=100)
      offset: int = Field(0, ge=0)
      order_by: Literal["created_at", "updated_at"] = "created_at"
      tags: list[str] = []

  @app.get("/items/")
  async def read_items(filter_query: Annotated[FilterParams, Query()]):
      return filter_query
  ```

### Request Body
+ 說明
  |🔮 <span class="important">IMPORTANT</span>|
  |:---|
  | <mark>直接使用 `BaseModel`</mark>，而未用 `Annotated` 加額外標註 (`Path()` / `Query()` / `Header()`)。<br>FastAPI 一律當做 reqest body <span style="color: gray">(注意：`GET` 方法沒有 reqest body)</span>。 |
+ 範例
  ```ps
  curl -X POST "http://127.0.0.1:8000/items/" `
  -H "Content-Type: application/json" `
  -d '{
    "name": "apple",
    "price": 9.9
  }'
  ```
  ```py
  class Item(BaseModel):
    name: str
    description: str | None = None
    price: float
    tax: float | None = None

  @app.post("/items/")
  async def create_item(item: Item):
      return item
  ```
+ 範例：`Body` + `embed=True`
  ```ps
  curl -X POST "http://127.0.0.1:8000/items/" `
  -H "Content-Type: application/json" `
  -d '{
    "item": {
      "name": "apple",
      "price": 9.9
    }
  }'
  ```
  ```py
  class Item(BaseModel):
      name: str
      description: str | None = None
      price: float
      tax: float | None = None


  @app.post("/items/")
  async def create_item(item: Annotated[Item, Body(embed=True)]):
      return item
  ```
+ 範例：多參數
  ```ps
  curl -X PUT "http://127.0.0.1:8000/items/123" `
    -H "Content-Type: application/json" `
    -d '{
      "item": {
        "name": "Foo",
        "description": "The pretender",
        "price": 42.0,
        "tax": 3.2
      },
      "user": {
        "username": "dave",
        "full_name": "Dave Grohl"
      },
      "importance": 5
    }'
  ```
  ```py
  class Item(BaseModel):
      name: str
      description: str | None = None
      price: float
      tax: float | None = None


  class User(BaseModel):
      username: str
      full_name: str | None = None


  @app.put("/items/{item_id}")
  async def update_item(
      item_id: int,
      item: Item,
      user: User,
      importance: Annotated[int, Body()],
  ):
      results = {
          "item_id": item_id,
          "item": item,
          "user": user,
          "importance": importance,
      }
      return results
  ```


### `Cookie`
+ 範例
  ```ps
  # 獲取 cookie，儲存在 cookies.txt
  curl -X GET -i -c "cookies.txt" "http://127.0.0.1:8000/login"
  ```
  ```ps
  # 將 cookies.txt 的 cookie 附帶於請求中
  curl -X GET -b "cookies.txt" "http://127.0.0.1:8000/profile" 
  ```
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
+ 範例
  ```py
  @app.get("/read-header") # 讀取 request 中 header 的 User-Agent 欄位
  def read_header(user_agent: Annotated[str | None, Header()] = None):
      return {"User-Agent": user_agent}
  ```

### `Form`
+ 範例：`Content-Type: application/x-www-form-urlencode`
  ```ps
  curl -X POST "http://localhost:8000/test/" `
    -H "Content-Type: application/x-www-form-urlencoded" `
    -d "username=alice&password=123456"
  ```
  ```py
  class FormData(BaseModel):
      username: str
      password: str
      model_config = {"extra": "forbid"}  # ✅ 不允許出現其他欄位

  # Form() # 🚀 夾帶檔案
  @app.post("/test/")
  async def test(data: Annotated[FormData, Form()]): # 預設
      return data
  ```
+ 範例：`Content-Type: multipart/form-data`
  > 需要套件：<mark>python-multipart</mark>
  ```ps
  # 
  # 註：@ 告訴 curl 這是路徑，而非字串
  curl -X POST "http://localhost:8000/test/" `
    -F "username=alice" `
    -F "password=123456" `
    -F "file=@./doge_gopnik_pixel.png"
  ```
  ```py
  class FormData(BaseModel):
      username: str
      password: str
      model_config = {"extra": "forbid"}


  @app.post("/test/")
  async def test(
      username: Annotated[str, Form()],
      password: Annotated[str, Form()],
      file: UploadFile | None = None,
      # 或寫成 Annotated[UploadFile, File()]
  ):
      data = FormData(username=username, password=password)
      return {
          "form": data,
          "filename": file.filename if file else None,
      }
  ```



### `Depends`
+ 說明
  + 依賴注入
  + 注入方式：一個 Callable 物件
    > `Annotated[..., Depends(Callable)]` \
    > `Annotated[Type, Depends()]` 等價於 `Annotated[Type, Depends(Type)]`
  + <mark>對於一時不可見的依賴，會向外解析依賴樹，直到找到為止</mark>
    > 依賴樹的 root node 必須是 API handler，\
    > 意即，它只能用於 API handler 內的 `Annotated`。\
    > 想必是在 `@app` 做了一些處理，詳見 [Annotated 黑魔法](https://hackmd.io/@RogelioKG/pythons_flying_circus/%2F%40RogelioKG%2Ftyping#Annotated%EF%BC%9A%E8%A8%BB%E9%87%8B)。\
    > 不過你也能用三方庫 [fastapi-injectable](https://github.com/JasperSui/fastapi-injectable) 的 `@injectable`，\
    > 讓它脫離 `@app` 也能運作。
+ 範例
  ```ps
  curl "http://localhost:8000/items/?skip=10&limit=5"
  ```
  ```py
  # ✅ 若你需要，這裡還可以再塞 Depends (sub-dependency)
  async def common_params(skip: int = 0, limit: int = 100): 
      return {"skip": skip, "limit": limit}

  @app.get("/items/")
  async def read_items(commons: Annotated[dict, Depends(common_params)]):
      return commons
  ```
+ 範例：<mark>隔山打牛</mark>
  ```py
  def get_double(n: int) -> int:
      return n * 2

  # 🚩 n 不用寫在參數簽名！
  # 🚩 在 /test?n=2 時，會回傳 4 
  @app.post("/test")
  async def test(doubled_number: Annotated[int, Depends(get_double)]):
      return doubled_number
  ```
+ 範例：OAuth 2.0
  ```py
  from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm

  # 自動從 request 的 authorization header 拿取 bearer token
  OAuth2Token = Annotated[
    str, 
    Depends(OAuth2PasswordBearer(tokenUrl="api/auth/login"))
  ]

  # 自動從 request 抓取登入資訊 (username 與 password 欄位，此為 OAuth 2.0 規定)
  LoginForm = Annotated[
    OAuth2PasswordRequestForm, 
    Depends()
  ]
  ```
+ 範例：Database
  ```py
  ...
  ```



### `app.mount`
+ 說明
  ```py
  app.mount(
    "/assets", 
    StaticFiles(directory="static/assets", html=True),
    name="assets"
  )
  ```
  + **`path`**："/assets"
    > + 將「本地目錄」掛載到 /assets 路由底下
    > + 任何請求 /assets/... 都會去讀取 static/assets/...
  + **`app`**：StaticFiles(...)
    > + 靜態資源伺服器
    > + `directory`："static/assets" (掛載的本地目錄)
    > + `html`：True (當使用者存取掛載點 /assets 本身時，若對應的本地目錄中存在 index.html，回傳 index.html)
  + **`name`**：路由名稱
+ 範例
  + 請求 http://127.0.0.1:8000/assets/foo.js → 回傳 `static/assets/foo.js`
  + 請求 http://127.0.0.1:8000/assets → 回傳 `static/assets/index.html`


## Security

+ 範例：<mark>使用 [JWT](https://kucw.io/blog/jwt/) 最簡實作 OAuth 2.0 授權流程</mark>
  ```py
  from datetime import UTC, datetime, timedelta
  from typing import Annotated, Any, Literal

  import uvicorn
  from fastapi import Depends, FastAPI, HTTPException
  from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
  from jose import ExpiredSignatureError, JWTError, jwt
  from jose.constants import ALGORITHMS

  app = FastAPI()

  # 自動從 request 的 authorization header 拿取 bearer token
  OAuth2Token = Annotated[str, Depends(OAuth2PasswordBearer(tokenUrl="login"))]
  # 自動從 request 抓取登入資訊 (username 與 password 欄位，此為 OAuth 2.0 規定)
  LoginForm = Annotated[OAuth2PasswordRequestForm, Depends()]

  SECRET = "my-secret"
  ALGO = ALGORITHMS.HS256


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
          "exp": int(token_expire_time.timestamp()),  # 指定過期時間
          "usage": usage,  # 指定用途
      }
      token = jwt.encode(token_payload, secret, algorithm=ALGO)
      return token


  def decode_token(token: str, secret: str) -> dict[str, Any]:
      try:
          return jwt.decode(token, secret, algorithms=[ALGO])
      except ExpiredSignatureError as err:
          raise HTTPException(status_code=401, detail="Token expired") from err
      except JWTError as err:
          raise HTTPException(status_code=401, detail="Invalid token") from err


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

      payload = {
          "sub": "rogelio@example.com",
          "id": 5,
      }

      access_token = generate_token(payload, SECRET, usage="access")
      refresh_token = generate_token(payload, SECRET, usage="refresh")

      return {"access_token": access_token, "refresh_token": refresh_token}


  # * 刷新路由，獲取新的 token 用
  @app.post("/refresh")
  def refresh(token: OAuth2Token):
      payload = decode_token(token, SECRET)
      verify_user(payload)

      assert payload.get("usage") == "refresh"  # ! 只能使用 refresh_token 來 refresh

      # 重建 payload，避免來路不明的 payload 注入
      new_payload = {
          "sub": payload["sub"],
          "id": payload["id"],
      }

      access_token = generate_token(new_payload, SECRET, usage="access")
      refresh_token = generate_token(new_payload, SECRET, usage="refresh")

      return {"access_token": access_token, "refresh_token": refresh_token}


  # * 私人路由，獲取 private resources 用
  @app.get("/profile")
  def profile(token: OAuth2Token):
      payload = decode_token(token, SECRET)
      verify_user(payload)
      assert payload.get("usage") == "access"  # ! 只能使用 access_token 來 access

      return {"message": "Welcome back!"}


  if __name__ == "__main__":
      uvicorn.run(app, host="0.0.0.0", port=8000)

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

## Middleware
+ 說明
  + 中介層，攔截 Request、Response
+ 範例
  ```py
  @app.middleware("http")
  async def add_process_time_header(
      request: Request,
      call_next: Callable[[Request], Awaitable[Response]],
  ):
      start_time = time.perf_counter()
      print(f"[Middleware] 收到請求：{request.method} {request.url}")

      # 👉 呼叫下一層 (下一 middleware 或 API handler)
      response = await call_next(request)

      # 計算時間
      process_time = time.perf_counter() - start_time
      response.headers["X-Process-Time"] = str(process_time)

      print(f"[Middleware] 回傳 response，耗時 {process_time:.6f} 秒")
      return response


  @app.get("/")
  async def read_root():
      return {"message": "Hello from FastAPI!"}

  ```

+ 範例：<mark>CORS</mark>
  > <mark>是否允許 CORS 是由 server 端決定的</mark>，自然是要在後端進行設定
  > + Cross Origin Request（跨源請求）：\
  > 一個來自 http://localhost:8000 的 JS 腳本，向 https://api.sampleapis.com/coffee/hot 發出請求（調用 API）
  > + Cross Origin Resource Sharing（跨源資源共用）：\
  > server 端安全政策，用來決定是否接受跨源請求
  ```py
  origins = [
      "http://localhost.tiangolo.com",
      "https://localhost.tiangolo.com",
      "http://localhost",
      "http://localhost:8080",
  ]

  app.add_middleware(
      CORSMiddleware,
      allow_origins=origins,
      allow_credentials=True,
      allow_methods=["*"],
      allow_headers=["*"],
  )
  ```

## BackgroundTasks
+ 說明
  + 一些比較繁重的任務，你不希望等到它完整執行完，才給前端響應 (速度太慢)
+ 範例
  ```py
  def write_log(email: str):
      with open("log.txt", "a") as f:
          f.write(f"Email sent to {email}\n")

  @app.post("/notify/{email}")
  async def notify(email: str, background_tasks: BackgroundTasks):
      background_tasks.add_task(write_log, email)
      return {"message": "Response returned, task running in background!"}
  ```

## Uvicorn
+ 使用
  ```bash
  uvicorn <app_script>:<app_object_name> --host <host> --port <port>
  ```
+ 常見選項
  | 選項 | 說明 |
  |------|------|
  | `--reload` | 偵測檔案變更，並自動重新啟動伺服器（Hot reload） |
  | `--host 0.0.0.0` | 指定 IP |
  | `--port 8000` | 指定 port |
  | `--workers 4` | 啟動多個 worker（<mark>不能與 reload 同時使用</mark>） |
  | `--env-file .env` | 指定環境變數檔案 |
  | `--log-level info` | 設定 log 等級 |
  | `--proxy-headers` | 信任反向代理傳遞的 headers |
  | `--ssl-keyfile` / `--ssl-certfile` | 啟用 HTTPS |



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
