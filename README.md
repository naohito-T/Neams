# Introduction

エンタープライズアプリ

## Project Start

```sh
# プロジェクト初期時: サブモジュールごとcloneする。
$ git clone --recursive []

# サブモジュールをcloneし忘れたら
$ git submodule update --init --recursive

# 暗号化のファイルを復号する(鍵は担当者からもらってください)
# zshでの環境変数渡し、bashは適宜参照してください。
$ (make env.decrypt KEY=*********** FILE_PATH="********")

# local環境の.envrcを作成する
$ (make envrc.make ENVIRONMENT=local)
# ここでdirenvが勝手に読みこまれれば完了

# docker 起動(Makefile run targetが実行されます。)
$ make

```

## deploy

本番環境はHerokuを使用。
Herokuにアプリケーションが作成できると、gitのリモートリポジトリが1つherokuという名前で登録される。
Herokuのgitリポジトリのmasterブランチへpushすることにより、Heroku上で自分が作ったRailsアプリケーションを動かすことが可能

```sh
# production環境の.envrcを作成し読み込む
$ (make envrc.make ENVIRONMENT=pro)
```

下記のコマンドを実行してHerokuへアプリケーションをデプロイしてください。
```sh
# 現在masterにいる場合
$ git push heroku master

# 現在の作業しているブランチが masterでない場合には、以下のように現在の作業ブランチから Heroku の master ブランチへpushします。
# masterではい別ブランチの場合
$ git push heroku 現在のブランチ名:master
```

heroku Tips

```sh
# herokuの設定を確認する
$ heroku config

# ユーザーテーブルの作成
api $ heroku run rails db:migrate

# Seedデータの投入
api $ heroku run rails db:seed

# herokuオープン
api $ heroku open

```

## deploy check

```sh
$ curl -v -X POST \
https://<Herokuアプリ名>.herokuapp.com/api/v1/user_token \
-H 'Content-Type: application/json' \
-d '{"auth":{"email":"user0@example.com", "password":"password"}}'
```

## What you need to know about project start

```sh

$ brew install direnv
$ brew install lefthook

```

## envを修正したら

再度暗号化するmakeを実行してください。

## memo

docker環境変数
[docker](https://blog.cloud-acct.com/posts/u-env-docker-compose/)

環境作成
[dockdr](https://blog.cloud-acct.com/posts/u-rails-dockerfile)

## Git How to

サブモジュール運用をしております。

1. サブモジュールで作業をしコミットする。
2. rootディレクトリに戻る
3. rootリポジトリもコミットする

上記の制約があるためサブモジュールでプルリクを作成しdevelopにmergeをしたらlefthookが作動するようになっております。

## docker buildのタイミング

Dockrfile変更時
モジュール管理ファイルを変更した時(Gem, package.json)など。なにかそれをインストールする際に見るもの。

## やること

[アスキーアート(AA)](https://qiita.com/kenzooooo/items/9bc3520215a7d9823608)

## Heroku How To

マニフェストの確認
setupに記述した設定がうまくいっているかHeroku管理画面から確認してみる。

[Heroku Dashbord](https://dashboard.heroku.com/apps)

## 必要なenv

```yml
db
コンテナに渡す
TZ: $TIME_ZONE
PGTZ: $TIME_ZONE
POSTGRES_USER: $POSTGRES_USER
POSTGRES_PASSWORD: $POSTGRES_PASSWORD

api
dockerfileに渡す
args:
WORKDIR: $WORKDIR

コンテナに渡す
API_DOMAIN: ${HOST}:${FRONT_PORT}
POSTGRES_USER: $POSTGRES_USER
POSTGRES_PASSWORD: $POSTGRES_PASSWORD

front
Dockerfileに渡す
WORKDIR: $WORKDIR
CONTAINER_PORT: $CONTAINER_PORT # 3000
API_URL: "${SCHEME}${HOST}:${API_PORT}" # http://localhost:3000
```

## Docker 掃除

```sh
$ docker image prune
$ docker container prune
$ docker volume prune
```
