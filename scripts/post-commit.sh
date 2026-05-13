#!/bin/sh

DING_WEBHOOK="https://oapi.dingtalk.com/robot/send?access_token=fa90e3077e423ee233192ce3ed31a862c58fc4e8c3dac101e63a3ab6b204d854"

# 检查本次提交是否包含 CHANGELOG.md 或 skills 目录下的文件
if ! git diff-tree --no-commit-id --name-only -r HEAD | grep -q -E "^skills/"; then
  exit 0
fi

echo "到这里了"

# 提取最新一条变更内容（第一个 ## 之后到下一个 ## 之前）
CONTENT=$(git show HEAD:CHANGELOG.md | awk '
  BEGIN { flag=0 }
  /^## / {
    if (flag == 1) exit
    flag = 1
    next
  }
  flag { print }
')

# 空内容则跳过
[ -z "$CONTENT" ] && exit 0

# 发送钉钉消息
curl -s "$DING_WEBHOOK" \
  -H "Content-Type: application/json" \
  -d "{
    \"msgtype\": \"markdown\",
    \"markdown\": {
      \"title\": \"skills 已更新\",
      \"text\": \"我进化啦～\\n\\n### 更新日志\\n${CONTENT}\"
    }
  }" > /dev/null
