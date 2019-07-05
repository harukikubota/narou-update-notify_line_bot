# 本番環境でのテスト
## 前提
1. HerokuSetupが完了済である([手順書](./heroku_setup.md))

## 目次
1. [Botの友達登録](##Botの友達登録)
2. [メッセージの送信](##メッセージの送信)
3. [更新通知の確認](##更新通知の確認)


## Botの友達登録
1. [LINEWebHookURLの登録](##LINEWebhookURLの登録) から続く。
2. 「Bot情報」の `LINEアプリへのQRコード` に記載されている QRコードをLINE で読み込む。

## メッセージの送信
### 小説の登録
なろう小説の `URL` を送信する。

(例： `https://ncode.syosetu.com/n2267be/` )

### 一覧の表示
「一覧」を含むメッセージを送信する。

(例： `一覧を表示して` )

### ヘルプの表示
「ヘルプ」を含むメッセージを送信する。

（例： `ヘルプ出して` ）

## 更新通知の確認
### Herokuでタスク実行
※※※※※　本番環境での実行により、全利用者に影響が出る操作のため注意!!!　※※※※※
``` bash
heroku run rake update_novel_last_episode_id_minus_one
heroku run rake narou_update_check_and_notify_update_episode
```
登録している小説一覧が表示される。
