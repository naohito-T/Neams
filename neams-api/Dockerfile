FROM ruby:3.0
# aptを使う理由はたしかDockerの書籍に書いてあったはず
RUN apt-get update -qq && apt-get install -y curl

RUN mkdir -p /app
WORKDIR /app

# install nodejs(LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && apt-get install -y nodejs

# install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt update && apt install -y yarn

COPY Gemfile* /myapp/
RUN bundle install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# 公開ポートの指定
EXPOSE 3000

# Configure the main process to run when running the image
# イメージ内部に実行するメインプロセスの設定
CMD ["rails", "server", "-b", "0.0.0.0"]

##############################################
#################  MEMO  #####################
##############################################
# @see https://qiita.com/daichi41/items/dfea6195cbb7b24f3419
# [RUN] コマンドの実行。
# [ENTRYPOINT] 一番最初に実行するコマンド
# [CMD] イメージ内部のソフトウェア実行（つまりRailsのことですね）
