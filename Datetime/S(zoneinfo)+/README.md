# zoneinfo

Python 的 `zoneinfo` 模組自 Python 3.9 開始引入，主要用來處理 IANA 時區資料庫中的時區訊息。該模組包含的類別和函式允許你輕鬆地處理和管理不同時區之間的時間計算。以下是 `zoneinfo` 模組中的所有主要類別與函式的整理。

### 1. 類別

#### **`zoneinfo.ZoneInfo`**
- **說明** : 代表一個時區訊息物件，通常用來將 `datetime` 物件轉換到指定時區。
- **用法** :
  - **`ZoneInfo(key)`** : 透過 IANA 時區資料庫的時區名稱來創建時區物件，例如 `ZoneInfo("America/New_York")`。
  - **`ZoneInfo.no_cache()`** : 創建一個不使用快取的 `ZoneInfo` 實例。這個特性可以用於防止同一個時區物件的多次創建時重複使用快取版本。

#### **`zoneinfo.ZoneInfoNotFoundError`**
- **說明** : 當嘗試創建一個 `ZoneInfo` 物件時，如果指定的時區找不到，會引發這個異常。
- **用法** :
  - **`ZoneInfoNotFoundError`** : 可以捕獲並處理在 `ZoneInfo` 實例化過程中出現的錯誤。

### 2. 函式

#### **`zoneinfo.available_timezones()`**
- **說明** : 返回一個包含所有可用時區名稱的 `set`，這些時區名稱可以用於創建 `ZoneInfo` 物件。
- **用法** :
  - **`available_timezones()`** : 通常用於檢查系統支持的所有時區。

#### **`zoneinfo.TZPATH`**
- **說明** : 一個可變的列表，包含尋找時區數據文件的路徑。
- **用法** :
  - **`TZPATH`** : 可以修改這個列表來指定自定義的時區數據文件路徑。

#### **`zoneinfo.reset_tzpath()`**
- **說明** : 重置 `TZPATH` 列表，使其恢復到預設值。
- **用法** :
  - **`reset_tzpath()`** : 當你改變了 `TZPATH` 之後，想要恢復到初始設定時使用。

這些類別與函式為 `zoneinfo` 模組提供了完整的時區支持，可以在全球不同時區之間進行時間計算和轉換，對於需要處理多時區應用程序的開發者來說，這是一個非常有用的工具。