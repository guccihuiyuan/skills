---
name: uniapp-vue3-code-rules
description: >
  当用户要求生成、修改或审查 Vue3 + TypeScript + UniApp 项目代码时触发。
  覆盖 uni-app 页面/组件开发规范、Pinia 状态管理、API 请求封装、自动导入规则、
  响应式规范、子包开发规范、SCSS 样式规范、条件编译等。
  无论用户是否明确提到「规范」或「规则」，只要涉及 Vue3 + TypeScript + UniApp 项目的代码编写就应使用此 skill。
  当项目 package.json 中包含 @dcloudio 系列依赖（如 @dcloudio/uni-app）时，必须优先使用此 skill。
---

# UniApp Vue3 编码规范

## 适用范围

本规范适用于使用以下技术栈的 UniApp 项目：

- Vue 3 + TypeScript + Vite + Pinia + UniApp

**判断方式**：查看目标目录下 `package.json` 是否包含 `@dcloudio` 系列依赖（如 `@dcloudio/uni-app`、`@dcloudio/vite-plugin-uni` 等）。

如果用户操作的是 Vue2、React、Node.js 等其他技术栈项目，**不适用**本规范中的 UniApp 专属规则，但通用规则（如文件命名规范、注释规范）仍然建议遵循。

## 技术栈

- Vue 3 + TypeScript + Vite + Pinia + UniApp
- UI 组件库：`uni-ui`（通过 `@foundbyte/uni-ui` 封装，位于 `packages/uni-ui/`）
- 构建工具：`@dcloudio/vite-plugin-uni`
- 状态管理：Pinia
- 样式：SCSS + rpx 单位
- 路径别名：`@/` 和 `~/` 均指向 `src/`

## 目录结构规范

### 主包目录 (`src/`)

```
src/
├── components/          # 公共组件（全局可用，自动注册）
│   └── u-xxx/           # 组件名前缀为 u-，目录使用 kebab-case
│       └── index.vue
├── core/                # 核心模块
│   ├── apis/            # API 配置与请求封装
│   │   ├── configs/     # 环境配置（api.local.ts / api.dev.ts / api.test.ts / api.prod.ts）
│   │   ├── request.ts   # 请求封装（http / request）
│   │   └── index.ts     # 统一导出
│   ├── configs/         # 应用配置
│   ├── constants/       # 常量定义
│   ├── enum/            # 枚举定义（按领域分子目录）
│   ├── hooks/           # 自定义 Composable
│   ├── locales/         # 国际化
│   ├── service/         # 业务逻辑服务层
│   ├── store/           # Pinia Store
│   │   └── modules/     # 按模块组织
│   ├── type/            # 全局类型定义
│   └── utils/           # 工具函数
├── pages/               # 主包页面（tabBar 页面等）
│   └── page-name/
│       └── index.vue
├── sub/                 # 子包页面（按业务模块划分）
│   └── module-name/
│       ├── pages/
│       │   └── page-name/
│       │       ├── index.vue
│       │       ├── components/
│       │       ├── hooks/
│       │       └── type.ts
│       └── components/
├── styles/              # 全局 SCSS 样式
├── static/              # 静态资源
└── App.vue              # 应用入口
```

### 子包目录 (`src/sub/`)

每个子包是一个独立的业务模块：

```
src/sub/module-name/
├── pages/
│   └── page-name/
│       ├── index.vue          # 页面入口
│       ├── components/        # 页面私有组件
│       ├── hooks/             # 页面私有 hooks
│       └── type.ts            # 页面类型定义
└── components/                # 子包公共组件（可选）
```

## 页面/组件开发规范

### 单文件组件格式

必须使用 `<script setup lang='ts'>` 语法：

```vue
<template>
  <view class="page-container">
    <!-- 内容 -->
  </view>
</template>

<script setup lang="ts">
import { onLoad, onShow } from '@dcloudio/uni-app'

// 逻辑代码
</script>

<style scoped lang="scss">
.page-container {
  // 样式
}
</style>
```

### 模板规范

- 根元素使用 `view` 而非 `div`
- 图片使用 `image` 标签，必须设置 `mode` 属性
- 文本使用 `text` 标签
- 列表渲染使用 `v-for`，必须指定 `:key`
- 条件渲染使用 `v-if` / `v-show`
- 事件绑定使用 `@click` 而非 `v-on:click`
- 避免在模板中写复杂表达式，提取为 `computed`

### 生命周期

使用 `@dcloudio/uni-app` 提供的生命周期：

```ts
import {
  onLoad,
  onShow,
  onHide,
  onUnload,
  onPullDownRefresh,
  onReachBottom,
  onShareAppMessage,
  onShareTimeline,
} from '@dcloudio/uni-app'
```

常用生命周期：

- `onLoad` — 页面加载，接收页面参数
- `onShow` — 页面显示
- `onHide` — 页面隐藏
- `onUnload` — 页面卸载
- `onPullDownRefresh` — 下拉刷新
- `onReachBottom` — 上拉加载更多
- `onShareAppMessage` — 分享到好友
- `onShareTimeline` — 分享到朋友圈

## 自动导入规范

项目配置了自动导入插件，以下 API **禁止显式导入**：

**Vue API**（自动导入）：

- `ref`, `reactive`, `computed`, `watch`, `watchEffect`
- `onMounted`, `onUnmounted`, `onUpdated`, `onBeforeMount`, `onBeforeUnmount`
- `getCurrentInstance`, `nextTick`, `provide`, `inject`
- `defineProps`, `defineEmits`, `defineExpose`
- `toRefs`, `toRef`, `isRef`, `unref`, `shallowRef`, `shallowReactive`

**Pinia API**（自动导入）：

- `defineStore`, `storeToRefs`, `mapActions`, `mapState`

**错误示例：**

```ts
import { ref, computed } from 'vue' // 禁止
import { defineStore } from 'pinia' // 禁止
```

**正确示例：**

```ts
const count = ref(0) // 直接可用
const double = computed(() => count.value * 2)
```

### 需要显式导入的

- `@dcloudio/uni-app` 的生命周期：`onLoad`, `onShow` 等
- 自定义组件、hooks、service、store、type、enum
- 第三方库

## 响应式规范

- **简单变量**：使用 `ref`
- **嵌套对象/复杂状态**：使用 `reactive`
- **从 store 中提取的响应式数据**：使用 `storeToRefs`

**示例：**

```ts
// 简单变量用 ref
const searchKey = ref('')
const loading = ref(false)

// 嵌套对象用 reactive
const formState = reactive({
  name: '',
  phone: '',
  address: {
    province: '',
    city: '',
  },
})

// 从 store 提取
const { userInfo, token } = storeToRefs(useUserStore())
```

## 组件规范

### 公共组件 (`src/components/`)

- 目录名前缀为 `u-`，使用 kebab-case
- 每个组件独立目录，入口为 `index.vue`
- 组件通过 `vite-plugin-uni-components` 自动注册，全局可用
- Props 必须声明类型和默认值

**示例：**

```
src/components/
├── u-nav-bar/
│   └── index.vue
├── u-page-view/
│   └── index.vue
└── u-empty-view/
    └── index.vue
```

### 组件 Props 定义

```vue
<script setup lang="ts">
interface Props {
  /** 标题 */
  title?: string
  /** 是否显示返回按钮 */
  showBack?: boolean
  /** 自定义样式 */
  styles?: CSSProperties
}

const props = withDefaults(defineProps<Props>(), {
  title: '',
  showBack: true,
  styles: () => ({}),
})

const emit = defineEmits<{
  /** 点击返回 */
  (e: 'back'): void
  /** 点击标题 */
  (e: 'click-title', title: string): void
}>()
</script>
```

### 页面私有组件

页面内使用的组件放在页面目录的 `components/` 下：

```
pages/search/
├── index.vue
└── components/
    ├── search-input/
    │   └── index.vue
    └── search-title/
        └── index.vue
```

## 标准页面结构

生成页面代码时，遵循以下标准结构：

### 基本结构

```vue
<template>
  <view class="page-name">
    <!-- 顶部导航栏 -->
    <u-nav-bar title="页面标题" transparent />

    <!-- 页面内容区域 -->
    <u-page-view classes="content" block>
      <!-- 页面内容组件 -->
    </u-page-view>
  </view>
</template>

<script setup lang="ts">
import { onShow } from '@dcloudio/uni-app'
import { useRouteGuards } from '@/core/hooks'
import { useBuryPoint } from '@/core/utils/bury-point/hooks'
import { commonTrackCommonParams } from '@/core/utils/bury-point/xxx/enum'

const { startBurialPointTrack } = useBuryPoint()
const { userStore, auth } = useRouteGuards()

onShow(() => {
  startBurialPointTrack({
    ...commonTrackCommonParams,
    title: '页面标题',
  })
})
</script>

<style lang="scss" scoped></style>
```

### 顶部导航栏 (`u-nav-bar`)

- **必须**使用 `u-nav-bar` 作为顶部导航栏
- 普通页面：`title` 传入页面标题
- 透明导航栏：`transparent` + `title` 根据滚动状态动态变化
- 自定义左侧按钮：通过 `left-icon` 控制
- 支付宝小程序特殊处理：使用条件编译或 `isAlipay()` 判断

```vue
<!-- 普通导航栏 -->
<u-nav-bar title="页面标题" />

<!-- 透明导航栏 -->
<u-nav-bar :title="isShowNavbarBg ? '页面标题' : ''" transparent :left-icon="null" />
```

### 页面视图区域 (`u-page-view`)

- **必须**使用 `u-page-view` 包裹页面主要内容
- `classes`：传入自定义 class 名，用于样式隔离
- `block`：是否占满剩余空间
- `topStick`：吸顶元素顶部偏移量
- `@scroll`：监听滚动事件

```vue
<u-page-view classes="content" :topStick="0" block @scroll="onScroll">
  <!-- 页面内容 -->
</u-page-view>
```

### 完整示例

```vue
<template>
  <view class="page-name">
    <u-nav-bar title="页面标题" />

    <u-page-view classes="content" block>
      <!-- 页面内容 -->
    </u-page-view>
  </view>
</template>

<script setup lang="ts">
import { onShow } from '@dcloudio/uni-app'

onShow(() => {
  // 页面显示逻辑
})
</script>

<style lang="scss" scoped>
.content {
  // 页面样式
}
</style>
```

## Pinia Store 规范

### Store 文件组织

```
src/core/store/
├── index.ts              # 统一导出
└── modules/
    ├── user.ts           # 用户模块
    ├── home.ts           # 首页模块
    └── sub/
        └── show.ts       # 子包模块
```

### Store 定义规范

```ts
import { defineStore, storeToRefs } from 'pinia'
import { EBusinessType } from '@/core/enum'

export interface IUserInfo {
  /** 用户ID */
  id: string
  /** 昵称 */
  nickname: string
  /** 头像 */
  avatar: string
}

export const useUserStore = defineStore('user', {
  state: () => ({
    /** 用户信息 */
    userInfo: undefined as undefined | IUserInfo,
    /** 登录状态 */
    isLogin: false,
    /** 消息列表 */
    messageList: [] as Array<{ title: string }>,
  }),
  getters: {
    // getter 逻辑
  },
  actions: {
    setUserInfo(data: IUserInfo) {
      this.userInfo = data
      this.isLogin = true
    },
    logout() {
      this.userInfo = undefined
      this.isLogin = false
    },
  },
})

// 导出响应式引用辅助函数
export const useUserData = () => {
  const store = useUserStore()
  return storeToRefs(store)
}
```

### Store 使用规范

```ts
// 在组件中
const userStore = useUserStore()
const { userInfo, isLogin } = storeToRefs(userStore)

// 调用 action
userStore.setUserInfo(data)
```

## Core Hooks 使用规范

项目已在 `src/core/hooks/` 下封装了大量常用 hooks，**优先使用 core hooks 而不是自己重复实现**。

### 常用 Core Hooks

| Hook 名称              | 功能                           | 返回值                                                      |
| ---------------------- | ------------------------------ | ----------------------------------------------------------- |
| `useRouteGuards`       | 路由守卫 + 用户信息 + 登录状态 | `{ userStore, userInfo, auth, recommend, ...locationInfo }` |
| `useBackPress`         | 返回按键处理                   | -                                                           |
| `useNavbarContent`     | 导航栏高度/状态栏信息          | `{ statusBarHeight, navBarHeight, paddingRight }`           |
| `usePagination`        | 分页逻辑                       | `{ list, loading, finished, onLoad, onRefresh }`            |
| `useEventBus`          | 事件总线                       | `{ on, emit, off }`                                         |
| `useLang`              | 国际化                         | `{ getLangMessage }`                                        |
| `useTop`               | 滚动到顶部                     | `{ scrollTop, onScroll, scrollToTop }`                      |
| `useAppVersion`        | 应用版本信息                   | `{ version, platform }`                                     |
| `useShieldingFunction` | 防抖/节流                      | `{ debounce, throttle }`                                    |

### useRouteGuards 使用规范

获取用户信息和登录状态时，**优先使用 `useRouteGuards` 而不是直接操作 `useUserStore`**：

**正确示例：**

```ts
import { useRouteGuards } from '@/core/hooks'

const { userInfo, userStore, auth } = useRouteGuards()

// 读取用户信息
console.log(userInfo.value.nickName)

// 判断登录状态
if (auth.value) {
  // 已登录
}

// 修改用户信息
userStore.setUserinfo(newUserInfo)
```

**错误示例：**

```ts
// 避免直接操作 store，应通过 useRouteGuards 获取
import { useUserStore } from '@/core/store'
const userStore = useUserStore()
const { userInfo } = storeToRefs(userStore)
```

### 页面获取导航栏信息

```ts
import { useNavbarContent } from '@/core/hooks'

const { statusBarHeight, navBarHeight, paddingRight } = useNavbarContent()
```

### 自定义 Hooks 开发规范

如需在页面或子包中自定义 hooks：

- 页面私有 hooks 放在页面目录的 `hooks/` 下
- 子包公共 hooks 放在子包根目录的 `hooks/` 下
- hooks 文件使用 `use-xxx.ts` 命名
- 必须导出函数，返回对象格式

```ts
// pages/search/hooks/index.ts
export const useSearchHistory = () => {
  const historyList = ref<string[]>([])

  const getHistoryList = async () => {
    // ...
  }

  const deleteHistory = async () => {
    // ...
  }

  return {
    historyList,
    getHistoryList,
    deleteHistory,
  }
}
```

## API 请求规范

### 请求封装

使用 `src/core/apis/request.ts` 中的 `http` 或 `request` 方法：

```ts
import { http, request } from '@/core/apis'
```

### API 定义规范

按业务模块在 `src/core/service/` 下组织，**必须遵循以下规则**：

1. **异常处理**：每个请求函数必须 try/catch 包裹，错误处理在 service 层完成
2. **状态码判断**：成功/失败必须使用 `EResCode` 枚举值，如 `res?.code === EResCode.success`
3. **类型推导**：已知返回值类型时，优先使用 `http<T>` 泛型声明，让 TypeScript 自动推导
4. **数据处理**：格式转换、错误处理等逻辑尽量放到 service 层，减少页面层代码量

```ts
// src/core/service/home.ts
import { http } from '@/core/apis'
import { apiConfig } from '@/core/apis/configs'
import { EResCode } from '@/core/enum'

const { apiPrefix } = apiConfig

export interface IHomeData {
  /** 活动列表 */
  activityList: Array<{ title: string, url: string }>
  /** 推荐列表 */
  recommendList: Array<{ name: string, id: string }>
}

/**
 * 获取首页数据
 * @param regionCode 地区编码
 * @returns 首页数据
 */
export async function getHomeData(regionCode?: string) {
  try {
    const res = await http<IHomeData>('/home/data', 'GET', { regionCode })
    if (res?.code === EResCode.success) {
      return res.data
    }
  } catch {
    // 错误已在 request 拦截器中处理，此处可选补充业务逻辑
  }
}

/**
 * 获取搜索信息
 */
export async function getSearchInfo() {
  try {
    const res = await http('/home/search', 'GET')
    if (res?.code === EResCode.success) {
      return res.data
    }
  } catch {}
}

/**
 * 提交表单
 * @param params 表单参数
 * @returns 是否提交成功
 */
export async function submitForm(params: object) {
  try {
    const res = await http('/form/submit', 'POST', params)
    return res?.code === EResCode.success
  } catch {}
}
```

**错误示例：**

```ts
// 未使用 try/catch
export async function getData() {
  const res = await http('/api/data', 'GET')
  return res.data
}

// 未使用 EResCode 枚举，使用魔数
if (res?.code === 200) {
}

// 未声明泛型类型
const res = await http('/api/list', 'GET')
const list = res.data as IListItem[] // 避免手动类型断言
```

### 请求选项

```ts
interface IHttpOption {
  /** 是否显示加载中 */
  loading?: boolean
  /** 是否加密 */
  encrypt?: boolean
  /** 是否解密 */
  decrypt?: boolean
  /** 超时时间（默认 10000ms） */
  timeout?: number
  /** 报错时是否提示（默认 true） */
  toast?: boolean
}
```

## 枚举与类型规范

### 枚举定义 (`src/core/enum/`)

```ts
// src/core/enum/business.ts
export enum EBusinessType {
  /** 景区 */
  Scenic = 1,
  /** 酒店 */
  Hotel = 2,
  /** 民宿 */
  Homestay = 3,
  /** 美食 */
  Food = 4,
  /** 路线 */
  Route = 5,
}
```

### 类型定义 (`src/core/type/`)

```ts
// src/core/type/area.ts
export interface IAreaItem {
  /** 地区名称 */
  name: string
  /** 地区编码 */
  code: string
  /** 纬度 */
  latitude: number
  /** 经度 */
  longitude: number
}
```

### 状态值禁止用字符串字面量

**错误示例：**

```ts
const status = 'all' // 禁止
```

**正确示例：**

```ts
const status = EStatus.All
```

## Service 层规范

业务逻辑放在 `src/core/service/` 下：

```
src/core/service/
├── index.ts              # 统一导出
├── home.ts               # 首页业务
├── user.ts               # 用户业务
├── auth.ts               # 认证业务
├── jump-page.ts          # 页面跳转
├── storage.ts            # 本地存储
└── sub/
    ├── show.ts           # 子包业务
    └── ticket.ts
```

Service 层职责：

- 封装 API 调用
- 处理业务逻辑
- 数据转换和格式化
- 错误处理（try/catch 包裹每个请求）
- 状态码判断（必须使用 `EResCode` 枚举）
- 类型声明（优先使用 `http<T>` 泛型推导）

## 样式规范

### 单位

- 使用 `rpx` 作为响应式单位
- 字体大小使用 `rpx`
- 间距使用 `rpx`

**示例：**

```scss
.container {
  padding: 24rpx 32rpx;
  font-size: 28rpx;
}
```

### SCSS 使用

- 组件样式使用 `scoped lang='scss'`
- 全局样式放在 `src/styles/`
- 使用嵌套语法时保持层级清晰
- `page` 标签样式不加 `scoped`

**示例：**

```scss
<style scoped lang='scss'>
.navbar {
  position: fixed;
  top: 0;
  width: 100%;

  &-content {
    display: flex;
    align-items: center;
    padding: 0 10rpx;
  }
}

:deep(.search-inner) {
  background-color: rgba(0, 0, 0, 0.06);
}
</style>
```

### 条件编译

使用 UniApp 条件编译注释处理平台差异：

```scss
/* #ifdef MP-WEIXIN */
// 微信小程序专属样式
/* #endif */

/* #ifdef MP-ALIPAY */
// 支付宝小程序专属样式
/* #endif */

/* #ifdef APP-PLUS */
// App 专属样式
/* #endif */

/* #ifdef H5 */
// H5 专属样式
/* #endif */
```

```ts
// #ifdef MP-WEIXIN
// 微信小程序专属逻辑
// #endif

// #ifndef MP-WEIXIN
// 非微信小程序逻辑
// #endif
```

## 文件命名规范

- **禁止使用驼峰命名（camelCase）**
- 文件名使用短横线分隔（kebab-case）
- 组件目录名前缀为 `u-`

**正确示例：**

```
user-management/     ✓
search-result/       ✓
u-nav-bar/           ✓
```

**错误示例：**

```
userManagement/      ✗
SearchResult/        ✗
```

## 注释规范

- 所有类型字段必须有完整注释
- 复杂逻辑必须加行注释说明原因
- Props 必须注释说明用途
- 函数必须注释说明功能和参数

**示例：**

```ts
export interface IUserInfo {
  /** 用户ID */
  id: string
  /** 昵称 */
  nickname: string
  /** 头像URL */
  avatar: string
}

/**
 * 获取用户信息
 * @param userId 用户ID
 * @returns 用户信息
 */
export async function getUserInfo(userId: string) {
  // 从缓存读取，避免重复请求
  const cache = getStorageSync(EStorageType.userInfo)
  if (cache) return cache

  const res = await http('/user/info', 'GET', { userId })
  return res?.data
}
```

## ESLint 规范

- 生成的代码必须符合目标项目的 ESLint 配置
- 使用项目根目录下的 `.eslintrc` 或 `eslint.config.*` 文件定义的规则
- 避免产生任何 ESLint 警告或错误
- 代码格式需通过项目的 lint 命令校验

## 页面跳转规范

使用封装好的跳转方法：`src/core/service/jump-page.ts`

```ts
import { jumpPage, jumpToURLScheme } from '@/core/service'

// 普通跳转
jumpPage('/pages/index/index')

// 带参数跳转
jumpPage('/sub/module-name/pages/detail/index', { id: '123' })

// URL Scheme 跳转
jumpToURLScheme(url)
```

## 本地存储规范

使用封装好的存储方法：`src/core/service/storage.ts`

```ts
import { getStorageSync, setStorageSync, EStorageType } from '@/core/service'

// 读取
const token = getStorageSync(EStorageType.token)

// 写入
setStorageSync(EStorageType.token, 'xxx')
```
