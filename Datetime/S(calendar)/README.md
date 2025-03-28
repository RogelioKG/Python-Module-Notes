# calendar

Python 的 `calendar` 模組提供了一組有關日曆操作的函式和類別，這些工具可以生成月曆和年曆，並提供有關日期和時間的訊息。以下是 `calendar` 模組中的主要函式和類別：

### 1. `calendar` 類別
- **`Calendar()`** : 生成一個日曆物件，可以用來生成特定月份或年份的日曆資料。這個類別允許你設定每週的第一天 (通常是星期一或星期日)，並且提供許多方法來檢索和操作日曆資料。

### 2. 生成月曆和年曆
- **`month(year, month, w=0, l=0)`** : 返回特定年份和月份的日曆作為多行字符串，`w` 是每列的寬度，`l` 是每行之間的行數。
- **`monthcalendar(year, month)`** : 返回一個月曆作為嵌套的列表，其中的每一行代表一周，每一天以數字表示 (0 表示該天不在這個月)。
- **`monthrange(year, month)`** : 返回兩個值：該月的第一天是星期幾 (0 是星期一)，以及該月有幾天。
- **`calendar(year, w=2, l=1, c=6, m=3)`** : 返回整個年份的年曆作為多行字符串，`w` 是每個日曆方格的寬度，`l` 是每行的行數，`c` 是月之間的空格數，`m` 是每行中的月數。

### 3. 日期相關函式
- **`isleap(year)`** : 判斷給定年份是否是閏年，返回 `True` 或 `False`。
- **`leapdays(y1, y2)`** : 返回從年份 `y1` 到年份 `y2` (不包括 `y2`) 之間的閏年數量。
- **`weekday(year, month, day)`** : 返回指定日期是星期幾 (0 是星期一，6 是星期日)。

### 4. 設置和格式化
- **`setfirstweekday(weekday)`** : 設置每週的第一天 (預設是星期一)，`weekday` 可以是 `0` (星期一) 到 `6` (星期日)。
- **`firstweekday()`** : 返回目前設置的每週第一天。
- **`prmonth(year, month, w=0, l=0)`** : 在控制台中輸出指定月份的日曆。
- **`prcal(year, w=2, l=1, c=6, m=3)`** : 在控制台中輸出指定年份的年曆。

### 5. 當地時間和閏年
- **`timegm(tuple)`** : 將時間 tuple 轉換為 UTC 的時間戳。
- **`month_name`** : 提供從 1 到 12 的月份名稱的列表。
- **`day_name`** : 提供從 0 到 6 的星期幾名稱的列表。

### 6. TextCalendar 和 HTMLCalendar
- **`TextCalendar(firstweekday=0)`** : 生成一個適合於輸出的文本日曆。
- **`HTMLCalendar(firstweekday=0)`** : 生成一個適合於在網頁上顯示的 HTML 格式日曆。

### 7. 其他函式
- **`timegm(time_tuple)`** : 將時間 tuple 轉換為對應的時間戳 (秒數)。
- **`LocaleTextCalendar(firstweekday=0, locale=None)`** : 生成一個根據地區設置格式化的文本日曆。
- **`LocaleHTMLCalendar(firstweekday=0, locale=None)`** : 生成一個根據地區設置格式化的 HTML 日曆。

這些函式和類別為 Python 程式員提供了強大的日曆生成和操作功能，可以輕鬆地處理與日期和時間相關的任務。