# click

[![RogelioKG/click](https://img.shields.io/badge/Sync%20with%20HackMD-grey?logo=markdown)](https://hackmd.io/@RogelioKG/click)

## References
+ 🔗 [**click 官方文檔**](https://click.palletsprojects.com/en/8.1.x/)
+ 🔗 [**click 中文文檔**](https://click-docs-zh-cn.readthedocs.io/zh/latest/)
+ 🔗 [**shaoeChen : click 部分文檔翻譯**](https://hackmd.io/@shaoeChen/BJ_cf2jhX)
+ 🔗 [**GitHub : source code**](https://github.com/pallets/click/tree/main)
+ 🔗 [**myapollo : Python 用 Click 模組製作好用的指令**](https://myapollo.com.tw/blog/python-click/)

<!-- link -->
[Setuptools Integration]: https://click.palletsprojects.com/en/8.1.x/setuptools/#setuptools-integration


## Caution

| 📗 <span class="tip">TIP</span>                              |
| :------------------------------------------------------------------ |
| 盡量使用 `click.echo` 代替 `print` (前者在不同檔案與環境支援度更高) |

| 📘 <span class="note">NOTE</span> |
| :----------------------------------- |
| 你可以單純寫成腳本，也可使用 `setuptools` (更方便配合虛擬環境使用)，詳見 [Setuptools Integration] |

## Note

### 引數型別

+ 字串：`str`
+ 整數：`int`
+ 浮點數：`float`
+ 布林：`bool`
+ UUID：`click.uuid`
+ 檔案：`click.File`
+ 路徑：`click.Path`
+ 選項：`click.Choice`
+ 範圍整數：`click.IntRange`
+ 範圍浮點數：`click.FloatRange`
+ 日期：`click.DateTime`
+ 不處理：`click.UNPROCESSED` (例如你的 flag_value 想要回傳類別，但 click 會自動轉成字串，這裡的不處理即保留原樣)

### 選項 `@click.option(...)`
+ **參數說明**
    ```py
    @click.command()
    @click.option(
        "-r",                       # 指令選項 (字母)
        "--repeat",                 # 指令選項 (單字)
        "repeat",                   # 傳入函數的參數名稱 (如果不給，預設就是使用指令選項的單字作為名稱)
        help="Repeat n times",      # 於 --help 的說明
        default="strange",          # 預設值 (若未調用此指令)
        show_default=True,          # 於 --help 說明預設值為何
        type=int,                   # 型別驗證 (不符合會出錯，可自訂型別)
        required=True,              # 必要
        nargs=1,                    # 定長引數數量 (不符合會出錯，傳入函數時為 tuple[type])
        case_sensitive=False,       # 引數是否大小寫敏感
        count=True,                 # 指令選項的字母重複幾次 (極少用到)
        prompt="Repeat times",      # 使用者提示 (若未調用此指令)
        hide_input=True,            # 隱藏輸入 (若未調用此指令)
        confirmation_prompt=True,   # 再次確認輸入 (若未調用此指令)
        is_flag=True                # 是否為雙狀態 (若以斜線分隔兩選項，隱式設為 True)
    )
    def greeting(repeat):
        pass
    ```

+ **雙狀態 (flag)** `/`
    > 以斜線分隔兩選項，click 就會知道這個是 boolean flag (`is_flag` 隱式設為 `True`)。
    ```py
    # default=False 意味著預設是 --no-shout
    @click.command()
    @click.option("-S/ ", "--shout/--no-shout", "shout", default=False)
    def greeting(shout: bool):
        string = "hello world"
        if shout:
            click.echo(string.upper() + "!!!!!!!")
        else:
            click.echo(string)

    if __name__ == "__main__":
        greeting()
    ```
    ```bash
    $ py test.py
    hello world
    $ py test.py --shout
    HELLO WORLD!!!!!!!
    $ py test.py --no-shout
    hello world
    $ py test.py -S
    HELLO WORLD!!!!!!!
    ```

+ **多狀態** `flag_value=`
    > 預設的那個狀態要給 default=True。被選擇的選項會將 flag_value 賦值給 transformation。
    ```py
    @click.command()
    @click.option("--upper", "transformation", flag_value="upper", default=True)
    @click.option("--lower", "transformation", flag_value="lower")
    @click.option("--cap", "transformation", flag_value="capitalize")
    def greeting(transformation: str):
        click.echo(getattr("hello", transformation)()) # 注意看，這裡其實是在調用字串方法！

    if __name__ == "__main__":
        greeting()
    ```
    ```
    $ py test.py
    HELLO
    $ py test.py --lower
    hello
    $ py test.py --cap
    Hello
    $ py test.py
    HELLO
    ```

### 引數 `@click.argument(...)`
> 有 `default` 但沒有 `prompt`

+ **不定長參數 `nargs=-1`**
    ```py
    # in test.py
    @click.command()
    @click.argument("numbers", nargs=-1, required=True, type=float)
    def do_sum(numbers: tuple[float]):
        click.echo(f"sum: {sum(numbers)}")
    ```
    ```
    $ py test.py 1 2 3 4 5
    15
    ```

### 客製型別 `click.ParamType`
> 繼承並實作 convert 方法即可。
```py
import click

class OddIntType(click.ParamType):
    name = "odd_int"

    def convert(self, value, param, ctx):
        try:
            n = int(value)
            if n % 2 == 0:
                raise ValueError
            return n
        except ValueError:
            self.fail(f"{value} is not a valid odd integer")

ODD_INT = OddIntType()

# 我們希望 --repeat 只接受奇數
@click.command()
@click.option("-t", "--to", "to", help="To who", default="stranger", show_default=True)
@click.option("-r", "--repeat", "repeat", help="Repeat n times", type=ODD_INT, required=True)
def greeting(to: str, repeat: int):
    """Say hello to someone"""
    for _ in range(0, repeat):
        print(f"Hello, {to}")

if __name__ == "__main__":
    greeting()
```

### 指令分組 `@click.group()`
> group 允許巢狀分組，且本身也可以有 option

```py
@click.group()
@click.option("--debug/--no-debug", default=False)
def cli(debug):
    click.echo(f"Debug mode is {'on' if debug else 'off'}")

# short_help 是 command 的說明
# 就如同 help 是 option 的說明一樣
@cli.command(short_help="trying to synchornize")
def sync():
    click.echo("Synching")

@cli.command(short_help="greeting")
def greet():
    click.echo("Hello")


if __name__ == "__main__":
    cli()
```
```
$ py test.py sync
Debug mode is off
Synching
$ py test.py --debug greet
Debug mode is on
Hello
```

### 上下文傳遞 `@click.pass_context`
```py
@click.group()
@click.option("--debug/--no-debug", default=False)
@click.pass_context
def cli(ctx: click.Context, debug: bool):
    # 初始化一個空的上下文字典
    ctx.ensure_object(dict)
    ctx.obj["DEBUG"] = debug

# 上下文可以讓群組和命令有溝通管道
@cli.command()
@click.pass_context
def sync(ctx: click.Context):
    click.echo(f"Debug is {'on' if ctx.obj['DEBUG'] else 'off'}")


@cli.command(short_help="greeting")
def greet():
    click.echo("Hello")


if __name__ == "__main__":
    cli()
```
```
$ py test.py sync
Debug mode is off
$ py test.py --debug sync
Debug mode is on
```

### 例外

| **exception**            | **description** | **example** |
| ------------------------ | ------------------------------------------------- | ------------------------------------------------------------- |
| `click.UsageError`       | 當使用者提供的指令用法不正確時引發，例如無效的選項或參數。   | `raise click.UsageError("The '--workers' option requires '--parallel' to be enabled.")` |
| `click.BadParameter`     | 當參數 (選項或參數) 驗證失敗時引發，例如輸入的數值不符合預期類型。 | `raise click.BadParameter("Invalid value for '--workers': must be a positive integer.")` |
| `click.MissingParameter` | 當缺少必要的參數 (選項或參數) 時引發。  | `raise click.MissingParameter(param='--workers', param_hint='--workers')` |
| `click.NoSuchOption`     | 當使用者提供了一個不存在的選項時引發。                             | `raise click.NoSuchOption('--invalid-option')` |
| `click.FileError`        | 當文件操作 (如讀取或寫入) 失敗時引發，例如文件不存在或無法打開。   | `raise click.FileError(filename='config.txt', hint='...')` |
| `click.Abort`            | 當操作被使用者中止時引發，通常是按 `Ctrl+C`。                      | `raise click.Abort()`  |
| `click.ClickException`   | 所有 Click 例外狀況的基類。可直接引發此例外或自訂子類別。          | `raise click.ClickException("...")` |
| `click.Exit`             | 用於退出應用程式並指定狀態碼。當需要以非零狀態碼結束程序時使用。   | `raise click.Exit(code=1)` |

### 版本資訊 `@click.version_option`
```py
# poetry.py
import click

@click.command()
@click.version_option(version="1.8.4", prog_name="Poetry")
def cli():
    click.echo("Hello, this is Poetry!")

if __name__ == "__main__":
    cli()
```

```
$ py poetry.py --version
Poetry, version 1.8.4
```

### 顏色 `click.style`
詳見[此範例](https://github.com/pallets/click/blob/main/examples/colors/colors.py)。

### 待學
+ [`click.password_option`](https://click.palletsprojects.com/en/8.1.x/api/#click.password_option)
+ [`click.confirmation_option`](https://click.palletsprojects.com/en/8.1.x/api/#click.confirmation_option)
+ [`click.progressbar`](https://click.palletsprojects.com/en/8.1.x/api/#click.progressbar)


## Plugins

### [click-help-colors]
此插件能為 help info 上色。

[click-help-colors]: https://github.com/click-contrib/click-help-colors