#!/usr/bin/env bash
set -u

INTERVAL=60
REPO_URL="${GITHUB_REPO_URL:-}"
TOKEN="${GITHUB_TOKEN:-}"
TRACE_FILE="/workspace/logs/autosave-trace.log"

mkdir -p /workspace/logs 2>/dev/null || true

log_trace() {
  echo "[$(date -u +'%Y-%m-%d %H:%M:%S UTC')] $1" >> "${TRACE_FILE}"
}

if [ -z "${REPO_URL}" ] || [ -z "${TOKEN}" ]; then
  echo "[autosave] GITHUB_REPO_URL ou GITHUB_TOKEN absent — autosave desactive"
  log_trace "DESACTIVE — variables manquantes"
  exit 0
fi

AUTH_URL=$(echo "${REPO_URL}" | sed "s|https://|https://${TOKEN}@|")

echo "[autosave] Demarre — intervalle ${INTERVAL}s — repo masque"
log_trace "DEMARRE — intervalle ${INTERVAL}s"

while true; do
  sleep "${INTERVAL}"
  cd /workspace || { log_trace "ERREUR /workspace inaccessible"; continue; }

  if [ ! -d ".git" ]; then
    log_trace "INIT — /workspace n'est pas un repo git"
    git init >> "${TRACE_FILE}" 2>&1 || { log_trace "ERREUR git init"; continue; }
    git remote add origin "${AUTH_URL}" >> "${TRACE_FILE}" 2>&1 || true
  fi

  # Verifier changements
  CHANGES=$(git status --porcelain 2>/dev/null || true)
  if [ -z "${CHANGES}" ]; then
    log_trace "RIEN — aucun changement detecte"
    continue
  fi

  log_trace "CHANGEMENTS — ${CHANGES}"
  git add -A >> "${TRACE_FILE}" 2>&1 || { log_trace "ERREUR git add"; continue; }
  TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
  git commit -m "autosave: ${TIMESTAMP}" >> "${TRACE_FILE}" 2>&1 || { log_trace "ERREUR git commit"; continue; }
  git push "${AUTH_URL}" >> "${TRACE_FILE}" 2>&1 || { log_trace "ERREUR git push"; continue; }
  log_trace "SUCCES — pousse a ${TIMESTAMP}"
done
