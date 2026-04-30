#!/usr/bin/env bash
set -u

INTERVAL=60
REPO_URL="${GITHUB_REPO_URL:-}"
TOKEN="${GITHUB_TOKEN:-}"

if [ -z "${REPO_URL}" ] || [ -z "${TOKEN}" ]; then
  echo "[autosave] GITHUB_REPO_URL ou GITHUB_TOKEN absent — autosave desactive"
  exit 0
fi

AUTH_URL=$(echo "${REPO_URL}" | sed "s|https://|https://${TOKEN}@|")

echo "[autosave] Demarre — intervalle ${INTERVAL}s — repo masque"

while true; do
  sleep "${INTERVAL}"
  cd /workspace || { echo "[autosave] /workspace inaccessible"; continue; }

  if [ ! -d ".git" ]; then
    echo "[autosave] /workspace n'est pas un repo git — initialisation..."
    git init || { echo "[autosave] git init echoue"; continue; }
    git remote add origin "${AUTH_URL}" || true
  fi

  # Verifier changements
  CHANGES=$(git status --porcelain 2>/dev/null || true)
  if [ -z "${CHANGES}" ]; then
    continue
  fi

  echo "[autosave] Changements detectes — commit en cours..."
  git add -A || { echo "[autosave] git add echoue"; continue; }
  TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
  git commit -m "autosave: ${TIMESTAMP}" || { echo "[autosave] git commit echoue"; continue; }
  git push "${AUTH_URL}" || { echo "[autosave] git push echoue"; continue; }
  echo "[autosave] Pousse reussi — ${TIMESTAMP}"
done
