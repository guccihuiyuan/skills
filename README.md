# skills

## 安装skills
```shell
npx skills add guccihuiyuan/skills
```

### keyblade-pro-code-rules

pc项目代码规则skill，封装了keyblade-pro的代码规则，生成代码时候必须满足这些规则。

### keyblade-pro-workflow

工作流skill，封装了keyblade-pro的工作流，先使用 brainstorming 进行头脑风暴，在使用 ` writing-plans` 制定计划，再使用 `executing-plans` 执行计划并跟踪进度，最后使用 `keyblade-pro-code-rules` 生成符合规则的AI代码。如果是一个简单的需求，可以直接使用 `keyblade-pro-code-rules` 即可。

同时需要额外安装以下skills，全局/项目 都可以。

```shell
npx skills add https://github.com/obra/superpowers --skill brainstorming
npx skills add https://github.com/obra/superpowers --skill writing-plans
npx skills add https://github.com/obra/superpowers --skill executing-plans
```

### uniapp-vue3-code-rules

uniapp项目代码规则skill，封装了uniapp的代码规则，生成代码时候必须满足这些规则。

### midscene-testing-rules

uniapp项目代码规则skill，封装了uniapp的代码规则，生成代码时候必须满足这些规则。

## 更新skills
```shell
npx skills update
```

## 查看skills
```shell
npx skills list
```
