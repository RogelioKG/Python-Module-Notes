# sqlalchemy

![](https://media.licdn.com/dms/image/v2/D4E10AQHg03wvp6XmBg/image-shrink_1280/image-shrink_1280/0/1722610852769?e=1745780400&v=beta&t=-eil40RhZ0TzsMk_jVPWgn3x_RcR9jxAqcJrSxfO-cg)

## References
+ 🔗 [**什么是 N+1 问题，以及如何解决**](https://segmentfault.com/a/1190000039421843)

## ORM
物件關係對映 (Object Relational Mapping)
開發者可通過操作類別與實例，來對資料庫進行 CRUD 等操作，而不必直接操作 SQL 語句。

1. 將<span style="color: cornflowerblue">表格</span>映射為<span style="color: firebrick">類別</span>
2. 將<span style="color: cornflowerblue">欄位</span>映射為<span style="color: firebrick">屬性</span>
3. 將<span style="color: cornflowerblue">記錄</span>映射為<span style="color: firebrick">實例</span>


## Session
|🔮 <span class="important">IMPORTANT</span>|
|:---|
|一次 session 中，允許多次的 `commit()` 和 `rollback()` (參考：[SQLAlchemy - Managing Transactions](https://docs.sqlalchemy.org/en/13/orm/session_transaction.html#managing-transactions))|
|未對資料庫操作前，session 是 begin 狀態；<br>對資料庫操作時（如 `execute()`），session 是 transactional 狀態；<br>一旦 `commit()` 之後，session 又回到 begin 狀態|
|session 看似可產生一次，永久運行，實際上是不建議這麼做的。<br>session 本質上就是一個資料變更緩衝區 + ORM 實例管理器，<mark>設計上就是是暫時性的</mark>，而非永久性的。<br>在長時間運行的 web app 中，若沒有定期釋放，久了會導致 memory leak 或資料不一致。<br>請盡可能以<mark>一個任務一次 session</mark> 的方式去限制它的生命週期。|

|🚨 <span class="caution">CAUTION</span>|
|:---|
|在<mark>使用 ORM 實例</mark>前請注意，若你位處一個 session 之中，<br>且在那之前有更新資料庫過 (`commit()`)，請記得先 `refresh()`，因為資料可能不一致！|
|最常見的範例就是，ORM 實例無 id，由資料庫自動產生 id，那麼塞進資料庫後，id 欄位被自動補上，因此就產生了不一致。|

+ `expire_on_commit=False`
    + 決定在呼叫 commit() 之後，session 中的「所有」 ORM 實例是否應該自動標記為過期，以便下次使用時自動從資料庫重新載入
    + 若跟隨預設 (`True`)，當資料量龐大時，會[相當耗時](https://blog.youguanxinqing.xyz/index.php/archives/147/)
    + 這邊選擇 `False`，所以我們要手動 `refresh()`

```py
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine, async_sessionmaker

engine = create_async_engine(os.getenv("DATABASE_URI"))
async_session = async_sessionmaker(engine, expire_on_commit=False)

@asynccontextmanager
async def get_db():
    async with async_session() as db:
        async with db.begin():  # 自動 commit / rollback
            yield db

```
```py
# 外面這樣寫
with get_db() as db
    user = User(...)
    db.add(...)
    await db.commit()
    # ⚠️ 塞進資料庫後，id 欄位被自動補上，因此就產生了不一致
    await db.refresh(user)
```

## SQLAlchemy 2.0

### result
+ `scalars()`
  > 返回多個結果
  + `first()`：取第一個
  + `all()`：取每個
  + `one()`：取一個，斷言僅一個
+ `scalar()`
  > 返回單一結果

### `select` / `where`
```py
stmt = select(User).where(User.name == "Alice")
result = await session.execute(stmt)
user = result.scalars().first()
```

### `insert` / `update` / `delete`
```py
from sqlalchemy import insert, update, delete

# 新增
stmt = insert(User).values(name="Alice", email="a@example.com")
await session.execute(stmt)
await session.commit()

# 更新
stmt = update(User).where(User.id == 1).values(name="Updated Name")
await session.execute(stmt)
await session.commit()

# 刪除
stmt = delete(User).where(User.id == 1)
await session.execute(stmt)
await session.commit()

```

### `and_`
```py
stmt = select(User).where(
    and_(
        User.age >= 18,
        User.email.like("%@gmail.com")
    )
)
result = await session.execute(stmt)
users = result.scalars().all()
```

### `in`
```py
stmt = select(User).where(User.id.in_([1, 2, 3]))
```

### `order_by`
```py
stmt = select(User).order_by(User.created_at.desc())
```

### `join`
```py
stmt = select(User, Address).join(Address).where(User.id == Address.user_id)
result = await session.execute(stmt)
rows = result.all()  # 回傳 list[tuple(User, Address)]
```

### `offset` / `limit`
```py
stmt = select(User).offset(10).limit(20)  # 跳過 10 筆，取 20 筆
```
