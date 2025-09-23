# PyQt

## References

### PyQt6
+ 🔗 [**Documentation - PyQt6**](https://www.riverbankcomputing.com/static/Docs/PyQt6/)
+ 🔗 [**Documentation - PyQt6 Signals and Slots**](https://www.riverbankcomputing.com/static/Docs/PyQt6/signals_slots.html)
+ 🔗 [**PythonGUIs**](https://www.pythonguis.com/)
+ 🔗 [**oxxostudio - PyQt6 教學**](https://steam.oxxostudio.tw/category/python/pyqt6/)
+ 🔗 [**GitHub - PyQt6 Example**](https://github.com/pyqt/examples)

### QSS
+ 🔗 [**Qt - QSS Reference**](https://doc.qt.io/qt-6/stylesheet-reference.html)

### QML
+ 🔗 [**kuanyui - QML 踩雷筆記**](https://kuanyui.github.io/2016/10/31/qml-mine-treader-first-month/)

## Nouns
+ QSS：Qt 版的 CSS
+ QML：Qt 版的 HTML + CSS + JavaScript (<mark>[🚨 不推薦學](https://kuanyui.github.io/2016/10/31/qml-mine-treader-first-month/)</mark>)
+ Qt Designer：用來捏介面的軟體，產生 `.ui` 檔 (定位類似 JavaFX 的 SceneBuilder)

## Executables
### `pyuic`
+ 用途：`.ui` 檔 (Qt Designer 介面檔案) -> `.py` 檔
+ 注意：<mark>🚨 有 cache 問題，路徑不能亂改</mark>
+ 使用
    ```bash
    pyuic6 -o ui_hello.py hello.ui
    ```
### `pyrcc`
+ 用途：`.qrc` 檔 (Qt Creator 資源檔案) -> `.py` 檔
+ 注意：<mark>🚨 PyQt6 已棄用</mark>
### `pylupdate`
+ 用途：多語言介面設計時，編輯語言資源的工具軟體

## Packaging
+ `pyinstaller`
  ```
  pyinstaller --onefile --windowed main.py
  ```

## Project Structure
> GPT 友情提供

```py
my_app/
│── main.py                # 進入點 (啟動應用程式)
│── requirements.txt       # 依賴
│── README.md
│
├── core/                  # M (Model)
│   ├── models.py          # 資料模型 (例如使用者、設定、資料庫 ORM)
│   ├── services.py        # 資料處理/商業邏輯
│   └── database.py        # 資料庫連線管理 (若有)
│
├── ui/                    # V (View)
│   ├── qss/               # QSS 樣式檔
│   │   ├── main.qss
│   │   └── dark.qss
│   │
│   ├── forms/             # Qt Designer 產生的 .ui 檔
│   │   ├── main_window.ui
│   │   └── settings_dialog.ui
│   │
│   ├── generated/         # 使用 `pyuic6` 轉換後的 .py 檔
│   │   ├── ui_main_window.py
│   │   └── ui_settings_dialog.py
│   │
│   └── views/             # View 封裝 (可繼承 generated 類別)
│       ├── main_window.py
│       └── settings_dialog.py
│
├── controllers/           # C (Controller)
│   ├── main_controller.py
│   └── settings_controller.py
│
└── resources/             # 靜態資源
    ├── icons/
    │   ├── app.ico
    │   └── settings.png
    └── translations/      # Qt 語系檔
        └── zh_TW.qm
```

## UI XML
+ ui 檔
    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <ui version="4.0">
    <class>MainWindow</class>
    <widget class="QMainWindow" name="MainWindow">
        <property name="geometry">
        <rect>
            <x>0</x>
            <y>0</y>
            <width>800</width>
            <height>600</height>
        </rect>
        </property>
        <property name="windowTitle">
        <string>MainWindow</string>
        </property>
        <widget class="QWidget" name="centralwidget"/>
        <widget class="QMenuBar" name="menubar">
        <property name="geometry">
            <rect>
            <x>0</x>
            <y>0</y>
            <width>800</width>
            <height>21</height>
            </rect>
        </property>
        </widget>
        <widget class="QStatusBar" name="statusbar"/>
    </widget>
    <resources/>
    <connections/>
    </ui>
    ```

+ 轉成 py 檔
    ```py
    from PyQt6 import QtCore, QtGui, QtWidgets

    class Ui_MainWindow(object):
        def setupUi(self, MainWindow):
            MainWindow.setObjectName("MainWindow")
            MainWindow.resize(800, 600)
            
            self.centralwidget = QtWidgets.QWidget(MainWindow)
            MainWindow.setCentralWidget(self.centralwidget)

            self.menubar = QtWidgets.QMenuBar(MainWindow)
            MainWindow.setMenuBar(self.menubar)

            self.statusbar = QtWidgets.QStatusBar(MainWindow)
            MainWindow.setStatusBar(self.statusbar)

            self.retranslateUi(MainWindow)
            QtCore.QMetaObject.connectSlotsByName(MainWindow)
    ```

## Signal & Slot
+ 說明
    + 在 Qt 中「監聽事件」 (`QObject` 之間溝通) 的核心機制是以<mark>訊號 (signal)</mark> 和<mark>槽 (slot)</mark> 實現的。

+ 特性
    + 一個 signal 可以 connect 到多個 slots
    + 一個 signal 可以 connect 到另一個 signal
    + 多個 signals 可以 connect 到一個 slot
    + signal 可以 disconnect
    + connection 有兩種：direct (同步，即刻執行) 和 queued (異步，事件迴圈)
    + connection 可跨線程

+ 範例：signal 和 slot 的參數型別匹配
    ```py
    from PyQt6.QtCore import QObject, pyqtSignal, pyqtSlot


    class Counter(QObject):
        # 傳出 int | str
        valueChanged = pyqtSignal([int], [str])

        # 傳出 int, str
        statusUpdated = pyqtSignal(int, str)

        def __init__(self, start: int = 0) -> None:
            super().__init__()
            self._value = start

        def increment(self) -> None:
            self._value += 1
            self.valueChanged[int].emit(self._value)
            self.statusUpdated.emit(self._value, "incremented")

        def setText(self, text: str) -> None:
            self.valueChanged[str].emit(text)
            self.statusUpdated.emit(self._value, text)


    class Display(QObject):
        # 收到 int
        @pyqtSlot(int)
        def show_number(self, value: int) -> None:
            print(f"Number updated: {value}")

        # 收到 str
        @pyqtSlot(str)
        def show_text(self, text: str) -> None:
            print(f"Text updated: {text}")

        # 收到 int, str
        @pyqtSlot(int, str)
        def show_status(self, value: int, info: str) -> None:
            print(f"Status: value={value}, info='{info}'")


    if __name__ == "__main__":
        counter = Counter()
        display = Display()

        counter.valueChanged[int].connect(display.show_number)
        counter.valueChanged[str].connect(display.show_text)

        counter.statusUpdated.connect(display.show_status)

        counter.increment()
        # Number updated: 1
        # Status: value=1, info='incremented'

        counter.setText("Hello")
        # Text updated: Hello
        # Status: value=1, info='Hello'
    ```

## Modules
> GPT 友情提供

| 模組                | 主要用途 |
|-------------------------|--------------------------------------------------|
| **QtCore**              | 核心：事件迴圈、計時器、日期時間、檔案存取、線程、訊號與槽機制 |
| **QtGui**               | 繪圖功能：字型、顏色、影像、滑鼠鍵盤事件、`QPainter` 繪圖 |
| **QtWidgets**           | 核心 UI 元件：`QWidget`, `QMainWindow`, `QDialog`, `QPushButton`, `QLabel`, `QLineEdit`, `QTableView` 等 |
| **QtPrintSupport**      | 列印：`QPrinter`, `QPrintDialog` |
| **QtCharts**            | 圖表：折線圖、長條圖、圓餅圖等 |
| **QtMultimedia**        | 媒體：播放音訊/影片、麥克風、攝影機 |
| **QtHelp**              | 幫助：建立/顯示離線說明文件 (`.qch`)、整合應用程式內建說明檔 |
| **QtSvg**               | 處理與顯示 SVG 格式 |
| **QtSql**               | 資料庫：支援 SQLite、MySQL、PostgreSQL 等 |
| **QtNetwork**           | 網路：TCP/UDP、HTTP 請求、Socket |
| **QtNfc**               | NFC：讀取/寫入 NFC 標籤、NDEF 訊息處理 |
| **QtMultimediaWidgets** | 媒體 UI 元件：例如 `QVideoWidget` 用於播放影音畫面 |
| **QtQml** / **QtQuick** | 使用 QML 建構動畫化、流暢的 UI |
| **QtWebEngineWidgets**  | 內嵌瀏覽器，顯示網頁內容 |
| **QtOpenGL**            | OpenGL 繪圖整合 |
| **QtWebSockets**        | WebSocket |
| **QtBluetooth**         | Bluetooth |
| **QtSerialPort**        | Serial Port |



## Inheritance Tree
> GPT 友情提供
+ Widget
    ```mermaid
    %%{init:{"flowchart":{"curve":"linear"}}}%%
    flowchart TD

        QObject
        QPaintDevice

        QObject --> QWidget
        QPaintDevice --> QWidget

        QWidget --> QMainWindow
        QWidget --> QDialog
        QWidget --> QFrame
    ```
+ Dialog
    ```mermaid
    %%{init:{"flowchart":{"curve":"linear"}}}%%
    flowchart TD
        QDialog --> QFileDialog
        QDialog --> QColorDialog
        QDialog --> QFontDialog
        QDialog --> QMessageBox
        QDialog --> QInputDialog
        QDialog --> QProgressDialog
        QDialog --> QWizard
    ```
+ Frame
    ```mermaid
    %%{init:{"flowchart":{"curve":"linear"}}}%%
    flowchart TD
        QFrame --> QLabel
        QFrame --> QPushButton
        QFrame --> QLineEdit
        QFrame --> QCheckBox
        QFrame --> QRadioButton
        QFrame --> QComboBox
        QFrame --> QListWidget
        QFrame --> QTableWidget
        QFrame --> QTreeWidget
        QFrame --> QSlider
        QFrame --> QProgressBar
    ```
+ Model / View
    ```mermaid
    %%{init:{"flowchart":{"curve":"linear"}}}%%
    flowchart TD

        QObject --> QAbstractItemModel
        QAbstractItemModel --> QStandardItemModel
        QAbstractItemModel --> QStringListModel

        QWidget --> QAbstractItemView
        QAbstractItemView --> QListView
        QAbstractItemView --> QTableView
        QAbstractItemView --> QTreeView
    ```
+ Layout
    ```mermaid
    %%{init:{"flowchart":{"curve":"linear"}}}%%
    flowchart TD

        QObject --> QLayout
        QLayout --> QBoxLayout
        QLayout --> QGridLayout
        QLayout --> QFormLayout
        QLayout --> QStackedLayout

        QBoxLayout --> QHBoxLayout
        QBoxLayout --> QVBoxLayout
    ```
+ Event
    ```mermaid
    %%{init:{"flowchart":{"curve":"stepBefore"}}}%%
    flowchart TD
        QEvent --> QKeyEvent
        QEvent --> QMouseEvent
        QEvent --> QPaintEvent
        QEvent --> QTimerEvent
    ```
+ Paint
    ```mermaid
    %%{init:{"flowchart":{"curve":"stepBefore"}}}%%
    flowchart TD
        QPaintDevice --> QPixmap
        QPaintDevice --> QImage
        QPainter
    ```
+ Others
    ```mermaid
    %%{init:{"flowchart":{"curve":"linear"}}}%%
    flowchart TD

        QObject --> QCoreApplication
        QCoreApplication --> QGuiApplication
        QGuiApplication --> QApplication

        QObject --> QTimer
        QObject --> QAction
        QObject --> QFileSystemWatcher
        QObject --> QThread
    ```

## Example

+ 基本控件

  ![pyqt-widgets](https://github.com/pyqt/examples/blob/_/src/screenshots/pyqt-widgets.png?raw=true)
  
  ```py
  from PyQt6.QtCore import QDateTime, Qt, QTimer
  from PyQt6.QtWidgets import (
      QApplication,
      QCheckBox,
      QComboBox,
      QDateTimeEdit,
      QDial,
      QDialog,
      QGridLayout,
      QGroupBox,
      QHBoxLayout,
      QLabel,
      QLineEdit,
      QProgressBar,
      QPushButton,
      QRadioButton,
      QScrollBar,
      QSizePolicy,
      QSlider,
      QSpinBox,
      QStyleFactory,
      QTableWidget,
      QTabWidget,
      QTextEdit,
      QVBoxLayout,
      QWidget,
  )


  class WidgetGallery(QDialog):
      def __init__(self, parent=None):
          super().__init__(parent)

          self.originalPalette = QApplication.palette()

          styleComboBox = QComboBox()
          styleComboBox.addItems(QStyleFactory.keys())

          styleLabel = QLabel("&Style:")
          styleLabel.setBuddy(styleComboBox)

          self.useStylePaletteCheckBox = QCheckBox("&Use style's standard palette")
          self.useStylePaletteCheckBox.setChecked(True)

          disableWidgetsCheckBox = QCheckBox("&Disable widgets")

          self.createTopLeftGroupBox()
          self.createTopRightGroupBox()
          self.createBottomLeftTabWidget()
          self.createBottomRightGroupBox()
          self.createProgressBar()

          styleComboBox.textActivated.connect(self.changeStyle)
          self.useStylePaletteCheckBox.toggled.connect(self.changePalette)
          disableWidgetsCheckBox.toggled.connect(self.topLeftGroupBox.setDisabled)
          disableWidgetsCheckBox.toggled.connect(self.topRightGroupBox.setDisabled)
          disableWidgetsCheckBox.toggled.connect(self.bottomLeftTabWidget.setDisabled)
          disableWidgetsCheckBox.toggled.connect(self.bottomRightGroupBox.setDisabled)

          topLayout = QHBoxLayout()
          topLayout.addWidget(styleLabel)
          topLayout.addWidget(styleComboBox)
          topLayout.addStretch(1)
          topLayout.addWidget(self.useStylePaletteCheckBox)
          topLayout.addWidget(disableWidgetsCheckBox)

          mainLayout = QGridLayout()
          mainLayout.addLayout(topLayout, 0, 0, 1, 2)
          mainLayout.addWidget(self.topLeftGroupBox, 1, 0)
          mainLayout.addWidget(self.topRightGroupBox, 1, 1)
          mainLayout.addWidget(self.bottomLeftTabWidget, 2, 0)
          mainLayout.addWidget(self.bottomRightGroupBox, 2, 1)
          mainLayout.addWidget(self.progressBar, 3, 0, 1, 2)
          mainLayout.setRowStretch(1, 1)
          mainLayout.setRowStretch(2, 1)
          mainLayout.setColumnStretch(0, 1)
          mainLayout.setColumnStretch(1, 1)
          self.setLayout(mainLayout)

          self.setWindowTitle("Styles")
          self.changeStyle("Windows")

      def changeStyle(self, styleName):
          QApplication.setStyle(QStyleFactory.create(styleName))
          self.changePalette()

      def changePalette(self):
          if self.useStylePaletteCheckBox.isChecked():
              style = QApplication.style()
              assert style is not None
              QApplication.setPalette(style.standardPalette())
          else:
              QApplication.setPalette(self.originalPalette)

      def advanceProgressBar(self):
          curVal = self.progressBar.value()
          maxVal = self.progressBar.maximum()
          self.progressBar.setValue(curVal + (maxVal - curVal) // 100)

      def createTopLeftGroupBox(self):
          self.topLeftGroupBox = QGroupBox("Group 1")

          radioButton1 = QRadioButton("Radio button 1")
          radioButton2 = QRadioButton("Radio button 2")
          radioButton3 = QRadioButton("Radio button 3")
          radioButton1.setChecked(True)

          checkBox = QCheckBox("Tri-state check box")
          checkBox.setTristate(True)
          checkBox.setCheckState(Qt.CheckState.PartiallyChecked)

          layout = QVBoxLayout()
          layout.addWidget(radioButton1)
          layout.addWidget(radioButton2)
          layout.addWidget(radioButton3)
          layout.addWidget(checkBox)
          layout.addStretch(1)
          self.topLeftGroupBox.setLayout(layout)

      def createTopRightGroupBox(self):
          self.topRightGroupBox = QGroupBox("Group 2")

          defaultPushButton = QPushButton("Default Push Button")
          defaultPushButton.setDefault(True)

          togglePushButton = QPushButton("Toggle Push Button")
          togglePushButton.setCheckable(True)
          togglePushButton.setChecked(True)

          flatPushButton = QPushButton("Flat Push Button")
          flatPushButton.setFlat(True)

          layout = QVBoxLayout()
          layout.addWidget(defaultPushButton)
          layout.addWidget(togglePushButton)
          layout.addWidget(flatPushButton)
          layout.addStretch(1)
          self.topRightGroupBox.setLayout(layout)

      def createBottomLeftTabWidget(self):
          self.bottomLeftTabWidget = QTabWidget()
          self.bottomLeftTabWidget.setSizePolicy(
              QSizePolicy.Policy.Preferred, QSizePolicy.Policy.Ignored
          )

          tab1 = QWidget()
          tableWidget = QTableWidget(10, 10)

          tab1hbox = QHBoxLayout()
          tab1hbox.setContentsMargins(5, 5, 5, 5)
          tab1hbox.addWidget(tableWidget)
          tab1.setLayout(tab1hbox)

          tab2 = QWidget()
          textEdit = QTextEdit()

          textEdit.setPlainText(
              "Twinkle, twinkle, little star,\n"
              "How I wonder what you are.\n"
              "Up above the world so high,\n"
              "Like a diamond in the sky.\n"
              "Twinkle, twinkle, little star,\n"
              "How I wonder what you are!\n"
          )

          tab2hbox = QHBoxLayout()
          tab2hbox.setContentsMargins(5, 5, 5, 5)
          tab2hbox.addWidget(textEdit)
          tab2.setLayout(tab2hbox)

          self.bottomLeftTabWidget.addTab(tab1, "&Table")
          self.bottomLeftTabWidget.addTab(tab2, "Text &Edit")

      def createBottomRightGroupBox(self):
          self.bottomRightGroupBox = QGroupBox("Group 3")
          self.bottomRightGroupBox.setCheckable(True)
          self.bottomRightGroupBox.setChecked(True)

          lineEdit = QLineEdit("s3cRe7")
          lineEdit.setEchoMode(QLineEdit.EchoMode.Password)

          spinBox = QSpinBox(self.bottomRightGroupBox)
          spinBox.setValue(50)

          dateTimeEdit = QDateTimeEdit(self.bottomRightGroupBox)
          dateTimeEdit.setDateTime(QDateTime.currentDateTime())

          slider = QSlider(Qt.Orientation.Horizontal, self.bottomRightGroupBox)
          slider.setValue(40)

          scrollBar = QScrollBar(Qt.Orientation.Horizontal, self.bottomRightGroupBox)
          scrollBar.setValue(60)

          dial = QDial(self.bottomRightGroupBox)
          dial.setValue(30)
          dial.setNotchesVisible(True)

          layout = QGridLayout()
          layout.addWidget(lineEdit, 0, 0, 1, 2)
          layout.addWidget(spinBox, 1, 0, 1, 2)
          layout.addWidget(dateTimeEdit, 2, 0, 1, 2)
          layout.addWidget(slider, 3, 0)
          layout.addWidget(scrollBar, 4, 0)
          layout.addWidget(dial, 3, 1, 2, 1)
          layout.setRowStretch(5, 1)
          self.bottomRightGroupBox.setLayout(layout)

      def createProgressBar(self):
          self.progressBar = QProgressBar()
          self.progressBar.setRange(0, 10000)
          self.progressBar.setValue(0)

          timer = QTimer(self)
          timer.timeout.connect(self.advanceProgressBar)
          timer.start(1000)


  if __name__ == "__main__":
      import sys

      app = QApplication(sys.argv)
      gallery = WidgetGallery()
      gallery.show()
      sys.exit(app.exec())

  ```