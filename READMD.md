# Introduction

## How To ?

## Project Startに関して必要なもの

direnv
lefthook

## memo

片方dockerで片方dockerじゃない場合はどうなる？？
これを調査する目的も兼ねて、nuxtはコンテナ化せずに対応する。
これはnuxtもコンテナ化する方法で記載する。

docker環境変数
[docker](https://blog.cloud-acct.com/posts/u-env-docker-compose/)

環境作成
[dockdr](https://blog.cloud-acct.com/posts/u-rails-dockerfile)

## 環境変数運用方法

makefileで.envrcを上書きする。
.envrcは読み込み先を変更する(プロダクトごと)
最終的にはdocker-composeを起動しておきたい。
lefthookでmerge後、envが自動設定されるようにする。
