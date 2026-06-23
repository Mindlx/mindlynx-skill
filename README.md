<!-- Language toggle -->
<div align="right">
  <a href="#english">English</a> | <a href="#chinese">中文</a>
</div>

<a id="english"></a>

# mindlynx-skill — OpenCode Skills Pack

Generic OpenCode skills distilled from the MindLynx-Aistock project.
**Fully generic**: No project-specific references; works with any codebase.

## Skills

| Skill | Description | Includes |
|:------|:------------|:---------|
| [`fork-merge-audit`](skills/fork-merge-audit/) | Git Fork merge methodology — automated upstream scan, FE² 5-axis evaluation, Strategy D reimplementation | Python script + SKILL.md + examples |
| [`c1skill`](skills/c1skill/) | Cross-layer problem audit & fix methodology — 8-stage closed loop, evidence hierarchy | SKILL.md + examples |

## Installation

```bash
git clone https://github.com/Mindlx/mindlynx-skill.git
cd mindlynx-skill
bash scripts/install.sh
```

Or manually:
```bash
cp -r skills/fork-merge-audit ~/.agents/skills/
cp -r skills/c1skill ~/.agents/skills/
```

## Usage

```bash
# 1. Scan upstream in any git fork project
cd /path/to/your/forked/project
python ~/.agents/skills/fork-merge-audit/fork_merge_audit.py --output report.json

# 2. Load methodology in OpenCode
skill(name="fork-merge-audit")
skill(name="c1skill")
```

## Dependencies

- Python 3.8+ (for `fork_merge_audit.py` only, zero third-party deps)
- git

## Skill Relationships

```
fork-merge-audit
  ├── FE² framework (5-axis evaluation)
  │     └── Tie/complex cases → c1skill
  └── Strategy D (selective reimplementation)
        └── When deep reasoning needed → c1skill
```

See [docs/architecture.md](docs/architecture.md) for details.

## Multi-Tool Support

| Tool | Methodology | Script |
|:-----|:------------|:-------|
| **OpenCode** | `skill(name="fork-merge-audit")` | ✅ bash |
| **Claude** | Paste `prompts/*.md` or write to `CLAUDE.md` | ✅ bash |
| **Cursor** | Copy `prompts/*.md` to `.cursorrules` | ✅ bash |
| **Windsurf** | Copy to `.windsurfrules` | ✅ bash |
| **Copilot** | Add to `.github/copilot-instructions.md` | — |
| **ChatGPT / others** | Paste prompt content as first message | — |

Full guide: [docs/tool-integration.md](docs/tool-integration.md).

## Extending

To add a new skill → create a directory under `skills/` with `SKILL.md` (must be uppercase), optional scripts, and `examples/`.

## License

MIT

---

<a id="chinese"></a>

## 🌐 中文版本

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
| **Copilot** | 添加到 `.github/copilot-instructions.md` | — |
| **ChatGPT / 其他** | 粘贴 prompt 内容作为第一条消息 | — |

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
