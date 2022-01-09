# Introduction

## How To ?

## Project Startに関して必要なもの

direnv
lefthook

開発に必要なもの

1. 暗号化のファイルを復号する(鍵は担当者からもらってください)

`(make env.encrypt KEY=*********** FILE_PATH="********")`

2. 環境の.envrcを作成する

`(make envrc.make ENVIRONMENT=*****)`

ここでdirenvが勝手に読みこまれれば完了

3. docker 起動

## envを修正したら

再度暗号化するmakeを実行してください。

## memo

docker環境変数
[docker](https://blog.cloud-acct.com/posts/u-env-docker-compose/)

環境作成
[dockdr](https://blog.cloud-acct.com/posts/u-rails-dockerfile)

## 環境変数運用方法

lefthookでmerge後、envが自動設定されるようにする。

## 作業途中

https://blog.cloud-acct.com/posts/u-docker-compose-rails6new/

## Git How to

サブモジュールで運用しているため編集した際には以下運用をする。
**Railsアプリを編集する場合**

1. apiディレクトリでコミットする。
2. rootディレクトリに戻る
3. rootリポジトリもコミットする

これはサブモジュールがdevelopにmergeされた時にやるかなと、main

## docker buildのタイミング

Dockrfile変更時
モジュール管理ファイルを変更した時(Gem, package.json)など。なにかそれをインストールする際に見るもの。

