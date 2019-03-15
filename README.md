# shell-scripts

## vps-init.sh

### 作用

初始化 VPS

### 内容

* 修改密码
* 修改主机名
* 修改时区为中国上海
* 定时时间同步
* 更新软件
* 安装常用软件包
  * wget
  * vim
  * git
  * screen
  * ca-certificates
* 自动配置 ssh 密钥 （使用的是 [KiritoMiao/SSHKEY_Installer](https://github.com/KiritoMiao/SSHKEY_Installer)）
* 一键安装部署 Fail2ban （使用的是 [FunctionClub/Fail2ban](https://github.com/FunctionClub/Fail2ban/)）

#### 自动配置 ssh 密钥

前往 [https://github.com/settings/keys](https://github.com/settings/keys) 绑定公钥，即可在 VPS 使用该公钥。

### 使用方法

必须依次输入三个参数：

* 是否修改密码。值为 `1` 则是修改密码，`0` 则是不修改密码。
* 主机名
* 绑定公钥的 GitHub 用户名

`wget https://github.com/pupilcc/shell-scripts/raw/master/vps-init.sh && bash vps-init.sh [是否修改密码] [主机名] [你的GitHub 用户名]`

## install-rclone.sh

### 作用

安装 rclone 1.41 版本

### 使用方法

`wget https://github.com/pupilcc/shell-scripts/raw/master/install-rclone.sh && bash install-rclone.sh`