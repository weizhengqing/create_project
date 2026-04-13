#!/bin/zsh

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

TARGET_DIR="$HOME/.local/bin"
SCRIPT_NAME="mkproj"
SOURCE_FILE="$(pwd)/mkproj.sh"

echo "正在安装 $SCRIPT_NAME 到 $TARGET_DIR..."

# 第一步：赋予执行权限
chmod +x "$SOURCE_FILE"

# 第二步：确保目标目录存在
mkdir -p "$TARGET_DIR"

# 第三步：创建软链接
ln -sf "$SOURCE_FILE" "$TARGET_DIR/$SCRIPT_NAME"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}[SUCCESS] 安装成功！${NC}"
    echo "现在你也可以在终端的任何位置输入 '$SCRIPT_NAME' 来运行它。"
    # 检查 PATH 是否包含目标目录
    if [[ ":$PATH:" != *":$TARGET_DIR:"* ]]; then
        echo -e "${RED}提示: $TARGET_DIR 不在你的 PATH 中。${NC}"
        echo "请将以下行添加到你的 ~/.zshrc 或 ~/.bashrc:"
        echo "  export PATH=\"$TARGET_DIR:\$PATH\""
    fi
else
    echo -e "${RED}[ERROR] 安装失败，请检查目录状态。${NC}"
fi
else
    echo -e "${RED}[ERROR] 安装失败，请检查目录状态。${NC}"
fi
