# Introduction

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

