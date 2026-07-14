#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_PATH="$SCRIPT_DIR/plugins/user-skills"
CLAUDE_DIR="$HOME/.claude"
SETTINGS="$CLAUDE_DIR/settings.json"
INSTALLED="$CLAUDE_DIR/plugins/installed_plugins.json"

echo "Instalando user-skills@claude-skills..."

mkdir -p "$CLAUDE_DIR/plugins"

# Atualiza settings.json
python3 - <<PYTHON
import json, os

settings_path = "$SETTINGS"

if os.path.exists(settings_path):
    with open(settings_path) as f:
        settings = json.load(f)
else:
    settings = {}

settings.setdefault("extraKnownMarketplaces", {})["claude-skills"] = {
    "source": {"source": "github", "repo": "Linhares015/claude-skills"}
}

settings.setdefault("enabledPlugins", {})["user-skills@claude-skills"] = True

# Remove entrada local se existir
settings.get("enabledPlugins", {}).pop("user-skills@local", None)

with open(settings_path, "w") as f:
    json.dump(settings, f, indent=2)
    f.write("\n")

print("✓ settings.json atualizado")
PYTHON

# Atualiza installed_plugins.json
python3 - <<PYTHON
import json, os
from datetime import datetime, timezone

installed_path = "$INSTALLED"
plugin_path = "$PLUGIN_PATH"

if os.path.exists(installed_path):
    with open(installed_path) as f:
        installed = json.load(f)
else:
    installed = {"version": 2, "plugins": {}}

now = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%S.000Z")

installed["plugins"]["user-skills@claude-skills"] = [
    {
        "scope": "user",
        "installPath": plugin_path,
        "version": "1.0.0",
        "installedAt": now,
        "lastUpdated": now
    }
]

# Remove entrada local se existir
installed["plugins"].pop("user-skills@local", None)

with open(installed_path, "w") as f:
    json.dump(installed, f, indent=2)
    f.write("\n")

print("✓ installed_plugins.json atualizado")
PYTHON

echo ""
echo "✓ Pronto! Reinicie o Claude Code para ativar a skill codex-mode."
echo "  Para atualizar as skills no futuro: git pull"
