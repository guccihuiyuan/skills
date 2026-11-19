---
name: keyblade-pro-code-rules
description: >
  当用户要求生成、修改或审查 Vue3 + TypeScript + Arco Design 子项目代码时触发。
  覆盖 kb-pro-table / useTable / useForm 使用规范、arco design + unocss 样式规则。
  模块组织与命名规范、枚举与类型约束、ref 优先的响应式规范等。
  无论用户是否明确提到"规范"或"规则"，只要涉及 Vue3 + TypeScript + Arco Design 子项目的代码编写就应使用此 skill。
---

# 项目编码规范

## 适用范围

本项目是 **pnpm monorepo**，包含多个子项目。本规范**仅适用于使用以下技术栈的子项目**：

- vue3 + TypeScript + vite + arco design + unocss

**判断方式**：查看目标目录下是否有 `vite.config.ts` 且 `package.json` 中包含上述依赖。

如果用户操作的是 Vue2、React、Node.js 等其他技术栈的子项目，**不适用**本规范中的 Vue3 专属规则（如表格页规范、组件规范、样式规范、响应式规范、自动导入等），但通用规则（如文件命名规范、注释规范）仍然建议遵循。

## 技术栈

vue3 + TypeScript + vite + arco design + unocss

## 表格页规范【Vue3 专属】

常规列表页必须遵循以下模式，参考 `web/src/views/components-document/query-table/index.vue`：

1. **必须使用 `kb-pro-table`** 作为表格组件
2. **表格逻辑尽量使用 `useTable`** hooks，从 `@/hooks` 导入
3. **弹窗式编辑优先**：新增、编辑操作建议使用弹窗式实现（`save.modalComponent` 配置）
4. **表单尽量使用 `useForm`**，从 `@/hooks` 导入
5. 多表格页面必须拆分为多个独立组件
6. 如果操作栏按钮个数<=4，正常使用文字按钮，否则使用 `tooltip-button` 组件

### useTable 配置要点

- query.fn：请求函数，严禁在组件内做复杂数据处理，建议放到 request.ts 中
- remove.beforeFn：删除前确认逻辑
- save.modalComponent：弹窗编辑组件

### 表格列定义

- 使用 `IProTableColumn` 类型
- 字段名使用字符串，方便编辑器可以点击跳转到定义处
- 通过 `setColumnAlign(columns, 'center')` 设置默认居中

## 组件规范【Vue3 专属】

- 使用 arco design 组件库，文档参考 https://arco.design/vue/component
- 自定义组件需类型完备，props 必须声明类型和必要的注释
- 双向绑定统一使用 `defineModel`，**禁止**使用 `props + emit('update:xxx')` 手动实现

**正确示例：**
```ts
// 子组件中直接声明双向绑定
const modelValue = defineModel<string>({ default: '' })
const visible = defineModel<boolean>('visible')
```

**错误示例：**
```ts
// 禁止：手动 props + emit('update:xxx')
const props = defineProps<{ modelValue: string }>()
const emit = defineEmits<{ (e: 'update:modelValue', v: string): void }>()
```

## 样式规范【Vue3 专属】
- 上下、左右间距统一使用 `<a-space>` 组件，避免用 margin/padding 模拟间距
- 文字展示优先使用 a-typography 相关组件（如 `<a-typography-text>`、`<a-typography-title>`、`<a-typography-paragraph>`）
- **优先使用 unocss**，避免在 `<style>` 标签中定义 class
- arco design 组件上使用 unocss 时，若出现样式覆盖冲突，加 `!` 前缀强制生效
- 示例：`<a-button class="!bg-red-500">`

## 确认操作规范【Vue3 专属】

- 确认类操作（`a-popconfirm`、`a-modal` 等）使用 `on-before-ok` 属性发起数据请求，`ok` 事件只做成功后的刷新
- `on-before-ok` 返回 Promise，组件自动处理 loading 状态；返回 `false` 或 reject 时不会关闭，可阻止后续 `ok` 触发
- 禁止在 `ok` 事件中发起数据请求

**示例：**
```vue
<a-popconfirm
  content="确认删除吗？"
  @before-ok="handleDelete"
  @ok="refresh"
/>

<script setup lang="ts">
// 数据请求放在 before-ok，返回布尔结果决定是否继续关闭
const handleDelete = async () => {
  return await ExampleRequest.remove(row.id)
}

// ok 事件仅做成功后的列表刷新
const refresh = () => {
  reload()
}
</script>
```

## 模态框规范【Vue3 专属】

- 打开模态框统一使用项目内置的 `openModal` 方法，禁止手写 `a-modal` + `v-model:visible` 自行控制显隐
- 弹窗内容以组件形式通过参数传入，标题、宽度等在 `openModal` 调用处配置

**示例：**
```ts
openModal({
  title: '编辑',
  content: EditForm,
  width: 600,
})
```

## 模块组织规范【通用】

`modules/` 下按业务模块创建以下文件：

| 文件 | 用途 |
|------|------|
| `index.ts` | 统一导出 |
| `request.ts` | API 请求 + mock 数据 |
| `type.ts` | 类型定义 |
| `enum.ts` | 枚举定义 |

**每个字段必须有完整注释。**

### request.ts 规范

参考 `web/src/modules/example/request.ts`：

1. **namespace 组织**：使用 `namespace 模块名Request` 包裹所有接口函数
2. **HTTP 方法对应**：从 `@keyblade/http` 导入 `getRequest` / `postRequest` / `putRequest` / `deleteRequest`
3. **URL 前缀**：使用 `AppConfig.apiPrefix` 拼接路径
4. **try/catch 包裹**：每个请求函数必须 try/catch，错误处理在 request 层完成
5. **错误码判断**：成功/失败必须使用 `EResponseCode` 枚举值，如 `res?.code === EResponseCode.success`
6. **类型声明**：已知返回值类型时必须显式声明到 `getRequest<T>` / `postRequest<T>` 中，优先让 TypeScript 自动推导
7. **错误处理统一收口**：`Message.error`、`Message.info`、`Modal.error` 等错误提示调用**禁止出现在页面/组件层**，必须在 request 层统一处理。渲染层仅接收处理后的数据或布尔结果，不感知错误提示细节

**示例：**
```ts
import { getRequest, postRequest, putRequest, deleteRequest } from '@keyblade/http'
import { AppConfig } from '@/configs/app'
import { EResponseCode } from '@/enums'
import type { IExample } from './type'

const { apiPrefix } = AppConfig

export namespace ExampleRequest {
  export async function listPage(params: { pageNum: number; pageSize: number }) {
    try {
      const res = await getRequest<{ data: { list: IExample[]; total: number } }>(
        apiPrefix.main + '/',
        params
      )
      if (res?.data) {
        return res.data
      }
    } catch {}
  }

  export async function add(params: object) {
    try {
      const res = await postRequest(apiPrefix.main + '/', params)
      return res?.code === EResponseCode.success
    } catch {}
    return false
  }
}
```

**错误示例：**

```ts
// 页面层直接调用错误提示 — 禁止
const list = await ExampleRequest.listPage(params)
if (!list) {
  Message.error('获取数据失败')
}
```

### type.ts 要求

1. type/interface 变量名前缀：`I + 父级完整模块名 + 子模块名首字母简写`

**示例：**
```ts
export type IUserManagementUM = {
  /** 用户ID */
  id: string
  /** 用户名称 */
  name: string
}
```

### enum.ts 要求

1. enum 变量名前缀：`E + 父级完整模块名 + 子模块名首字母简写`

**示例：**
```ts
export enum EUserManagementUM {
  /** 正常 */
  Normal = 1,
  /** 冻结 */
  Frozen = 2,
}
```

## 枚举字典与状态展示规范【Vue3 专属】

状态、类型、选项等枚举值一律通过 `createEnumMap`（从 `@/utils` 导入）生成"字典 + 选项"单一数据源，集中定义在所属模块的 `modules/<模块>/enum.ts`，**禁止**在 `common/dict.ts` 或组件内维护与之重复的旧 `*_OPTIONS` 数组。

### createEnumMap 定义

```ts
// 返回 { valueMap: Map<T, IValueMapValue>, options: ({ key } & IValueMapValue)[] }
// IValueMapValue = { text: string; tagColor?; badgeStatus?; badgeColor? }
export enum ECommentAuditStatus {
  /** 待审核 */
  Pending = 1,
  /** 审核通过 */
  Passed = 2,
  /** 审核驳回 */
  Rejected = 3,
}

export const { valueMap: CommentStatusDict, options: CommentStatusOptions } =
  createEnumMap<ECommentAuditStatus>([
    { value: ECommentAuditStatus.Pending, text: '待审核', tagColor: 'orange' },
    { value: ECommentAuditStatus.Passed, text: '审核通过', tagColor: 'green' },
    { value: ECommentAuditStatus.Rejected, text: '审核驳回', tagColor: 'red' },
  ])
```

- 命名约定：枚举前缀 `E`；`valueMap` 命名为 `XxxDict`，`options` 命名为 `XxxOptions`。
- 仅需展示文案、无标签色时，可只解构 `valueMap`（如 `ShopBusinessScopeDict`）。

### 1. 表格/详情状态展示：必须用 `status-enum` 组件

列表列、详情中的状态标签/badge **禁止**直接写 `<a-tag>` / `<a-badge>`，统一用 `status-enum`（已全局自动导入，无需 import）：

```vue
<template #auditStatus="{ record }">
  <status-enum :value-map="CommentStatusDict" :value-map-key="record.auditStatus" />
</template>

<!-- badge 形态 -->
<status-enum value-type="badge" :value-map="XxxDict" :value-map-key="record.status" />
```

### 2. 下拉选项：用 `options`

```vue
<a-option
  v-for="item in CommentStatusOptions"
  :key="item.key"
  :label="item.text"
  :value="item.key"
/>
```

### 3. 纯文本取值（详情/时间线等非标签场景）

用 `Dict.get(字段)?.text`，**禁止**再用 `getDictLabel`（已废弃删除）：

```vue
{{ ShopBusinessScopeDict.get(detail?.businessScope as EShopBusinessScope)?.text || '-' }}
```

> 字段类型为 `number | undefined` 时，`Map.get` 要求枚举键，需 `as E枚举` 断言；运行时 `get(undefined)` 返回 `undefined`，再由 `|| '-'` 兜底。

## 类型规范【通用】

- 状态切换、选项值等**禁止使用字符串字面量**，必须定义枚举
- 定义 type/interface 字段类型时，若该字段已有对应枚举，**必须使用枚举类型**，禁止用 `number` / `string` 等基础类型替代
- 下拉选项、状态标签统一走 `createEnumMap` 生成的 `Dict`/`Options`，标签展示配合 `status-enum` 组件（见"枚举字典与状态展示规范"）

**错误示例：**
```ts
export type ICommentC = {
  /** 审核状态 */
  auditStatus: number // 禁止：已有 ECommentAuditStatus 枚举
}
```

**正确示例：**
```ts
export type ICommentC = {
  /** 审核状态 */
  auditStatus: ECommentAuditStatus
}
```

**错误示例：**
```ts
const status = 'all' // 禁止
```

**正确示例：**
```ts
const status = EStatus.All
```

## 响应式规范【Vue3 专属】

- **优先使用 `ref`**，只在特殊场景下使用 `reactive`
- ref 访问值时必须 `.value`，模板中自动解包

## 自动导入【Vue3 专属】

项目已配置 `unplugin-auto-import` 插件，Vite 会自动注入以下 API，**代码中禁止显式导入**：

- `vue`：`ref`、`reactive`、`computed`、`watch`、`watchEffect`、`onMounted`、`onUnmounted`、`defineProps`、`defineEmits`、`defineExpose` 等
- `pinia`：`defineStore`、`storeToRefs` 等
- `vue-router`：`useRoute`、`useRouter` 等

**错误示例：**
```ts
import { ref, computed } from 'vue'        // 禁止
import { defineStore } from 'pinia'        // 禁止
import { useRoute } from 'vue-router'      // 禁止
```

**正确示例：**
```ts
const count = ref(0)                       // 直接可用
const double = computed(() => count.value * 2)
```

## 表单规范【Vue3 专属】

- 使用 `a-form` + `useForm` 组合
- 校验规则必须写 `message` 提示
- 弹窗表单需暴露 `submit` 和 `beforeCancel` 方法
- 例如 `手机号、姓名` 等这些通用规则单独写在一个文件存放，全局共用，其他表单规则直接写在 <form-item> 模板里面

## defineEmits
- 需要使用对象形式
- 如有参数，需要声明参数及其类型
例如：
```ts
const emits = defineEmits<{
  (e: 'select', v: number): void
}>()
```

## 文件命名规范【通用】

- **禁止使用驼峰命名（camelCase）**
- 文件名使用短横线分隔（kebab-case）
- 示例：`user-management` ✓，`userManagement` ✗

## ESLint 规范【通用】

- 生成的代码必须符合目标项目的 ESLint 配置
- 使用项目根目录下的 `.eslintrc` 或 `.eslintrc.*` 或 `eslint.config.*` 文件定义的规则
- 避免产生任何 ESLint 警告或错误
- 代码格式需通过项目的 lint 命令校验

## 注释规范【通用】

- 所有类型字段必须有完整注释
- 复杂逻辑必须加行注释说明原因
- props 必须注释说明用途
