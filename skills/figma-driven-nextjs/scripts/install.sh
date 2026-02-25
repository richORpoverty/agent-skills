#!/bin/bash

# Figma-Driven Next.js 技能安装脚本
# 自动创建 Next.js 项目并配置设计系统

set -e

echo "═══════════════════════════════════════════════════════════════"
echo "  Figma-Driven Next.js 技能安装"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# 获取当前目录
CURRENT_DIR=$(pwd)
PROJECT_NAME=$(basename "$CURRENT_DIR")

# 检查是否已经是 Next.js 项目
check_nextjs_project() {
    if [ -f "package.json" ] && grep -q '"next"' package.json 2>/dev/null; then
        return 0
    fi
    return 1
}

# 检查是否在空目录
is_empty_directory() {
    if [ -z "$(ls -A "$CURRENT_DIR" 2>/dev/null)" ]; then
        return 0
    fi
    return 1
}

# 创建 Next.js 项目
create_nextjs_project() {
    echo "📦 创建 Next.js 项目..."
    
    # 使用 create-next-app 创建项目
    npx create-next-app@latest . \
        --typescript \
        --tailwind \
        --eslint \
        --app \
        --src-dir \
        --import-alias "@/*" \
        --no-turbopack \
        --yes
    
    echo "✅ Next.js 项目创建完成"
}

# 安装额外依赖
install_dependencies() {
    echo ""
    echo "📦 安装额外依赖..."
    
    # 安装动画库
    npm install motion
    
    # 安装图标库
    npm install lucide-react
    
    # 安装 Supabase 客户端
    npm install @supabase/supabase-js
    
    # 安装开发依赖
    npm install -D @types/node
    
    echo "✅ 依赖安装完成"
}

# 创建设计令牌文件结构
create_design_tokens() {
    echo ""
    echo "📁 创建设计令牌文件结构..."
    
    # 创建目录
    mkdir -p src/styles/tokens
    mkdir -p src/components/atoms
    mkdir -p src/components/molecules
    mkdir -p src/components/organisms
    mkdir -p src/components/templates
    mkdir -p src/components/icons
    mkdir -p src/docs
    
    # 创建颜色令牌
    cat > src/styles/tokens/colors.ts << 'EOF'
export const colors = {
  light: {
    primary: '#3B82F6',
    secondary: '#6366F1',
    background: '#FFFFFF',
    foreground: '#1F2937',
    muted: '#6B7280',
    accent: '#10B981',
    destructive: '#EF4444',
    border: '#E5E7EB',
    input: '#F3F4F6',
    ring: '#3B82F6',
  },
  dark: {
    primary: '#60A5FA',
    secondary: '#818CF8',
    background: '#111827',
    foreground: '#F9FAFB',
    muted: '#9CA3AF',
    accent: '#34D399',
    destructive: '#F87171',
    border: '#374151',
    input: '#1F2937',
    ring: '#60A5FA',
  },
}

export type ColorTheme = keyof typeof colors
EOF

    # 创建字体令牌
    cat > src/styles/tokens/typography.ts << 'EOF'
export const typography = {
  fontFamily: {
    sans: 'var(--font-sans)',
    serif: 'var(--font-serif)',
    mono: 'var(--font-mono)',
  },
  fontSize: {
    xs: '0.75rem',
    sm: '0.875rem',
    base: '1rem',
    lg: '1.125rem',
    xl: '1.25rem',
    '2xl': '1.5rem',
    '3xl': '1.875rem',
    '4xl': '2.25rem',
    '5xl': '3rem',
  },
  fontWeight: {
    normal: '400',
    medium: '500',
    semibold: '600',
    bold: '700',
  },
  lineHeight: {
    tight: '1.25',
    normal: '1.5',
    relaxed: '1.75',
  },
  letterSpacing: {
    tight: '-0.025em',
    normal: '0',
    wide: '0.025em',
  },
}
EOF

    # 创建间距令牌
    cat > src/styles/tokens/spacing.ts << 'EOF'
export const spacing = {
  0: '0',
  1: '0.25rem',
  2: '0.5rem',
  3: '0.75rem',
  4: '1rem',
  5: '1.25rem',
  6: '1.5rem',
  8: '2rem',
  10: '2.5rem',
  12: '3rem',
  16: '4rem',
  20: '5rem',
  24: '6rem',
}
EOF

    # 创建阴影令牌
    cat > src/styles/tokens/shadows.ts << 'EOF'
export const shadows = {
  sm: '0 1px 2px 0 rgb(0 0 0 / 0.05)',
  md: '0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)',
  lg: '0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1)',
  xl: '0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1)',
}
EOF

    # 创建统一导出
    cat > src/styles/tokens/index.ts << 'EOF'
export * from './colors'
export * from './typography'
export * from './spacing'
export * from './shadows'
EOF

    echo "✅ 设计令牌文件创建完成"
}

# 创建主题提供者
create_theme_provider() {
    echo ""
    echo "🎨 创建主题提供者..."
    
    cat > src/components/ThemeProvider.tsx << 'EOF'
'use client'

import { createContext, useContext, useEffect, useState } from 'react'

type Theme = 'light' | 'dark'
type ThemeContextType = {
  theme: Theme
  setTheme: (theme: Theme) => void
  toggleTheme: () => void
}

const ThemeContext = createContext<ThemeContextType | undefined>(undefined)

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  const [theme, setTheme] = useState<Theme>('light')
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
    const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches
    const savedTheme = localStorage.getItem('theme') as Theme | null
    setTheme(savedTheme || (prefersDark ? 'dark' : 'light'))
  }, [])

  useEffect(() => {
    if (mounted) {
      document.documentElement.classList.toggle('dark', theme === 'dark')
      localStorage.setItem('theme', theme)
    }
  }, [theme, mounted])

  const toggleTheme = () => {
    setTheme(prev => prev === 'light' ? 'dark' : 'light')
  }

  if (!mounted) return null

  return (
    <ThemeContext.Provider value={{ theme, setTheme, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  )
}

export const useTheme = () => {
  const context = useContext(ThemeContext)
  if (!context) throw new Error('useTheme must be used within ThemeProvider')
  return context
}
EOF

    echo "✅ 主题提供者创建完成"
}

# 更新 Tailwind 配置
update_tailwind_config() {
    echo ""
    echo "⚙️ 更新 Tailwind 配置..."
    
    cat > tailwind.config.ts << 'EOF'
import type { Config } from 'tailwindcss'

const config: Config = {
  darkMode: 'class',
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: 'var(--primary)',
          foreground: 'var(--primary-foreground)',
        },
        secondary: {
          DEFAULT: 'var(--secondary)',
          foreground: 'var(--secondary-foreground)',
        },
        background: 'var(--background)',
        foreground: 'var(--foreground)',
        muted: {
          DEFAULT: 'var(--muted)',
          foreground: 'var(--muted-foreground)',
        },
        accent: {
          DEFAULT: 'var(--accent)',
          foreground: 'var(--accent-foreground)',
        },
        destructive: {
          DEFAULT: 'var(--destructive)',
          foreground: 'var(--destructive-foreground)',
        },
        border: 'var(--border)',
        input: 'var(--input)',
        ring: 'var(--ring)',
      },
      fontFamily: {
        sans: ['var(--font-sans)'],
        serif: ['var(--font-serif)'],
        mono: ['var(--font-mono)'],
      },
    },
  },
  plugins: [],
}
export default config
EOF

    echo "✅ Tailwind 配置更新完成"
}

# 更新全局样式
update_globals_css() {
    echo ""
    echo "🎨 更新全局样式..."
    
    cat > src/app/globals.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    --primary: #3B82F6;
    --primary-foreground: #FFFFFF;
    --secondary: #6366F1;
    --secondary-foreground: #FFFFFF;
    --background: #FFFFFF;
    --foreground: #1F2937;
    --muted: #F3F4F6;
    --muted-foreground: #6B7280;
    --accent: #10B981;
    --accent-foreground: #FFFFFF;
    --destructive: #EF4444;
    --destructive-foreground: #FFFFFF;
    --border: #E5E7EB;
    --input: #F3F4F6;
    --ring: #3B82F6;
  }

  .dark {
    --primary: #60A5FA;
    --primary-foreground: #111827;
    --secondary: #818CF8;
    --secondary-foreground: #111827;
    --background: #111827;
    --foreground: #F9FAFB;
    --muted: #1F2937;
    --muted-foreground: #9CA3AF;
    --accent: #34D399;
    --accent-foreground: #111827;
    --destructive: #F87171;
    --destructive-foreground: #111827;
    --border: #374151;
    --input: #1F2937;
    --ring: #60A5FA;
  }
}

@layer base {
  * {
    @apply border-border;
  }
  body {
    @apply bg-background text-foreground;
  }
}
EOF

    echo "✅ 全局样式更新完成"
}

# 创建组件映射文件
create_component_mapping() {
    echo ""
    echo "📄 创建组件映射文件..."
    
    cat > src/docs/component-mapping.md << 'EOF'
# 组件命名映射规则

此文件记录 Figma 组件与代码组件的命名映射关系。

| Figma 组件名 | 代码组件名 | 文件路径 |
|-------------|-----------|---------|
| Button/Primary | Button | /src/components/atoms/Button |
| Button/Secondary | Button | /src/components/atoms/Button |
| Input/Text | Input | /src/components/atoms/Input |
| Input/Email | Input | /src/components/atoms/Input |
| Card/Default | Card | /src/components/molecules/Card |
| Header/Default | Header | /src/components/organisms/Header |
| Footer/Default | Footer | /src/components/organisms/Footer |

## 命名规则

- **Figma 组件**: 使用 `Category/Variant` 格式
- **代码组件**: 使用 PascalCase 格式
- **文件路径**: 基于 `src/components/` 的相对路径

## 更新记录

- 初始化映射文件
EOF

    echo "✅ 组件映射文件创建完成"
}

# 更新 layout.tsx
update_layout() {
    echo ""
    echo "📝 更新 layout.tsx..."
    
    cat > src/app/layout.tsx << 'EOF'
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import { ThemeProvider } from '@/components/ThemeProvider'

const inter = Inter({ subsets: ['latin'], variable: '--font-sans' })

export const metadata: Metadata = {
  title: 'Figma-Driven Next.js App',
  description: 'Created with Figma-Driven Next.js skill',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className={inter.variable}>
        <ThemeProvider>
          {children}
        </ThemeProvider>
      </body>
    </html>
  )
}
EOF

    echo "✅ layout.tsx 更新完成"
}

# 主流程
main() {
    if check_nextjs_project; then
        echo "✅ 检测到已存在的 Next.js 项目"
        echo ""
        install_dependencies
    elif is_empty_directory; then
        echo "📁 当前目录为空，将创建新的 Next.js 项目"
        echo ""
        create_nextjs_project
        install_dependencies
    else
        echo "⚠️ 当前目录不为空且不是 Next.js 项目"
        echo "请在一个空目录或现有 Next.js 项目中运行此脚本"
        exit 1
    fi
    
    create_design_tokens
    create_theme_provider
    update_tailwind_config
    update_globals_css
    update_layout
    create_component_mapping
    
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo "  ✅ 安装完成！"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    echo "📁 已创建的文件结构:"
    echo "   src/styles/tokens/     - 设计令牌"
    echo "   src/components/        - 组件目录"
    echo "   src/docs/              - 文档目录"
    echo ""
    echo "🚀 下一步:"
    echo "   1. 运行 'npm run dev' 启动开发服务器"
    echo "   2. 提供 Figma 设计文件开始开发"
    echo ""
}

main
