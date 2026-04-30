#!/usr/bin/env bash
set -u

echo "========================================"
echo "Claude Kimi HF Space starting"
echo "========================================"
echo "Modele : ${ANTHROPIC_MODEL:-non defini}"
echo "Base URL : ${ANTHROPIC_BASE_URL:-non defini}"
echo "Workspace : /workspace"
echo "Port : ${PORT:-7860}"
echo "========================================"

# Ne jamais afficher de token complet
if [ -n "${ANTHROPIC_AUTH_TOKEN:-}" ]; then
  echo "ANTHROPIC_AUTH_TOKEN : present (masque)"
else
  echo "ANTHROPIC_AUTH_TOKEN : ABSENT"
fi
if [ -n "${GITHUB_TOKEN:-}" ]; then
  echo "GITHUB_TOKEN : present (masque)"
else
  echo "GITHUB_TOKEN : ABSENT"
fi
if [ -n "${HF_TOKEN:-}" ]; then
  echo "HF_TOKEN : present (masque)"
else
  echo "HF_TOKEN : ABSENT"
fi

# Variables optionnelles
if [ -n "${GITHUB_REPO_URL:-}" ]; then
  echo "GITHUB_REPO_URL : ${GITHUB_REPO_URL}"
fi
if [ -n "${HFSPACEURL:-}" ]; then
  echo "HFSPACEURL : ${HFSPACEURL}"
fi
if [ -n "${URLHTTPSUI_FINAL:-}" ]; then
  echo "URLHTTPSUI_FINAL : ${URLHTTPSUI_FINAL}"
fi

# Preparation workspace
mkdir -p /workspace

cd /workspace || exit 1

# Clone ou pull du repo GitHub workspace si defini
if [ -n "${GITHUB_REPO_URL:-}" ] && [ -n "${GITHUB_TOKEN:-}" ]; then
  AUTH_URL=$(echo "${GITHUB_REPO_URL}" | sed "s|https://|https://${GITHUB_TOKEN}@|")
  if [ ! -d "/workspace/.git" ]; then
    echo "[start] Clonage du workspace GitHub..."
    git clone "${AUTH_URL}" /workspace || echo "[start] Echec clone, continuation sans workspace distant"
  else
    echo "[start] Workspace existant, pull..."
    git pull "${AUTH_URL}" || echo "[start] Echec pull, continuation"
  fi
  git config --global user.email "autosave@claude-kimi-cloud.local" || true
  git config --global user.name "Claude Kimi Autosave" || true

  # S'assurer que README.md complet est present
  if [ ! -f "/workspace/README.md" ] && [ -f "/app/README.md" ]; then
    cp /app/README.md /workspace/README.md
    git add README.md || true
    git commit -m "autosave: ajout README.md complet depuis /app" || true
    git push "${AUTH_URL}" || true
  fi
fi

# Demarrer autosave en arriere-plan si GITHUB_REPO_URL est defini
if [ -n "${GITHUB_REPO_URL:-}" ]; then
  echo "[start] Lancement de autosave.sh en arriere-plan..."
  mkdir -p /workspace/logs
  bash /app/scripts/autosave.sh >> /workspace/logs/autosave-trace.log 2>&1 &
fi

# Demarrer CloudCLI en arriere-plan sur le port 3001
cd /app || exit 1
echo "[start] Lancement CloudCLI UI sur 0.0.0.0:3001..."
npx @cloudcli-ai/cloudcli --port 3001 &
CLOUDCLI_PID=$!

# Attendre que CloudCLI demarre
sleep 3

# Demarrer le serveur principal (proxy + API chat)
echo "[start] Lancement serveur principal sur 0.0.0.0:${PORT:-7860}..."
exec node server.js
