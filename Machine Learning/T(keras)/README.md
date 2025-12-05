# keras

[![RogelioKG/keras](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/keras)

## References
+ 🔗 [**Documentation - Keras**](https://keras.io/)
+ 🔗 [**菜鳥教程 - Keras**](https://www.runoob.com/tensorflow/keras-neural-network.html)
+ ⚒️ [**Visualizer - Netron**](https://netron.app/)


## Note


|📘 <span class="note">NOTE</span> : 網路下載資源|
|:---|
| datasets：放在 `~/.keras/datasets` |
| models：放在 `~/.keras/models` |

|📘 <span class="note">NOTE</span> : 分層|
|:---|
| 神經網路 - 介面層 (前端)：`keras` |
| 神經網路 - 實作層 (後端)：`tensorflow`、`pytorch`、`jax` |
| 註：`pytorch`、`jax` 並不依賴 `keras`，但當 `keras` 3.0 正式成為一個介面層後，他們也一併支援了 `keras` 作為介面層 |

| 實作層 | 特性 | 場景 |
| :--- | :--- | :--- |
| `tensorflow` | 穩重、部署 | 生產環境部署 (手機端 TFLite, 網頁端 TF.js) |
| `pytorch` | 靈活、研究 | 學術研究、快速實驗、除錯方便 |
| `jax` | 極速、數學 | 高效能運算 (HPC)、超大規模模型訓練、科學計算 |

## Nouns

### Open Neural Network Exchange (ONNX)
+ 參考：[ONNX](https://ithelp.ithome.com.tw/m/articles/10330780)
+ 定義：一種針對機器學習所設計的開放式的文件格式，用於<mark>儲存訓練好的模型</mark>
+ 

## 1. Neural Network

### A. Sequential API

+ 說明
  + 最簡單、最常用
  + 適合「單一輸入、單一輸出、層層堆疊」的簡單模型。
+ 範例
  ```python
  import keras
  from keras import layers

  model = keras.Sequential([
      keras.Input(shape=(28, 28, 1)),
      layers.Conv2D(32, (3, 3), activation="relu"),
      layers.Flatten(),
      layers.Dense(10, activation="softmax")
  ])
  ```

### B. Functional API

+ 說明
  + 更靈活，像拼樂高一樣
  + 適合多輸入 / 多輸出、非線性結構（如 ResNet 的跳接）

+ 範例
  ```python
  inputs = keras.Input(shape=(28, 28, 1))
  x = layers.Conv2D(32, (3, 3), activation="relu")(inputs)
  x = layers.MaxPooling2D()(x)
  outputs = layers.Dense(10, activation="softmax")(x)
  model = keras.Model(inputs=inputs, outputs=outputs)
  ```

## 2. Data Loading & Preprocessing
+ 說明
  + 內建完整的 ETL (Extract, Transform, Load) 流程
  + 不需要依賴第三方工具（如 OpenCV 或 Pandas）就能完成資料準備

### A. Data Loading

+ 範例
  ```python
  # 自動從目錄讀取圖片，並切分為 batch_size=32
  train_ds = keras.utils.image_dataset_from_directory(
      "path/to/images",
      image_size=(256, 256),
      batch_size=32
  )
```

### B. In-Model Preprocessing

+ 說明
  + 允許將「資料預處理」作為模型的一層
  + 這意味著模型匯出後，預處理邏輯會跟著模型走，部署時不易出錯。

+ 範例
  ```python
  # 資料預處理
  data_augmentation = keras.Sequential([
      layers.Rescaling(1./255),
      layers.RandomFlip("horizontal"),
      layers.RandomRotation(0.1),
  ])

  # 主模型
  model = keras.Sequential([
      keras.Input(shape=(256, 256, 3)),
      data_augmentation,  # <--- 資料預處理
      # 模型層
      # layers.Conv2D(32, 3, activation='relu'),
      # ...
  ])
  ```

## 3. Keras Ops
+ 說明
  + 一套「能在任何後端上執行的 NumPy」
  + 痛點：以前寫自定義層時，若用 `tf.math` 就不能跑在 PyTorch 上
  + 解決：使用 `keras.ops`，keras 會自動將其編譯為當前後端 (`tensorflow` / `pytorch` / `jax`) 的原生操作，且支援 GPU 加速

+ 範例
  ```python
  import keras
  from keras import ops

  def custom_activation(x):
      # 這段數學運算可以跑在 TensorFlow, PyTorch 或 JAX 上
      return ops.maximum(x, 0) + ops.sin(x)

  # 矩陣運算範例
  a = ops.convert_to_tensor([[1., 2.], [3., 4.]])
  b = ops.matmul(a, a)
  ```

## 4. Model Zoo
+ 說明
  + 提供一個「預訓練模型庫」
  + 包含數十種在 ImageNet 上訓練好的頂級模型。你不需要從零開始訓練

+ 範例：[ResNet](https://blog.csdn.net/wuqitong123/article/details/132725824)
  ```python
  base_model = keras.applications.MobileNetV3Small(
      weights="imagenet", 
      include_top=False, 
      input_shape=(224, 224, 3)
  )

  # 凍結預訓練部分的參數 (不進行訓練)
  base_model.trainable = False
  ```

+ 應用場景
  + 開箱即用：直接用來分類圖片
  + 遷移學習：載入權重，凍結底層，只訓練最後一層來適應你的新任務


## 5. Callbacks

> Callbacks 是「訓練迴圈的 Hooks」。\
> 它允許你在訓練過程中的特定時間點（例如每個 epoch 結束時）執行動作。

### 常見 Callbacks

| Callback 名稱 | 功能描述 | 用途 |
| :--- | :--- | :--- |
| `ModelCheckpoint` | 自動存檔 | 防止當機白跑，只儲存 loss 最低的模型。 |
| `EarlyStopping` | 早停機制 | 當模型不再進步時自動停止，overfitting。 |
| `ReduceLROnPlateau`| 動態學習率 | 遇到瓶頸時，自動降低學習率試圖突破。 |
| `TensorBoard` | 視覺化監控 | 紀錄 Loss 曲線、計算圖，供 TensorBoard 介面查看。 |

```python
callbacks_list = [
    # 如果驗證集 loss 連續 2 個 epoch 沒有下降，就停止訓練
    keras.callbacks.EarlyStopping(monitor="val_loss", patience=2),
    
    # 儲存最佳模型
    keras.callbacks.ModelCheckpoint(
        filepath="best_model.keras", 
        save_best_only=True, 
        monitor="val_loss"
    )
]

# 在 fit 時掛載
model.fit(x_train, y_train, epochs=100, callbacks=callbacks_list)
```
