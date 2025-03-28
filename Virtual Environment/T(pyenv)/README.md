# pyenv

### References
+ 🔗 [**GitHub : pyenv**](https://github.com/pyenv/pyenv)
+ 🔗 [**Maxlist : [Python 教學] 如何切換 Python 版本，讓 Pyenv 幫你輕鬆管理版本**](https://www.maxlist.xyz/2022/05/06/python-pyenv/)
+ 🎬 [**k0nze : How to Install and Run Multiple Python Versions on Windows 10/11 | pyenv & virtualenv Setup Tutorial**](https://youtu.be/HTx18uyyHw8)

### Install

+ Windows
  ```bash
  git clone https://github.com/pyenv-win/pyenv-win.git "$HOME/.pyenv"
  ```

  ```powershell
  [System.Environment]::SetEnvironmentVariable('PYENV',$env:USERPROFILE + "\.pyenv\pyenv-win\","User")
  [System.Environment]::SetEnvironmentVariable('PYENV_ROOT',$env:USERPROFILE + "\.pyenv\pyenv-win\","User")
  [System.Environment]::SetEnvironmentVariable('PYENV_HOME',$env:USERPROFILE + "\.pyenv\pyenv-win\","User")
  [System.Environment]::SetEnvironmentVariable('path', $env:USERPROFILE + "\.pyenv\pyenv-win\bin;" + $env:USERPROFILE + "\.pyenv\pyenv-win\shims;" + [System.Environment]::GetEnvironmentVariable('path', "User"),"User")
  ```


### Usage


|📗 <span class="tip">TIP</span>|
|:---|
|發現一個取巧的地方，若是 Windows 平台的話，<br>`py` 恰使用 system python version，<br>`python` 恰使用 pyenv python version。|

+ `help`
  ```bash
  pyenv help
  ```

+ `install`

  + `--list` : 列出所有可使用版本

  ```bash
  pyenv install 3.7.7
  ```

+ `uninstall`
  ```bash
  pyenv uninstall 3.7.7
  ```

+ `shell`

  > 設定在此 shell 中使用 Python 版本\
  > 原理 : 設定臨時 envvar `PYENV_VERSION`

  ```bash
  pyenv install 3.7.7
  ```

+ `local`

  > 設定當前目錄使用 Python 版本\
  > 原理 : `./.python-version`

  ```bash
  pyenv local 3.7.7
  ```

+ `global`

  > 設定全域使用 Python 版本\
  > 原理 : `~/.pyenv/pyenv-win/version`

  ```bash
  pyenv global 3.7.7
  ```

+ `versions`

  > 查看目前有哪些版本可用

  ```bash
  pyenv versions
  ```