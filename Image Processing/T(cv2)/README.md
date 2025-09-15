# opencv-python

[![RogelioKG/opencv-python](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/opencv-python)

## References
+ [**oxxostudio - OpenCV 教學**](https://steam.oxxostudio.tw/category/python/ai/opencv-index.html)


## Class

### `cv2.Mat`
+ **dtype**: `uint8`
+ **shape**: `(層, 列, 行)`
  + 層：圖片高
  + 列：圖片寬
  + 行：色彩採樣
    + RGBA = 4 (每個 pixel 代表一個 `NDA[uint8]`，其中元素為 B / G / R / A)
    + RGB = 3 (每個 pixel 代表一個 `NDA[uint8]`，其中元素為 B / G / R)
    + Grayscale = 1 (每個 pixel 代表一個 `uint8`)
