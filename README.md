
# Webサーバー構築サンプルCookbook
## 概要
ChefSoloを使って簡単にサーバー環境を構築するサンプルです。  
コマンド数回でnginx+ruby+mysqlをインストール済みのサーバーが完成します。  
Chefを触ったことがない人にこれに使ってChefがどんなものなのか評価してくれたらいいなーってのが目的です。(楽しいので)  
サーバーはさくらのVPS(CentOS6.3)、クライアントはMacOSX10.8.2/ruby1.9.3-p392で検証しています。  
※設定値等は詳細に詰めていないので、本番運用する際には各ソフトウェアの設定値を精査して下さい。  
　なお、本情報によって発生したいかなる損害も一切責任を負いません。自己責任でお願いします。  

## 作業
環境を作る前に以下の作業が必要です。

* リポジトリのclone
* ユーザーパスワードの設定
* ssh公開鍵の登録
* MySQL rootパスワードの設定
* ユーザー名の変更

### リポジトリのclone
リポジトリを任意のディレクトリにcloneして下さい。

```bash
git clone git://github.com/TakatoshiMaeda/webserver-cookbooks.git
```

### <a name="password"></a>ユーザーパスワードの設定
まずはTerminalで以下のコマンドを入力します。  
ダブルクォートで囲まれた箇所には設定したいユーザーのパスワードを入力してください。

```bash
openssl passwd -1 ""
```

出力結果をpassword欄に入力して保存して下さい。

```json
// data_bags/users/foo.json
{
  "id": "foo",
  "uid": "2001",
  "comment": "Example User",
  "password": "", //出力結果を指定
  "ssh_keys": [
    "ssh-rsa ABCDEFGHI....." 
  ],
  "groups": [ "sysadmin" ]
}
```
 
### ssh公開鍵を登録する

ssh公開鍵を登録します。  
以下の2ファイルを変更してください。

```json
// data_bags/users/foo.json
{
  "id": "foo",
  "uid": "2001",
  "comment": "Example User",
  "password": "",
  "ssh_keys": [
    "ssh-rsa ABCDEFGHI....." //自分のssh公開鍵を指定
  ],
  "groups": [ "sysadmin" ]
}
```

``` ruby
# spec/bar.com/user_spec.rb
require 'spec_helper'

describe 'foo' do
  it { should be_user }
  it { should belong_to_group 'sysadmin' }
  it { should have_uid 2001 }
  it { should have_gid 2001 }
  it { should have_authorized_key ''} #自分のssh公開鍵を指定
end
```

### MySQLrootパスワードの設定

以下のファイルを編集してMySQLのrootユーザーパスワードを指定します。

```json
// nodes/bar.com.json

{
  "run_list": [
    "role[base]",
    "role[webserver]",
    "role[dbserver]",
    "role[ruby]",
    "recipe[chefsoloenv]"
   ],
   "mysql": {
     "server_root_password": "", //rootユーザーパスワードを指定
     "server_repl_password": "", //レプリケーションユーザーパスワードを設定。今回のcookbookでは意味が無いが指定しないと動かないので指定する。
     "server_debian_password": "" //debian系OSではメンテナンスユーザーのパスワードが必要らしい。これもないと動かないのでCentOSの場合でも指定する。
   }
}
```

### ユーザー名の変更
このままではユーザー名fooでユーザーが作成されてしまいます。  
普段使っているユーザー名に変更しましょう。※試しに実行してみたい場合には変更しなくてもいいです

```json
// data_bags/users/foo.json
{
  "id": "foo", //ここを変更します
  "uid": "2001",
  "comment": "Example User",
  "password": "",
  "ssh_keys": [
    "ssh-rsa ABCDEFGHI....."
  ],
  "groups": [ "sysadmin" ]
}
```

```ruby
# roles/base.rb
name "base"
description "all server base role"
run_list "recipe[chef-solo-search]", "recipe[users::sysadmins]", "recipe[sudo]", "recipe[openssh]"

default_attributes({
  :authorization => {
    :sudo => {
      :groups => ["sysadmin", "admin", "wheel"],
      :users => ["foo"], #ここを変更します
      :passwordless => false,
      :sudoers_defaults => [
        '!visiblepw',
        'env_reset',
        'env_keep =  "COLORS DISPLAY HOSTNAME HISTSIZE INPUTRC KDEDIR LS_COLORS"',
        'env_keep += "MAIL PS1 PS2 QTDIR USERNAME LANG LC_ADDRESS LC_CTYPE"',
        'env_keep += "LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES"',
        'env_keep += "LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE"',
        'env_keep += "LC_TIME LC_ALL LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY"',
        'env_keep += "HOME"',
        'always_set_home',
        'secure_path = /sbin:/bin:/usr/sbin:/usr/bin'
      ]
    }
  },
  :openssh => {
    :server => {
      :password_authentication => "no"
    }
  }
})
```

```ruby
# spec/bar.com/user_spec.rb

require 'spec_helper'

describe 'foo' do #ここを変更します
  it { should be_user }
  it { should belong_to_group 'sysadmin' }
  it { should have_uid 2001 }
  it { should have_gid 2001 }
  it { should have_authorized_key ''}
end
```

準備完了しました。次にサーバーを作成します。  
作成する環境に応じて[サーバーへの構築](#server)と[仮想環境への構築](#vm)に分けています。

## <a name="server"></a> サーバーへの構築
cloneしたディレクトリで以下のコマンドを実行します  
対象サーバーIPアドレスは構築したいサーバーのIPアドレスを指定して下さい。

```bash
bundle install --path=./vendor/
bundle exec berks install --path=./cookbooks
bundle exec knife solo bootstrap root@対象サーバーIPアドレス -N bar.com
```

knife-soloの実行時に数回パスワードを入力しないといけません。
rubyのビルドが走るため少し時間がかかります。待ちましょう。
実行が完了するとサーバーが出来上がりました。
実際にサーバーが出来ているかテストしてみましょう。

## 構築したサーバーのテスト
サーバーにspecを実行するためにspecファイルの修正をします。

```bash
mv spec/bar.com spec/対象サーバーipアドレス
```
`spec/bar.com`ディレクトリを対象サーバーのipアドレスディレクトリに移動して下さい。
また、テストの実行前に.ssh/configに追記して下さい。

```.ssh/config
Host 対象サーバーIPアドレス
  User foo # 作成したユーザー
  HostName 対象サーバーIPアドレス
```
ここまで編集するとテストが実行出来ます。

```bash
ENV=production SUDO_PASSWORD=***** bundle exec rake spec 
```
*****の箇所には[ユーザーパスワードの設定](#password)で入力したパスワードを指定して下さい  

全てのspecが通ればサーバーは問題なくできています。
指定した公開鍵でログイン出来るはずです。

## <a name="vm"></a>仮想環境を用いた構築/テスト

仮想環境を使ってテストすることができます。
vagrant <http://www.vagrantup.com/>が必要ですのでインストールして下さい。

cloneしたディレクトリで以下のコマンドを実行します。

```bash
vagrant up
bundle exec rake spec
```

仮想環境にレシピが適用された後、テストがオールグリーンになれば成功です。
今回実行したテストは仮想環境に対して行われています。

## 参考リンク


入門Chef Solo - Infrastructure as Code http://tatsu-zine.com/books/chef-solo ※読みやすくお勧めです。

chef-soloのセットアップとchefについての私感 http://qiita.com/items/06b8709abd73aba66d49

Opscode Public Cookbooks https://github.com/opscode-cookbooks

Vagrant http://www.vagrantup.com/

serverspec http://serverspec.org/

[Chef][serverspec]VPSサーバーにnginx+mysql+rubyの環境を30分で構築する http://takatoshimaeda.github.io/blog/2013/05/07/create-server-30-minutes/