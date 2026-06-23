[English](README.md) | [中文](README_CN.md)

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
| **Copilot** | Copy to `.github/copilot-instructions.md` | ❌ |
| **ChatGPT / others** | Paste prompt content as first message | ❌ |

Full guide: [docs/tool-integration.md](docs/tool-integration.md).

## Extending

To add a new skill → create a directory under `skills/` with `SKILL.md` (must be uppercase), optional scripts, and `examples/`.

## License

MIT
