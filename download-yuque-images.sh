#!/bin/bash

# 下载语雀图片脚本

DOCS_DIR="/home/ep/ep_blog/my-note/docs"
YUQUE_DIR="$DOCS_DIR/assets/images/yuque"

# 所有图片URL列表
declare -a URLs=(
"https://cdn.nlark.com/yuque/0/2026/png/61267216/1768544670595-119b546a-d430-450f-9447-1ccb0f2cba32.png"
"https://cdn.nlark.com/yuque/0/2026/png/61267216/1768540812020-0084b8ba-8848-45bc-99f3-31b39d362a19.png"
"https://cdn.nlark.com/yuque/0/2026/gif/61267216/1768541414751-1bbd9ad9-c878-4651-9fc6-a52d6e80e746.gif"
"https://cdn.nlark.com/yuque/0/2026/png/61267216/1768543003811-c8840b00-050e-450a-ade5-4ead8287e164.png"
"https://cdn.nlark.com/yuque/0/2026/png/61267216/1768543071943-7aef81db-7237-4160-9388-60996cd28f14.png"
"https://cdn.nlark.com/yuque/0/2026/png/61267216/1768546101265-857d7fa1-a8d3-46b8-9569-e0bb1cf177f5.png"
"https://cdn.nlark.com/yuque/0/2026/png/61267216/1768550046501-8472a7f6-faf6-4e84-9137-d0f101d40216.png"
"https://cdn.nlark.com/yuque/0/2026/png/61267216/1768549805276-f9b47b9b-a17b-4a59-a631-8c65c10b2d96.png"
"https://cdn.nlark.com/yuque/0/2026/png/61267216/1768567435954-862db6c1-5aaf-4a61-8d17-8a50d947bf84.png"
"https://cdn.nlark.com/yuque/0/2026/png/61267216/1768830338668-501703df-b30c-49fc-97af-27e47b5d11dc.png"
"https://cdn.nlark.com/yuque/0/2026/png/61267216/1768720419103-2a6c1d6c-9dc0-41e3-8701-a0ff1d1ea16c.png"
"https://cdn.nlark.com/yuque/0/2026/png/61267216/1768719738362-e0093395-d7b9-47ee-81a0-6d4c19a17bd4.png"
"https://cdn.nlark.com/yuque/0/2026/png/61267216/1768719940838-b85209c7-3f0a-4029-94c3-28875b98c4aa.png"
"https://cdn.nlark.com/yuque/0/2026/png/61267216/1768721129365-de628cba-7fb4-4e74-a641-b0a70b980d0f.png"
"https://cdn.nlark.com/yuque/0/2026/png/61267216/1768720045956-539a0c21-f372-4609-b799-d407b124eb01.png"
"https://cdn.nlark.com/yuque/0/2026/png/61267216/1768720195851-3af19557-1f0a-4a25-a540-a030e998db63.png"
"https://cdn.nlark.com/yuque/0/2026/png/61267216/1769072055859-e8a6aebc-de17-4e26-9e89-12633b06ca79.png"
"https://cdn.nlark.com/yuque/0/2026/png/61267216/1768719311660-1f8e97fd-c6ad-4a3-8f20-ff4c07488714.png"
"https://cdn.nlark.com/yuque/0/2026/png/61267216/1768832699910-0b7abc83-3a19-4a6a-b434-4e789f804f94.png"
"https://cdn.nlark.com/yuque/0/2026/png/61267216/1768809948076-168acd71-0caa-44be-9c43-75d17c8e41cc.png"
"https://cdn.nlark.com/yuque/0/2026/png/61267216/1768826440254-81ddcdf8-4fe7-497e-b924-dd127de4b515.png"
)

n=1
for url in "${URLs[@]}"; do
    filename=$(echo "$url" | sed 's/.*\///' | sed 's/\?.*//')
    echo "下载 $n: $filename"
    curl -sL "$url" -o "$YUQUE_DIR/$filename"
    if [ $? -eq 0 ]; then
        echo "  成功"
    else
        echo "  失败"
    fi
    n=$((n+1))
done

echo "完成！共下载 $(ls $YUQUE_DIR | wc -l) 个文件"