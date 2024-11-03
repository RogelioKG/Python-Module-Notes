# setuptools

[![RogelioKG/setuptools](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/setuptools)

### References
+ 🔗 [**Documentation : setuptools**](https://setuptools.pypa.io/en/latest/userguide/)
+ 🔗 [**HackMD : 由淺入深 Python Packaging**](https://hackmd.io/@celineyeh/SyJSK8AXB#Package-distribution)
+ 🔗 [**HackMD : 如何將寫好的 package 上傳到 pypi 供人安裝使用**](https://hackmd.io/@seanbbear/HJaAYctkw)
+ 🔗 [**Medium: 開發 Python 套件並且上傳至 Pypi by setuptool and twine**](https://medium.com/edward-hong-%E6%8A%80%E8%A1%93%E7%AD%86%E8%A8%98/%E9%96%8B%E7%99%BCpython-%E5%A5%97%E4%BB%B6%E4%B8%A6%E4%B8%94%E4%B8%8A%E5%82%B3%E8%87%B3pypi-by-setuptool-and-twine-4f178e752640)
+ 🔗 [**Cnblogs : Python 包构建教程**](https://www.cnblogs.com/cposture/p/9029023.html)
+ 🔗 [**CSDN : pip 安裝常見坑**](https://blog.csdn.net/qq_41068877/article/details/127457367)
+ 🔗 [**Structuring Your Project**](https://docs.python-guide.org/writing/structure/)
+ 🔗 [**Choose an open source license**](https://choosealicense.com/)
+ 🔗 [**Dependency Resolution Made Simple**](https://borretti.me/article/dependency-resolution-made-simple)
+ 🔗 [**pip : Dependency Resolution**](https://pip.pypa.io/en/latest/topics/dependency-resolution/)
+ 🔗 [**【Python的解憂錦囊】setuptools.errors.PackageDiscoveryError**](https://vocus.cc/article/64f1c81bfd897800012a054b)
+ 🔗 [**【Python的解憂錦囊】python -m build 打包時也能包含被引用的目錄**](https://vocus.cc/article/662998defd89780001968711)
+ 🎞️ [**ArjanCodes: How to Build a Complete Python Package Step-by-Step**](https://youtu.be/5KEObONUkik)
<!-- link -->
[binary-distribution-format]: https://packaging.python.org/en/latest/specifications/binary-distribution-format/
[toml-config]: https://packaging.pythonlang.cn/en/latest/guides/writing-pyproject-toml/
[caching-and-troubleshooting]: https://setuptools.pypa.io/en/latest/userguide/miscellaneous.html#caching-and-troubleshooting
[dependency-resolution]: https://pip.pypa.io/en/stable/topics/dependency-resolution/

### Preface

| 🚨 <span class="caution">CAUTION</span> |
| :--- |
| 你也遇到奇怪的安裝錯誤了嗎？看看 [Common Error](#Common-Error) 能不能解決你遇到的問題！ |


### Nouns

+ **egg**

  > Python 的一種 <mark>二進制發佈格式 ([binary distribution format][binary-distribution-format])</mark>，現已被 wheel 取代。

+ **wheel**

  > Python 的一種 <mark>二進制發佈格式 ([binary distribution format][binary-distribution-format])</mark>，旨在加速套件的安裝過程。\
  > 相較於源代碼發佈格式 (如 `.tar.gz`)，wheel <ins>不需在安裝時進行編譯</ins>，因而可以節省安裝時間。\
  > wheel 檔案的副檔名為 `.whl` (本質上是 `zip` 格式的壓縮檔)，是目前 Python 生態系中推薦的發佈格式。

+ **PyPI**

  > Python 的<mark>第三方套件集中地</mark>。全稱 Python Package Index。

+ **TestPyPI**

  > <mark>PyPI 的測試區</mark>，與 PyPI 是分開的，不用擔心會相互影響。

+ **build frontend**

  > 負責<mark>調用構建過程的工具</mark>，通過與 build backend 交互來實際執行構建任務。\
  > 前端工具本身不處理具體的構建邏輯，它只是啟動後端的構建。\
  > 例如 : `build` / `pip` / `tox`。

+ **build backend**

  > 負責<mark>實際執行構建邏輯的工具</mark>，它會處理如何將源代碼轉換成可以安裝和發佈的格式 (`.whl` 和 `.tar.gz`)。\
  > 例如 : `setuptools` / `flit` / `poetry` / `hatchling` / `meson-python`。



### Tools

+ `pip`
  + <mark>package management 工具</mark>
  + <mark>build frontend 工具</mark>
  + 用於從 PyPI 上下載、安裝套件

+ `build`
  + <mark>第三方套件</mark>
  + <mark>build frontend 工具</mark>
  + 支持從 `pyproject.toml` 配置構建

+ `distutils`
  + <mark>標準庫套件</mark>
  + 用於構建和發佈 Python 套件
  + 現已被 setuptools 取代

+ `setuptools`
  + <mark>第三方套件</mark>
  + <mark>build backend 工具</mark>
  + 用於構建和發佈 Python 套件
  + 擴展了標準的 distutils 模組 (打了個 monkey patch)
  + 提供了更多強大的功能，如支持依賴關係的管理、自動化版本控制和插件系統

+ `wheel`
  + <mark>第三方套件</mark>
  + 用於產生 Python 套件的二進制發佈格式 ([binary distribution format][binary-distribution-format]) `.whl`

+ `twine`
  + <mark>第三方套件</mark>
  + 用於發佈 Python 套件
  + 支持將多個檔案一次性上傳到 PyPI / TestPyPI
  + 發佈 Python 套件的推薦工具



### Note

| 🚨 <span class="caution">CAUTION</span> |
| :--- |
| 在 PyPI 上刪除一個 project，是無法刪除過往的 distribution 的。<br>這是為了避免混淆，<mark>確保已經下載過某個套件的使用者，未來不會錯誤地獲取一個相同名稱但內容不同的 distribution</mark>。 |
| 假設某 project 叫 pdfize，它從 0.1.1 版推進到 0.3.3 版後，就被刪除了，<br>而某天有另一團隊想開啟新 project ，名稱也剛好叫做 pdfize (可能與前者毫無相關)，<br>那此團隊就不能上傳 0.1.1 版，因為這名稱的這版本已被使用過了。 |



### Project Directory

```
sound_project/
├── pyproject.toml      # configuration (or setup.py or setup.cfg)
|   README.md
|   LICENSE
└── soundcraft/         # top-level package
    ├── __init__.py
    └── ...
└── tests/              # unit testing
    ├── __init__.py
    └── ...
```

```
soundcraft/             # top-level package
├── __init__.py
├── formats/            # subpackage for file format conversions
│   ├── __init__.py
│   ├── wavread.py
│   ├── wavwrite.py
│   ├── aiffread.py
│   ├── aiffwrite.py
│   ├── auread.py
│   └── auwrite.py
├── effects/            # subpackage for sound effects
│   ├── __init__.py
│   ├── echo.py
│   ├── surround.py
│   └── reverse.py
└── filters/            # subpackage for filters
    ├── __init__.py
    ├── equalizer.py
    ├── vocoder.py
    └── karaoke.py
```


### Configure

| 📘 <span class="note">NOTE</span> |
|:---|
| 這些 config 用來設定 distribution 的 metadata |

| ☢️ <span class="warning">WARNING</span> |
| :--- |
| 盡量使用 `pyproject.toml` 和 `setup.cfg` 這類的靜態 config，<br>少用 `setup.py` 這類的動態 config (除非必要)。 |

| 🚨 <span class="caution">CAUTION</span> |
| :--- |
| 目錄底下一定要有 `__init__.py` 才會被視為套件 |

#### `setup.py`

+ `setup()`
  ```py
  # In setup.py
  from setuptools import find_packages, setup

  with open("README.md", "r", encoding="utf-8") as f:
      long_description = f.read()

  setup(
      # 套件名稱
        # 當你安裝這個套件時，它將會使用這個名稱
      name="pdfize",

      # 套件版本
        # 隨著套件的更新，版本會改變
      version="0.3.3",

      # 套件簡短描述
      description="a simple tools for converting pdf to image.",

      # 構建成發佈套件後應該呈現的目錄架構
        # 詳見 packages 選項
      packages=[...]

      # 發佈套件目錄架構映射
        # 詳見 package_dir 選項
      package_dir={"...": "..."},

      # 套件詳細描述
        # 通常是從一個 README 檔案中讀取內容
      long_description=long_description,

      # 詳細描述格式
      long_description_content_type="text/markdown",

      # 參考網址
        # 通常是指向套件的源代碼或官方網站
      url="https://github.com/RogelioKG/PDFize",

      # 套件作者
      author="RogelioKG",

      # 套件作者信箱
      author_email="...@gmail.com",

      # 套件維護者
      maintainer="WilliamHuang",

      # 套件維護者信箱
      maintainer_email="...@gmail.com",

      # 授權條款
      license="MIT",

      # 分類項目
        # 方便 PyPI 索引
      classifiers=[
          "License :: OSI Approved :: MIT License",
          "Programming Language :: Python :: 3.11",
          "Operating System :: OS Independent",
      ],

      # 套件運行所需的依賴套件
      install_requires=[
          "altgraph>=0.17.4",
          "click>=8.1.7",
          "colorama>=0.4.6",
          "pillow>=10.3.0",
          "PyMuPDF>=1.24.9",
          "PyMuPDFb>=1.24.9",
          "pywin32-ctypes>=0.2.2",
          "tqdm>=4.66.4",
      ],

      # 套件額外的依賴套件
      extras_require={
          "dev": ["twine>=4.0.2"], # pip install pdfize[dev]
      },

      # 套件所需的 Python 版本
      python_requires=">=3.11",
  )
  ```

  + `packages=`
    
    構建成 distribution 後應該呈現的目錄架構

    > [Project Directory](#project-directory) 中，呈現的是「project 的目錄架構」\
    > 但這裡指定的是「構建成發佈套件後應該呈現的目錄架構」\
    > 假如你希望發佈套件架構應該長這樣：
    > ```
    > soundcraft/
    > ├── __init__.py
    > ├── formats/
    > │   ├── __init__.py
    > │   ├── ...
    > ├── effects/
    > │   ├── __init__.py
    > │   ├── ...
    > └── filters/
    >     ├── __init__.py
    >     ├── ...
    > ```
    > 就應該給定
    > ```py
    > packages=[
    >     "soundcraft",
    >     "soundcraft/formats",
    >     "soundcraft/effects",
    >     "soundcraft/filters",
    > ]
    > ```
    > 此時若沒有給定 package_dir 選項，它就會直接映射。\
    > 也就是說：
    > + 發佈套件中的 soundcraft 目錄\
      對應的是 project 中的 soundcraft 目錄
    > + 發佈套件中的 soundcraft/formats 目錄\
      對應的是 project 中的 soundcraft/formats 目錄
    > + 發佈套件中的 soundcraft/effects 目錄\
      對應的是 project 中的 soundcraft/effects 目錄
    > + 發佈套件中的 soundcraft/filters 目錄\
      對應的是 project 中的 soundcraft/filters 目錄
  
  + `package_dir=`

    > 假如你希望發佈套件架構應該長這樣：
    > ```
    > soundcraft/
    > ├── __init__.py
    > ├── encodings/
    > │   ├── __init__.py
    > │   ├── ...
    > ├── modifiers/
    > │   ├── __init__.py
    > │   ├── ...
    > └── sifters/
    >     ├── __init__.py
    >     ├── ...
    > ```
    > 你可以指定：
    > ```py
    > packages=[
    >     "soundcraft",
    >     "soundcraft/encodings",
    >     "soundcraft/modifiers",
    >     "soundcraft/sifters",
    > ]
    > ```
    > 但你的 project 套件目錄架構長得像 [Project Directory](#project-directory)，\
    > 此時你會希望它們有個映射關係可以對應，\
    > 這時候你就可以指定 package_dir 選項。\
    > 像這樣：
    > ```py
    > package_dir={
    >     "soundcraft/encodings": "soundcraft/formats",
    >     "soundcraft/modifiers": "soundcraft/effects",
    >     "soundcraft/sifters": "soundcraft/filters",
    > }
    > ```
    > 也就是說：
    > + 發佈套件中的 soundcraft 目錄\
      對應的是 project 中的 soundcraft 目錄
    > + 發佈套件中的 soundcraft/encodings 目錄\
      對應的是 project 中的 soundcraft/formats 目錄
    > + 發佈套件中的 soundcraft/modifiers 目錄\
      對應的是 project 中的 soundcraft/effects 目錄
    > + 發佈套件中的 soundcraft/sifters 目錄\
      對應的是 project 中的 soundcraft/filters 目錄

  + `find_packages()`

    在 project 中自動搜索套件

    > 套件 (package) 和子套件 (subpackage) 間以 `.` 分隔，可使用 `*` 作為 wildcard。\
    > 比如 [Project Directory](#project-directory) 中，\
    > 若要忽略 `soundcraft/effects/`，要給定 `exclude=["soundcraft.effects"]`。\
    > 若要忽略 `tests/` (單元測試)，要給定 `exclude=["tests", "tests.*"]`。

    + `where=` : 從哪個目錄搜索套件 (預設為 `'.'`，即與 `setup.py` 同層目錄)
    + `include=` : 包含哪些套件 (預設為 `('*',)`，即包含所有套件)
    + `exclude=` : 排除哪些套件 (預設為 `()`，即不排除任何套件)

#### [`pyproject.toml`][toml-config]

| 🚨 <span class="caution">CAUTION</span> |
| :--- |
| 超級警告！！！如果你使用 setuptools 作為 build backend，<br>這裡搜索套件的匹配字串和 `find_packages()` 有小差異。|
| <mark>最後使用 `*` 時，前面不要加 `.`</mark> |

| 🚨 <span class="caution">CAUTION</span> |
| :--- |
| 當你在套件中包含 `py.typed` 時，這表示該套件的 type hints 可以被靜態類型檢查工具 (mypy) 正確地識別和使用。 |
| 如果套件沒有包含此檔案，而使用者嘗試進行 mypy 檢查，就會出現以下錯誤：<br>`error: Skipping analyzing "...": module is installed, but missing library stubs or py.typed marker  [import-untyped]` |
| 然後記得 == 要先在 virtual environment 下載 mypy (是誰那麼蠢會忘記，是的就是我！) |


```toml
[build-system]
requires = ["setuptools>=61.0.0", "wheel"]
build-backend = "setuptools.build_meta" # 使用 setuptools 作為 build backend

[tool.setuptools.packages.find]
include = ["pdfize*"]
exclude = ["pdfize.data*", "tests*"] # 注意不是 ["pdfize.data.*", "tests.*"]

[tool.setuptools.package-data]
pdfize = ["py.typed"] # 新版 setuptools 會自動包含 py.typed 或 .pyi


[project]
name = "pdfize"
version = "1.0.6"
description = "a simple tools for converting pdf to image."
authors = [{ name = "RogelioKG", email = "...@gmail.com" }]
license = { text = "MIT" }
requires-python = ">=3.11"
dependencies = [
    "altgraph>=0.17.4",
    "click>=8.1.7",
    "colorama>=0.4.6",
    "pillow>=10.3.0",
    "PyMuPDF>=1.24.9",
    "PyMuPDFb>=1.24.9",
    "pywin32-ctypes>=0.2.2",
    "tqdm>=4.66.4",
]
readme = { file = "README.md", content-type = "text/markdown" }
classifiers = [
    "License :: OSI Approved :: MIT License",
    "Programming Language :: Python :: 3.11",
    "Operating System :: OS Independent",
]

[project.urls]
Repository = "https://github.com/RogelioKG/PDFize"
Changelog = "https://github.com/RogelioKG/PDFize/blob/main/CHANGELOG.md"

[project.optional-dependencies]
dev = ["build>=1.2.1", "twine>=5.1.1"]

```

#### `setup.cfg`
...

#### `MANIFEST.in`

包含非 Python 相關目錄或檔案

| Command | Description |
|---------|-------------|
| `include pat1 pat2 ...`                       | Add all files matching any of the listed patterns<br>(Files must be given as paths relative to the root of the project)    |
| `exclude pat1 pat2 ...`                       | Remove all files matching any of the listed patterns<br>(Files must be given as paths relative to the root of the project) |
| `recursive-include dir-pattern pat1 pat2 ...` | Add all files under directories matching dir-pattern that match any of the listed patterns                                 |
| `recursive-exclude dir-pattern pat1 pat2 ...` | Remove all files under directories matching dir-pattern that match any of the listed patterns |
| `global-include pat1 pat2 ...`                | Add all files anywhere in the source tree matching any of the listed patterns |
| `global-exclude pat1 pat2 ...`                | Remove all files anywhere in the source tree matching any of the listed patterns |
| `graft dir-pattern`                           | Add all files under directories matching dir-pattern |
| `prune dir-pattern`                           | Remove all files under directories matching dir-pattern |

### Build

| 🚨 <span class="caution">CAUTION</span> |
| :--- |
| 重新將套件構建為 distribution 時，構建工具可能會有一些[快取行為][caching-and-troubleshooting]。<br>如果發現構建結果有問題，先刪除 `dist/` 和 `build/` 和 `*.egg-info/` 目錄，再重新構建一次。 |

#### `setputools`

  + 安裝套件到環境中
    
    ```bash
    py setup.py install
    ```

  + 將套件構建為 source distribution

    > 產生 dist/ 和 *.egg-info/
    ```bash
    py setup.py sdist
    ```

  + 將套件構建為 binary distribution (egg 格式)
    
    ```bash
    py setup.py bdist_egg
    ```

  + 將套件構建為 binary distribution (wheel 格式)
    
    > 產生 build/ 和 dist/ 和 *.egg-info/
    ```bash
    py setup.py bdist_wheel
    ```

#### `build`

  + 將套件構建為 distribution

    > 產生 dist/ 和 *.egg-info/
    ```bash
    py -m build
    ```

### Distribute

| 🚨 <span class="caution">CAUTION</span> |
| :--- |
| 發佈到 TestPyPI 或 PyPI 需要 API key |

| 🚨 <span class="caution">CAUTION</span> |
| :--- |
| 每次發佈都要更新 version，不可重複發佈已發佈過的 version |

#### `twine`

  + 確認
    ```bash
    twine check dist/*
    ```
  
  + 發佈 (PyPI)
    ```bash
    twine upload dist/*
    ```
  
  + 發佈 (TestPyPI)
    ```bash
    twine upload -r testpypi dist/*
    ```

  + 發佈 (跳過已發佈過的舊版)
    ```bash
    twine upload --skip-existing -r testpypi dist/*
    ```



### Dowdload

#### `pip`

  |📘 <span class="note">NOTE</span> : 相依性 dependency|
  |:---|
  | 安裝一個套件時，會自動安裝它的依賴套件 |
  | 移除一個套件時，其依賴套件也會被移除，除非它被其他套件依賴<br>(🚨 <span class="caution">CAUTION</span> : `pip` 沒有自動移除依賴套件的功能，`poetry` 則有)|

  |📘 <span class="note">NOTE</span> : 依賴解析 [dependency resolution][dependency-resolution]|
  |:---|
  | 套件依賴關係是一種有向無環圖 (DAG) |
  | 每個套件對其依賴套件的版本有要求，不同版本之間對依賴套件的版本的要求可能不同 |
  | `pip` 在安裝或更新套件時，會解析整個依賴圖，確保所有版本相容，<mark>同個套件不會有兩個版本</mark><br>(🚨 <span class="caution">CAUTION</span> : Node.js 的 `npm` 比較特別，仰賴它自身 [Node.js Module Resolution Algorithm](https://hackmd.io/@RogelioKG/package_management_js#Nodejs-Module-Resolution-Algorithm) 的特性，它可以做到同個套件有多個版本，詳見[此處](https://hackmd.io/@RogelioKG/package_management_js#npm-v3)。 |

  |📘 <span class="note">NOTE</span> : 依賴衝突 dependency conflicts|
  |:---|
  | 當多個套件對同一依賴有不同版本要求且無交集，會導致衝突 |

  |🚨 <span class="caution">CAUTION</span> : 安裝或升級會影響其他套件 |
  |:---|
  | `pip` 在安裝或升級一個套件的時候，是有可能影響到其他套件的，這不僅限於它的直接相依套件 |
  | 範例：比如原先有個套件 B `==1.0`，它要求套件 A `>=1.5,<2.0`，現在它相依於套件 A `==1.5`，<br>今天新安裝了一個套件 C，它要求套件 A `>=2.0`，因此 pip 把套件 A 重裝為 `2.0`，這個套件 B 也就需要重裝。 |

  |🚨 <span class="caution">CAUTION</span> : 安裝差異 |
  |:---|
  | **一次安裝** : 一次解析所有套件依賴，避免衝突 |
  | **分批安裝** : 可能會因新套件需求，導致已安裝套件的版本變動 |

  + `install`

    + options
      + `-e` | `--editable`    : 可編輯模式，套件安裝為一個軟連結，而不是將其複製到 site-packages
      + `-i` | `--index-url`   : 從指定 Python package index 下載和安裝套件\
        (預設 : https://pypi.org/simple/) (連結不要點，你的記憶體會原地往生)
      + `-r` | `--requirement` : requirements.txt
      + `-t` | `--target`      : 下載到某個路徑
      + `-U` | `--upgrade`     : 將函式庫升級到最新版
      + `--extra-index-url`    : --index-url 的備案選項
      + `--force-reinstall`    : 強制重新安裝\
        (套件下載到一半出錯，但目錄已創建，pip 會誤認為已安裝)
      + `--no-cache-dir`       : 強制從網路下載套件，而非從本地 cache 目錄抓取
      + `--pre`                : 安裝預發佈套件 (比如 alpha / beta 版本)
      + `--no-deps`            : 不進行依賴解析 ([dependency resolution][dependency-resolution])

    + arguments
      + `name[extras_require]`

  + `cache`

    | 📘 <span class="note">NOTE</span> |
    | :--- |
    | pip 在安裝套件時，若之前有下載過，不會從網路重新下載，而是使用本地 cache 來安裝，加快速度 |
    | Windows : `C:\Users\username\AppData\Local\pip\Cache` |
    | Linux : `~/.cache/pip` |

    + subcommands
      + `dir`   : 本地 cache 目錄位置
      + `purge` : 完全清除本地 cache

### Common Error

+ 🚨 `ERROR: Could not find a version that satisfies the requirement ...`

  翻譯蒟蒻 : 找不到對應的版本
  
  + Scenario 1. 下載某個指定版本的套件

    > Solution :\
    > 可能是你 Python 版本太高，\
    > 你可以去 PyPI 找一下這套件這版本的 python_requires，\
    > 可能考慮 Python 要降版，或者套件要升版。

  + Scenario 2. 把自己寫的套件上傳到 TestPyPI 然後想載下來測試 (結果和你說找不到依賴套件的版本)
    
    > Solution :\
    > 簡單來說，\
    > 這是因為你套件的依賴套件沒有在 TestPyPI 發佈，所以 pip 找不到套件。\
    > 解決方法也很簡單，就再給 pip 一個備案 URL 就好\
    > (由 `--extra-index-url` 指定，叫它找不到去 PyPI 找)。

    ```bash
    pip install -i https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple/ package-name
    ```

  + Scenario 3. 把自己寫的套件上傳到 PyPI 然後想載下來使用 (結果和你說找不到你寫的套件的版本)

    > Solution :\
    > 剛上傳，要等一下，再試一次就可以了。

+ 🚨 `ERROR: THESE PACKAGES DO NOT MATCH THE HASHES FROM THE REQUIREMENTS FILE ...`

  翻譯蒟蒻 : 下載後的檔案 hash 值與 PyPI 提供的 hash 值不一致

  > Solution :\
  > pip 會檢查 hash 值，確保下載檔案的完整性與安全性。\
  > 發生這種錯誤表示下載過程中檔案可能遭到損毀或被惡意篡改。\
  > 大部分情況是網路不好，所以下載檔案損毀了。

+ 🚨 `ERROR: To modify pip, please run the following command: python -m pip install ...`

  翻譯蒟蒻 : 你現在要下載的這個套件，它的 dependency 之一就是 pip，而且還要求比你現在還高版的 pip

  > Solution :\
  > 你可能原本使用 `pip install ...`，\
  > 但使用 `python -m pip install ...` 才有辦法自動更新 pip。


+ 🚨 `WARNING: Retrying (...) after connection broken by 'ReadTimeoutError(...)'`
  
  翻譯蒟蒻 : 你斷網了

  > Solution :\
  > 請連上網路。
