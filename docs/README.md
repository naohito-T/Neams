# Introduction


## envセット方法

`direnv edit .`
するとカレントディレクトリに.envrcが作成され下記のように設定した環境変数が追加/削除される。
※なんか機能しない場合もある。

.envrc

## env確認コマンド(Dockerfileに記載する)

```sh
# ENV確認
# RUN echo ${HOME}
# RUN echo ${LANG}
# RUN echo ${TZ}
# RUN echo ${RACK_ENV}
# RUN echo ${RAILS_ENV}
# RUN echo ${RAILS_LOG_TO_STDOUT}
# RUN echo ${RAILS_SERVE_STATIC_FILES}
# RUN echo ${RAILS_MASTER_KEY}
```


## rails作成

`$ docker-compose run --rm api rails new . -f -B -d postgresql --api`

run ... 指定したサービスのコンテナを立ち上げ、任意のコマンドを実行する時に使う。

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
`$ docker-compose run --rm api rails g controller api::v1::home::test::hello`

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

## docker build時

- フロント

```sh
$ docker-compose build [service name]

# フロントはinstallする。
$ docker-compose run --rm front yarn install
```

- api(GemfileにGemを追加後)

```sh
# イメージを再ビルドする
$ docker-compose build api
# 命令を削除しただけの場合は1からイメージが作られない場合もあるため以下を実行
$ docker-compose build --no-cache api

# 起動し確認
$ docker-compose up api

# gemがインストールされているか確認
$ docker-compose run --rm api bundle info hirb

```

## Docker Tips

```sh
# イメージを作成した後、前回からの反映を確認する(Docker Desktop)でも確認できるけど..
$ docker images
# コンテナiDでイメージ内容確認
$ docker inspect [container ID]


# api modalを作成
$ docker-compose run --rm api rails g model User --no-fixture
# --no-fixture ... fixture（フィクスチャ）ファイルを作成しない。
# 今回のテストデータはseedデータから読み込むのでこのファイルは使用しない。

# テーブル作成コマンド(modalを作成後実施する)
$ docker-compose run --rm api rails db:migrate

# マイグレーション失敗した場合
$ docker-compose run --rm api rails db:migrate:reset

# 作成されたDBを確認
$ docker-compose run --rm api rails dbconsole

# seedデータを全て削除して、新たに投入したい場合
$ docker-compose run --rm api rails db:reset

```

## API を Testする

```sh
$ make api.test
docker-compose run --rm api rails t
Creating neams_api_run ... done
Run options: --seed 45637

# Running:

users seed ...
users seed ...
users = 10
users = 10
.

Finished in 2.104753s, 0.4751 runs/s, 0.4751 assertions/s.
1 runs, 1 assertions, 0 failures, 0 errors, 0 skips

1 tests ... 1つのテストブロックの
1 assertions ... 1つのassertを実行した結果、
0 failures ... テストの失敗は0
0 errors ... エラーは0
0 skips ... 飛ばしたテストは0
```


## login判定

サーバーサイドではCookieに保存したトークンを検証して、ログインを判定します。
クライアントではサーバーから返された有効期限をログイン判定に使用します。
今回実装した方法は、最低限のセキュリティを考慮したものであって、セキュリティを高ようと思えばもっと改善が必要です。（筆者はそこまでの知識を持ち合わせていない:face_with_head_bandage: ）

ただ、「セキュリティが高ければ高いほど良い」というものでもなく、そこには時間とお金がかかるので、アプリに適したセキュリティ対応を行う必要があります。

まずは「どんなアプリを作るか」を明確にして、「そのアプリのセキュリティはどの程度必要か」を考え、時間とお金を投資しましょう。
