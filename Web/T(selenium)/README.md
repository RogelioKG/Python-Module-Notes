# selenium



## References
+ 🔗 [**Selenium 教學**](https://steam.oxxostudio.tw/category/python/spider/selenium.html)
+ 🔗 [**Selenium IDE 教學**](https://www.tpisoftware.com/tpu/articleDetails/1846#markdown-header-selenium-ide)
+ 🔗 [**Chrome Driver**](https://chromedriver.chromium.org/downloads)
+ 🔗 [**robots.txt**](https://www.cloudflare.com/zh-tw/learning/bots/what-is-robots-txt/)


## Selenium IDE
| command | desciption |
|:---        |:---|
|`assert`    |(驗證) 檢核目標是否符合期待的值，出現錯誤就終止測試。|
|`verify`    |(辨識) 檢核目標是否為設定值，出現錯誤測試仍繼續。|
|`wait for`  |(等待) 檢核目標是否在指定時間內出現某狀態，出現錯誤就終止測試。|
|`type`      |(輸入)|
|`send keys` |(按下某鍵)|


## Note

### 尋找元素
+ 說明
  | by | description |
  |--- |--- |
  |`By.ID`|透過 id，尋找第一個相符的元素|
  |`By.CLASS_NAME`|透過 class，尋找第一個相符的元素|
  |`By.CSS_SELECTOR`|透過 css 選擇器，尋找第一個相符的元素|
  |`By.NAME`|透過 name 屬性，尋找第一個相符的元素|
  |`By.TAG_NAME`|透過 HTML tag，尋找第一個相符的元素|
  |`By.LINK_TEXT`|透過 hyperlink 的文字，尋找第一個相符的元素|
  |`By.PARTIAL_LINK_TEXT`|透過 hyperlink 的部分文字，尋找第一個相符的元素|
  |`By.XPATH, xpath`|透過 xpath 的方式，尋找第一個相符的元素|
+ 範例
  ```py
  # 尋找第一個 option
  web_element = driver.find_element(By.TAG_NAME, "option")
  print(web_element.text)
  # OXXO

  # 再尋找下一個 option
  web_element = web_element.find_element(By.XPATH, "following-sibling::*[1]")
  print(web_element.text)
  # GKPen

  # 再尋找下兩個 option
  web_elements = web_element.find_elements(By.XPATH, "following-sibling::*[position() <= 2]")
  for web_element in web_elements:
      print(web_element.text)
      # OK
      # Hello
  ```

### 操作元素
+ 說明
  | method | params | description |
  |--- |--- |--- |
  |`click()`|`element`|按下滑鼠左鍵|
  |`click_and_hold()`|`element`|滑鼠左鍵按著不放|
  |`double_click()`|`element`|連續按兩下滑鼠左鍵|
  |`context_click()`|`element`|按下滑鼠右鍵 ( 需搭配指定元素定位 )|
  |`drag_and_drop()`|`source, target`|點擊 source 元素後，移動到 target 元素放開|
  |`drag_and_drop_by_offset()`|`source, x, y`|點擊 source 元素後，移動到指定的座標位置放開|
  |`move_by_offset()`|`x, y`|移動滑鼠座標到指定位置|
  |`move_to_element()`|`element`|移動滑鼠到某個元素上|
  |`move_to_element_with_offset()`|`element, x, y`|移動滑鼠到某個元素的相對座標位置|
  |`release()`|`element`|放開滑鼠|
  |`send_keys()`|`values`|送出某個鍵盤按鍵值|
  |`send_keys_to_element()`|`element`, values|向某個元素發送鍵盤按鍵值|
  |`key_down()`|`value`|按著鍵盤某個鍵|
  |`key_up()`|`value`|放開鍵盤某個鍵|
  |`reset_actions()`||清除儲存的動作|
  |`pause()`|`seconds`|暫停動作|
  |`perform()`||執行儲存的動作|

```py
# WebElement
a: WebElement
a = driver.find_element(By.ID, 'a')
a.click()       # 點擊 a
time.sleep(1)   # 等待一秒

# ActionChains
actions: ActionChains
actions = ActionChains(driver)
actions.click(a).pause(1) # 點擊 a 並等待 1 秒
actions.perform()         # 執行動作鏈
```

### 取得元素內容

+ 說明
  | method | params | description |
  |--- |--- |--- |
  |`get_attribute()`|`name`|元素的某個 HTML 屬性值 (例如："class")|
  |`get_property()`|`name`|元素的某個 HTML 特性值 (例如："readonly" / "disabled" / "required" / "checked" ...)|
  |`is_displayed()`||元素是否顯示在網頁上|
  |`is_enabled()`||元素是否可用|
  |`is_selected()`||元素是否被選取|
  |`screenshot()`|`filename`|將元素截圖並儲存成圖片|

  | attribute | description |
  |--- |--- |
  |`text`|元素的內容文字|
  |`id`|元素的 id|
  |`tag_name`|元素的 tag 名稱|
  |`size`|元素的長寬尺寸|
  |`parent`|元素的父元素|
+ 範例
  ```py
  web_element = driver.find_element(By.TAG_NAME, "select")
  print(web_element.get_attribute("id"))
  # select

  web_element = driver.find_element(By.TAG_NAME, "select")
  print(web_element.get_attribute("innerHTML"))
  # <option value="OXXO">OXXO</option>
  # <option value="GKPen">GKPen</option>
  # <option value="OK">OK</option>
  # <option value="Hello">Hello</option>

  web_element = driver.find_element(By.TAG_NAME, "select")
  print(web_element.get_attribute("outerHTML"))
  # <select id="select">
  #   <option value="OXXO">OXXO</option>
  #   <option value="GKPen">GKPen</option>
  #   <option value="OK">OK</option>
  #   <option value="Hello">Hello</option>
  # </select>

  outer_text = web_element.get_attribute("outerHTML")
  soup = BeautifulSoup(outer_text, "html.parser")
  print(soup.find("option", {"value": "GKPen"}).text)
  # GKPen
  ```



### 預期元素


|☢️ <span class="warning">WARNING</span> : `time.sleep()` bad👎|
|:---|
|你應預期某元素顯現可點擊、已載入等等的狀態，卻把這樣的預期付諸等待。<br>你永遠不知道可能發生什麼事，導致元素沒能在你寫死的時間內顯現狀態！|

+ 說明
  | function | params | description |
  |--- |--- |--- |
  |`presence_of_element_located()`|`locator`|等待元素出現在 DOM 中（不保證可見）。|
  |`presence_of_all_elements_located()`|`locator`|等待一組元素出現在 DOM 中。|
  |`visibility_of()`|`element`|等待傳入的 WebElement 可見。|
  |`visibility_of_element_located()`|`locator`|等待指定 locator 的元素可見。|
  |`visibility_of_all_elements_located()`|`locator`|等待一組元素都可見。|
  |`invisibility_of_element_located()`|`locator`|等待元素不可見或不存在。|
  |`invisibility_of_element()`|`element`|等待指定的元素消失或不可見。|
  |`element_to_be_clickable()`|`locator`|元素可見且可點擊（常用）。|
  |`element_to_be_selected()`|`element_or_locator`|等待元素被選取（如 checkbox）。|
  |`element_selection_state_to_be()`|`element_or_locator, is_selected`|等待元素的選取狀態符合期望。|
  |`text_to_be_present_in_element()`|`locator, text`|等待元素內包含特定文字。|
  |`text_to_be_present_in_element_value()`|`locator, text`|等待元素的 `value` 屬性包含特定文字。|
  |`attribute_contains()`|`locator, attribute, value`|等待屬性包含指定子字串。|
  |`attribute_to_be()`|`locator, attribute, value`|等待屬性等於指定值。|
  |`number_of_windows_to_be()`|`count`|等待視窗數量符合指定值（常用於彈出視窗）。|
  |`number_of_elements_to_be()`|`locator, count`|等待某 locator 對應的元素數量符合指定值。|
  |`staleness_of()`|`element`|等待元素變得無效（例如 DOM 更新後）。|
  |`frame_to_be_available_and_switch_to_it()`|`locator`|等待 iframe 可用並自動切換進入。|
  |`alert_is_present()`||等待 alert 彈出（可接 `.accept()`）。|

+ 範例
  ```py
  # [掛機神器]
  # 等 900 s，每 500 ms 檢查一次 "某元素是否可以點擊"，如果可以點就立馬點
  # ⚠️ 注意：傳進去的是 tuple！
  try:
      buy_button: WebElement = WebDriverWait(driver, 900).until(
          EC.element_to_be_clickable((By.CSS_SELECTOR, "..."))
      )
      buy_button.click()
  except Exception as err:
      print(err)
      driver.quit()
  ```

  ```py
  # [等待載入]
  # 等 5 s，每 500 ms 檢查一次 "某元素是否載入"，如果已載入就立馬使用
  # ⚠️ 注意：傳進去的是 tuple！
  try:
      beginning_block: WebElement = WebDriverWait(driver, 5).until(
          EC.presence_of_element_located((By.CLASS_NAME, "..."))
      )
  except Exception as err:
      print(err)
      driver.quit()
  ```

### 執行腳本
+ 範例
  ```py
  driver.execute_script('window.scrollTo(0, 2500)')  # 捲動到 2500px 位置
  ```

### 錯誤
+ 說明
  | exception | description |
  |--- |--- |
  | `NoSuchElementException` | 無法找到符合條件的元素，例如 `find_element()` 找不到任何結果。 |
  | `TimeoutException` | `WebDriverWait` 等待條件超時，例如元素遲遲未出現。 |
  | `StaleElementReferenceException` | 元素在 DOM 中被更新或移除，原本的 WebElement 引用失效。 |
  | `ElementNotInteractableException` | 元素存在但不可互動（例如被隱藏、disabled 或被其他元素遮住）。 |
  | `ElementClickInterceptedException` | 嘗試點擊元素時，被其他元素攔截（例如彈窗、遮罩）。 |
  | `ElementNotSelectableException` | 元素無法被選取（多發生在 select/option 未啟用時）。 |
  | `InvalidElementStateException` | 元素狀態不允許執行操作（例如 disabled 的輸入框送鍵）。 |
  | `MoveTargetOutOfBoundsException` | 嘗試移動滑鼠到螢幕或 viewport 之外的座標。 |
  | `JavascriptException` | 執行 `execute_script()` 時 JS 發生錯誤。 |
  | `UnexpectedAlertPresentException` | 操作期間突然跳出 alert，導致命令中斷。 |
  | `NoAlertPresentException` | 嘗試處理 alert 時（accept/dismiss）實際上不存在 alert。 |
  | `WebDriverException` | 所有 webdriver 錯誤的父類別（通用錯誤）。 |
  | `SessionNotCreatedException` | 啟動瀏覽器 session 失敗，常見於 driver 與瀏覽器版本不符。 |
  | `InvalidSessionIdException` | 操作已關閉或失效的 session（例如 driver.quit() 後仍呼叫）。 |
  | `InvalidArgumentException` | 傳入不合法的參數（例如錯誤的 URL、locator 類型）。 |
  | `NoSuchWindowException` | 嘗試切換到不存在的視窗或 tab。 |
  | `NoSuchFrameException` | 嘗試切換到不存在的 iframe。 |
  | `NoSuchCookieException` | 嘗試取得不存在的 cookie。 |
  | `UnexpectedTagNameException` | 使用錯誤的 WebElement 類型（例如非 select 元素傳給 Select）。 |
  | `InvalidSelectorException` | locator CSS/XPath 語法錯誤。 |
  | `ImeNotAvailableException` | IME（輸入法引擎）不可用或不支援。 |
  | `ImeActivationFailedException` | 嘗試啟用 IME 失敗。 |
  | `UnhandledAlertException` | alert 未被正確處理導致操作中斷。 |
  | `NoSuchDriverException` | 嘗試存取已被關閉的 driver。 |
  | `ScreenshotException` | 無法對元素或頁面截圖。 |
  | `ErrorInResponseException` | 低階通訊錯誤（通常是舊版 Selenium）。 |
  | `RemoteDriverServerException` | 遠端 webdriver server 發生錯誤（remote 執行時）。 |
  | `InvalidCookieDomainException` | 嘗試設定 cookie 到不屬於目前 domain 的網站。 |
  | `InsecureCertificateException` | SSL 憑證錯誤或瀏覽器拒絕載入網站。 |


### 結束
+ 範例
  ```py
  # 關閉視窗
  driver.close()
  # 結束瀏覽器進程
  driver.quit()
  ```