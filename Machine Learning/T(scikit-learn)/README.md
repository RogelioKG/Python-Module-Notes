# scikit-learn

[![RogelioKG/scikit-learn](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/scikit-learn)

## References
+ 🔗 [**Documentation - scikit-learn**](https://scikit-learn.org/)

## Cheatsheet

![ML map](https://scikit-learn.org/1.4/_static/ml_map.png)

## Note
|🚨 <span class="caution">CAUTION</span>|
|:---|
| scikit-learn 中使用的 <mark>neural network</mark> 以 <mark>CPU</mark> 作為計算平台 |

## Persistence
> 使用 `joblib`
```py
import joblib

# ...

# 訓練模型
model.fit(X_train, y_train)

# 模型持久化
joblib.dump(model, 'iris.joblib')

# 載入模型
model = joblib.load('iris.joblib')
```

## Classification
```py
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score

# 1. 準備資料
data = load_iris()
X, y = data.data, data.target
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)

# 2. 建立模型
model = RandomForestClassifier(n_estimators=100, random_state=42)

# 3. 訓練模型
model.fit(X_train, y_train)

# 4. 預測與評估
predictions = model.predict(X_test)
print(f"Accuracy: {accuracy_score(y_test, predictions):.2f}")
```
```py
from sklearn.neural_network import MLPClassifier
from sklearn.datasets import make_classification
from sklearn.model_selection import train_test_split

# 1. 產生資料
X, y = make_classification(n_samples=100, random_state=1)
X_train, X_test, y_train, y_test = train_test_split(X, y, stratify=y, random_state=1)

# 2. 建立模型
clf = MLPClassifier(hidden_layer_sizes=(100, 50), max_iter=300, random_state=1)

# 3. 訓練模型
clf.fit(X_train, y_train)

# 4. 進行預測
print(f"Accuracy: {clf.score(X_test, y_test):.2f}")
```


## Regression
```py
from sklearn.datasets import make_regression
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error

# 1. 準備資料
X, y = make_regression(n_samples=200, n_features=1, noise=20, random_state=42)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)

# 2. 建立模型
model = LinearRegression()

# 3. 訓練模型
model.fit(X_train, y_train)

# 4. 預測與評估
predictions = model.predict(X_test)
mse = mean_squared_error(y_test, predictions)
print(f"MSE: {mse:.2f}")
print(f"Coefficient: {model.coef_[0]:.2f}")
```


## Clustering

```py
from sklearn.datasets import make_blobs
from sklearn.cluster import KMeans

# 1. 準備資料
X, true_labels = make_blobs(n_samples=300, centers=3, cluster_std=0.60, random_state=0)

# 2. 建立模型
model = KMeans(n_clusters=3, n_init='auto', random_state=0)

# 3. 訓練模型 (不需要 true_labels)
model.fit(X)

# 4. 取得結果
predict_labels = model.predict(X)
print(f"Labels: {predict_labels}")
print(f"Cluster Centers: {model.cluster_centers_}")
```

## Dim Reduction

```py
from sklearn.datasets import load_iris
from sklearn.decomposition import PCA

# 1. 準備資料
data = load_iris()
X = data.data
print(f"Shape: {X.shape}") # (150, 4)

# 2. 建立模型 (目標降到 2 維)
pca = PCA(n_components=2)

# 3. 訓練並轉換 (Fit & Transform)
X_reduced = pca.fit_transform(X)

# 4. 查看結果
print(f"Reduced Shape: {X_reduced.shape}") # (150, 2)
print(f"Explained Variance Ratio: {pca.explained_variance_ratio_}")
```

## Metrics
```py
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix

# 1. 準確率
print(accuracy_score(y_true, y_pred))

# 2. 分類報告
# Precision: 正確預測是貓 / 預測是貓
# Recall: 正確預測是貓 / 實際多少貓
print(classification_report(y_true, y_pred))

# 3. 混淆矩陣
print(confusion_matrix(y_true, y_pred))
```

```py
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score

y_true = [3.0, -0.5, 2.0, 7.0]
y_pred = [2.5,  0.0, 2.1, 7.8]

# 1. MSE
print(f"MSE: {mean_squared_error(y_true, y_pred):.2f}") 

# 2. MAE
print(f"MAE: {mean_absolute_error(y_true, y_pred):.2f}")

# 3. R2 Score
print(f"R2 Score: {r2_score(y_true, y_pred):.2f}")
```
