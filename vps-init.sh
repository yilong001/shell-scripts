#!/bin/bash
# VPS 初始化

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

# 系统版本
os_num=0


# 修改密码
is_password=$1
# 主机名
hostname=$2
# ssh key pub url
ssh_key_url=$3
# sshkey 文件
authorized_keys=~/.ssh/authorized_keys
# raw url
raw=https://raw.githubusercontents.com

# 参数个数
declare -i COUNT=0

for i in "$@"
do
    let COUNT+=1
done

# 系统检测
check_os()
{
    source /etc/os-release
    case $ID in
        debian|ubuntu)
            os_num=1
            ;;
        centos)
            os_num=2
            ;;
    esac
}

# 验证参数个数
check_param_count(){
    if [ $COUNT != 3 ]
    then
        echo -e "${Error} 终止脚本运行，请输入正确参数个数。"
        exit
    fi
}

# 是否修改密码
change_password(){
    if [ $is_password -eq 1 ] || [ $is_password -eq 0 ]
    then
        # 修改密码
        if [ $is_password = 1 ]
        then
            echo -e "${Info} 修改密码"
            passwd
        fi

        # 不修改密码
        if [ $is_password = 0 ]
        then
            echo -e "${Info} 不修改密码"
        fi
    else
        echo -e "${Error} 请输入正确的参数值来决定是否修改密码"
        exit
    fi
}

# 修改主机名
change_hostname(){
    echo -e "${Info} 修改主机名为 ${Green_font_prefix}${hostname}${Font_color_suffix}"
    echo $hostname > /etc/hostname
}

# 安装时间同步服务
install_chrony_debian(){
    apt -y install chrony
}
install_chrony_centos(){
    yum -y install chrony
}

# 设置时间同步
timesync(){
    systemctl status chronyd
    systemctl enable chrony
    # 设置时区
    timedatectl set-timezone Asia/Shanghai
    # 设置完时区后，在强制同步下系统时钟
    chronyc -a makestep
}

# 更新软件
update_soft_debian(){
    apt-get -y update
}
update_soft_centos(){
    yum -y update
}

# 安装常用软件包
install_soft_debian(){
    apt-get install -y wget git vim screen ca-certificates ntpdate acpid cloud-init curl

}
install_soft_centos(){
    yum install -y wget git vim screen ca-certificates ntpdate acpid cloud-init curl
}

# 安装 speedtest
install_speedtest(){
    curl -fsSL git.io/speedtest-cli.sh | bash
}

# 拉取远端 vimrc
get_vimrc(){
    wget -P ~ ${raw}/pupilcc/dotfiles/master/vim/.vimrc
}

# 添加 ssh 公钥
add_sshkey(){
    wget ${raw}/P3TERX/SSH-Key-Installer/master/key.sh 
    chmod +x key.sh
    bash key.sh -ou ${ssh_key_url}
}

# 重启
system_reboot(){
    echo -e "${Info} VPS 重启中..."
    reboot
}

main(){
    check_os
    check_param_count
    change_password

    if [ $os_num == 1 ]; then
        echo -e "${Info} 更新软件"
        update_soft_debian

        echo -e "${Info} 安装常用软件包"
        install_soft_debian

        echo -e "${Info} 修改时区为 ${Green_font_prefix}上海${Font_color_suffix}"
        install_chrony_debian
    fi

    if [ $os_num == 2 ]; then
        echo -e "${Info} 更新软件"
        update_soft_centos

        echo -e "${Info} 安装常用软件包"
        install_soft_centos

        echo -e "${Info} 修改时区为 ${Green_font_prefix}上海${Font_color_suffix}"
        install_chrony_centos
    fi

    timesync
    install_speedtest
    change_hostname
    get_vimrc
    add_sshkey
    system_reboot
}

main
