# bs4

## References
+ 🔗 [**oxxostudio - beautifulsoup**](https://steam.oxxostudio.tw/category/python/spider/beautiful-soup.html)

## Tips
+ 上網爬
  ```py
  url = "https://water.taiwanstat.com/"
  response = requests.get(url)
  soup = BeautifulSoup(response.text, "html.parser")
  ```
+ 本地爬
  ```py
  url = "./practice.html"
  with open(url, mode="r", encoding="utf-8") as htmlFile:
      html_content = htmlFile.read()
  soup = BeautifulSoup(html_content, "html.parser")
  ```

## Class

### `PageElement`
> ...

### `Tag`
> 繼承自 PageElement，代表一個 HTML 元素

### `BeautifulSoup`
> 繼承自 Tag

+ 屬性
  ```py
  soup.name      # 過濾器 - tag 名稱 (濾出 Tag 的過濾器會被記錄在它的屬性內)
  soup.attrs     # 過濾器 - 屬性字典
  soup.contents  # 內容 (list)
  soup.text      # 內容 (str) (通常就是你要爬的內容)
  soup["href"]   # 或者你想要屬性裡的某個內容
  ```
+ 方法
  ```py
  soup: BeautifulSoup             # 無論是 BeautifulSoup 還是 Tag
  tags: Tag                       # 都可以使用下列的方法 (畢竟他們是繼承關係)

  soup.prettify()                 # 漂亮格式

  soup.select()                   # 以 CSS 選擇器的方式尋找指定的 tag
                                  # -> ResultSet[Tag]

                                  # name:      過濾器 - tag 名稱 (例如 "div")
                                  # attrs:     過濾器 - 屬性字典 (例如 {"class": "contents_box02"})
                                  # recursive: 預設 True，會搜尋內容【所有】層，設定 False 只會搜尋下一層
                                  # string:    搜尋 tag 包含的文字
                                  # limit:     搜尋 tag 後只回傳多少個結果

  soup.find_all()	                # 以所在的 tag 位置，尋找全部內容裡【所有】指定的 tag
                                  # -> ResultSet[Tag]                                       
  soup.find()	                    # 以所在的 tag 位置，尋找全部內容裡【第一個】找到的 tag
                                  # -> Tag

  soup.find_parents()             # 以所在的 tag 位置，尋找父層【所有】指定的 tag
                                  # -> ResultSet[Tag]
  soup.find_parent()	            # 以所在的 tag 位置，尋找父層【第一個】找到的 tag
                                  # -> Tag
  
  soup.find_next_siblings()       # 以所在的 tag 位置，尋找同層後方【所有】指定的 tag
                                  # -> ResultSet[Tag]
  soup.find_next_sibling()        # 以所在的 tag 位置，尋找同層後方【第一個】找到的 tag
                                  # -> Tag
                                      
  soup.find_previous_siblings()   # 以所在的 tag 位置，尋找同層前方【所有】指定的 tag
                                  # -> ResultSet[Tag]
  soup.find_previous_sibling()    # 以所在的 tag 位置，尋找同層前方【第一個】找到的 tag
                                  # -> Tag
                                      
  soup.find_all_next()            # 以所在的 tag 位置，尋找後方內容裡【所有】指定的 tag
                                  # -> ResultSet[Tag]
  soup.find_next()                # 以所在的 tag 位置，尋找後方內容裡【第一個】找到的 tag
                                  # -> Tag
                                      
  soup.find_all_previous()        # 以所在的 tag 位置，尋找前方內容裡【所有】指定的 tag
                                  # -> ResultSet[Tag]
  soup.find_previous()            # 以所在的 tag 位置，尋找前方內容裡【第一個】找到的 tag
                                  # -> Tag
  ```
### `ResultSet`
> 繼承自 list，Tag 的容器
+ 屬性
  ```py
  # source: 過濾器，SoupStrainer 類別
  ```

### `SoupStrainer`
> 過濾器

+ ...
  ```py
  # SoupStrainer 被用於指定篩選條件
  # 在 BeautifulSoup 物件建立之前
  # 限制僅解析 <div class="contents_box02"></div> 標籤
  # 這樣可以節省解析大型文件時的時間和記憶體

  url = "https://www.taiwanlottery.com.tw/index_new.aspx"
  response = requests.get(url)
  strainer = SoupStrainer("div", {"class": "contents_box02"})
  soup = BeautifulSoup(response.text, "html.parser", parse_only=strainer)
  ```