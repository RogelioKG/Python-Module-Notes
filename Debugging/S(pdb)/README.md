# pdb

[![RogelioKG/threading](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/pdb)

### References
+ 🎬 [**【python】来学学debugger吧，不能只会用print调试呀！**](https://youtu.be/oyIJOCSgTM0)

### Command

|📗 <span class="tip">TIP</span>|
|:---|
| pdb 不只可讓你檢視程式狀態，也允許你**改變**程式狀態<br>(例：輸入一行 Python code 改變變數值)。|

|🚨 <span class="caution">CAUTION</span>|
|:---|
| `->` 箭頭指的是下一行要執行的程式。|

|🚨 <span class="caution">CAUTION</span>|
|:---|
| 在 breakpoint 停下來，表示還沒開始執行 breakpoint 這一行，<br>要等你下指令才會繼續執行。|

+ 顯示
  | Command | Shorthand | Description |
  |------------|------|-----------------|
  | `print`    | `p`  | 顯示變數的值。|
  | `where`    | `w`  | 顯示目前 call stack。|
  | `list`     | `l`  | 顯示目前執行的程式碼片段，預設顯示目前位置上下各 5 行的程式碼<br>(再輸入一次 `l` 可繼續往下看，`l .` 則是回到目前行數)。|
  | `longlist`| `ll` | 顯示目前所在函數的所有程式碼。|

+ 執行下一行
   | Command | Shorthand | Description |
   |------------|------|-----------------|
   | `next`     | `n`  | 執行下一行程式，但<mark>不會進入函數內部</mark>。|
   | `step`     | `s`  | 執行下一行程式，若<mark>有函數呼叫則進入函數內部</mark>。|

+ breakpoint
  | Command | Shorthand | Description |
  |------------|------|-----------------|
  | `break`    | `b`  | 在某一行設定 breakpoint (例：`break 10`)、<br>在某個函數開頭設定 breakpoint (例：`break func`)、<br>列出所有 breakpoint (`break`)。|
  | `disable`  |      | 停用某個 breakpoint。|
  | `enable`   |      | 啟用某個 breakpoint。|
  | `clear`    |      | 移除某個 breakpoint (例：`clear 1`)、<br>移除所有 breakpoint (例：`clear`)。|
  | `ignore`   |      | 設定某 breakpoint 的忽略次數<br>(例： breakpoint 1 接下來忽略四次 `ignore 1 2`)。|
  | `condition`|      | 設定 breakpoint 的條件。|

+ 繼續執行程式
  | Command | Shorthand | Description |
  |------------|------|-----------------|
  | `continue` | `c`  | 繼續執行程式，直到下一個 breakpoint。|
  | `return`   | `r`  | 繼續執行程式，直到函數結束。|
  | `until`    |      | 繼續執行程式，直到運行到某一行<br>(例：`until 10`)。|
  | `jump`     | `j`  | 跳到指定行號<br>(☢️ WARNING : 不執行跳過的行)<br>(🚨 CAUTION : 如果在函數內，跳轉範圍不能超過函數，想想 call stack！)。|

+ 其他
  | Command | Shorthand | Description |
  |------------|------|-----------------|
  | `help`     | `h`  | 幫助。|
  | `run`      |      | 重新執行程式 (原先設立的 breakpoint 會保留)。|
  | `quit`     | `q`  | 結束 debug 並退出 pdb。|
  | `args`     | `a`  | 列出目前函數引數值。|
  | `retval`   |      | 查看目前函數返回值。|
  | `up`       | `u`  | 移到上一層的 stack frame。|
  | `down`     | `d`  | 移到下一層的 stack frame。|