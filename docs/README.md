# Introduction


## envセット方法

`direnv edit .`
するとカレントディレクトリに.envrcが作成され下記のように設定した環境変数が追加/削除される。

.envrc


## rails作成

`$ docker-compose run --rm api rails new . -f -B -d postgresql --api`

run ... 指定したサービスのコンテナを立ち上げ、任意のコマンドを実行する時に使います。

--rmオプション ... 任意のコマンドを実行後、コンテナを自動で削除します。

これは、コンテナを削除する$ docker-compose rmコマンドを実行するのと同じことをしています。

api ... Composeファイルに記述したサービス名。

rails new <ディレクトリ名> <-オプション> <--モードオプション>

. ... カレントディレクトリ（現在のディレクトリ）内にRailsアプリを作成する指定です。

通常rails newの後はアプリ名兼、ディレクトリ名を指定します。

ただ今回のように既にある「api」ディレクトリの中にRailsアプリを作成したい場合は、.ドットを指定します。

カレントディレクトリと判断される場所は、docker-compose.ymlのcontextで指定した場所となります。
-fオプション ... ファイルが存在する場合に上書きします。ここでは Gemfile を対象としています。

-Bオプション ... Gemをインストールするbundle installコマンドを実行しません。

後でイメージを作り替えるときに実行されるため、ここでは省略しています。

-d <データベース名>オプション ... 使用するデータベースを指定します。

今回は、postgresqlを指定していますが、指定がない場合はデフォルトのsqlite3が使用されます。

ちなみに–database=postgresqlこういった書き方もできます。

--apiオプション ... API専用のRailsアプリケーションを作成する場合に指定するオプションです。

## Rails Controller生成コマンド

末尾はディレクトリ構造となる。
`$ docker-compose run --rm api rails g controller home::api::v1::hello`

## Postgresのパスワードを変更したい時

この値はデータベースが初期化されるタイミングで設定されるため、以後この環境変数を変えてもコンテナ内のPostgreSQLのパスワードを変更することができません。

パスワードを変えるには、イメージを作り直すか、コンテナ内で直接変更を行う必要があります。

[参考URL](https://blog.cloud-acct.com/posts/u-docker-compose-rails6new)

## nuxt生成

`$ docker-compose run --rm front yarn create nuxt-app`

※neams-uiにDockrfileがあるとerrorになる

以下で対応
`$ docker-compose run --rm front yarn create nuxt-app app`
create-nuxt-app v4.0.0
✨  Generating Nuxt.js project in app
? Project name: app
? Programming language: TypeScript
? Package manager: Yarn
? UI framework: None
? Nuxt.js modules: Axios - Promise based HTTP cl
ient
? Linting tools: ESLint, Prettier
? Testing framework: Jest
? Rendering mode: Universal (SSR / SSG)
? Deployment target: Server (Node.js hosting)
? Development tools: jsconfig.json (Recommended
for VS Code if you're not using typescript)
? Continuous integration: GitHub Actions (GitHub
 only)
? What is your GitHub username? naohito-t
? Version control system: Git


`$ mv front/app/{*,.*} neams-ui`


## サブモジュール化

rootディレクトリは`git init`を初期に行っている状態。サブディレクトリは作成されている状態。

git initされている状態であれば
apiディレクトリ(もともとはmasterとなっていた)
`$ git br -m develop`

「api」リポジトリがコミットされると、当然コミットIDも変化します。

その場合、「root」リポジトリもコミットする必要があります。

今後のコミット手順
Railsアプリを編集した
apiディレクトリに移動してコミットする
rootディレクトリに戻る
rootリポジトリもコミットする

`$ git init`
`$ git br -m develop`
`$ git add .`
`$ gc`

ここからgithub上でサブモジュール用のプロジェクトのリポジトリを作成する。

`$ git remote -vv` 設定されていない
`$ git remote add origin [new repository ssh url]`
`$ git push -u `

ルートディレクトリに戻りサブモジュール追加をする
`$ git submodule add git@github.com:naohito-T/Neams-ui.git neams-ui`

.gitmodulesファイルが作成されている
[submodule "neams-ui"]
	path = neams-ui
	url = git@github.com:naohito-T/Neams-ui.git


サブモジュールに追加されているか確認する(ディレクトリ名のみの情報であればOK)
`$ git ls-files`

エラー時
.gitmodules
.git/config内と
.git/modules/内のディレクトリ名を変更すればいける
