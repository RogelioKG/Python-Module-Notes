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
    └── schemas          # SQLAlchemy Table
        ├── __init__.py
        ├── items.py
        └── users.py
```

## API document
![](https://hackmd.io/_uploads/rJOpvhe1el.png)
![](https://hackmd.io/_uploads/HJ4ag6lylg.png)


## Usage

### `@app.HTTP_METHOD(...)`：API 端點
+ `response_model=`：response 採用的 schema
+ `deprecated=`：棄用

### `Depends` 依賴注入
|🚨 <span class="caution">CAUTION</span>|
|:---|
|只能用於 API endpoint 的 handle funtion，並且必須是 `Annotated` 的註釋<br>（想必是在 app decorator 做了一些處理，詳見 [Annotated 黑魔法](https://hackmd.io/@RogelioKG/pythons_flying_circus/%2F%40RogelioKG%2Ftyping#Annotated-%E8%A8%BB%E9%87%8B)）。|
|當然你也能用三方庫 [fastapi-injectable](https://github.com/JasperSui/fastapi-injectable) 的 `@injectable` 讓它脫離 app decorator 也能運作。|


## Uvicorn
+ `--reload`：開啟 hot reload
  ```bash
  uvicorn <entry_point_script>:<app_object_name> --host <host> --port <port>
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
### 幻想的破滅
+ 配置
  + engine 與 workers 皆採預設
+ 測試工具：[locust](https://locust.io/)
  + peak concurrency; 100
  + ramp up: 10
+ 測試結果

  可以看到實際上<mark>異步版本反而 overhead 很重</mark>。\
  我覺得就現實面來看，還是要考量：
  1. 應用是否符合 I/O 密集（比如需要到某處 fetch 資料很久）
  2. 應用是否有高 concurrency 需求（比如網站流量超大）

  + sync
    ![](https://hackmd.io/_uploads/r1ZZcG4kxg.png)
  + async
    ![](https://hackmd.io/_uploads/r1bWcM4kgx.png)

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