## 概要
Sinatraを使って、メモを作成、編集、削除、一覧を表示する機能があります。

## 手順
1. `git clone`を使ってローカルに複製する。
```
git clone https://github.com/zecky1120/sinatra.git
```
2. `sinatra`ディレクトリに移動する
```
cd sinatra
```
3. `bundle install`を実行する。（必要なGemをインストール）
```
bundle install
```

## テーブルを作成する

1. PostgreSQLでログインする
```
% psql -U アカウント名
```
2. データベースを作成する
```
アカウント名=# CREATE DATABASE memo_app;
```
3. `psql`を一旦終了する
```
アカウント名=# \q
```
4. `memo_app`に接続する
```
% psql memo_app
```
5. テーブルを作成する
```
CREATE TABLE memos
(id serial PRIMARY KEY,
title VARCHAR(100) NOT NULL,
content text,
created_at timestamp NOT NULL);
```
6. `ruby main.rb`を実行する
```
% ruby main.rb
```
ブラウザで[http://127.0.0.1:4567](http://127.0.0.1:4567)にアクセスする。
