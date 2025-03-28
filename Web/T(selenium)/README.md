# selenium



### References
+ 🔗 [**Selenium 教學**](https://steam.oxxostudio.tw/category/python/spider/selenium.html)
+ 🔗 [**Selenium IDE 教學**](https://www.tpisoftware.com/tpu/articleDetails/1846#markdown-header-selenium-ide)
+ 🔗 [**Chrome Driver**](https://chromedriver.chromium.org/downloads)
+ 🔗 [**robots.txt**](https://www.cloudflare.com/zh-tw/learning/bots/what-is-robots-txt/)



### Note

+ **Chrome 相關版本資訊**
  ```
  chrome://version
  ```
+ **Chrome 小恐龍**
  ```
  chrome://dino
  ```



### Selenium IDE
| command | desciption |
|:---        |:---|
|`assert`    |(驗證) 檢核目標是否符合期待的值，出現錯誤就終止測試。|
|`verify`    |(辨識) 檢核目標是否為設定值，出現錯誤測試仍繼續。|
|`wait for`  |(等待) 檢核目標是否在指定時間內出現某狀態，出現錯誤就終止測試。|
|`type`      |(輸入)|
|`send keys` |(按下某鍵)|



### Example
```py
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.remote.webelement import WebElement         # 網頁元素，find 回傳的資料結構
from selenium.webdriver.common.action_chains import ActionChains    # 動作鏈
from selenium.webdriver.support.ui import WebDriverWait             # 待機
from selenium.webdriver.support import expected_conditions as EC    # 預期元素
from pathlib import Path
from bs4 import BeautifulSoup
import time


# Service
# chromedriver 路徑
path = Path.home() / Path(".wdm/drivers/chromedriver/win64/119.0.6045.105/chromedriver-win32/chromedriver.exe")
# 把 Chrome Driver 路徑放到這裡
service = Service(path)                                                 

# Options
options = Options()
# 抑制錯誤日誌輸出到 console
options.add_experimental_option('excludeSwitches', ['enable-logging'])  

# 創建 Driver 實例
driver = webdriver.Chrome(options=options, service=service)

# 隱式等待 (這將會在每次載入頁面時都自動等待 10 秒，後續不須重新調用)
# driver.implicitly_wait(10)

# 開啟範例網址
driver.get('https://google.com')
driver.get('https://example.oxxostudio.tw/python/selenium/demo.html')
# 返回上一個瀏覽歷史
driver.back()
# 前進下一個瀏覽歷史
driver.forward()
```



### 尋找網頁元素

| params of `find_element` / `find_elements` | description |
|--- |--- |
|`By.ID, id`|透過 id，尋找第一個相符的網頁元素。|
|`By.CLASS_NAME, class`|透過 class，尋找第一個相符的網頁元素。|
|`By.CSS_SELECTOR, css_selector`|透過 css 選擇器，尋找第一個相符的網頁元素。|
|`By.NAME, name`|透過 name 屬性，尋找第一個相符的網頁元素。|
|`By.TAG_NAME, tag`|透過 HTML tag，尋找第一個相符的網頁元素。|
|`By.LINK_TEXT, text`|透過超連結的文字，尋找第一個相符的網頁元素|
|`By.PARTIAL_LINK_TEXT, text`|透過超連結的部分文字，尋找第一個相符的網頁元素。|
|`By.XPATH, xpath`|透過 xpath 的方式，尋找第一個相符的網頁元素。|

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





### 操作網頁元素

| action | params | description |
|--- |--- |--- |
|`click()`|`element`|按下滑鼠左鍵。|
|`click_and_hold()`|`element`|滑鼠左鍵按著不放。|
|`double_click()`|`element`|連續按兩下滑鼠左鍵。|
|`context_click()`|`element`|按下滑鼠右鍵 ( 需搭配指定元素定位 )。|
|`drag_and_drop()`|`source, target`|點擊 source 元素後，移動到 target 元素放開。|
|`drag_and_drop_by_offset()`|`source, x, y`|點擊 source 元素後，移動到指定的座標位置放開。|
|`move_by_offset()`|`x, y`|移動滑鼠座標到指定位置。|
|`move_to_element()`|`element`|移動滑鼠到某個元素上。|
|`move_to_element_with_offset()`|`element, x, y`|移動滑鼠到某個元素的相對座標位置。|
|`release()`|`element`|放開滑鼠。|
|`send_keys()`|`values`|送出某個鍵盤按鍵值。|
|`send_keys_to_element()`|`element`, values|向某個元素發送鍵盤按鍵值。|
|`key_down()`|`value`|按著鍵盤某個鍵。|
|`key_up()`|`value`|放開鍵盤某個鍵。|
|`reset_actions()`||清除儲存的動作。|
|`pause()`|`seconds`|暫停動作。|
|`perform()`||執行儲存的動作。|

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



### 取得網頁元素內容

| content | description |
|--- |--- |
|`text`|元素的內容文字。|
|`get_attribute()`|元素的某個 HTML 屬性值。(若給 "outerHTML"，回傳整個 tag 含內部的HTML字串)(若給 "innerHTML"，回傳 tag 內部的HTML字串)|
|`get_property()`|元素的某個 HTML 特性值。(例如 readonly / disabled / required / checked 等等特性，回傳的是布林值)|
|`id`|元素的 id。|
|`tag_name`|元素的 tag 名稱。|
|`size`|元素的長寬尺寸。|
|`screenshot`|將某個元素截圖並儲存為 png。|
|`is_displayed()`|元素是否顯示在網頁上。|
|`is_enabled()`|元素是否可用。|
|`is_selected()`|元素是否被選取。|
|`parent`|元素的父元素。|

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



### 預期元素 EC (顯式等待)


|☢️ <span class="warning">WARNING</span> : `time.sleep()` bad👎|
|:---|
|你應預期某元素顯現可點擊、已載入等等的狀態，卻把這樣的預期付諸等待。<br>你永遠不知道可能發生甚麼事，導致元素沒能在你寫死的時間內顯現狀態！|


>
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



### JS腳本
```py
driver.execute_script('window.scrollTo(0, 2500)')  # 捲動到 2500px 位置
```



### 結束
```py
# 關閉視窗
driver.close()
# 結束瀏覽器進程
driver.quit()
```