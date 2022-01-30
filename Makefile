# makefile注意
# makeは一列のコマンドごとにsh(シェル)を起動する。
# これを避けるためコマンドの終了後とに ; でつなげること
# コンテナ内で任意のコマンドを実行する
# $ docker-compose run <サービス名> <任意のコマンド>

# Dockerイメージを作成する
# $ docker-compose build

# 複数のコンテナの生成し起動する
# $ docker-compose up

# コンテナを停止する
# $ docker-compose stop

# 停止中のコンテナを削除する
# $ docker-compose rm -f

# コンテナの停止・削除を一度に行う
# $ docker-compose down

# コンテナの一覧を表示する
# $ docker-compose ps -a

# ---------------------------------------------------------------#
#  											Variables		 														 #
# ---------------------------------------------------------------#

# ログの色
R := \e[31m
G := \e[32m
B := \e[34m
N := \e[0m

# .envrc書き込みパス
DECODING_COMMON_PATH := dotenv ./env/decrypt/common/.env.
DECODING_API_PATH := dotenv ./env/decrypt/api/.env.
DECODING_FRONT_PATH := dotenv ./env/decrypt/front/.env.

# ---------------------------------------------------------------#
#  											Make for Docker.		 										 #
# ---------------------------------------------------------------#

# project start makeコマンドのみで実行する
.PHONY: start
start:
	docker-compose down && docker-compose up -d

# コンテナの停止・削除を同時に行う
.PHONY: down
down:
	docker-compose down

# ホスト側のマウントディレクトリorファイルを更新したい場合の再起動
restert:
	docker-compose restart

# build Gemfile, Package.jsonとか設定し直した時にイメージを再作成してください。
.PHONY: down
build:
	docker-compose build $(SERVICE)

# プロジェクト内でなにか実行したい時
# $ docker-compose run --rm api bundle info puma インストール確認
.PHONY: run
run:
	docker-compose run --rm $(SERVICE) $(ARG)

# ---------------------------------------------------------------#
#  									  make for API 															 #
# ---------------------------------------------------------------#

# api console login
.PHONY: api.console
api.console:
	docker-compose run --rm api rails c

# apiが返すrouteを確認できます。
.PHONY: api.route
api.route:
	docker-compose run --rm api rails routes

# CLI DB login
.PHONY: login.db
login.db:
	docker-compose run --rm api rails dbconsole

# api install confirmation Code : (make api.confirm GEM=xxx)
.PHONY: api.confirm
api.confirm:
	docker-compose run --rm api bundle info $(GEM)

# api test
.PHONY: api.test
api.test:
	docker-compose run --rm api rails t

# api integration test /app/test/integration
.PHONY: test.integration
test.integration:
	docker-compose run --rm api rails t integration

.PHONY: test.controller
test.controller:
	docker-compose run --rm api rails t controllers

# api controller create (g: generateの簡略)
# Usage : (make create.controller NAMESPACE="Api::V1::Home::UserToken"
.PHONY: create.controller
create.controller:
	docker-compose run --rm api rails g controller $(NAMESPACE)

# 作成したapi controllerを削除する(関連するファイルも削除)
.PHONY: destory.controller
destory.controller:
	docker-compose run --rm api rails destroy controller $(NAMESPACE)

# Seedデータを追加で投入したい時
.PHONY: add.seed
add.seed:
	docker-compose run --rm api rails db:seed

# seedデータを全て削除して、新たに投入したい場合
.PHONY: reset.seed
reset.seed:
	docker-compose run --rm api rails db:reset

# api Model作成
.PHONY: create.model
create.model:
	docker-compose run --rm api rails g model $(NAME) --no-fixture

# Model作成後のマイグレーション テーブル作成(create.model実行後)
.PHONY: migrate
migrate:
	docker-compose run --rm api rails db:migrate

# マイグレーション失敗した場合
.PHONY: reset.migrate
reset.migrate:
	docker-compose run --rm api rails db:migrate:reset

# ---------------------------------------------------------------#
#  												setup make 													 	 #
# ---------------------------------------------------------------#

# @をつけると実行コマンドを標準出力に出力しない。
# 暗号化
.PHONY: env.encrypt
env.encrypt:
	@make _env.encrypt KEY=$(KEY) INPUT=./env/decrypt/$(FILE_PATH) OUTPUT=./env/encrypt/$(FILE_PATH)

# 復号化
.PHONY: env.decrypt
env.decrypt:
	@make _env.decrypt KEY=$(KEY) INPUT=./env/encrypt/$(FILE_PATH) OUTPUT=./env/decrypt/$(FILE_PATH)

# .envrc 作成
.PHONY: envrc.make
envrc.make:
	@make _env.makerc ENVIRONMENT=$(ENVIRONMENT)

# ---------------------------------------------------------------#
#  												make method 													 #
# ---------------------------------------------------------------#

# 暗号化 method
_env.encrypt:
	@if [ -n "$(KEY)" ]; then\
		openssl aes-256-cbc -e -in $(INPUT) -pass pass:$(KEY) | base64 > $(OUTPUT);\
		printf '${B}%s\n' "# 鍵を暗号化し配置しました。→→$(OUTPUT)";\
	else\
		printf '${R}%s\n' "# you need define KEY.\nyou need read README.md.";\
	fi

# 復号化 method
_env.decrypt:
	@if [ -n "$(KEY)" ]; then\
		cat $(INPUT) | base64 -d | openssl aes-256-cbc -d -out $(OUTPUT) -pass pass:$(KEY);\
		printf '${B}%s\n' "# 鍵を復号化し配置しました。→→$(OUTPUT)";\
	else\
		printf '${R}%s\n' "# you need define KEY.\nyou need read README.md.";\
	fi

# .envrc 作成method
# 最初の > で.envrcを必ず上書きします。
_env.makerc:
	@if [ -n "$(ENVIRONMENT)" ]; then\
		printf '${B}%s\n' "# envを.envrcに記載";\
		echo ${DECODING_COMMON_PATH}$(ENVIRONMENT) > .envrc;\
		echo ${DECODING_API_PATH}$(ENVIRONMENT) >> .envrc;\
		echo ${DECODING_FRONT_PATH}$(ENVIRONMENT) >> .envrc;\
		direnv allow;\
		printf '${B}%s\n' "# $(ENVIRONMENT)用の.envrcを作成。\n.envrc done";\
	else\
		printf '${R}%s\n' "# you need define ENVIRONMENT.\nyou need read README.md.";\
	fi
