# README
## ENVIROMENT
* Ruby version
2.5.3

## server
* [heroku](https://dashboard.heroku.com)
* [LINEMessaging API ドキュメント](https://developers.line.biz/ja/docs/messaging-api/overview/)
* [なろう API ドキュメント](https://dev.syosetu.com/man/api/)

## WebSite
* [LINE Official Account Manager](https://manager.line.biz)
* [LINE Developers](https://developers.line.biz/ja/)

## Configuration
### setup development environment
``` bash
git clone git@github.com:harukikubota/narou-update-notify_line_bot.git
bundle update && bundle install
```

### Database creation
``` bash
# local
rake db:migrate

# heroku
heroku run rake db:migrate
```

### Database initialization
``` bash
# local
rake db:seed

# heroku
heroku run rake db:seed
```

### SERVER START
``` bash
# local
rails s
curl localhost:3000/

# heroku
heroku restart
curl https://line-bot-notify-novel-update.herokuapp.com/
```

### その他手順書
* [LINE アカウント設定](/doc/environment_construction_procedure/line_account.md)
* [Heroku 環境構築](/doc/environment_construction_procedure/heroku_setup.md)
* [本番環境でのテスト](/doc/environment_construction_procedure/environment_test.md)

## DEVEROP
### Console
``` bash
# local
rails c

# heroku
heroku run rails c
```

### View logs
``` bash
# local
cd log; view development.log

# heroku
heroku logs --tail
```

### Services (job queues, cache servers, search engines, etc.)
``` bash
# 更新通知ジョブ lib/task/notify_narou_update.rake
rake narou_update_check_and_notify_update_episode

# デバッグ用 登録されている小説の最新話を通知できるようにする
rake update_novel_last_episode_id_minus_one
```

### Deployment instructions
``` bash
git add .
git commit -m "xxx something"
git push origin master
git push heroku master
```
