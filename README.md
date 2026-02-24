# Agent Skills

A collection of AI coding agent skills for Figma-driven Next.js development.

## Available Skills

### figma-driven-nextjs

Figma设计驱动的Next.js开发技能。当用户提到'根据Figma'、'按照设计稿'、提供Figma链接或MCP数据时自动触发。

**技术栈**:
- Next.js (App Router)
- Supabase
- Tailwind CSS
- Lucide Icons
- Motion

**功能**:
- 从 Figma 自动提取设计令牌（颜色、字体、间距、阴影）
- 自动生成 Dark 模式颜色
- 创建组件命名映射文件
- 原子设计方法论组件库架构
- 响应式布局 + 自适应方法
- 无障碍支持（WCAG AA）

**依赖技能**:
- `vercel-react-best-practices`
- `web-design-guidelines`

## Installation

```bash
npx skills add https://github.com/Zekiwest/agent-skills --skill figma-driven-nextjs
```

## Usage

技能会在以下情况自动触发：

- 用户请求从 Figma 设计创建页面/组件
- 用户提到 "根据 Figma..." 或 "按照设计稿..."
- 用户提供 Figma 文件链接或 MCP 数据
- 用户请求创建设计令牌

## License

MIT
