# pytorch

[![RogelioKG/pytorch](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/pytorch)

## References
+ 🔗 [**Document - Pytorch**](https://pytorch.org/)

## Note

|📗 <span class="tip">TIP</span>|
|:---|
| 檢查 CUDA 版本：`nvcc --version` |

|📘 <span class="NOTE">NOTE</span>|
|:---|
| 本筆記目前暫時以 LLM 自動產出，未經過消化整理 |

## 1. 安裝

+ 範例
  |🚨 <span class="caution">CAUTION</span>|
  |:---|
  | 請安裝與本機 CUDA 相符的版本 |
  ```toml
  # pyproject.toml
  [tool.uv.sources]
  torch = [{ index = "pytorch-cu121" }]
  torchvision = [{ index = "pytorch-cu121" }]
  torchaudio = [{ index = "pytorch-cu121" }]

  [[tool.uv.index]]
  name = "pytorch-cu121"
  url = "https://download.pytorch.org/whl/cu121"
  explicit = true
  ```
  ```ps
  uv add torch torchvision torchaudio
  ```

## 2. 張量 `Tensor`
+ 說明
  + PyTorch 的核心資料結構是 `Tensor`
  + 它類似於 NumPy 的 `ndarray`，但有兩個關鍵區別
    1.  可以在 GPU 上運行以加速計算
    2.  可以儲存梯度資訊（用於自動微分）

+ 範例 2.1 - 建立張量
  ```python
  import torch

  # 1. 直接從數據建立
  data = [[1, 2], [3, 4]]
  x_data = torch.tensor(data)

  # 2. 隨機生成與全 0/1 張量
  shape = (2, 3)
  rand_tensor = torch.rand(shape)  # 均勻分佈
  ones_tensor = torch.ones(shape)  # 全 1
  zeros_tensor = torch.zeros(shape) # 全 0

  print(f"Random Tensor: \n{rand_tensor}")
  ```

+ 範例 2.2 - 張量屬性與操作
  > 了解張量的形狀 (Shape) 和裝置 (Device) 是除錯的關鍵
  ```python
  tensor = torch.rand(3, 4)

  print(f"Shape: {tensor.shape}")
  print(f"Datatype: {tensor.dtype}")
  print(f"Device: {tensor.device}") # 預設是 'cpu'

  # 張量運算 (類似 NumPy)
  t1 = torch.rand(2, 2)
  t2 = torch.rand(2, 2)

  # 矩陣乘法 (Matrix Multiplication)
  # 等同於 t1 @ t2
  matmul_res = torch.matmul(t1, t2) 

  # 元素對應相乘 (Element-wise Product)
  # 等同於 t1 * t2
  elem_res = torch.mul(t1, t2)
  ```

+ 範例 2.3 - GPU 加速 (CUDA/MPS)
  > 將張量移動到 GPU 是加速深度學習的關鍵步驟。
  ```python
  # 檢查是否有可用的 GPU (Nvidia CUDA 或 Mac MPS)
  device = (
      "cuda"
      if torch.cuda.is_available()
      else "mps"
      if torch.backends.mps.is_available()
      else "cpu"
  )
  print(f"Using {device} device")

  # 移動張量
  tensor = tensor.to(device)
  ```

## 3. 自動微分引擎 `autograd`

+ 說明
  + 神經網路的訓練依賴於 backpropagation
  + PyTorch 的 `autograd` 模組會自動記錄對張量的所有操作，以便計算梯度
    + 設定 `requires_grad=True` 來追蹤計算歷史。
    + 呼叫 `.backward()` 來自動計算梯度。
    + 梯度會累積在 `.grad` 屬性中。
+ 範例 3.1
  ```python
  x = torch.ones(5)  # input
  y = torch.zeros(3)  # expected output
  w = torch.randn(5, 3, requires_grad=True) # weights (需要更新)
  b = torch.randn(3, requires_grad=True)    # bias (需要更新)

  # Forward pass (前向傳播)
  z = torch.matmul(x, w) + b

  # 計算 Loss (例如 Binary Cross Entropy)
  loss = torch.nn.functional.binary_cross_entropy_with_logits(z, y)

  print(f"Gradient function for z: {z.grad_fn}")

  # Backward pass (反向傳播)
  loss.backward()

  # 查看梯度 (這些梯度將用於更新 w 和 b)
  print(w.grad)
  print(b.grad)
  ```

## 4. 神經網路 `Module`
+ 說明
  + `torch.nn` 提供了構建神經網路所需的層 (Layers) 和容器
  + 所有的模型都應該繼承 `nn.Module`
+ 範例
+ 範例 4.1 - 定義一個簡單的模型
  > 我們來建立一個標準的多層感知機 (MLP)
  ```python
  from torch import nn

  class NeuralNetwork(nn.Module):
      def __init__(self):
          super().__init__()
          # 定義層
          self.flatten = nn.Flatten()
          self.linear_relu_stack = nn.Sequential(
              nn.Linear(28*28, 512), # 輸入層 -> 隱藏層
              nn.ReLU(),             # 激活函數
              nn.Linear(512, 512),   # 隱藏層 -> 隱藏層
              nn.ReLU(),
              nn.Linear(512, 10)     # 隱藏層 -> 輸出層 (10類)
          )

      def forward(self, x):
          # 定義數據流向
          x = self.flatten(x)
          logits = self.linear_relu_stack(x)
          return logits

  # 實例化模型並移至 GPU
  model = NeuralNetwork().to(device)
  print(model)
  ```

## 5. 數據處理 `Dataset` & `DataLoader`
+ 說明
  + `torch.utils.data.Dataset`：儲存樣本及其對應標籤
  + `torch.utils.data.DataLoader`：將 Dataset 包裝成一個可迭代對象 (Iterable)，提供 batching (批次處理)、shuffling (打亂) 等功能

+ 範例 5.1 - 自定義 Dataset

  ```python
  from torch.utils.data import Dataset, DataLoader

  class CustomNumberDataset(Dataset):
      def __init__(self, length=1000):
          # 初始化數據 (這裡我們隨機生成一些假數據)
          # 假設輸入是 28x28 的隨機圖像，標籤是 0-9 的整數
          self.data = torch.randn(length, 28, 28)
          self.labels = torch.randint(0, 10, (length,))

      def __len__(self):
          # 回傳數據集總長度
          return len(self.data)

      def __getitem__(self, idx):
          # 根據索引回傳一筆數據 (image, label)
          return self.data[idx], self.labels[idx]

  # 建立 Dataset
  training_data = CustomNumberDataset(length=1000)
  test_data = CustomNumberDataset(length=200)

  # 建立 DataLoader
  batch_size = 64
  train_dataloader = DataLoader(training_data, batch_size=batch_size, shuffle=True)
  test_dataloader = DataLoader(test_data, batch_size=batch_size, shuffle=False)

  # 測試讀取一個 Batch
  for X, y in train_dataloader:
      print(f"Shape of X [N, C, H, W]: {X.shape}")
      print(f"Shape of y: {y.shape} {y.dtype}")
      break
  ```

## 6. 訓練循環

+ 說明
  + 這是將所有積木組合在一起的時刻。訓練模型包含三個步驟：
    1.  **定義損失函數 (Loss Function)**: 衡量模型預測與真實值的差距。
    2.  **定義優化器 (Optimizer)**: 根據梯度更新模型參數。
    3.  **迭代訓練**: 前向傳播 -\> 計算 Loss -\> 反向傳播 -\> 更新參數。

+ 範例 6.1 - 設定超參數與組件
  ```python
  learning_rate = 1e-3
  epochs = 5

  # 損失函數 (分類問題常用 Cross Entropy)
  loss_fn = nn.CrossEntropyLoss()

  # 優化器 (SGD 或 Adam)
  optimizer = torch.optim.Adam(model.parameters(), lr=learning_rate)
  ```

+ 範例 6.2 - 訓練與測試函數

  > 為了保持程式碼整潔，我們將訓練和測試邏輯封裝成函數。

  ```python
  def train_loop(dataloader, model, loss_fn, optimizer):
      size = len(dataloader.dataset)
      model.train() # 設定為訓練模式 (啟用 Dropout, BatchNorm 等)

      for batch, (X, y) in enumerate(dataloader):
          # 1. 將數據移至 GPU/MPS
          X, y = X.to(device), y.to(device)

          # 2. 前向傳播 (預測)
          pred = model(X)
          loss = loss_fn(pred, y)

          # 3. 反向傳播 (Backpropagation)
          optimizer.zero_grad() # 清空舊的梯度
          loss.backward()       # 計算新梯度
          optimizer.step()      # 更新參數

          if batch % 5 == 0:
              loss, current = loss.item(), batch * len(X)
              print(f"loss: {loss:>7f}  [{current:>5d}/{size:>5d}]")

  def test_loop(dataloader, model, loss_fn):
      model.eval() # 設定為評估模式
      size = len(dataloader.dataset)
      num_batches = len(dataloader)
      test_loss, correct = 0, 0

      # 評估時不需要計算梯度，節省記憶體
      with torch.no_grad():
          for X, y in dataloader:
              X, y = X.to(device), y.to(device)
              pred = model(X)
              test_loss += loss_fn(pred, y).item()
              correct += (pred.argmax(1) == y).type(torch.float).sum().item()

      test_loss /= num_batches
      correct /= size
      print(f"Test Error: \n Accuracy: {(100*correct):>0.1f}%, Avg loss: {test_loss:>8f} \n")
  ```

+ 範例 6.3 - 開始訓練

  ```python
  print(f"Training on {device}...")
  for t in range(epochs):
      print(f"Epoch {t+1}\n-------------------------------")
      train_loop(train_dataloader, model, loss_fn, optimizer)
      test_loop(test_dataloader, model, loss_fn)
  print("Done!")
  ```


## 7. 儲存、載入模型

+ 說明
  訓練完成後，我們通常會儲存模型的權重（`state_dict`），而不是儲存整個模型結構（這樣相容性較差）。

+ 範例 7.1 - 儲存
  ```python
  torch.save(model.state_dict(), "model_weights.pth")
  print("Saved PyTorch Model State to model_weights.pth")
  ```

+ 範例 7.2 - 載入
  ```python
  # 1. 必須先重新建立模型架構 (因為我們只存了權重)
  model2 = NeuralNetwork().to(device)

  # 2. 載入權重
  model2.load_state_dict(torch.load("model_weights.pth", weights_only=True))

  # 3. 設定為評估模式
  model2.eval()
  print("Model loaded successfully!")
  ```


## 8. 進階技巧、最佳實踐

1. **TensorBoard 視覺化**:
    PyTorch 支援 TensorBoard 來監控 Loss 曲線。

    ```python
    from torch.utils.tensorboard import SummaryWriter
    writer = SummaryWriter('runs/experiment_1')
    # 在 train_loop 中: writer.add_scalar('Loss/train', loss, epoch)
    ```

2. **除錯維度問題**:
    深度學習最常見的錯誤是維度不匹配 (Shape mismatch)。

      * 善用 `print(x.shape)`。
      * 使用 `x.view()` 或 `x.reshape()` 改變形狀。
      * 使用 `x.unsqueeze(0)` 增加 batch 維度（例如將 `[3, 32, 32]` 變為 `[1, 3, 32, 32]`）。

3. **`model.train()` vs `model.eval()`**:
    永遠記得在訓練時呼叫 `.train()`，在測試/推論時呼叫 `.eval()`。這會影響 Dropout 和 Batch Normalization 的行為。

4. **使用 `torchvision.transforms`**:
    對於影像處理，使用 Transforms 進行數據增強 (Data Augmentation) 是標準做法。

    ```python
    from torchvision import transforms
    transform = transforms.Compose([
        transforms.Resize(256),
        transforms.CenterCrop(224),
        transforms.ToTensor(),
    ])
    ```