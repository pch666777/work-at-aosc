#!/bin/bash

# 必须先设置指定的路径
AOSC_TREE="/home/pngchs/build/amd64/TREE"
AOSC_SRCS="/home/pngchs/build/other/SRCS"

# 构架目录
AOSC_ARCH=("amd64" "arm64" "loong64" "loong64_nosimd" "loong3" "ppc" "rv")

relink_dir(){
    echo "-----------------------------------------"
    if [ ! -e "$BASE_DIR/$1" ]; then
        echo "构架不存在：$1"
        return 0
    fi
    # 处理SRCS
    if test -e "$BASE_DIR/$1/SRCS"; then
        echo "清理：$1/SRCS"
        rm -rfv "$BASE_DIR/$1/SRCS"
    fi
    ln -s "$AOSC_SRCS" "$BASE_DIR/$1/SRCS"
    echo "$AOSC_SRCS --> $BASE_DIR/$1/SRCS"
    # 处理TREE
    if [ -e "$BASE_DIR/$1/TREE" ]; then
        # 只要是软连接，则清理
        if [ -h "$BASE_DIR/$1/TREE" ]; then
            rm -rf "$BASE_DIR/$1/TREE"
            echo "清理: $1/TREE"
        else
            echo "保留 $1/TREE"
        fi
    fi
    # TREE 路径不存在则连接
    if [ ! -e "$BASE_DIR/$1/TREE" ]; then
        # 还要再清理一次，因为可能遇到指向无效目录的软连接
        rm -rf "$BASE_DIR/$1/TREE"
        ln -s "$AOSC_TREE" "$BASE_DIR/$1/TREE"
        echo "$AOSC_TREE --> $1/TREE"
    fi
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

# 连接安同的 TREE 目录，以及 SRCS
link_asoc(){
    for this_arch in "${AOSC_ARCH[@]}"; do
        relink_dir "$this_arch" "$AOSC_TREE"
    done
}

link_my_asoc(){
    echo "不支持的操作！"
}

create_dir(){
    for this_arch in "${AOSC_ARCH[@]}"; do
        mkdir "$this_arch"
    done
    mkdir "other"
    mkdir "other/SRCS"
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
