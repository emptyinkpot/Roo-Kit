# Roo-Kit Review Guide

## 仓库定位

这个仓库承载 Roo / Cursor 运行时资产、技能、MCP 与治理资料，不应把业务仓实现直接复制进来长期维护。

## 审查重点

1. `skills-cursor/**`、`projects/**/mcps/**`、`.roo/**` 相关变更要重点检查：
   - 是否继续保持“能力层 / 治理层”定位，而不是把业务实现塞进 Roo 目录；
   - 是否引入重复 skill、重复 MCP、重复治理规则。
2. `argv.json`、`permissions.json`、`sandbox.json` 等运行态配置变更要重点检查：
   - 是否出现硬编码单一业务仓路径；
   - 是否还能坚持 env-first、声明驱动、最小权限原则。
3. `extensions/**` 与运行态缓存类目录要重点检查：
   - 默认不要把扩展构建产物、数据库、缓存、临时状态当成常规源码改动；
   - 除非任务明确要求，否则不要在 review 中鼓励顺手改打包产物或运行态数据。

## PR 要求

- PR 描述要写清本轮是改 skill、MCP、权限配置，还是运行时编排。
- 如果改了路径解析、权限模型、sandbox、MCP 注册或 capability 真源，必须说明验证方式。
- 如果改了运行态配置，默认需要给出最小复现步骤或结果截图。
- 只有在明确需要跳过审查时才使用 `skip-sourcery`、`no-sourcery` 或 `sourcery-ignore`。
