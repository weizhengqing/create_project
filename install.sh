#!/bin/zsh

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

TARGET_DIR="/usr/local/bin"
SCRIPT_NAME="mkproj"
SOURCE_FILE="$(pwd)/mkproj.sh"

echo "正在安装 $SCRIPT_NAME 到 $TARGET_DIR..."

# 第一步：赋予执行权限
chmod +x "$SOURCE_FILE"

# 第二步：创建软链接 (需要 sudo 权限)
sudo ln -sf "$SOURCE_FILE" "$TARGET_DIR/$SCRIPT_NAME"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}[SUCCESS] 安装成功！${NC}"
    echo "现在你可以在终端的任何位置输入 '$SCRIPT_NAME' 来运行它。"
else
    echo -e "${RED}[ERROR] 安装失败，请检查是否具有 sudo 权限或目录状态。${NC}"
fi
