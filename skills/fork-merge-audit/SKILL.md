# Fork Merge Audit — Git Fork 合并方法论

## 用途

管理 fork 项目与上游仓库之间的同步。提供从扫描 → 评估 → 执行 → 审计的完整闭环，适用于分叉深度 100+ commits 的高分歧 fork。

**来源**：实战总结于 200+ 分歧 commit 的高分歧 fork 项目，经过 15+ 功能模块验证。

## 适用场景

- fork 项目独立发展超过 100 次 commit 后需要评估上游变更
- 判断"上游功能是否值得合入"需要结构化标准
- BLOCKED commit 的功能有价值但冲突不可解
- 需要审计追踪每个"未执行"的上游决策

## 前置条件

- 本仓库有指向上游的 git remote（任意名称）
- Python 3.8+
- 本 skill 目录下的 `fork_merge_audit.py` 脚本可用

## 使用方法

### 快速开始

```bash
# 1. 运行自动化扫描
python ~/.agents/skills/fork-merge-audit/fork_merge_audit.py --output report.json

# 2. 阅读摘要
# SAFE=33  NEEDS_REVIEW=39  BLOCKED=87
# Safe fixes: 16

# 3. 查看推荐
# --output 生成的 JSON 中有 recommendations 字段
```

### 完整流程

```
Phase 0: 基础设施准备
Phase 1: 自动化扫描（fork_merge_audit.py）
Phase 2: 模块化聚合（将 commits 按功能模块分组）
Phase 3: FE² 评估（5 轴对比）
Phase 4: 执行方案编排（P0→P3 排序）
Phase 5: 三路执行（cherry-pick / Strategy D / Backlog）
Phase 6: 验证门禁（编译 + 测试 + 烟雾）
Phase 7: 审计存档
```

---

## Phase 0 — 基础设施

```bash
# 确保有上游 remote
git remote -v
# 如果没有：
git remote add upstream https://github.com/original/project.git

# 确保 fork_merge_audit.py 可用
python ~/.agents/skills/fork-merge-audit/fork_merge_audit.py --help
```

**初始化文档**（可选但推荐）：
- `docs/upstream_backlog.md` — 审计日志
- `docs/upstream_comparison.md` — FE² 评估矩阵

---

## Phase 1 — 自动化扫描

```bash
python ~/.agents/skills/fork-merge-audit/fork_merge_audit.py \
  --output upstream_report.json \
  --noise "docs/CHANGELOG.md" "README.md" \
  --human
```

### 参数说明

| 参数 | 默认值 | 说明 |
|:-----|:------|:-----|
| `--remote` | auto-detect | 上游 remote 名称（尝试 upstream→origin→第一个） |
| `--branch` | main | 上游分支名 |
| `--output` | stdout | JSON 报告输出路径 |
| `--human` | false | 输出人类可读格式 |
| `--check-hash` | — | 只分析指定 hashes |
| `--no-fetch` | false | 跳过 git fetch |
| `--noise` | 默认集 | 额外噪音文件模式 |

### 输出解读

**三次分类**：

```
第一次过滤：conflict_status
  SAFE          = 0 冲突文件 + 0 新文件 → 可直接 cherry-pick
  NEEDS_REVIEW  = 1-2 冲突文件，或引入新文件 → 需人工审查
  BLOCKED       = 3+ 冲突文件 → 模块已分叉

第二次过滤：classification
  fix / feat / docs / refactor / chore / security / perf / other
  fix = 优先合入，feat = 需评估价值

第三次过滤：dependency_chains
  连续 3+ commit 修改同一文件 → 依赖链
  链中任一 BLOCKED → 整条链不可 cherry-pick
```

---

## Phase 2 — 模块化聚合

将分散的 commits 聚合为功能模块。一条模块 = 多次提交实现的同一功能。

**聚合线索**：
1. **相邻 commits 修改相同文件**（dependency_chains 已标注）
2. **相同 subject 前缀**（如 "feat: add P6 portfolio alerts" 和 "feat: add P7 market light alerts"）
3. **PR 描述关联**：`git log --format=%b`

**产出**：一个模块清单，如：
```
Module #1: DecisionSignal (9 commits) → signal persistence + API + frontend
Module #2: AlphaSift (13 commits) → stock screener + hot topics
```

---

## Phase 3 — FE² 评估框架

对每个模块执行 5 轴对比评估：

### 5 个评估轴

| 轴 | 评估什么 | 证据来源（2-3 min/轴） |
|:--:|:---------|:----------------------|
| **CORRECT** | 功能正确性 | 测试覆盖、edge case、已修 bug |
| **MAINTAIN** | 可维护性 | 圈复杂度、耦合度、模式复用 |
| **PERFORM** | 性能 | 时间复杂度、I/O 次数、缓存 |
| **INTEGRATE** | 集成适配度 | 新依赖、架构风格、波及范围 |
| **ROBUST** | 健壮性 | 错误处理、重试、日志、校验 |

### 判决规则

```
LOCAL_WINS ≥ 3 且 UPSTREAM_WINS = 0  → 跳过（本地更好）
LOCAL_WINS ≥ 2 且 UPSTREAM_WINS = 0  → 跳过（最低门槛）
UPSTREAM_WINS ≥ 2 且 LOCAL_WINS ≤ 1  → 采用（上游更好）
各有胜负 → Hybrid：创建提取任务
全部 TIE → 跳过（无新增价值）
```

### 升级到深度分析

当以下任一条件触发时，升级到 c1skill 全流程：
1. 平局（2-2 轴）
2. 安全敏感（auth/加密/网络边界）
3. diff 跨 5+ 文件
4. 双方无测试且逻辑 >50 行
5. 用户质疑初步结论

### FE² 模板

```markdown
## Module: <name>

| 轴 | 判决 | 证据 |
|:--:|:----:|:-----|
| CORRECT | LOCAL_WINS | — |
| MAINTAIN | TIE | — |
| PERFORM | UPSTREAM_WINS | — |
| INTEGRATE | TIE | — |
| ROBUST | LOCAL_WINS | — |

**决策**: LOCAL IS BETTER（2 LOCAL, 1 UPSTREAM）
**行动**: 跳过。关注上游 ROBUST 改进 → backlog
```

---

## Phase 4 — 方案编排

按 P0→P3 优先级排序，识别依赖关系：

```
P0（必须做）：高价值 + 无阻塞依赖
P1（应该做）：高价值 + 有依赖
P2（值得做）：中低价值
P3（有空做）：清理/优化
```

**依赖检查**：如果模块 A 修改的文件被模块 B 也修改了，A→B 有依赖。B 必须等 A 完成后执行。

---

## Phase 5 — 执行（三路选择树）

```
上游候选
  │
  ├─ SAFE / NEEDS_REVIEW ───→ Cherry-pick（≤3/batch）
  │                               │
  │                          ┌────┴────┐
  │                          │         │
  │                       成功完成  出错 → git revert 回滚
  │
  ├─ BLOCKED + 高价值 ────→ Strategy D 重实现
  │
  └─ BLOCKED + 低价值 ────→ Backlog（记入条件）
```

### Cherry-pick 规则

```bash
git cherry-pick <hash1> <hash2> <hash3>   # 每批 ≤3

# 冲突解决
git status          # 查看冲突文件
# 手动解决...
git add <file>
git cherry-pick --continue

# 出错回滚
git cherry-pick --abort           # 中断未完成
git revert --no-edit <hash>       # 已提交出错
```

### Strategy D：选择性重实现

**核心原则**：读上游的思想，不读上游的代码。

**步骤**：
```
Step 1: 理解意图
  git show <hash>               # 看上游实现了什么
  git log -1 --format=%b <hash> # 看 PR 描述和动机

Step 2: 解耦核心逻辑
  提取不依赖上游架构的函数/类
  通常只有 20-40% 的代码是核心逻辑

Step 3: 在本仓库架构上重实现
  保持本地已有的设计模式
  不强行适配上游的架构选择

Step 4: 验证
  python -m py_compile src/<file>.py
  python -m pytest tests/test_<module>.py -x -q
```

---

## Phase 6 — 验证门禁

**每次改动后**：
```bash
python -m py_compile src/<changed_file>.py
python -m pytest tests/test_<module>.py -x --no-header -q
```

**每个模块完成后**：
```bash
# 烟雾测试
python -m pytest tests/test_<new_module>*.py -x -q

# 如果是 AI/ML 项目，加端到端烟雾
python main.py --dry-run
```

---

## Phase 7 — 审计存档

**每条未执行的 BLOCKED 建议必须记录**：
```markdown
#### `<hash>` `<subject>`
- **分类**: feat / fix / docs
- **冲突状态**: BLOCKED
- **阻因**: 具体原因
- **FE² 结论**: UPSTREAM_WINS on which axes
- **重新评估条件**: 当 XXX 发生时
```

**Backlog 的作用**：
1. 审计备查
2. 本地架构变化后重新评估
3. 新需求出现时搜索上游是否已有实现

---

## 完整执行模板

```markdown
## Fork Merge Session: YYYY-MM-DD

### Phase 1 — 扫描
`python fork_merge_audit.py --output report.json`

### Phase 2 — 模块化
- Module #1: DecisionSignal (9 commits)
- Module #2: AlphaSift (13 commits)

### Phase 3 — FE² 评估
| # | 模块 | 决策 | 行动 |
|:-:|:-----|:----:|:-----|
| 1 | DecisionSignal | UPSTREAM | 完整采用 |
| 2 | AlphaSift | LOCAL | 跳过 |

### Phase 4 — 方案编排
P0: #1 DecisionSignal (5-8d)
P1: #2 AlphaSift (3-5d)

### Phase 5 — 执行
- Batch 1: hash1 hash2 hash3 → cherry-pick ✅
- Batch 2: hash4 → Strategy D ✅

### Phase 6 — 验证
- py_compile: ✅
- smoke test: ✅

### Phase 7 — 审计
- Report saved to docs/
- Backlog updated
```

---

## 关键规则

1. **永远先跑脚本**。不要人工枚举 commits — 一定有遗漏。
2. **FE² 是门禁**。说"跳过"必须在至少 2 个轴 LOCAL_WINS。
3. **Backlog 必须记条件**。只有 hash 没有重新评估条件 = 无价值记录。
4. **每批 cherry-pick ≤ 3**。每批之后运行烟雾测试。
5. **解决冲突 > 2 小时 → 降级为 Strategy D**。不要花半天解一个 commit。
6. **警惕语义依赖**。文件级 SAFE ≠ 运行时 SAFE——检查 import 链。

---

## 与 OpenCode 技能的配合

| 技能 | 角色 |
|:-----|:-----|
| `c1skill` | FE² 升级路径。平局/安全/复杂时启用 |
| `gitnexus-impact-analysis` | 执行前评估波及范围（推荐） |
| `gitnexus-debugging` | 合入后回归排查（按需） |

---

## 安装到新项目

```bash
# 本 skill 已在用户级安装: ~/.agents/skills/fork-merge-audit/
# 在新项目中直接使用：
python ~/.agents/skills/fork-merge-audit/fork_merge_audit.py

# 可选: 复制到项目本地
cp ~/.agents/skills/fork-merge-audit/fork_merge_audit.py scripts/
```
