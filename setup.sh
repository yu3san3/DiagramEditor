#!/bin/bash

# プロジェクトのルートディレクトリからスクリプトが実行されることを想定
# 'hooks' フォルダが存在するか確認
if [ -d "./hooks" ]; then
    # '.git/hooks' ディレクトリが存在するか確認し、存在しなければ作成
    if [ ! -d "./.git/hooks" ]; then
        mkdir ./.git/hooks
    fi

    # 'hooks' フォルダの内容を '.git/hooks' にコピー
    cp -r ./hooks/* ./.git/hooks/

    # コピーしたスクリプトに実行権限を付与
    chmod -R +x ./.git/hooks/

    echo "Hooks have been successfully copied to .git/hooks."

    exit 0
else
    echo "Error: 'hooks' directory does not exist."

    exit 1
fi
