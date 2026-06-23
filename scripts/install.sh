#!/bin/bash
# mindlynx-skill — 一键安装脚本
# 安装所有技能到 OpenCode 用户级技能目录 ~/.agents/skills/

set -e

INSTALL_DIR="${HOME}/.agents/skills"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "📦 Installing mindlynx skills to ${INSTALL_DIR}..."

install_skill() {
    local name="$1"
    local src="${SCRIPT_DIR}/skills/${name}"
    local dst="${INSTALL_DIR}/${name}"

    if [ -d "$src" ]; then
        mkdir -p "$dst"
        cp -r "$src/"* "$dst/"
        # Make Python scripts executable
        find "$dst" -name "*.py" -exec chmod +x {} \;
        echo "  ✅ ${name} installed"
    else
        echo "  ⚠️  ${name} not found, skipping"
    fi
}

install_skill "fork-merge-audit"
install_skill "c1skill"

echo ""
echo "✅ All skills installed!"
echo ""
echo "Usage:"
echo "  cd /path/to/your/forked/project"
echo "  python ${INSTALL_DIR}/fork-merge-audit/fork_merge_audit.py --output report.json"
echo ""
echo "  # In OpenCode:"
echo "  skill(name=\"fork-merge-audit\")"
echo "  skill(name=\"c1skill\")"
