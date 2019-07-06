# Heroku SetUp
## 前提
1. Herokuアカウントが作成済である([参考](https://qiita.com/Daiji-Nagashima/items/755ee75ebc72281a6a82))
2. HerokuCLIを導入済である([参考](https://qiita.com/Daiji-Nagashima/items/755ee75ebc72281a6a82))
3. LineBotが作成済である([手順書](./line_account.md))
4. LineDevelopersからチャンネルトークン、チャンネルシークレットを取得済である(3の手順書内に記載)
5. プロジェクトをクローン済である([README.mdを参照](/README.md))

## 目次
1. [Herokuへのログイン](##Herokuへのログイン)
2. [アプリのデプロイ](##アプリのデプロイ)
3. [本番環境構築](##本番環境構築)
4. [LINEWebHookURLの登録](##LINEWebhookURLの登録)

## Herokuへのログイン
### ログイン
``` bash
heroku login
```
Herokuのサイトが表示されるので、表示に従いログインする。

## アプリのデプロイ
### アプリの作成
``` bash
heroku create `アプリ名`
```
アプリ名は任意のもので構わないが、 `url` に使用されるため気をつける。

アプリ名は全ての `Heroku App` で一意のため、エラーが発生したら他を使用する。

### Herokuへのデプロイ
``` bash
git push heroku master
```

## 本番環境構築
### DBのマイグレーション
``` bash
heroku run rake db:migrate
```

### 環境変数の設定
``` bash
heroku config:set LINE_CHANNEL_SECRET='チャンネルシークレット'
heroku config:set LINE_CHANNEL_TOKEN='チャンネルトークン'
heroku config:add LANG=ja_JP.UTF-8
heroku config:add TZ=Asia/Tokyo
```
設定する値は[LINEアカウント設定手順書](./line_account.md)で取得したもの。

### タスクの登録(Terminal編)
``` bash
heroku addons:create scheduler:standard --app `アプリ名`
heroku addons:open scheduler
```
タスクをスケジューラに登録する。

スケジューラを使用するにはクレジットカードの登録が必要。（フリープランでも可能）

[以下のページ](https://reasonable-code.com/heroku-cron/)を参照。

### タスクの登録(Heroku編)
* `Add new job` をクリックする。
* 実行間隔は `Every 10 minutes` のまま。（１時間でも問題なし）
* `$ ` に `rake narou_update_check_and_notify_update_episode` を入力する。
* `Save Job` をクリックする。

## LINEWebhookURLの登録
### 登録
1. [LINE Developers](https://developers.line.biz/ja/) へアクセスする。
2. 右上のアカウントメニューから登録したBotのページを開く。
3. サイドバーのプロバイダー、個人、Botのページを開く。
4. 「メッセージ送受信設定」の `Webhook送信` を `利用する` に変更する。
5. 「メッセージ送受信設定」の `Webhook URL` に `HerokuApp` の `URL` を入力する。(`xxx.herokuapp.com/`)
6. 「メッセージ送受信設定」の `Webhook URL` の `接続確認` をクリックする。（「成功しました。」が表示されればOK）
