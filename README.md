# FreePBX を使った Asterisk 環境の構築

## 概要
* FreePBXを使ったAsterisk環境を構築するためのAnsible Playbook
* Multipassを使った仮想環境、または、raspberry pi上のUbuntu Server 22.04 LTSでの構築を想定している

## Multipass環境
### 事前準備
* Multipassのインストール
```
$ brew install ansible
$ brew install --cask multipass
```

* `cloud-config.yaml`を`cloud-config.yaml.template`をコピーして作成し、`ssh_authorized_keys`に公開鍵を記述

* Multipassのネットワークの確認
```
$ multipass networks
```

* Multipassのネットワークの指定して仮想マシンを作成
  * 例: `en0`を指定して仮想マシンを作成
  * 指定したネットワークにブリッジ接続された仮想マシンが作成される
```
$ make create network=en0
```
* 仮想マシンのIPアドレスを確認
```
$ make info
```

* 仮想マシンのIPアドレスを`/inventory/hosts.ini`に記述
* Playbookを実行して環境を構築する
```
$ make provision
```

* ブラウザで`http://<ipアドレス>/admin`にアクセスしてFreePBXの設定画面が表示されることを確認
* sshで仮想マシンにログインできることを確認する
```
$ ssh -i ~/.ssh/id_rsa ubuntu@<ipアドレス>
```

## Asteriskの設定
### MOH用の音声ファイルの制限
* 利用する音声ファイルは8000Hzのサンプリングレートをもつwavファイルであること
* サンプリングレートが異なる場合はffmpegなどで変換すること

```bash
$ ffmpeg -i input.wav -ar 8000 output.wav
```
