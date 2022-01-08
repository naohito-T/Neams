# makefile注意
# makeは一列のコマンドごとにsh(シェル)を起動する。
# これを避けるためコマンドの終了後とに ; でつなげること


# ログの色
R := \e[31m
G := \e[32m
B := \e[34m
N := \e[0m

# .envrc書き込み内容
DECODING_COMMON_PATH := dotenv ./env/decrypt/common/.env.
DECODING_API_PATH := dotenv ./env/decrypt/api/.env.
DECODING_FRONT_PATH := dotenv ./env/decrypt/front/.env.


# project start makeコマンドのみで実行する
run:
	docker-compose down && docker-compose up -d

# ホスト側のマウントディレクトリorファイルを更新したい場合の再起動
restert:
	docker-compose restart

# build configとか設定し直した時のみOK
build:
	docker-compose build;\


# コンテナの停止・削除を同時に行う
down:
	docker-compose down;

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
# 最初の > で必ず上書きします。
_env.makerc:
	@if [ -n "$(ENVIRONMENT)" ]; then\
		printf '${B}%s\n' "# envを.envrcに記載";\
		echo ${DECODING_COMMON_PATH}$(ENVIRONMENT) > .envrc;\
		echo ${DECODING_API_PATH}$(ENVIRONMENT) >> .envrc;\
		echo ${DECODING_FRONT_PATH}$(ENVIRONMENT) >> .envrc;\
		printf '${B}%s\n' "# $(ENVIRONMENT)用の.envrcを作成。\n.envrc done";\
	else\
		printf '${R}%s\n' "# you need define ENVIRONMENT.\nyou need read README.md.";\
	fi

