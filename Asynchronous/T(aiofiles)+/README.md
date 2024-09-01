# aiofiles

### 參考
  + 🔗 [**Medium - aiofiles 讀檔案反而比較慢?**](https://medium.com/@bright2227/python-aiofiles-%E8%AE%80%E6%AA%94%E6%A1%88%E5%8F%8D%E8%80%8C%E6%AF%94%E8%BC%83%E6%85%A2-a0cbeca8a587)
  + 🔗 [**StackOverFlow - aiofiles take longer than normal file operation**](https://stackoverflow.com/questions/68957147/aiofiles-take-longer-than-normal-file-operation)
  + 🔗 [**稀土掘金 - aiofiles尝鲜**](https://juejin.cn/post/7091282276612472846)

### 注意

|📘 <span class="note">NOTE</span>|
|:---|
|aiofiles 雖然是異步操作，但似乎是 delegate 另一個線程去讀取檔案，<br>由於 GIL 的緣故，它會比同步 open 耗費更多時間，<br>好處是將讀取檔案操作放在其他線程，在遇到大檔案的時候，就不會阻塞主線程<br>(在 GUI 設計時，這蠻重要的，畢竟主線程一旦 block，控件就完全無法運作了) |