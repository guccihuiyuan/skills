#!/bin/sh

DING_WEBHOOK="https://oapi.dingtalk.com/robot/send?access_token=ab48f8ca425f43717f4e665f79dfe1aeb5b31054b24894eb85f0cb44e9b215c2"

# 检查本次提交是否包含 CHANGELOG.md
if ! git diff-tree --no-commit-id --name-only -r HEAD | grep -q "^CHANGELOG.md$"; then
  exit 0
fi

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
      \"title\": \"CHANGELOG 已更新\",
      \"text\": \"我进化啦～\\n\\n### 更新日志\\n${CONTENT}\"
    }
  }" > /dev/null
