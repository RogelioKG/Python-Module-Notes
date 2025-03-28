# flask

### 參考
+ 🔗 [**Flask 官方中文文檔**](https://dormousehole.readthedocs.io/en/latest/)
+ 🔗 [**HackMD (shaoeChen) - Book_Python Flask 0.x實作記錄**](https://hackmd.io/@shaoeChen/HJiZtEngG)
+ 🔗 [**HackMD (shaoeChen) - Book_Python Flask 2.x實作記錄**](https://hackmd.io/@shaoeChen/SJrwFa2Pq)
+ 🔗 [**Medium - Flask 部署機器學習模型**](https://daniel820710.medium.com/%E6%A9%9F%E5%99%A8%E5%AD%B8%E7%BF%92%E5%BE%9E%E9%9B%B6%E5%88%B0%E4%B8%80-day5-%E5%88%A9%E7%94%A8-flask-%E9%83%A8%E7%BD%B2%E6%A9%9F%E5%99%A8%E5%AD%B8%E7%BF%92%E5%A5%97%E4%BB%B6-62c94b19e299)
+ 🔗 [**GitLab (Patrick Kennedy) - Flask 範例**](https://gitlab.com/patkennedy79/flask_user_management_example/-/tree/main?ref_type=heads)
+ 🔗 [**StackOverflow - Waitress：部署到生產環境**](https://stackoverflow.com/a/54381386)

### 注意

|🚨 <span class="caution">CAUTION</span>|
|:---|
|Chrome 真的很愛快取，如果在開發時期發現某個圖片或資源，<br>並沒有如你預期的加載進來，請將整個 Chrome 關掉，再重開一次。|

|🚨 <span class="caution">CAUTION</span>|
|:---|
|Flask 的 `create_app` 工廠，請不要使用傳參讀取配置產生應用程式，而要使用環境變數讀取配置產生應用程式。<br>其原因在於 `create_app` 如果有參數會有很多麻煩 (例如無法使用 Flask CLI)|


### 筆記

+ **動態路由變數**

  + `string`：字串 (預設)
  + `int`：整數
  + `float`：浮點數
  + `path`：路徑
  + `uuid`：UUID
  + `any`：都可

+ **斜線結尾**

  + Flask 的處理方式

    + 如果 <span style="color: orange;">**rule 以斜線結尾**</span>
      + 對不以斜線結尾的 rule 的頁面發出 request -> <span style="color: orange;">**重定向**</span>至以斜線結尾的 rule 的頁面

    + 如果 <span style="color: orange;">**rule 不以斜線結尾**</span>
      + 對以斜線結尾的 rule 的頁面發出 request -> <span style="color: orange;">**404 NotFound**</span>

    + 範例
      ```py
      @app.route('/')
      def index():
          return 'Index Page'

      @app.route('/hello')
      def hello():
          return 'Hello, Flask'

      @app.route('/about/')
      def hello():
          return 'about Flask'
      ```

+ **路由 default**

  ```py
  # 如果連到 /users，等同連到 /users/1
  @app.route("/users/", defaults={"page": 1})
  @app.route("/users/<int:page>")
  def show_users(page: int):
      return f"users {page}"
  ```

### 命令行

+ **執行 (開發階段)**

  |☢️ <span class="warning">WARNING</span>|
  |:---|
  |請不要在生產階段使用這些命令運行應用，關於如何在生產中運行應用，詳見[生產部署](https://dormousehole.readthedocs.io/en/latest/deploying/index.html)|

  > 會自動找出 Flask 實例 (app) 或實例工廠 (create_app)
  ```bash
  flask --app 入口模組名稱 run
  ```


### 每日關心 Flask extension 健康狀況

<!-- TABLE_START -->

| Extension Repository | Latest version  | Last Commit |  Downloads | Build with latest Flask (3.x) and Python (3.12.x) |
| -------------------- | --------------- | ----------- | ---------- | ------------------------------------------------- |
| [juniors90/Flask-FomanticUI](https://github.com/juniors90/Flask-FomanticUI) | ![PyPI - Version](https://img.shields.io/pypi/v/Flask-FomanticUI) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/juniors90/Flask-FomanticUI) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/Flask-FomanticUI?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/Flask-FomanticUI.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/Flask-FomanticUI.yml) |
| [autoinvent/flask-magql](https://github.com/autoinvent/flask-magql) | ![PyPI - Version](https://img.shields.io/pypi/v/Flask-Magql) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/autoinvent/flask-magql) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/Flask-Magql?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/Flask-Magql.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/Flask-Magql.yml) |
| [helloflask/bootstrap-flask](https://github.com/helloflask/bootstrap-flask) | ![PyPI - Version](https://img.shields.io/pypi/v/bootstrap-flask) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/helloflask/bootstrap-flask) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/bootstrap-flask?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/bootstrap-flask.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/bootstrap-flask.yml) |
| [flask-admin/flask-admin](https://github.com/flask-admin/flask-admin) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-admin) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/flask-admin/flask-admin) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-admin?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-admin.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-admin.yml) |
| [jmcarp/flask-apispec](https://github.com/jmcarp/flask-apispec) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-apispec) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/jmcarp/flask-apispec) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-apispec?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-apispec.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-apispec.yml) |
| [viniciuschiele/flask-apscheduler](https://github.com/viniciuschiele/flask-apscheduler) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-apscheduler) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/viniciuschiele/flask-apscheduler) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-apscheduler?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-apscheduler.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-apscheduler.yml) |
| [miracle2k/flask-assets](https://github.com/miracle2k/flask-assets) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-assets) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/miracle2k/flask-assets) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-assets?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-assets.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-assets.yml) |
| [helloflask/flask-avatars](https://github.com/helloflask/flask-avatars) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-avatars) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/helloflask/flask-avatars) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-avatars?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-avatars.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-avatars.yml) |
| [python-babel/flask-babel](https://github.com/python-babel/flask-babel) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-babel) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/python-babel/flask-babel) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-babel?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-babel.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-babel.yml) |
| [maxcountryman/flask-bcrypt](https://github.com/maxcountryman/flask-bcrypt) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-bcrypt) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/maxcountryman/flask-bcrypt) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-bcrypt?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-bcrypt.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-bcrypt.yml) |
| [pallets-eco/flask-caching](https://github.com/pallets-eco/flask-caching) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-caching) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/pallets-eco/flask-caching) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-caching?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-caching.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-caching.yml) |
| [helloflask/flask-ckeditor](https://github.com/helloflask/flask-ckeditor) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-ckeditor) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/helloflask/flask-ckeditor) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-ckeditor?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-ckeditor.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-ckeditor.yml) |
| [corydolphin/flask-cors](https://github.com/corydolphin/flask-cors) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-cors) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/corydolphin/flask-cors) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-cors?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-cors.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-cors.yml) |
| [pallets-eco/flask-debugtoolbar](https://github.com/pallets-eco/flask-debugtoolbar) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-debugtoolbar) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/pallets-eco/flask-debugtoolbar) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-debugtoolbar?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-debugtoolbar.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-debugtoolbar.yml) |
| [dillibabukadati/flask-helmet](https://github.com/dillibabukadati/flask-helmet) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-helmet) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/dillibabukadati/flask-helmet) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-helmet?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-helmet.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-helmet.yml) |
| [nathancahill/flask-inputs](https://github.com/nathancahill/flask-inputs) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-inputs) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/nathancahill/flask-inputs) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-inputs?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-inputs.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-inputs.yml) |
| [vimalloc/flask-jwt-extended](https://github.com/vimalloc/flask-jwt-extended) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-jwt-extended) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/vimalloc/flask-jwt-extended) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-jwt-extended?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-jwt-extended.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-jwt-extended.yml) |
| [alisaifee/flask-limiter](https://github.com/alisaifee/flask-limiter) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-limiter) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/alisaifee/flask-limiter) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-limiter?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-limiter.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-limiter.yml) |
| [maxcountryman/flask-login](https://github.com/maxcountryman/flask-login) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-login) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/maxcountryman/flask-login) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-login?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-login.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-login.yml) |
| [waynerv/flask-mailman](https://github.com/waynerv/flask-mailman) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-mailman) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/waynerv/flask-mailman) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-mailman?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-mailman.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-mailman.yml) |
| [marshmallow-code/flask-marshmallow](https://github.com/marshmallow-code/flask-marshmallow) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-marshmallow) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/marshmallow-code/flask-marshmallow) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-marshmallow?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-marshmallow.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-marshmallow.yml) |
| [miguelgrinberg/flask-migrate](https://github.com/miguelgrinberg/flask-migrate) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-migrate) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/miguelgrinberg/flask-migrate) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-migrate?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-migrate.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-migrate.yml) |
| [miguelgrinberg/flask-moment](https://github.com/miguelgrinberg/flask-moment) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-moment) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/miguelgrinberg/flask-moment) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-moment?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-moment.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-moment.yml) |
| [MongoEngine/flask-mongoengine](https://github.com/MongoEngine/flask-mongoengine) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-mongoengine) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/MongoEngine/flask-mongoengine) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-mongoengine?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-mongoengine.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-mongoengine.yml) |
| [lepture/flask-oauthlib](https://github.com/lepture/flask-oauthlib) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-oauthlib) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/lepture/flask-oauthlib) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-oauthlib?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-oauthlib.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-oauthlib.yml) |
| [bauerji/flask-pydantic](https://github.com/bauerji/flask-pydantic) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-pydantic) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/bauerji/flask-pydantic) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-pydantic?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-pydantic.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-pydantic.yml) |
| [marcoagner/Flask-QRcode](https://github.com/marcoagner/Flask-QRcode) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-qrcode) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/marcoagner/Flask-QRcode) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-qrcode?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-qrcode.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-qrcode.yml) |
| [plangrid/flask-rebar](https://github.com/plangrid/flask-rebar) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-rebar) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/plangrid/flask-rebar) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-rebar?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-rebar.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-rebar.yml) |
| [flask-restful/flask-restful](https://github.com/flask-restful/flask-restful) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-restful) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/flask-restful/flask-restful) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-restful?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-restful.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-restful.yml) |
| [python-restx/flask-restx](https://github.com/python-restx/flask-restx) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-restx) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/python-restx/flask-restx) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-restx?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-restx.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-restx.yml) |
| [mattupstate/flask-security](https://github.com/mattupstate/flask-security) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-security) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/mattupstate/flask-security) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-security?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-security.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-security.yml) |
| [pallets-eco/flask-session](https://github.com/pallets-eco/flask-session) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-session) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/pallets-eco/flask-session) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-session?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-session.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-session.yml) |
| [marshmallow-code/flask-smorest](https://github.com/marshmallow-code/flask-smorest) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-smorest) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/marshmallow-code/flask-smorest) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-smorest?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-smorest.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-smorest.yml) |
| [miguelgrinberg/Flask-SocketIO](https://github.com/miguelgrinberg/Flask-SocketIO) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-socketio) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/miguelgrinberg/Flask-SocketIO) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-socketio?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-socketio.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-socketio.yml) |
| [pallets/flask-sqlalchemy](https://github.com/pallets/flask-sqlalchemy) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-sqlalchemy) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/pallets/flask-sqlalchemy) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-sqlalchemy?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-sqlalchemy.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-sqlalchemy.yml) |
| [jarus/flask-testing](https://github.com/jarus/flask-testing) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-testing) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/jarus/flask-testing) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-testing?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-testing.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-testing.yml) |
| [maxcountryman/flask-uploads](https://github.com/maxcountryman/flask-uploads) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-uploads) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/maxcountryman/flask-uploads) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-uploads?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-uploads.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-uploads.yml) |
| [fedora-copr/flask-whooshee](https://github.com/fedora-copr/flask-whooshee) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-whooshee) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/fedora-copr/flask-whooshee) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-whooshee?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-whooshee.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-whooshee.yml) |
| [wtforms/flask-wtf](https://github.com/wtforms/flask-wtf) | ![PyPI - Version](https://img.shields.io/pypi/v/flask-wtf) | ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/wtforms/flask-wtf) | ![PyPI - Downloads](https://img.shields.io/pypi/dm/flask-wtf?color=darkgrey) | [![build](https://github.com/greyli/flask-extension-status/actions/workflows/flask-wtf.yml/badge.svg)](https://github.com/greyli/flask-extension-status/actions/workflows/flask-wtf.yml) |

<!-- TABLE_END -->