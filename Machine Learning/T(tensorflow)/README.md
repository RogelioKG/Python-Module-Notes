# tensorflow

[![RogelioKG/tensorflow](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/tensorflow)

## References
+ [**Tensorboard**](https://www.tensorflow.org/tensorboard/get_started)

## Tensorboard
```py
import datetime
import os
import numpy as np
import tensorflow as tf
import keras
from dataclasses import dataclass


# ==========================================
# 1. Configuration
# ==========================================
@dataclass
class Config:
    app_name: str = "mnist_experiment"
    batch_size: int = 64
    epochs: int = 10
    learning_rate: float = 0.001
    log_base_dir: str = "logs/fit"

    @property
    def log_dir(self) -> str:
        timestamp = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
        return os.path.join(self.log_base_dir, f"{self.app_name}_{timestamp}")


# ==========================================
# 2. Data Pipeline
# ==========================================
def load_and_preprocess_data():
    print("Loading data...")
    (x_train, y_train), (x_test, y_test) = keras.datasets.mnist.load_data()
    x_train, x_test = x_train / 255.0, x_test / 255.0
    return (x_train, y_train), (x_test, y_test)


# ==========================================
# 3. Model Definition
# ==========================================
def build_model(input_shape=(28, 28), num_classes=10) -> keras.Model:
    model = keras.models.Sequential(
        [
            keras.layers.Flatten(input_shape=input_shape, name="input_flatten"),
            keras.layers.Dense(512, activation="relu", name="hidden_dense_1"),
            keras.layers.Dropout(0.2, name="dropout"),
            keras.layers.Dense(
                num_classes, activation="softmax", name="output_softmax"
            ),
        ]
    )
    return model


# ==========================================
# 4. Callbacks for Dataset Visualization
# ==========================================
class DatasetVisualizer(keras.callbacks.Callback):
    def __init__(self, log_dir, x_data, y_data, num_images=5):
        super().__init__()
        self.file_writer = tf.summary.create_file_writer(
            os.path.join(log_dir, "images")
        )
        self.x_data = x_data
        self.y_data = y_data
        self.num_images = num_images

    def on_epoch_end(self, epoch, logs=None):
        # 為了不佔用太多空間，我們只在每個 Epoch 結束時抽樣顯示
        # 隨機挑選索引
        indices = np.random.choice(len(self.x_data), self.num_images, replace=False)
        images = self.x_data[indices]

        # 圖片形狀調整：(Batch, Height, Width) -> (Batch, Height, Width, Channels)
        # TensorBoard 需要 4D Tensor，且 MNIST 是灰階，所以補上 Channel=1
        images = np.reshape(images, (-1, 28, 28, 1))

        with self.file_writer.as_default():
            # 這裡就是關鍵：將圖片寫入 TensorBoard
            # max_outputs 設定一次顯示幾張
            tf.summary.image(
                "Validation Data Sample",
                images,
                step=epoch,
                max_outputs=self.num_images,
            )


# ==========================================
# 5. Callbacks
# ==========================================
def get_callbacks(config: Config, x_val, y_val) -> list:
    # 1. 基礎 TensorBoard 設定
    tensorboard_callback = keras.callbacks.TensorBoard(
        log_dir=config.log_dir,
        histogram_freq=1,
        write_graph=True,
        write_images=True,
    )

    # 2. 新增自訂 Callback
    visualizer_callback = DatasetVisualizer(
        log_dir=config.log_dir,
        x_data=x_val,
        y_data=y_val,
        num_images=5,  # 每個 epoch 隨機看 5 張圖
    )

    return [tensorboard_callback, visualizer_callback]


# ==========================================
# 5. Main Execution
# ==========================================
def main():
    config = Config()

    print(f"Starting training with config: {config}")

    (x_train, y_train), (x_test, y_test) = load_and_preprocess_data()

    model = build_model()
    optimizer = keras.optimizers.Adam(learning_rate=config.learning_rate)

    model.compile(
        optimizer=optimizer,
        loss="sparse_categorical_crossentropy",
        metrics=["accuracy"],
    )

    callbacks = get_callbacks(config, x_test, y_test)

    print(f"TensorBoard Log Directory: {config.log_dir}")

    model.fit(
        x_train,
        y_train,
        epochs=config.epochs,
        batch_size=config.batch_size,
        validation_data=(x_test, y_test),
        callbacks=callbacks,
    )

    print("Training finished.")


if __name__ == "__main__":
    main()
```