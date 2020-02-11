# [Qiita_clone1](https://qiita-qlone-stg.herokuapp.com/)　
## Over View
[take off rails](https://freelance.cat-algorithm.com/) の課題で学習した、Qiitaのクローンアプリです。
- Ruby version 2.6.2
- vue version 2.6.10
- Docker
- Rspec

## Description
Qiitaの機能の一部を真似て作成しました。

### 機能一覧
- ユーザー登録、ログイン、ログアウト機能
- 下書き投稿、本番公開投稿(Markdown記法・シンタックスハイライト)
- 記事一覧表示
- 記事編集、削除
- マイページ一覧表示（本番公開記事のみ）
- 下書き一覧表示（自身の記事のみ）

APIはRails, フロントはVueで作成しました。

＊　フロントは教材のサンプルコードをコピーしているため、自分で実装はしておりません。

Rspecによる、model,APIのテストを実装しております。
Dockerをとりいれました
CircleCIの導入も試みましたが、現在は上手くいっておりません


ログイン、ログアウト機能の実装には`devise-token-auth`を導入し、公式ドキュメント等を参考にして、実装しました。

herokuへのデプロイも行いました。
https://qiita-qlone-stg.herokuapp.com/

