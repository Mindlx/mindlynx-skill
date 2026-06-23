# mindlynx-skill — OpenCode 用户级技能包

从 MindLynx-Aistock 实战中提炼的通用化 OpenCode 技能。
**通用化设计**：无项目特定引用，任何代码库可用。

## 技能

| 技能 | 描述 | 包含 |
|:-----|:-----|:-----|
| [`fork-merge-audit`](skills/fork-merge-audit/) | Git Fork 合并方法论——自动扫描上游 commits、FE² 5 轴评估、Strategy D 重实现 | Python 脚本 + SKILL.md + 示例 |
| [`c1skill`](skills/c1skill/) | 交叉层问题审计与修复方法论——8 阶段闭环、证据等级体系 | SKILL.md + 示例 |

## 安装

```bash
git clone https://github.com/Mindlx/mindlynx-skill.git
cd mindlynx-skill
bash scripts/install.sh
```

或手动复制：
```bash
cp -r skills/fork-merge-audit ~/.agents/skills/
cp -r skills/c1skill ~/.agents/skills/
```

## 使用

```bash
# 1. 在任何 git fork 项目中扫描上游
cd /path/to/your/forked/project
python ~/.agents/skills/fork-merge-audit/fork_merge_audit.py --output report.json

# 2. 在 OpenCode 中获取方法论
skill(name="fork-merge-audit")
skill(name="c1skill")
```

## 多工具支持

| 工具 | 方法论 | 脚本调用 |
|:-----|:-------|:--------:|
| **OpenCode** | `skill(name="fork-merge-audit")` | ✅ bash |
| **Claude** | 粘贴 `prompts/*.md` 或写入 `CLAUDE.md` | ✅ bash |
| **Cursor** | 复制到 `.cursorrules` | ✅ bash |
| **Windsurf** | 复制到 `.windsurfrules` | ✅ bash |
| **Copilot** | 复制到 `.github/copilot-instructions.md` | ❌ |
| **ChatGPT / 其他** | 粘贴 prompt 内容作为第一条消息 | ❌ |

完整指南：[docs/tool-integration.md](docs/tool-integration.md)。

## 依赖

- Python 3.8+（仅 `fork_merge_audit.py`，零第三方依赖）
- git

## 技能间关系

```
fork-merge-audit
  ├── FE² 框架（5 轴对比评估）
  │     └── 平局/复杂时 → c1skill
  └── Strategy D（选择性重实现）
        └── 需深度论证时 → c1skill
```

详见 [docs/architecture.md](docs/architecture.md)。

## 扩展

新增技能 → 在 `skills/` 下创建目录，包含 `SKILL.md`（必须大写）、可选脚本和 `examples/`。

## 许可证

MIT
