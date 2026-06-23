# MindLynx Skills — 体系架构

## 设计理念

本仓库汇集从 MindLynx-Aistock 项目实战中提炼的通用化 OpenCode 技能。
每个技能满足三个标准：
1. **通用化** — 无项目特定引用，任何代码库可用
2. **可论证** — 有明确的方法论和证据要求，不是"凭感觉"
3. **可审计** — 每个决策留下可追溯的记录

## 技能间关系

```
fork-merge-audit
  │
  ├── FE² 框架（5 轴对比评估）
  │     │
  │     └── 平局/复杂时升级到 → c1skill
  │
  └── Strategy D（选择性重实现）
        │
        └── 需要深度论证时升级到 → c1skill
```

- **`fork-merge-audit`** 是入口——自动扫描 + 快速评估 + 三路执行
- **`c1skill`** 是升级路径——当 FE² 平局/安全敏感/用户质疑时启用

## 扩展指南

新增技能时：
1. 在 `skills/` 下创建 `your-skill-name/`
2. 必须包含 `SKILL.md`（大写！OpenCode 要求）
3. 可选：Python 脚本、`examples/` 示例目录
4. 如果技能间有引用关系，在 `docs/architecture.md` 中记录

## 版本兼容

- 所有技能与 OpenCode 主版本无关——纯文本 + Python 标准库
- `fork_merge_audit.py` 需 Python 3.8+，零第三方依赖
