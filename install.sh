#!/bin/bash

set -e

# 获取linux平台类型，ubuntu还是centos
function get_linux_platform_type()
{
    if which apt-get > /dev/null ; then
        echo "ubuntu" # debian ubuntu系列
    elif which yum > /dev/null ; then
        echo "centos" # centos redhat系列
    elif which pacman > /dev/null; then
        echo "archlinux" # archlinux系列
    else
        echo "invaild"
    fi
}

# 安装centos发行版必要软件
function install_prepare_software_on_centos()
{
    sudo yum install -y ctags automake gcc gcc-c++ kernel-devel cmake python-devel python3-devel curl fontconfig ack
}

# 安装ubuntu发行版必要软件
function install_prepare_software_on_ubuntu()
{
    sudo apt-get install -y ctags build-essential cmake python-dev python3-dev fontconfig curl libfile-next-perl ack-grep
}

# 安装archlinux发行版必要软件
function install_prepare_software_on_archlinux()
{
    sudo pacman -S --noconfirm vim ctags automake gcc cmake python3 python2 curl ack
}

# 拷贝文件
function copy_files()
{
    rm -rf ~/.vimrc
    ln -s ${PWD}/.vimrc ~

    rm -rf ~/.vimrc.local
    cp ${PWD}/.vimrc.local ~

    rm -rf ~/.vim
    mkdir ~/.vim
    rm -rf ~/.vim/colors
    ln -s ${PWD}/colors ~/.vim

    rm -rf ~/.vim/git.vim
    ln -s ${PWD}/git.vim ~/.vim

    rm -rf ~/.vim/functions.vim
    ln -s ${PWD}/functions.vim ~/.vim
}

# 下载插件管理软件vim-plug
function download_vim_plug()
{
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

function copy_vim_plug()
{
    git submodule update --recursive
    mkdir -p ~/.vim/autoload
    cp ./vim-plug/plug.vim ~/.vim/autoload/plug.vim
}

# 安装vim插件
function install_vim_plugin()
{
    vim -c "PlugInstall" -c "q" -c "q"
}

# linux编译ycm插件
function compile_ycm_on_linux()
{
    cd ~/.vim/plugged/YouCompleteMe
    ./install.py --clang-completer
}

function begin_install_calmvim()
{
    copy_files
    copy_vim_plug
    install_vim_plugin
    compile_ycm_on_linux
}

# 在ubuntu发行版安装vimplus
function install_calmvim_on_ubuntu()
{
    install_prepare_software_on_ubuntu
    begin_install_calmvim
}

# 在centos发行版安装vimplus
function install_calmvim_on_centos()
{
    install_prepare_software_on_centos
    begin_install_calmvim
}

# 在archlinux发行版安装vimplus
function install_calmvim_on_archlinux()
{
    install_prepare_software_on_archlinux
    begin_install_calmvim
}

# 在linux平台安装vimplus
function install_calmvim_on_linux()
{
    type=`get_linux_platform_type`
    echo "linux platform type: "${type}

    if [ ${type} == "ubuntu" ]; then
        install_calmvim_on_ubuntu
    elif [ ${type} == "centos" ]; then
        install_calmvim_on_centos
    elif [ ${type} == "archlinux" ]; then
        install_calmvim_on_archlinux
    else
        echo "not support this linux platform type: "${type}
    fi
}

install_prepare_software_on_ubuntu

#begin_install_calmvim
    copy_files
    copy_vim_plug
    install_vim_plugin
    compile_ycm_on_linux

#install_calmvim_on_linux
