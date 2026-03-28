# Roo Code 升级计划书（对齐 OpenClaw 模块化架构）

> 版本：v2.1
>
> 更新时间（UTC）：2026-03-28T09:15:00Z
>
> 适用范围：Roo/Cursor 运行时目录（`C:/Users/ASUS-KL/.cursor`）与目标业务仓库（默认 `E:/Auto`）

---

## 1. 文档目标

本计划不再把重点放在“新增若干脚本/目录”，而是把 Roo 能力体系严格映射到 OpenClaw 的治理思想：

1. 平台克制：Roo 只做工具能力层与工作流层，不承载业务实现。
2. 模块闭环：业务逻辑留在业务模块，Roo 只通过契约调用。
3. 声明驱动：MCP、Skill、路由、运行参数均由声明配置驱动。
4. 运行态外置：运行缓存与证据归档不进入业务源码树。
5. 可校验：每项改造都可脚本化验证。
6. 可回滚：能力可按目录粒度停用，配置可版本化回退。

---

## 2. 架构定位（与 OpenClaw 总纲一致）

### 2.1 三层映射

- OpenClaw 平台/模块/运行层：继续作为业务工程主体系。
- Roo 能力层：定位为“外置工程助手层”，不侵入业务分层。
- 两者关系：Roo 通过 MCP 与 Skill 编排接入业务仓库，不反向污染模块边界。

### 2.2 Roo 在整体架构中的职责边界

Roo 允许做：

- 自动化验收（页面、API、日志、证据归档）
- 运维诊断（仓库状态、日志扫描、只读诊断）
- 经验沉淀（经验检索、会话摘要、结构化报告）
- 治理校验（边界检查、迁移检查、发布前检查）

Roo 禁止做：

- 在 Roo 目录复制业务模块实现
- 在 kernel 或跨模块边界写业务逻辑
- 用脚本长期维持旧目录/旧路由/旧别名并存
- 在启动器中硬编码唯一业务仓库路径

---

## 3. 目录与真源约束

## 3.1 Roo 运行时真源（本机）

- `C:/Users/ASUS-KL/.cursor/projects/e-Auto/mcps/`
- `C:/Users/ASUS-KL/.cursor/skills-cursor/`
- `C:/Users/ASUS-KL/.cursor/permissions.json`
- `C:/Users/ASUS-KL/.cursor/sandbox.json`

说明：以上目录用于能力运行与编排，属于本机运行态资产。

## 3.2 业务仓库真源（工程）

- `E:/Auto/projects/extensions/*`（模块体系）
- `E:/Auto/projects/control-ui-custom`（平台控制台壳真源）
- `E:/Auto/.runtime/extensions/<module>/`（模块运行态目录）

说明：业务实现、模块契约、路由归属与架构治理规则以业务仓库为准。

## 3.3 强约束

1. Roo 目录不承载业务代码真源。
2. 业务仓库不承载 Roo 私有运行时缓存。
3. Roo 启动器必须 env-first：
   - 优先读取显式环境变量；
   - 未设置时再做自动探测；
   - 禁止硬编码单一仓库路径。

---

## 3.4 完整重整文件树（目标态）

> 以下为“治理完成后”目标树，严格遵循你给出的约束：
>
> - `control-ui-custom` 只有项目根一份真源
> - `extensions` 顶层禁止 `core/`、`plugins/`、`public/`
> - 模块必须闭环（`frontend/backend/core/contracts/plugin`）
> - 运行态外置到 `.runtime`
> - Roo 作为外置能力层，不承载业务实现

```text
[业务工程真源]
E:/Auto/
├─ .runtime/
│  └─ extensions/
│     ├─ novel-manager/
│     │  ├─ cache/
│     │  ├─ browser/
│     │  ├─ logs/
│     │  ├─ temp/
│     │  └─ state/
│     ├─ automation-hub/
│     ├─ experience-manager/
│     ├─ file-manager/
│     ├─ ai-model-hub/
│     ├─ qmd/
│     ├─ memory-lancedb-pro/
│     └─ feishu-openclaw/
└─ projects/
   ├─ openclaw.json
   ├─ control-ui-custom/                # 平台控制台壳唯一真源
   ├─ shared/
   │  ├─ nav-bar.html
   │  ├─ nav-bar-behavior.js
   │  └─ sync-nav-bar.sh
   └─ extensions/
      ├─ kernel/
      │  ├─ config/
      │  ├─ db/
      │  ├─ http/
      │  ├─ obs/
      │  ├─ web-shell/
      │  ├─ types/
      │  └─ testing/
      ├─ novel-manager/
      │  ├─ module.json
      │  ├─ frontend/
      │  ├─ backend/
      │  ├─ core/
      │  ├─ contracts/
      │  ├─ plugin/
      │  ├─ tests/
      │  ├─ package.json
      │  ├─ tsconfig.json
      │  └─ index.ts
      ├─ automation-hub/
      │  └─ (同上闭环结构)
      ├─ experience-manager/
      │  └─ (同上闭环结构)
      ├─ file-manager/
      │  └─ (同上闭环结构)
      ├─ ai-model-hub/
      │  └─ (同上闭环结构)
      ├─ qmd/
      │  ├─ module.json
      │  ├─ frontend/
      │  ├─ backend/
      │  ├─ core/
      │  ├─ contracts/
      │  ├─ plugin/
      │  ├─ mcp/
      │  ├─ cli/
      │  └─ tests/
      ├─ memory-lancedb-pro/
      │  └─ (同 qmd 能力模块结构)
      ├─ feishu-openclaw/
      │  └─ (同上闭环结构)
      ├─ package.json
      ├─ package-lock.json
      ├─ tsconfig.base.json
      ├─ .eslintrc.cjs
      ├─ dependency-cruiser.cjs
      └─ ARCHITECTURE.md

[Roo 外置能力层（本机运行时）]
C:/Users/ASUS-KL/.cursor/
├─ permissions.json
├─ sandbox.json
├─ skills-cursor/
│  ├─ .cursor-managed-skills-manifest.json
│  ├─ module-acceptance/
│  │  ├─ SKILL.md
│  │  ├─ checklist.md
│  │  └─ examples.md
│  ├─ gateway-restart-safe/
│  ├─ regression-snapshot/
│  ├─ migration-boundary-check/
│  ├─ incident-triage/
│  └─ release-preflight/
└─ projects/
   └─ e-Auto/
      └─ mcps/
         ├─ _templates/
         │  └─ skill-output-template.md
         ├─ _artifacts/
         │  ├─ acceptance/
         │  ├─ regression/
         │  └─ triage/
         ├─ playwright-browser/
         │  ├─ server.json
         │  ├─ start.cmd
         │  └─ README.md
         ├─ experience-manager/
         ├─ repo-inspector/
         ├─ log-diagnose/
         ├─ db-readonly/
         ├─ prompt-compressor/
         ├─ context-reranker/
         ├─ context-store/
         ├─ output-guard/
         └─ memory-distill/
```

### 3.5 禁止项（必须持续为 0）

- `E:/Auto/projects/extensions/public/control-ui-custom/`（历史镜像，禁止复活）
- `E:/Auto/projects/extensions/core/`（全局业务 core 禁止）
- `E:/Auto/projects/extensions/plugins/`（全局插件目录禁止）
- 任何模块外的业务页面/路由副本（`_old` / `_new` / `_temp` / `_fixed`）

---

## 4. 当前状态基线（按本工作区实际）

### 4.1 已具备

1. `projects/e-Auto/mcps/` 已存在并包含 10 组 MCP wrapper 目录，且全部 `start.cmd` 已统一为 JSON 证据输出模式。
2. `skills-cursor/` 下 6 组核心 Skill 目录已具备 `SKILL.md` / `checklist.md` / `examples.md`，并已纳管到 `managedSkillIds`。
3. 项目级 `.roo/mcp.json` 已登记 10 组 MCP，具备完整发现声明。
4. 已具备一键回归脚本：`run-p0-regression.cmd`（P0）与 `run-all-mcps-regression.cmd`（10 组全量）。
5. `permissions.json` 已放开 MCP 与常见终端命令执行白名单，`sandbox.json` 当前为宽松网络策略（allow）。

### 4.2 待接通（关键缺口）

1. Skill 运行时发现链路仍未闭环：虽然 `managedSkillIds` 已纳管，但当前会话对 `module-acceptance` 调用返回 `Skill not found`，需重载运行时并再次验证。
2. P0 MCP 已完成声明注册与脚本行为闭环，但当前能力仍为“模拟验收链路”，后续需逐步替换为真实业务工具接线。

> 结论：MCP 的“声明注册 + 行为验收”已闭环；Skill 还差“运行时可调用验证”这最后一公里。

---

## 5. 目标状态（治理完成定义）

满足以下条件，才算本计划完成：

1. MCP 可发现：存在并维护项目级 `.roo/mcp.json`，可稳定加载关键 MCP。
2. Skill 可发现：核心 Skill 被稳定纳管（manifest 或平台约定机制），可被直接调用。
3. 行为可验证：关键链路均有 smoke 与 default 模式验证证据。
4. 边界不破坏：Roo 不承载业务实现，业务模块不出现 Roo 运行态反写污染。
5. 回滚可执行：任一 MCP/Skill 可按目录停用并恢复到最小能力集。

---

## 6. MCP 体系规划（按优先级）

## 6.1 P0（先打通）

### MCP-1 `playwright-browser`

- 定位：页面级验收与截图证据。
- 目标：支持 URL 巡检、console/pageerror 采集、截图归档。
- 验收：`--smoke` 通过，且默认模式能产出证据文件。

### MCP-2 `experience-manager`

- 定位：经验读写与检索中台。
- 目标：通过外部真实实现接线，避免在 Roo 侧复制业务实现。
- 验收：最小读/写/查链路可用，且支持失败报告。

### MCP-3 `repo-inspector`

- 定位：仓库状态与变更摘要。
- 目标：输出标准化 Git 状态、差异摘要、风险文件提示。
- 验收：`--smoke` + default 均可稳定执行。

## 6.2 P1（补诊断）

### MCP-4 `log-diagnose`

- 定位：日志聚合与故障定位。
- 目标：统一错误关键词扫描与报告结构。

### MCP-5 `db-readonly`

- 定位：只读数据诊断。
- 目标：严格只读，不执行 DDL/DML。

## 6.3 P2（降本增效）

- `prompt-compressor`（上下文压缩）
- `context-reranker`（二阶段重排）
- `context-store`（语义召回）
- `output-guard`（结构化输出约束）
- `memory-distill`（长期记忆蒸馏）

原则：先可用再高阶；先稳定链路再优化成本。

---

## 7. Skill 体系规划（与模块化治理强绑定）

核心 Skill：

1. `module-acceptance`：模块验收闭环（健康检查/页面/API/证据）
2. `gateway-restart-safe`：安全重启与就绪探测
3. `regression-snapshot`：批量回归截图与差异摘要
4. `migration-boundary-check`：迁移边界与残留检查
5. `incident-triage`：故障快照、分级与修复建议
6. `release-preflight`：发布前一致性检查

Skill 必须满足：

- 输入、输出、失败回退可读；
- 每次执行都有证据目录落盘；
- 不直接承载业务实现，仅编排调用。

---

## 8. OpenClaw 架构思想落地到 Roo 的执行规则

## 8.1 平台克制

- Roo 仅做工具层，不成为“第二业务后端”。

## 8.2 模块闭环

- 业务模块能力通过 API/contracts 暴露，Roo 不深层导入模块内部。

## 8.3 声明驱动

- MCP 由 `.roo/mcp.json` 声明；
- Skill 由 manifest 或约定机制纳管；
- 环境参数统一由 `ROO_TARGET_REPO` 等变量驱动。

## 8.4 迁移即清理

- 替代链路验证通过后，删除旧别名与旧副本，不长期双轨。

## 8.5 机器可校验

- 每个阶段都附带脚本化检查清单与通过门槛。

---

## 9. 分阶段实施路线图

## 阶段 A：声明注册接通（Day 1）

1. 在目标工程根创建并维护 `.roo/mcp.json`。
2. 将 P0 MCP 全量登记到声明文件。
3. 补齐 Skill 纳管清单（确保 6 个核心 Skill 可发现）。

交付门槛：

- MCP 在 Roo 可见并可触发；
- Skill 在 Roo 可见并可触发。

## 阶段 B：P0 行为闭环（Day 2-3）

1. 升级 `playwright-browser` 到可产证据模式。
2. 接通 `experience-manager` 真实入口并通过最小读写链路。
3. 固化 `repo-inspector` 报告结构。

交付门槛：

- 至少 3 个 P0 MCP 通过 smoke + default；
- `_artifacts/acceptance` 有可复现证据。

## 阶段 C：治理校验闭环（Day 4-5）

1. 强化 `migration-boundary-check` 与 `release-preflight`。
2. 新增模块边界检查项：
   - 跨模块深层导入检查；
   - 路由归属冲突检查；
   - 旧副本/旧目录残留检查。

交付门槛：

- 治理检查可输出明确 fail/pass 与修复建议。

## 阶段 D：P1/P2 与长期运维（Day 6+）

1. 按需接入降本组件（压缩、重排、向量检索、输出守卫）。
2. 建立日常巡检与周度回归。
3. 定期清理失效 Skill/MCP，保持能力集精简。

---

## 10. 配置规范（必须执行）

1. `start.cmd` 不得硬编码单仓路径。
2. 优先读取：`ROO_TARGET_REPO`、`ROO_PLAYWRIGHT_MCP`、`ROO_EXPERIENCE_MANAGER_MCP` 等。
3. 证据统一落盘：
   - `mcps/_artifacts/acceptance/`
   - `mcps/_artifacts/regression/`
   - `mcps/_artifacts/triage/`
4. 高风险操作保留人工确认；低风险读写自动化。

---

## 11. 验收标准（最终）

满足全部条件方可结项：

1. MCP 注册、发现、调用链路完整。
2. 6 个核心 Skill 可调用并有输出规范。
3. 至少 3 个关键 MCP 通过 smoke + default 双模式。
4. 每次验收都有日志/截图/摘要证据。
5. 不出现“Roo 承载业务实现”或“业务仓库存放 Roo 运行态污染”的边界破坏。

---

## 12. 回滚策略

1. 单能力回滚：停用目标 MCP/Skill 目录并恢复上一版启动器。
2. 配置回滚：恢复 `permissions.json` / `sandbox.json` 上一版。
3. 最小能力保留：`playwright-browser` + `module-acceptance`。
4. 回滚后必须重新执行 smoke 验证。

---

## 13. 防过时机制

为避免计划书再次过时，执行以下机制：

1. 每次目录/配置调整后，更新“当前状态基线”与“更新时间”。
2. 每周执行一次结构一致性检查并附结果摘要。
3. 文档中“已完成项”仅在有命令证据时更新，禁止口头完成。
4. 不再维护长篇“历史流水账”，改为“当前状态 + 最近变更 + 下步计划”。

---

## 14. 当前下一步（立即执行清单）

1. 重启 Roo/VS Code 会话，验证托管 Skill 可发现并可调用（目标：`module-acceptance` 调用成功）。
2. 将 10 组 MCP 的“模拟默认链路”逐步替换为真实业务接线，并保留当前 JSON 证据格式与退出码约定。
3. 例行执行 `projects/e-Auto/mcps/run-all-mcps-regression.cmd`，并归档 summary 到 `_artifacts/acceptance/`。
4. Skill 运行时验证通过后，再推进 P1/P2，避免一次性铺开导致维护失控。

---

## 15. 一句话总括

本计划将 Roo 升级为“工程治理增强层”，严格服务于 OpenClaw 的模块化单体架构，而不是另起一套平行业务体系。
