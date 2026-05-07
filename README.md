# skills

## 安装
### 1.keyblade-pro-code-rules
代码规则skill，封装了keyblade-pro的代码规则，生成代码时候必须满足这些规则。
```shell
npx skills add https://github.com/guccihuiyuan/skills --skill keyblade-pro-rules
```

### 2.keyblade-pro-workflow
工作流skill，封装了keyblade-pro的工作流，先使用 brainstorming 进行头脑风暴，在使用 ` writing-plans` 制定计划，最后使用 `keyblade-pro-code-rules` 生成符合规则的AI代码。如果是一个简单的需求，可以直接使用 `keyblade-pro-code-rules` 即可。
```shell
npx skills add https://github.com/guccihuiyuan/skills --skill keyblade-pro-workflow
```
