# sqlalchemy

### ORM
物件關係對映 ORM (Object Relational Mapping) 是一種程式設計技術，\
用於將<mark>*物件導向程式語言中的物件*</mark>與<mark>**關聯式資料庫中的資料表**</mark>之間建立對應關係，\
從而允許開發者可以使用物件的方式來操作資料庫中的資料，而不必直接處理 SQL 語句。\
ORM 技術將資料庫的資料映射到程式語言中的物件，使開發者可以使用物件導向的方式來操作資料庫，\
這樣可以提高開發效率並降低代碼的複雜度。

ORM 提供了一種抽象層
1. 將<mark>**資料庫表格**</mark>映射為<mark>*程式語言中的類別*</mark>
2. 將<mark>**表格中的欄位**</mark>映射為<mark>*類別中的屬性*</mark>
3. 將<mark>**資料庫中的記錄**</mark>映射為<mark>*類別的實例*</mark>

開發者可以通過操作這些類別和實例來對資料庫進行增刪改查等操作，而不必直接操作 SQL 語句。

### 注意

> [!NOTE]
> + 可預先給定 id 值，但若存入資料庫時有撞 id，會引發錯誤。
> + 若不預先給定 id 值，那麼其在存進資料庫時 (commit 後) 會自動給定值。
> ```py
> def create_user(user: User, session: Session) -> User:
>     session.add(user)
>     session.commit()
>     return user # 返回的這個 user 已有 id
> ```

### Base

+ `metadata`

    + `tables` 所有資料表

        > 清空每個資料表中的所有資料
        ```py
        # name: str 型別，也就是 __tablename__
        # table: Table 型別，query 給的引數可以直接是資料表類別 (比如 User)，也可以使用這裡迭代的 table
        for name, table in Base.metadata.tables.items():
            session.query(table).delete()
        session.commit()
        ```

    + `create_all()` 建立所有資料表
  
    + `drop_all()` 刪除所有資料表