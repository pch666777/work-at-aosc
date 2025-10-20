#!/bin/bash

relink_dir(){
    if [ ! -e "$BASE_DIR/$1" ]; then
        echo "目录不存在：$1"
        return 0
    fi
    if test -e "$BASE_DIR/$1/SRCS"; then
        echo "清理：$1/SRCS"
        rm -rf "$BASE_DIR/$1/SRCS"
    fi
    if test -e "$BASE_DIR/$1/TREE"; then
        echo "清理 $1/TREE"
        rm -rf "$BASE_DIR/$1/TREE"
    fi

    ln -s "$BASE_DIR/base/SRCS" "$BASE_DIR/$1/SRCS"
    echo "$BASE_DIR/base/SRCS --> $BASE_DIR/$1/SRCS"

    ln -s "$BASE_DIR/base/$2" "$BASE_DIR/$1/TREE"
    echo "$BASE_DIR/base/$2 --> $BASE_DIR/$1/TREE"
}

clear_dir_one(){
    if [ ! -e "$BASE_DIR/$1" ]; then
        echo "目录不存在：$1"
        return 0
    fi
    cd "$BASE_DIR/$1"
    echo "准备清理：$1"
    sudo ciel clean
}

clear_dir(){
    clear_dir_one "rv"
    clear_dir_one "amd64"
    clear_dir_one "arm64"
    clear_dir_one "ppc"
    clear_dir_one "loong3"
    clear_dir_one "loong64"
    clear_dir_one "loong64_nosimd"
}

link_asoc(){
    relink_dir "rv" "aosc-TREE"
    relink_dir "amd64" "aosc-TREE"
    relink_dir "arm64" "aosc-TREE"
    relink_dir "ppc" "aosc-TREE"
    relink_dir "loong3" "aosc-TREE"
    relink_dir "loong64" "aosc-TREE"
    relink_dir "loong64_nosimd" "aosc-TREE"
}

link_my_asoc(){
    relink_dir "rv" "my-TREE"
    relink_dir "amd64" "my-TREE"
    relink_dir "arm64" "my-TREE"
    relink_dir "ppc" "my-TREE"
    relink_dir "loong3" "my-TREE"
    relink_dir "loong64" "my-TREE"
    relink_dir "loong64_nosimd" "aosc-TREE"
}

create_dir(){
    mkdir "./base"
    mkdir "./base/SRCS"
    mkdir "./amd64"
    mkdir "./arm64"
    mkdir "./loong3"
    mkdir "./loong64"
    mkdir "./ppc"
    mkdir "./rv"
    mkdir "./loong64_nosimd"
}


BASE_DIR=$(pwd)
echo "当前工作目录：$BASE_DIR"

echo "1-连接 aosc 目录"
echo "2-连接 my-aosc 目录"
echo "3-清理所有构架"
echo "4-创建所有构架目录"

read -p "请输入操作数字 (1-4): " choice
case $choice in
    1) link_asoc ;;
    2) link_my_asoc ;;
    3) clear_dir ;;
    4) create_dir ;;
    *) echo "无效输入" ;;
esac

echo "执行完成"
