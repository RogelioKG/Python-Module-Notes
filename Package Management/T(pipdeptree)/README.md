# pipdeptree

### Note

+ 這玩意竟然能把依賴圖畫成 Mermaid

  > 不過要以 `<br>` / `&gt;` / `&lt;` 替換一下特殊字元

  ```mermaid
  %%{init:{"flowchart":{"defaultRenderer":"elk"}}}%%
  flowchart TD
      classDef missing stroke-dasharray: 5
      asttokens["asttokens<br>2.4.1"]
      beautifulsoup4["beautifulsoup4<br>4.12.3"]
      certifi["certifi<br>2024.8.30"]
      charset-normalizer["charset-normalizer<br>3.3.2"]
      clarabel["clarabel<br>0.9.0"]
      colorama["colorama<br>0.4.6"]
      contourpy["contourpy<br>1.3.0"]
      cvxpy["cvxpy<br>1.5.3"]
      cycler["cycler<br>0.12.1"]
      datetime["DateTime<br>5.5"]
      decorator["decorator<br>5.1.1"]
      ecos["ecos<br>2.0.14"]
      empyrial["empyrial<br>2.1.4"]
      empyrical["empyrical<br>0.5.5"]
      executing["executing<br>2.1.0"]
      fonttools["fonttools<br>4.53.1"]
      fpdf["fpdf<br>1.7.2"]
      frozendict["frozendict<br>2.4.4"]
      html5lib["html5lib<br>1.1"]
      idna["idna<br>3.8"]
      ipython["ipython<br>8.27.0"]
      jedi["jedi<br>0.19.1"]
      kiwisolver["kiwisolver<br>1.4.7"]
      lxml["lxml<br>5.3.0"]
      matplotlib-inline["matplotlib-inline<br>0.1.7"]
      matplotlib["matplotlib<br>3.9.2"]
      multitasking["multitasking<br>0.0.11"]
      numpy["numpy<br>1.24.1"]
      osqp["osqp<br>0.6.7.post1"]
      packaging["packaging<br>24.1"]
      pandas-datareader["pandas-datareader<br>0.10.0"]
      pandas["pandas<br>2.2.2"]
      parso["parso<br>0.8.4"]
      peewee["peewee<br>3.17.6"]
      pillow["pillow<br>10.4.0"]
      pip["pip<br>24.2"]
      pipdeptree["pipdeptree<br>2.23.3"]
      platformdirs["platformdirs<br>4.3.2"]
      prompt-toolkit["prompt_toolkit<br>3.0.47"]
      pure-eval["pure_eval<br>0.2.3"]
      pygments["Pygments<br>2.18.0"]
      pyparsing["pyparsing<br>3.1.4"]
      pyportfolioopt["pyportfolioopt<br>1.5.5"]
      python-dateutil["python-dateutil<br>2.9.0.post0"]
      pytz["pytz<br>2024.1"]
      qdldl["qdldl<br>0.1.7.post4"]
      quantstats["QuantStats<br>0.0.62"]
      requests["requests<br>2.32.3"]
      scipy["scipy<br>1.14.1"]
      scs["scs<br>3.2.7"]
      seaborn["seaborn<br>0.13.2"]
      setuptools["setuptools<br>72.1.0"]
      six["six<br>1.16.0"]
      soupsieve["soupsieve<br>2.6"]
      stack-data["stack-data<br>0.6.3"]
      tabulate["tabulate<br>0.9.0"]
      traitlets["traitlets<br>5.14.3"]
      typing-extensions["typing_extensions<br>4.12.2"]
      tzdata["tzdata<br>2024.1"]
      urllib3["urllib3<br>2.2.2"]
      wcwidth["wcwidth<br>0.2.13"]
      webencodings["webencodings<br>0.5.1"]
      wheel["wheel<br>0.44.0"]
      yfinance["yfinance<br>0.2.43"]
      zope-interface["zope.interface<br>7.0.3"]
      asttokens -- "&gt;=1.12.0" --> six
      beautifulsoup4 -- "&gt;1.2" --> soupsieve
      clarabel -- "any" --> numpy
      clarabel -- "any" --> scipy
      contourpy -- "&gt;=1.23" --> numpy
      cvxpy -- "&gt;=0.5.0" --> clarabel
      cvxpy -- "&gt;=0.6.2" --> osqp
      cvxpy -- "&gt;=1.1.0" --> scipy
      cvxpy -- "&gt;=1.15" --> numpy
      cvxpy -- "&gt;=2" --> ecos
      cvxpy -- "&gt;=3.2.4.post1" --> scs
      datetime -- "any" --> pytz
      datetime -- "any" --> zope-interface
      ecos -- "&gt;=0.9" --> scipy
      ecos -- "&gt;=1.6" --> numpy
      empyrial -- "any" --> datetime
      empyrial -- "any" --> empyrical
      empyrial -- "any" --> fpdf
      empyrial -- "any" --> ipython
      empyrial -- "any" --> matplotlib
      empyrial -- "any" --> numpy
      empyrial -- "any" --> pyportfolioopt
      empyrial -- "any" --> quantstats
      empyrial -- "any" --> yfinance
      empyrical -- "&gt;=0.15.1" --> scipy
      empyrical -- "&gt;=0.16.1" --> pandas
      empyrical -- "&gt;=0.2" --> pandas-datareader
      empyrical -- "&gt;=1.9.2" --> numpy
      html5lib -- "&gt;=1.9" --> six
      html5lib -- "any" --> webencodings
      ipython -- "&gt;=0.16" --> jedi
      ipython -- "&gt;=2.4.0" --> pygments
      ipython -- "&gt;=3.0.41,&lt;3.1.0" --> prompt-toolkit
      ipython -- "&gt;=4.6" --> typing-extensions
      ipython -- "&gt;=5.13.0" --> traitlets
      ipython -- "any" --> colorama
      ipython -- "any" --> decorator
      ipython -- "any" --> matplotlib-inline
      ipython -- "any" --> stack-data
      jedi -- "&gt;=0.8.3,&lt;0.9.0" --> parso
      matplotlib -- "&gt;=0.10" --> cycler
      matplotlib -- "&gt;=1.0.1" --> contourpy
      matplotlib -- "&gt;=1.23" --> numpy
      matplotlib -- "&gt;=1.3.1" --> kiwisolver
      matplotlib -- "&gt;=2.3.1" --> pyparsing
      matplotlib -- "&gt;=2.7" --> python-dateutil
      matplotlib -- "&gt;=20.0" --> packaging
      matplotlib -- "&gt;=4.22.0" --> fonttools
      matplotlib -- "&gt;=8" --> pillow
      matplotlib-inline -- "any" --> traitlets
      osqp -- "&gt;=0.13.2" --> scipy
      osqp -- "&gt;=1.7" --> numpy
      osqp -- "any" --> qdldl
      pandas -- "&gt;=1.23.2" --> numpy
      pandas -- "&gt;=2.8.2" --> python-dateutil
      pandas -- "&gt;=2020.1" --> pytz
      pandas -- "&gt;=2022.7" --> tzdata
      pandas-datareader -- "&gt;=0.23" --> pandas
      pandas-datareader -- "&gt;=2.19.0" --> requests
      pandas-datareader -- "any" --> lxml
      pipdeptree -- "&gt;=24.1" --> packaging
      pipdeptree -- "&gt;=24.2" --> pip
      prompt-toolkit -- "any" --> wcwidth
      pyportfolioopt -- "&gt;=0.19" --> pandas
      pyportfolioopt -- "&gt;=1.1.19,&lt;2.0.0" --> cvxpy
      pyportfolioopt -- "&gt;=1.22.4,&lt;2.0.0" --> numpy
      pyportfolioopt -- "&gt;=1.3,&lt;2.0" --> scipy
      python-dateutil -- "&gt;=1.5" --> six
      qdldl -- "&gt;=0.13.2" --> scipy
      qdldl -- "&gt;=1.7" --> numpy
      quantstats -- "&gt;=0.1.70" --> yfinance
      quantstats -- "&gt;=0.24.0" --> pandas
      quantstats -- "&gt;=0.8.0" --> tabulate
      quantstats -- "&gt;=0.9.0" --> seaborn
      quantstats -- "&gt;=1.16.5" --> numpy
      quantstats -- "&gt;=1.2.0" --> scipy
      quantstats -- "&gt;=2.0" --> python-dateutil
      quantstats -- "&gt;=3.0.0" --> matplotlib
      requests -- "&gt;=1.21.1,&lt;3" --> urllib3
      requests -- "&gt;=2,&lt;4" --> charset-normalizer
      requests -- "&gt;=2.5,&lt;4" --> idna
      requests -- "&gt;=2017.4.17" --> certifi
      scipy -- "&gt;=1.23.5,&lt;2.3" --> numpy
      scs -- "any" --> numpy
      scs -- "any" --> scipy
      seaborn -- "&gt;=1.2" --> pandas
      seaborn -- "&gt;=1.20,!=1.24.0" --> numpy
      seaborn -- "&gt;=3.4,!=3.6.1" --> matplotlib
      stack-data -- "&gt;=1.2.0" --> executing
      stack-data -- "&gt;=2.1.0" --> asttokens
      stack-data -- "any" --> pure-eval
      yfinance -- "&gt;=0.0.7" --> multitasking
      yfinance -- "&gt;=1.1" --> html5lib
      yfinance -- "&gt;=1.16.5" --> numpy
      yfinance -- "&gt;=1.3.0" --> pandas
      yfinance -- "&gt;=2.0.0" --> platformdirs
      yfinance -- "&gt;=2.3.4" --> frozendict
      yfinance -- "&gt;=2.31" --> requests
      yfinance -- "&gt;=2022.5" --> pytz
      yfinance -- "&gt;=3.16.2" --> peewee
      yfinance -- "&gt;=4.11.1" --> beautifulsoup4
      yfinance -- "&gt;=4.9.1" --> lxml
      zope-interface -- "any" --> setuptools
  ```