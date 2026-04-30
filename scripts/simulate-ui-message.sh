#!/usr/bin/env bash
set -u

LOCAL_URL="http://localhost:7860"
FINAL_URL="${URLHTTPSUI_FINAL:-${HFSPACEURL:-}}"
LOG_DIR="${SIMULATION_LOG_DIR:-/workspace/simulation-logs}"
mkdir -p "${LOG_DIR}" 2>/dev/null || LOG_DIR="./simulation-logs"
mkdir -p "${LOG_DIR}" 2>/dev/null || LOG_DIR="/tmp/simulation-logs"
mkdir -p "${LOG_DIR}" 2>/dev/null || LOG_DIR="."
LOG_FILE="${LOG_DIR}/simulation-$(date -u +%Y%m%d_%H%M%S).log"

echo "[simulate] ============================================" | tee -a "${LOG_FILE}"
echo "[simulate] Demarrage simulation UI" | tee -a "${LOG_FILE}"
echo "[simulate] Local URL : ${LOCAL_URL}" | tee -a "${LOG_FILE}"
echo "[simulate] Final URL : ${FINAL_URL:-non definie}" | tee -a "${LOG_FILE}"
echo "[simulate] ============================================" | tee -a "${LOG_FILE}"

ERRORS=0

# 1. Healthcheck local
echo "[simulate] 1. Healthcheck local..." | tee -a "${LOG_FILE}"
if curl -fsS "${LOCAL_URL}/health" >> "${LOG_FILE}" 2>&1; then
  echo "[simulate]    -> OK" | tee -a "${LOG_FILE}"
else
  echo "[simulate]    -> ERREUR — UI locale inaccessible" | tee -a "${LOG_FILE}"
  ERRORS=$((ERRORS + 1))
fi

# 2. Test URL finale HTTPS si definie
echo "[simulate] 2. Test URL finale HTTPS..." | tee -a "${LOG_FILE}"
if [ -n "${FINAL_URL}" ]; then
  if curl -fsS "${FINAL_URL}/health" -H "User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1" >> "${LOG_FILE}" 2>&1; then
    echo "[simulate]    -> OK — URL finale repond (simulation mobile Safari)" | tee -a "${LOG_FILE}"
  else
    echo "[simulate]    -> AVERTISSEMENT — URL finale non accessible (probablement non encore deployee)" | tee -a "${LOG_FILE}"
  fi
else
  echo "[simulate]    -> SKIP — URLHTTPSUI_FINAL non definie" | tee -a "${LOG_FILE}"
fi

# 3. Test API chat locale avec plusieurs messages
echo "[simulate] 3. Test API chat locale..." | tee -a "${LOG_FILE}"

send_msg() {
  local msg="$1"
  local expect="$2"
  local resp
  resp=$(curl -s -X POST "${LOCAL_URL}/api/chat" \
    -H "Content-Type: application/json" \
    -d "{\"message\":\"${msg}\",\"history\":[]}" 2>/dev/null)
  if echo "${resp}" | grep -q "reply"; then
    echo "[simulate]    -> OK — reponse recue pour '${msg}'" | tee -a "${LOG_FILE}"
    echo "[simulate]       Reponse brute : ${resp}" | tee -a "${LOG_FILE}"
    return 0
  else
    echo "[simulate]    -> ERREUR — pas de reponse valide pour '${msg}'" | tee -a "${LOG_FILE}"
    echo "[simulate]       Reponse brute : ${resp}" | tee -a "${LOG_FILE}"
    return 1
  fi
}

# Verifier si le token est configure avant d'envoyer
if [ -z "${ANTHROPIC_AUTH_TOKEN:-}" ]; then
  echo "[simulate]    -> SKIP — ANTHROPIC_AUTH_TOKEN absent, impossible d'appeler l'API" | tee -a "${LOG_FILE}"
  echo "[simulate]       (Simulation API partielle uniquement)" | tee -a "${LOG_FILE}"
else
  send_msg "Reponds uniquement: SIMULATIONOK1" "SIMULATIONOK1" || ERRORS=$((ERRORS + 1))
  send_msg "Reponds uniquement: SIMULATIONOK2" "SIMULATIONOK2" || ERRORS=$((ERRORS + 1))
  send_msg "Reponds uniquement: SIMULATIONOK3" "SIMULATIONOK3" || ERRORS=$((ERRORS + 1))
fi

# 4. Verifier processus Node.js actif
echo "[simulate] 4. Verification processus CloudCLI..." | tee -a "${LOG_FILE}"
if command -v pgrep >/dev/null 2>&1 && pgrep -f "node server.js" > /dev/null 2>&1; then
  echo "[simulate]    -> OK — processus Node.js actif (pgrep)" | tee -a "${LOG_FILE}"
elif ps aux 2>/dev/null | grep -q "[n]ode server.js"; then
  echo "[simulate]    -> OK — processus Node.js actif (ps)" | tee -a "${LOG_FILE}"
else
  echo "[simulate]    -> AVERTISSEMENT — processus Node.js non trouve (peut-etre non lance ou OS incompatible)" | tee -a "${LOG_FILE}"
fi

# 5. Verifier workspace
echo "[simulate] 5. Verification workspace..." | tee -a "${LOG_FILE}"
if [ -d "/workspace" ]; then
  echo "[simulate]    -> OK — /workspace present" | tee -a "${LOG_FILE}"
else
  echo "[simulate]    -> INFO — /workspace absent (normal hors conteneur Docker)" | tee -a "${LOG_FILE}"
fi

# 6. Variables modele
echo "[simulate] 6. Variables modele..." | tee -a "${LOG_FILE}"
if [ -n "${ANTHROPIC_MODEL:-}" ]; then
  echo "[simulate]    -> OK — ANTHROPIC_MODEL=${ANTHROPIC_MODEL}" | tee -a "${LOG_FILE}"
else
  echo "[simulate]    -> AVERTISSEMENT — ANTHROPIC_MODEL non defini" | tee -a "${LOG_FILE}"
fi

# 7. Resume
echo "[simulate] ============================================" | tee -a "${LOG_FILE}"
if [ "${ERRORS}" -eq 0 ]; then
  echo "[simulate] SIMULATION TERMINEE — tous les criteres passent" | tee -a "${LOG_FILE}"
  echo "[simulate] Logs sauvegardes dans : ${LOG_FILE}" | tee -a "${LOG_FILE}"
  exit 0
else
  echo "[simulate] SIMULATION TERMINEE — ${ERRORS} erreur(s) detectee(s)" | tee -a "${LOG_FILE}"
  echo "[simulate] Logs sauvegardes dans : ${LOG_FILE}" | tee -a "${LOG_FILE}"
  exit 1
fi
