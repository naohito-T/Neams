# ログの色
R := \e[31m
G := \e[32m
B := \e[34m

# project start
docker-compose down && docker-compose up -d

# ホスト側のマウントディレクトリorファイルを更新したい場合の再起動
restert:
		docker-compose restart

# build configとか設定し直した時のみOK
build:
		docker-compose --env-file ./env/decrypt/common/local.env build
