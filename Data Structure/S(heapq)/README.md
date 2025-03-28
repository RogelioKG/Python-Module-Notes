# heapq

> [!NOTE]
> Python 的 heapq 只實現 min heap 功能，\
> 然而你可以自己寫一個翻轉比較子定義的 MaxHeapObj 轉接頭 (adaptor)，\
> 這樣 min heap 就被你轉為 max heap 了！

### 函式
| function                           | time complexcity | description                                                                                                |
| ---------------------------------- | ---------------- | ---------------------------------------------------------------------------------------------------------- |
| `heappush(heap, item)`             | O(log n)         | 將 `item` 推入堆積 `heap` 中                                                                               |
| `heappop(heap)`                    | O(log n)         | 彈出並返回堆積 `heap` 中的最小元素，如果堆積是空的，會引發 `IndexError` (複雜度低於 linear search 的 O(n)) |
| `heappushpop(heap, item)`          | O(log n)         | 將 `item` 推入堆積中，然後彈出並返回堆積中的最小元素                                                       |
| `heapreplace(heap, item)`          | O(log n)         | 彈出堆積 `heap` 中的最小元素，然後將 `item` 推入堆積中                                                     |
| `heapify(iterable)`                | O(n)             | 將 `iterable` 轉換為堆積 (in-place algorithm)                                                              |
| `nlargest(n, iterable, key=None)`  | O(n log n)       | 返回 `iterable` 中最大的 `n` 個元素，`key` 是可選的，用於指定排序的鍵                                      |
| `nsmallest(n, iterable, key=None)` | O(n log n)       | 返回 `iterable` 中最小的 `n` 個元素，`key` 是可選的，用於指定排序的鍵                                      |
