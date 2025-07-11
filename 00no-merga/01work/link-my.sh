#!/bin/bash

relink_dir(){
    if [ ! -d "$BASE_DIR/$1" ]; then
        echo "目录不存在：$1"
        return 0
    fi
    if test -d "$BASE_DIR/$1/SRCS"; then
        echo "清理：$1/SRCS"
        rm -rf "$BASE_DIR/$1/SRCS"
    fi
    if test -d "$BASE_DIR/$1/TREE"; then
        echo "清理 $1/TREE"
        rm -rf "$BASE_DIR/$1/TREE"
    fi

    ln -s "$BASE_DIR/base/SRCS" "$BASE_DIR/$1/SRCS"
    echo "$BASE_DIR/base/SRCS --> $BASE_DIR/$1/SRCS"

    ln -s "$BASE_DIR/base/my-TREE" "$BASE_DIR/$1/TREE"
    echo "$BASE_DIR/base/my-TREE --> $BASE_DIR/$1/TREE"
}

BASE_DIR=$(pwd)
echo "当前工作目录：$BASE_DIR"
relink_dir "rv"
relink_dir "amd64"
relink_dir "ppc"
relink_dir "loong3"
relink_dir "loong64"
