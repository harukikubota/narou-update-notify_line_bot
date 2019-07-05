# LINE Account
## 前提
1. 個人利用のLINEアカウントを所持している

## 目次
1. [Botの作成](##Botの作成)
2. [Botの設定](##Botの設定)
3. [API利用の準備](##API利用の準備)

## Botの作成
[以下のページ](https://qiita.com/y428_b/items/d2b1a376f5900aea30dc)を参考にBotを登録する。

## Botの設定
[LINE Account Page](https://manager.line.biz/)からBotのページへアクセスする。

### ホームタブ
メッセージの設定など。
* あいさつメッセージ（友達登録時のメッセージ）
* 応答メッセージ（OFF）

### 分析
情報を見れる。

ここから pushメッセージ送信数を確認できる。（月1000件まで）

### アカウントページ
ユーザからの見方を確認できる。

### 設定タブ
プロフィール設定ができる。
* アカウント名
* プロフィール画像
* 背景画像

## API利用の準備
### LINE Developers
1. [LINE Developers](https://developers.line.biz/console/profile/)へアクセスする。
2. サイドバー、プロバイダー、個人、Botを選択する。
3. 「Channel Secret」、「アクセストークン」を控える。（[Heroku手順書](./heroku_setup.md)で使用する）

