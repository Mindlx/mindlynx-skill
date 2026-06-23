# 多工具集成指南

本仓库的技能和工具可在多种 AI 开发工具中使用。以下是各工具的支持方式。

---

## 通用原则

| 组件 | 工具无关性 | 说明 |
|:-----|:----------|:-----|
| `fork_merge_audit.py` | ✅ **完全无关** | 纯 Python + git，任何工具可通过 bash 调用 |
| 方法论（FE² / Strategy D / c1skill） | ✅ **纯文本** | 任何 AI 都可以通过 prompt 注入来理解和遵循 |

---

## 各工具集成方式

### 1. OpenCode ✅（原生支持）

```bash
# 安装到用户级技能目录
bash scripts/install.sh

# 在对话中调用
skill(name="fork-merge-audit")    # 加载 Fork 合并方法论
skill(name="c1skill")             # 加载交叉层审计方法论

# 直接运行脚本
python ~/.agents/skills/fork-merge-audit/fork_merge_audit.py
```

### 2. Claude Desktop / Claude Code

**方式 A：项目级 CLAUDE.md**

将 `prompts/` 下的内容添加到项目的 `CLAUDE.md`：

```bash
cat prompts/fork-merge-audit.md >> /path/to/your/project/CLAUDE.md
```

**方式 B：对话中粘贴提示**

在 Claude 对话开始时，粘贴 `prompts/fork-merge-audit.md` 的内容作为系统指令。

**方式 C：直接调用脚本**

```bash
# Claude Code 可以运行 bash 命令
python /path/to/fork_merge_audit.py --output report.json
```

### 3. Cursor

**方式 A：.cursorrules**

```bash
cp prompts/fork-merge-audit.md /path/to/your/project/.cursorrules
```

Cursor 会自动加载 `.cursorrules` 作为 AI 的 system prompt。

**方式 B：Notepad**

将 `prompts/c1skill.md` 内容添加到 Cursor 的 Notepad 中，需要时引用。

### 4. Windsurf

**方式 A：.windsurfrules**

```bash
cp prompts/fork-merge-audit.md /path/to/your/project/.windsurfrules
```

**方式 B：Cascade 指令**

在 Cascade 对话中粘贴 `prompts/` 下的方法论内容。

### 5. GitHub Copilot

```bash
# 添加到 copilot 项目指令
cp prompts/fork-merge-audit.md /path/to/your/project/.github/copilot-instructions.md
```

### 6. Cline / Roo Code / Aider

这些工具支持加载自定义指令文件：

```bash
# Cline: 在 .clinerules 中引用
cp prompts/fork-merge-audit.md /path/to/your/project/.clinerules

# Aider: 使用 --message 加载
aider --file prompts/c1skill.md
```

### 7. 任何 AI Chat（ChatGPT / 文心一言 / DeepSeek 等）

直接复制 `prompts/*.md` 的内容粘贴到对话中作为第一条消息。这些 prompt 被设计为**工具无关的纯文本方法论**，任何 LLM 都可以理解和执行。

---

## Python 脚本的通用性

`fork_merge_audit.py` 在任何环境中都可以直接运行：

```bash
# 无 git remote 时需要手动指定
python fork_merge_audit.py --remote origin --branch main --output report.json

# 查看帮助
python fork_merge_audit.py --help
```

依赖：Python 3.8+，零第三方包，仅需 `git` 命令。

---

## 总结

| 工具 | 脚本调用 | 方法论加载 |
|:-----|:--------:|:----------:|
| OpenCode | ✅ `bash` | ✅ `skill()` 原生 |
| Claude Desktop | ✅ `bash` | ✅ `CLAUDE.md` / 粘贴 prompt |
| Claude Code | ✅ `bash` | ✅ `CLAUDE.md` |
| Cursor | ✅ `bash` | ✅ `.cursorrules` |
| Windsurf | ✅ `bash` | ✅ `.windsurfrules` |
| GitHub Copilot | ❌ | ✅ `copilot-instructions.md` |
| Cline / Roo Code | ✅ `bash` | ✅ `.clinerules` |
| ChatGPT / 其他 | ❌ | ✅ 粘贴 prompt |
